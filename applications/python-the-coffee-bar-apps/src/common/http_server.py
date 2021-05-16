from flask import Flask, Response, request
from flask_cors import CORS
import requests

from src.utils.utils import to_json

from opentelemetry import trace
from opentelemetry.util._time import _time_ns


class EndpointAction:
    def __init__(self, action):
        self.action = action
        self.response = Response(mimetype='application/json')

    def __call__(self, *args, **kwargs):
        data = to_json(request.json)
        result = self.action(data)

        if isinstance(result, requests.models.Response):
            self.response.status_code = result.status_code
            self.response.set_data(result.content)
            try:
                if result.status_code == 402:
                    trace.get_current_span().add_event("exception", {"exception.code": int(result.status_code),
                                                                     "exception.message": str(result.content)},
                                                       _time_ns())
            except:
                pass
        else:
            self.response.status_code = result.status_code
            self.response.set_data(result.get_data())

            if result.status_code == 402:
                trace.get_current_span().add_event("exception", {"exception.code": int(result.status_code),
                                                                 "exception.message": str(result.response)},
                                                   _time_ns())

        return self.response


class HttpServer:
    app = None

    def __init__(self, name: str, host: str, port: int):
        self.app = Flask(name)
        CORS(self.app, origins='*')
        self.host = host
        self.port = port

    def run(self):
        # Debug=True is causing issue with Flask application instrumentation
        self.app.run(host=self.host, port=self.port, debug=False)

    def add_endpoint(self, endpoint: str = None, endpoint_name: str = None, handler: staticmethod = None):
        self.app.add_url_rule(endpoint, endpoint_name, EndpointAction(handler), methods=['POST', 'GET', 'HEAD'])
