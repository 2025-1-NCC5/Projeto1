import firebase_admin
from flask import jsonify, request
import jwt
from functools import wraps
from firebase_admin import auth

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({"message": "Token missing"}), 401
        try:
            token = token.split("Bearer ")[-1] 
            decoded_token = auth.verify_id_token(token)
            request.user = decoded_token
        except Exception as e:
            return jsonify({"message": "Invalid token"}), 401
        return f(*args, **kwargs)
    return decorated