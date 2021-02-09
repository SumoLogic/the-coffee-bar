import json
import logging as log
from random import choice, randint
from time import sleep

import requests


SWEETS = ['cornetto', 'cannolo_siciliano', 'torta', 'muffin_alla_ricotta', 'budini_fiorentini', 'tiramisu']


class CoffeeLover:
    def __init__(self, bar_host: str = 'localhost', bar_port: int = 8082, ratio: int = 5):
        self.bar_url = 'http://{}:{}/order'.format(bar_host, bar_port)
        self.ratio = ratio

        log.info('The Coffee Bar URL: %s', self.bar_url)

    def get_coffee(self):
        order = {
            'coffee': 'espresso',
            'coffee_amount': randint(1, 3),
            'water': randint(-5, 50),
            'grains': randint(-5, 50),
            'sweets_amount': randint(1, 3),
            'sweets': choice(SWEETS),
            'bill': randint(1, 20),
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
