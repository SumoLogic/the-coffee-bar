import json
import os
import requests

FUNCTION_NAME = os.getenv('INVOKE_FUNCTION_NAME')
FUNCTION_URL = os.getenv('INVOKE_FUNCTION_URL')



def make_request(body):
    response = requests.post(FUNCTION_URL, json=body)
    return response

def get_cakes(event, context):
    request = event['body']
    print('Check if %s is available' % str(request))
    response = make_request(json.loads(request))
    response_body = response.json()
    print(response_body)

    return {'statusCode': response.status_code, 'body': json.dumps(response_body)}
