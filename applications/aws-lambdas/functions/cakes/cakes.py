import json
import boto3

from opentelemetry import trace

AVAILABLE_CAKES = ['cornetto', 'cannolo_siciliano', 'torta', 'muffin']
s3 = boto3.resource('s3')


def is_avi(data):
    sweet = str(data['cakes'])
    context = data['link_context']
    span_context = trace.SpanContext(context['trace_id'],
                                     context['span_id'],
                                     context['is_remote'],
                                     context['trace_flags'],
                                     context['trace_state'])
    link = trace.Link(context=span_context)

    tracer = trace.get_tracer(__name__)
    with tracer.start_as_current_span("is_cake_available", links=[link]) as span:
        span.set_attribute('requested_sweet', sweet)
        if sweet in AVAILABLE_CAKES:
            span.set_attribute('is_avi', True)
            status = 200
        else:
            span.set_attribute('requested_sweet', sweet)
            span.set_attribute('is_avi', False)
            status = 404

    return status


def lambda_handler(event, context):
    data = json.loads(event)
    result = is_avi(data)

    if result == 200:
        print('%s is available' % data['cakes'])
        return {'statusCode': 200, 'body': {'cakes': data['cakes']}}
    else:
        print('%s is not available' % data['cakes'])
        return {'statusCode': 404, 'body': {'cakes': data['cakes']}}
