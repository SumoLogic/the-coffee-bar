import logging as log

from flask import make_response
import requests
import datetime

from src.bar.coffee_machine import GET_COFFEE_ENDPOINT
from src.common.http_server import HttpServer


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
            if data['sweets_amount'] > 0:
                sweets_status = self.get_sweets(data=data)
                data.update(sweets_status)
            else:
                log.warning('Sweets were not requested.')
        else:
            log.warning('Sweets URL not configured. Sweets will be not provided.')

        # Get coffee_status
        coffee_status = {'coffee_status': False}
        if data['coffee_amount'] > 0:
            coffee_status = self.get_coffee(data=data)
            data.update(coffee_status)
        else:
            log.warning('Coffee was not requested.')

        # Coffee Amount and Sweets Amount <= 0 - no order
        if data['coffee_amount'] <= 0 and data['sweets_amount'] <= 0:
            result = {
                'reason': 'Please make an order.'
            }
            log.warning('Please make an order.')
            return make_response(result, 204)

        if coffee_status['coffee_status'] is True or sweets_status['sweets_status'] is True:
            return self.process_payment(data=data)
        else:
            if coffee_status['coffee_status'] is False and sweets_status['sweets_status'] is False:
                result = {
                    'reason': 'Lack of requested products: {}, {}'.format(data['coffee'], data['sweets']),
                }
            elif coffee_status['coffee_status'] is True and sweets_status['sweets_status'] is False:
                result = {
                    'reason': 'Lack of requested product: {}, {} provided.'.format(data['sweets'], data['coffee']),
                }
            elif coffee_status['coffee_status'] is False and sweets_status['sweets_status'] is True:
                result = {
                    'reason': 'Lack of requested product: {}, {} provided.'.format(data['coffee'], data['sweets']),
                }
            return make_response(result, 404)

    def get_sweets(self, data):
        log.info('Check if %s is available', data['sweets'])
        response = requests.post(url=self.sweets_url, json=data)

        return set_product_status(response=response, status_key='sweets_status')

    def get_coffee(self, data):
        start_time = datetime.datetime.now()
        log.info('Send request to the coffee-machine')
        coffee_machine_url = 'http://{}:{}{}'.format(self.coffee_machine_host, self.coffee_machine_port,
                                                     GET_COFFEE_ENDPOINT)

        response = requests.post(url=coffee_machine_url, json=data)
        end_time = datetime.datetime.now()
        time_diff = (end_time - start_time)
        request_time = time_diff.total_seconds() * 1000
        log.info('Coffee preparation request time: %s ms', request_time)

        return set_product_status(response=response, status_key='coffee_status')

    def process_payment(self, data):
        log.info('Send request to the cashdesk', data)
        cashdesk_url = 'http://{}:{}{}'.format(self.cashdesk_host, self.cashdesk_port, '/pay_in')
        cashdesk_status = requests.post(url=cashdesk_url, json=data)

        return cashdesk_status
