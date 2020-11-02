import json
import logging as log

import requests

from src.bar.storage import Storage
from src.common.http_server import CustomResponse
from src.common.http_server import HttpServer


class CashDesk(HttpServer):

    def __init__(self, connection_string: str, name: str = 'Cash Desk', host: str = 'localhost', port: int = 8084,
                 calculator_host: str = 'calculator-svc', calculator_port: int = 8090):
        super().__init__(name, host, port)
        self.calculator_host = calculator_host
        self.calculator_port = calculator_port
        self.db = Storage(connection_string=connection_string)
        self.add_pay_in_endpoint()

    def add_pay_in_endpoint(self):
        self.add_endpoint(endpoint='/pay_in', endpoint_name='pay_in', handler=self.payment)

    def call_calculator(self, data):
        log.info('Calculating total price for %s', data['product'])

        calculator_svc_url = 'http://{}:{}/Calculator'.format(self.calculator_host, self.calculator_port)

        res = None
        try:
            res = requests.post(url=calculator_svc_url, data=json.dumps(data))
            log.info('Calculation result: %s', res.text)
        except requests.exceptions.RequestException as ex:
            log.error(ex)
        finally:
            return res

    def payment(self, data):
        log.info('Payment in progress: %s', data)

        log.info('Get product price')
        price = self.get_product_price(data=data)
        data['price'] = price

        response = CustomResponse()

        calculation_res = self.call_calculator(data=data)
        if calculation_res:
            result = calculation_res.json()
            payout = data['bill'] - result['total']

            if payout >= 0:
                log.info('Process payment')
                items_sold = self.get_items_sold(data=data)
                total_items = items_sold + 1
                self.db.update_items((total_items, data['product']))
                response.msg = 'Money rest: %s' % payout
                log.info('Payment processed successfully. Money rest %s', payout)
            else:
                response.code = 402
                response.error = 'Not enough money'
                log.error('Not enough money')
        else:
            response.code = calculation_res.status_code
            response.error = 'Error during calculation'
            log.error('Error during calculation')

        return response

    def get_product_price(self, data):
        product = self.db.get_price_of_product(product_name=data['product'])
        return product['price']

    def get_items_sold(self, data):
        product = self.db.get_items_sold(product_name=data['product'])
        return product['items_sold']
