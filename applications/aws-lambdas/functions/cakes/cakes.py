import json

from opentelemetry import trace

AVAILABLE_CAKES = ['cornetto', 'cannolo_siciliano', 'torta', 'muffin']


def is_avi(cake):
    current_span = trace.get_current_span()    
    current_span.set_attribute('requested_cake', cake)
    if cake in AVAILABLE_CAKES:
        current_span.set_attribute('is_avi', True)
        status = 200
    else:
        current_span.set_attribute('is_avi', False)
        status = 404

    return status


def lambda_handler(event, context):
    print(event)
    body = event['body']
    cake = json.loads(body)['cakes']

    result = is_avi(cake)
    
    if result == 200:
        print('%s is available' % cake)
        return {'statusCode': 200, 'body': json.dumps({'cakes': cake})}
    else:
        print('%s is not available' % cake)
        return {'statusCode': 404, 'body': json.dumps({'cakes': cake})}
