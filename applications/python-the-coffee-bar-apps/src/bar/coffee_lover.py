import json
import logging as log
from random import randint
from time import sleep

import requests


class CoffeeLover:
    def __init__(self, bar_host: str = 'localhost', bar_port: int = 8082, ratio: int = 5):
        self.bar_url = 'http://{}:{}/do_espresso'.format(bar_host, bar_port)
        self.ratio = ratio

        log.info('The Coffee Bar URL: %s', self.bar_url)

    def get_coffee(self):
        order = {
            'product': 'espresso',
            'bill': randint(1, 20),
            'water': randint(-5, 50),
            'coffee': randint(-5, 50),
            'amount': randint(1, 3),
        }

        data = json.dumps(order)

        try:
            res = requests.post(url=self.bar_url, json=data)
            trace_id = res.request.headers.get('traceparent').split('-')[1]
            span_id = res.request.headers.get('traceparent').split('-')[2]
            log.info('Ordered coffee: %s - trace_id=%s - span_id=%s', order, trace_id, span_id)
            log.info('Order result: %s - trace_id=%s - span_id=%s', res.text, trace_id, span_id)
        except Exception as ex:
            log.error(ex)

    def run(self):
        while True:
            sleep(self.ratio)
            self.get_coffee()
