import json
import os
import boto3

FUNCTION_NAME = os.getenv('INVOKE_FUNCTION_NAME')

client = boto3.client('lambda')


def invoke(cakes):
    print('Invoke %s with data: %s' % (FUNCTION_NAME, cakes))
    response = client.invoke(
        FunctionName=FUNCTION_NAME,
        InvocationType='RequestResponse',
        Payload=json.dumps(cakes),
    )
    return response


def get_cakes(event, context):
    body = event['body']

    print('Check if %s is available' % str(body))
    response = invoke(body)
    payload = json.loads(response["Payload"].read())

    return {'statusCode': payload['statusCode'], 'body': json.dumps(payload['body'])}
