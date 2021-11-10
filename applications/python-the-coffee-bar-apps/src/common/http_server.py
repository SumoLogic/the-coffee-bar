import json
import logging as log
import os

from flask import Flask, Response, request
from flask_cors import CORS
import requests

from src.utils.utils import to_json
from opentelemetry import trace
from opentelemetry.util._time import _time_ns
import statsd

from waitress import serve
from paste.translogger import TransLogger


class EndpointAction:
    stats = None

    def __init__(self, action):
        self.action = action
        self.response = Response(mimetype='application/json')
        if os.getenv('STATSD'):
            statsd_address = os.getenv('STATSD').split(':')
            self.stats = statsd.StatsClient(host=statsd_address[0], port=int(statsd_address[1]))

    def __call__(self, *args, **kwargs):
        if self.stats:
            self.stats.incr('endpoint_calls')
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

        # Add trace_id into response
        try:
            data = json.loads(self.response.data)
        except:
            data = {}
        finally:
            context = trace.get_current_span().get_span_context()
            trace_id = context.trace_id
            data['trace_id'] = '{trace:032x}'.format(trace=trace_id)
            self.response.set_data(json.dumps(data))

        return self.response


class HttpServer:
    app = None
    stats = None

    def __init__(self, name: str, host: str, port: int):
        self.app = Flask(name)
        CORS(self.app, origins='*')
        self.host = host
        self.port = port
        # For K8s livenessProbe
        self.app.add_url_rule('/', 'index', self.index)

        if os.getenv('STATSD'):
            statsd_address = os.getenv('STATSD').split(':')
            self.stats = statsd.StatsClient(host=statsd_address[0], port=int(statsd_address[1]))

    def index(self, *args, **kwargs):
        log.info('Possible K8s livenessProbe request')
        if self.stats:
            self.stats.incr('health_check_calls')
        return Response("I'm alive!", status=200, mimetype='text/plain')

    def run(self):
        serve(TransLogger(application=self.app, logger=log.getLogger('root')), host=self.host, port=self.port,
              server_name=self.host)

    def add_endpoint(self, endpoint: str = None, endpoint_name: str = None, handler: staticmethod = None):
        self.app.add_url_rule(endpoint, endpoint_name, EndpointAction(handler), methods=['POST', 'GET', 'HEAD'])
