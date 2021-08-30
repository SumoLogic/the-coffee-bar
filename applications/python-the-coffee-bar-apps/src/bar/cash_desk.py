import json
import logging as log

from flask import make_response, Response
import requests

from src.bar.storage import Storage
from src.common.http_server import HttpServer


def calculation_order(product: str, price: int, amount: int):
    order = {
        'product': product,
        'price': price,
        'amount': amount,
    }

    return order


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

        try:
            res = requests.post(url=calculator_svc_url, data=json.dumps(data))
            log.info('Calculation result: %s', res.text)
            return res.json()
        except requests.exceptions.RequestException as ex:
            log.error(ex)
            return make_response({'result': 'Error during calculation'}, 500)

    def payment(self, data):
        log.info('Payment in progress: %s', data)

        log.info('Get product price')

        sweets_amount_to_pay = 0
        if 'sweets_status' in data and data['sweets_status'] is True:
            sweets_price = self.get_product_price(product=data['sweets'])
            calculation_data = calculation_order(product=data['sweets'], price=sweets_price,
                                                 amount=data['sweets_amount'])
            sweets_amount_to_pay = self.call_calculator(data=calculation_data)['total']

        coffee_amount_to_pay = 0
        if 'coffee_status' in data and data['coffee_status'] is True:
            coffee_price = self.get_product_price(product=data['coffee'])
            calculation_data = calculation_order(product=data['coffee'], price=coffee_price,
                                                 amount=data['coffee_amount'])
            coffee_amount_to_pay = self.call_calculator(data=calculation_data)['total']

        total_amount_to_pay = sweets_amount_to_pay + coffee_amount_to_pay

        payout = data['bill'] - total_amount_to_pay
        if payout >= 0:
            log.info('Process payment')

            if 'sweets_status' in data and data['sweets_status'] is True:
                items_sold = self.get_items_sold(product=data['sweets'])
                total_items = items_sold + 1
                self.db.update_items((total_items, data['sweets']))

            if 'coffee_status' in data and data['coffee_status'] is True:
                items_sold = self.get_items_sold(product=data['coffee'])
                total_items = items_sold + 1
                self.db.update_items((total_items, data['coffee']))

            log.info('Payment processed successfully. Money rest %s', payout)

            return make_response({'result': 'Money rest: %s' % payout}, 200)
        else:
            log.error('Payment failed. Not enough money')
            return make_response({'result': 'Not enough money'}, 402)

    def get_product_price(self, product: str):
        product = self.db.get_price_of_product(product_name=product)
        return product['price']

    def get_items_sold(self, product: str):
        product = self.db.get_items_sold(product_name=product)
        return product['items_sold']
