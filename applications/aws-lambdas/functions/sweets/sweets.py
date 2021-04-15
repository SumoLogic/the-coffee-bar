import awsgi
import json
from flask import Flask, request
from opentelemetry.instrumentation.wsgi import OpenTelemetryMiddleware

# from opentelemetry.instrumentation.flask import FlaskInstrumentor


AVAILABLE_SWEETS = ['cornetto', 'cannolo_siciliano', 'torta', 'muffin_alla_ricotta']

app = Flask(__name__)
app.wsgi_app = OpenTelemetryMiddleware(app.wsgi_app)


# FlaskInstrumentor().instrument_app(app)

@app.route('/', methods=['POST'])
def index():
    body = request.json
    requested_sweets = body['sweets']

    sweets = {
        'sweets': requested_sweets
    }
    headers = dict(request.headers)
    resp_body = json.dumps(sweets)
    if requested_sweets in AVAILABLE_SWEETS:
        return {'statusCode': 200, 'body': resp_body}
    else:
        return {'statusCode': 404, 'body': resp_body}


def lambda_handler(event, context):
    resp = awsgi.response(app, event, context)

    return {'statusCode': resp['statusCode'], 'body': resp['body']}
