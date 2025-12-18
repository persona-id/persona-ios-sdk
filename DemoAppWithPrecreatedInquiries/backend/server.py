from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
import os

app = Flask(__name__)
CORS(app)

PERSONA_API_KEY = os.environ.get('PERSONA_API_KEY')
PERSONA_API_URL = 'https://withpersona.com/api/v1'
PERSONA_VERSION = '2025-10-27'
INQUIRY_TEMPLATE_ID = 'itmpl_XXXXXXXXXXXXX'  # Replace with your template ID

def _get_persona_req_headers():
    return {
        'Authorization': f'Bearer {PERSONA_API_KEY}',
        'Content-Type': 'application/json',
        'Persona-Version': PERSONA_VERSION
    }

@app.route('/api/inquiries/get-or-create', methods=['POST'])
def get_or_create_inquiry():
    # In production, get user ID from your auth system
    user_id = 'usr_ABC123'

    # In production, fetch user data from your database
    user_data = {
        'name_first': 'Alexander',
        'name_last': 'Sample',
        'birthdate': '1977-08-31'
    }

    # Check for existing incomplete inquiry
    existing = find_incomplete_inquiry(user_id)

    if existing:
        inquiry_id = existing['id']
        status = existing['attributes']['status']

        print(f"Found existing inquiry {inquiry_id} with status: {status}")

        if status == 'pending':
            print("Inquiry is pending, generating session token to resume")
            session_token = create_session_token(inquiry_id)
            return jsonify({
                'inquiry_id': inquiry_id,
                'session_token': session_token
            })
        else:
            print("Inquiry is created, resuming without session token")
            return jsonify({
                'inquiry_id': inquiry_id,
                'session_token': None
            })
    else:
        print("No incomplete inquiry found, creating new one")
        inquiry_id = create_inquiry(user_id, user_data)
        return jsonify({
            'inquiry_id': inquiry_id,
            'session_token': None
        })

def find_incomplete_inquiry(user_id):
    """Find existing inquiry with status 'created' or 'pending'"""
    try:
        response = requests.get(
            f"{PERSONA_API_URL}/inquiries",
            params={
                'filter[reference-id]': user_id,
                'filter[status]': 'created,pending',
                'page[size]': 1
            },
            headers=_get_persona_req_headers()
        )
        response.raise_for_status()
        inquiries = response.json().get('data', [])
        return inquiries[0] if inquiries else None
    except Exception as e:
        print(f"Error finding inquiry: {e}")
        return None

def create_inquiry(user_id, user_data):
    """Create new inquiry via Persona API"""
    payload = {
        'data': {
            'attributes': {
                'inquiry-template-id': INQUIRY_TEMPLATE_ID,
                'reference-id': user_id,
                'fields': user_data
            }
        }
    }

    response = requests.post(
        f"{PERSONA_API_URL}/inquiries",
        json=payload,
        headers=_get_persona_req_headers()
    )
    response.raise_for_status()
    return response.json()['data']['id']

def create_session_token(inquiry_id):
    """Generate session token for resuming pending inquiry"""
    try:
        response = requests.post(
            f"{PERSONA_API_URL}/inquiries/{inquiry_id}/resume",
            json={'meta': {}},
            headers=_get_persona_req_headers()
        )
        response.raise_for_status()
        meta = response.json().get('meta', {})
        return meta.get('session-token')
    except Exception as e:
        print(f"Error creating session token: {e}")
        return None

if __name__ == '__main__':
    app.run(port=8000, debug=True)
