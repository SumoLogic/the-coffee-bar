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
        self.db = Storage(connection_string=connection_string, stats=self.stats)
        self.add_pay_in_endpoint()

    def add_pay_in_endpoint(self):
        self.add_endpoint(endpoint='/pay_in', endpoint_name='pay_in', handler=self.payment)

    def call_calculator(self, data):
        log.info('Calculating total price for %s', data['product'])

        calculator_svc_url = 'http://{}:{}/Calculator'.format(self.calculator_host, self.calculator_port)
        success = False
        result = ''
        try:
            res = requests.post(url=calculator_svc_url, data=json.dumps(data))
            log.info('Calculation result: %s', res.text)
            success = True
            result = res.json()
        except requests.exceptions.RequestException as ex:
            result = ex
            log.error(ex)
        finally:
            return success, result

    def make_calculation(self, data: dict, product: str):
        log.info('Get product price: %s', data[product])
        product_amount = '{}_amount'.format(product)

        success, error, result = self.db.get_price_of_product(product_name=data[product])
        if success:
            product_price = result['price']
            calculation_data = calculation_order(product=data[product], price=product_price,
                                                 amount=data[product_amount])
            callculation_success, data = self.call_calculator(data=calculation_data)
            if callculation_success:
                data = data['total']
            return callculation_success, data
        else:
            return success, error

    def update_items_status(self, data: dict, product: str):
        success, error, result = self.db.get_items_sold(product_name=data[product])
        if success:
            items_sold = result['items_sold']
            total_items = items_sold + 1
            update_success, update_error = self.db.update_items((total_items, data[product]))
            return update_success
        else:
            return success

    def payment(self, data: dict):
        log.info('Payment in progress: %s', data)

        sweets_amount_to_pay = 0
        if 'sweets_status' in data and data['sweets_status'] is True:
            success, res = self.make_calculation(data=data, product='sweets')
            if success:
                sweets_amount_to_pay = res
            else:
                return make_response({'result': 'Calculation error, check logs'}, 500)

        coffee_amount_to_pay = 0
        if 'coffee_status' in data and data['coffee_status'] is True:
            success, res = self.make_calculation(data=data, product='coffee')
            if success:
                coffee_amount_to_pay = res
            else:
                return make_response({'result': 'Calculation error, check logs'}, 500)

        total_amount_to_pay = sweets_amount_to_pay + coffee_amount_to_pay

        payout = data['bill'] - total_amount_to_pay
        if payout >= 0:
            log.info('Process payment')
            if 'sweets_status' in data and data['sweets_status'] is True:
                success = self.update_items_status(data=data, product='sweets')
                if success is False:
                    return make_response({'result': 'Database error, check logs'}, 500)
            if 'coffee_status' in data and data['coffee_status'] is True:
                success = self.update_items_status(data=data, product='coffee')
                if success is False:
                    return make_response({'result': 'Database error, check logs'}, 500)

            log.info('Payment processed successfully. Money rest %s', payout)

            return make_response({'result': 'Money rest: %s' % payout}, 200)
        else:
            log.error('Payment failed. Not enough money')
            return make_response({'result': 'Not enough money'}, 402)
