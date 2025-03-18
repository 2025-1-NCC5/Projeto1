import datetime
from functools import wraps
import os
import jwt
from dotenv import load_dotenv
from flask import Flask, jsonify, request
import requests
from firebase_config import db, auth
from middleware import token_required
from flask_restx import Api, Resource, fields
from schemas import RideSchema, UserSchema 
from firebase_admin import auth as firebase_auth



SECRET_KEY = os.getenv("SECRET_KEY")


def get_id_token(email, password):
    """Get an ID token from Firebase Authentication via REST API"""
    url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={SECRET_KEY}"
    data = {
        "email": email,
        "password": password,
        "returnSecureToken": True
    }
    response = requests.post(url, json=data)
    
    if response.status_code == 200:
        return response.json().get("idToken")  
    else:
        app.logger.error(f"Error authenticating: {response.json()}")  
        return None  

app = Flask(__name__)

api = Api(app, title="Auth API", version="1.0")

ns_auth = api.namespace("auth", description="Authentication operations")

user_schema = UserSchema()

JWT_ALGORITHM = "HS256"

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get("Authorization")
        if token and token.startswith("Bearer "):
            token = token[7:]  
        if not token:
            return {"message": "Token is missing!"}, 401

        try:
            
            decoded_token = firebase_auth.verify_id_token(token)
            
            
            user = firebase_auth.get_user(decoded_token["uid"])
            tokens_valid_after = user.tokens_valid_after_timestamp / 1000  
            if decoded_token["auth_time"] < tokens_valid_after:
                return {"message": "Token has been revoked"}, 401
            
            request.user = decoded_token  
        except firebase_auth.InvalidIdTokenError:
            return {"message": "Invalid token"}, 401
        except Exception as e:
            app.logger.error(f"Token validation error: {str(e)}")
            return {"message": "Invalid token"}, 401

        return f(*args, **kwargs)
    return decorated

@app.route('/')
def hello():
    return 'Backend is running!'

@ns_auth.route("/register")
class Register(Resource):
    @api.expect(api.model("User", {
        "email": fields.String(required=True),
        "password": fields.String(required=True),
    }))
    def post(self):
        """Register a new user"""
        data = request.json
        errors = user_schema.validate(data)
        if errors:
            return errors, 400
        
        email = data["email"]
        password = data["password"]
        
        try:
            user = auth.create_user(email=email, password=password)
            return {"uid": user.uid, "email": user.email}, 201
        except auth.EmailAlreadyExistsError:
            return {"message": "Email already exists"}, 409
        except Exception as e:
            return {"message": str(e)}, 400
        
@ns_auth.route("/login")
class Login(Resource):
    @api.expect(api.model("User", {
        "email": fields.String(required=True),
        "password": fields.String(required=True),
    }))
    def post(self):
        """Login and get ID token"""
        data = request.json
        email = data.get("email")
        password = data.get("password")
        
        try:
            
            id_token = get_id_token(email, password)
            if not id_token:
                return {"message": "Failed to generate ID token"}, 401
            
            
            user = auth.get_user_by_email(email)
            
           
            firebase_auth.revoke_refresh_tokens(user.uid)
            
            return {"token": id_token}, 200
        except auth.UserNotFoundError:
            return {"message": "User not found"}, 404
        except Exception as e:
            return {"message": str(e)}, 401




ride_schema = RideSchema()

@app.route('/rides', methods=['POST'])
@token_required
def create_ride():
    errors = ride_schema.validate(request.json)
    if errors:
        return jsonify(errors), 400

    data = request.json
    data["createdAt"] = datetime.datetime.utcnow().isoformat()
    data["updatedAt"] = datetime.datetime.utcnow().isoformat()
    data["uid"] = request.user["uid"]  

    ride_ref = db.collection('rides').document()
    ride_ref.set(data)
    return jsonify({"rideId": ride_ref.id, "message": "Ride created"}), 201


@app.route('/rides/<rideId>', methods=['GET'])
@token_required
def get_ride(rideId):
    ride_ref = db.collection('rides').document(rideId)
    ride = ride_ref.get()
    if ride.exists:
        ride_data = ride.to_dict()
        if ride_data["uid"] != request.user["uid"]:  
            return jsonify({"message": "Access denied"}), 403
        return jsonify(ride_data), 200
    return jsonify({"message": "Ride not found"}), 404



if __name__ == '__main__':
    app.run(debug=True)