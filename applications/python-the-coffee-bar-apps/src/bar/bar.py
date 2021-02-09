import logging as log

from flask import Response
import requests

from src.bar.coffee_machine import COFFEES
from src.common.http_server import HttpServer


PRICES = {
    'espresso': 2,
    'cappuccino': 4,
    'americano': 3,
    'cornetto': 1,
    'cannolo_siciliano': 3,
    'torta': 1.5,
    'budini_fiorentini': 1.25,
    'muffin_alla_ricotta': 2,
    'tiramisu': 2.5,
}


def set_product_status(response: requests.models.Response, status_key: str):
    product_status = {}

    if response.status_code == 200:
        product_status[status_key] = True
    else:
        product_status[status_key] = False

    return product_status


class Bar(HttpServer):
    def __init__(self, coffee_machine_host: str, coffee_machine_port: str, cashdesk_host: str, cashdesk_port: int,
                 name: str = 'The Coffee Bar', host: str = 'localhost', port: int = 8082, sweets_url: str = None):
        super().__init__(name, host, port)
        self.coffee_machine_host = coffee_machine_host
        self.coffee_machine_port = coffee_machine_port
        self.cashdesk_host = cashdesk_host
        self.cashdesk_port = cashdesk_port
        self.sweets_url = sweets_url
        self.add_all_endpoints()

    def add_all_endpoints(self):
        self.add_endpoint(endpoint='/order', endpoint_name='order',
                          handler=self.order)

    def order(self, data):

        # OPTIONAL: If sweets_url is set, get sweets_status
        sweets_status = {'sweets_status': False}
        if self.sweets_url:
            sweets_status = self.get_sweets(data=data)
            data.update(sweets_status)

        # Get coffee_status
        coffee_status = self.get_coffee(data=data)
        data.update(coffee_status)

        if coffee_status['coffee_status'] is True or sweets_status['sweets_status'] is True:
            return self.process_payment(data=data)
        else:
            result = {
                'reason': 'Lack of requested products',
                'products': [data['coffee'], data['sweets']],
            }
            return Response(result, status=404, mimetype='application/json')

    def get_sweets(self, data):
        log.info('Check if %s is available', data['sweets'])
        response = requests.post(url=self.sweets_url, json=data)

        return set_product_status(response=response, status_key='sweets_status')

    def get_coffee(self, data):
        log.info('Send request to the coffee-machine')
        coffee_machine_url = 'http://{}:{}{}'.format(self.coffee_machine_host, self.coffee_machine_port,
                                                     COFFEES['espresso'])

        response = requests.post(url=coffee_machine_url, json=data)

        return set_product_status(response=response, status_key='coffee_status')

    def process_payment(self, data):
        log.info('Send request to the cashdesk', data)
        cashdesk_url = 'http://{}:{}{}'.format(self.cashdesk_host, self.cashdesk_port, '/pay_in')
        cashdesk_status = requests.post(url=cashdesk_url, json=data)

        return cashdesk_status
