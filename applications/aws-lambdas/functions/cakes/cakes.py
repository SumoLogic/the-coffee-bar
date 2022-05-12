import json

from opentelemetry import trace

AVAILABLE_CAKES = ['cornetto', 'cannolo_siciliano', 'torta', 'muffin']


def is_avi(cake, context):
    span_context = trace.SpanContext(context['trace_id'],
                                     context['span_id'],
                                     context['is_remote'],
                                     context['trace_flags'],
                                     context['trace_state'])
    link = trace.Link(context=span_context)

    tracer = trace.get_tracer(__name__)
    with tracer.start_as_current_span("is_cake_available", links=[link]) as span:
        span.set_attribute('requested_cake', cake)
        if cake in AVAILABLE_CAKES:
            span.set_attribute('is_avi', True)
            status = 200
        else:
            span.set_attribute('is_avi', False)
            status = 404

    return status


def lambda_handler(event, context):
    data = json.loads(event)
    cake = data['cakes']
    link_context = data['link_context']

    result = is_avi(cake, link_context)

    if result == 200:
        print('%s is available' % cake)
        return {'statusCode': 200, 'body': {'cakes': cake}}
    else:
        print('%s is not available' % data['cakes'])
        return {'statusCode': 404, 'body': {'cakes': cake}}
