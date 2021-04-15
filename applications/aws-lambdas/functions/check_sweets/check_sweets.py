import json
import os
import requests

URL = os.getenv('SWEETS_URL')


def get_data(sweets):
    return requests.post(url=URL, json=sweets)


def get_sweets(event, context):
    body = event['body']
    requested_sweets = json.loads(body)

    response = get_data(requested_sweets)
    response_body = response.json()

    return {'statusCode': response.status_code, 'body': json.dumps(response_body)}
