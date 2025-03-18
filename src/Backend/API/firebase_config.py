import firebase_admin
from firebase_admin import credentials, firestore, auth


cred = credentials.Certificate(r"skd\ubarun-9a206-firebase-adminsdk-fbsvc-5c5fd0259f.json")

if not firebase_admin._apps:
    firebase_admin.initialize_app(cred)


db = firestore.client()

auth = auth