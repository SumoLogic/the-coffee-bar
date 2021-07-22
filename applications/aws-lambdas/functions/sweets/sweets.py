import json
import boto3

AVAILABLE_SWEETS = ['cornetto', 'cannolo_siciliano', 'torta', 'muffin']
s3 = boto3.resource('s3')


def lambda_handler(event, context):
    data = json.loads(event)
    if s3.Bucket(str(data['sweets']).replace('_', '-')) in s3.buckets.all():
        print('%s is available' % data['sweets'])
        return {'statusCode': 200, 'body': {'sweets': data['sweets']}}
    else:
        print('%s is not available' % data['sweets'])
        return {'statusCode': 404, 'body': {'sweets': data['sweets']}}
