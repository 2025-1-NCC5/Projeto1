from marshmallow import  Schema, fields, validate

class RideSchema(Schema):
    pickup = fields.Str(required=True)
    dropoff = fields.Str(required=True)
    distance = fields.Float(required=True)
    time = fields.Float(required=True)
    service_type = fields.Str(required=True)  # e.g., "UberX"
    created_at = fields.DateTime()
    updated_at = fields.DateTime()
    uid = fields.Str(required=True)  # Add the UID field to associate the ride with a user


class UserSchema(Schema):
    name = fields.String(required=True)
    email = fields.Email(required=True)
    phone = fields.String(required=True)
    password = fields.String(
        required=True,
        validate=validate.Length(min=8, error="Password must be at least 8 characters")
    )
    