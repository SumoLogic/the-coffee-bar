import logging as log
import requests

from src.bar.coffee_machine import COFFEES
from src.common.http_server import HttpServer


class Bar(HttpServer):
    PRICES = {
        'espresso': 2,
        'cappuccino': 4,
        'americano': 3
    }

    def __init__(self, coffee_machine_host: str, coffee_machine_port: str, cashdesk_host: str, cashdesk_port: int,
                 name: str = 'The Coffee Bar', host: str = 'localhost', port: int = 8082):
        super().__init__(name, host, port)
        self.coffee_machine_host = coffee_machine_host
        self.coffee_machine_port = coffee_machine_port
        self.cashdesk_host = cashdesk_host
        self.cashdesk_port = cashdesk_port
        self.add_all_endpoints()

    def add_all_endpoints(self):
        self.add_endpoint(endpoint='/do_espresso', endpoint_name='do_espresso',
                          handler=self.do_espresso)

    def do_espresso(self, data):
        coffe_machine_url = 'http://{}:{}{}'.format(self.coffee_machine_host, self.coffee_machine_port,
                                                    COFFEES['espresso'])

        log.info('Send request to the coffee-machine')
        coffe_status = requests.post(url=coffe_machine_url, json=data)

        if coffe_status.status_code == 200:
            data.update({'price': self.PRICES['espresso']})
            return self.process_payment(data=data)
        else:
            return coffe_status

    def process_payment(self, data):
        log.info('Send request to the cashdesk', data)
        cashdesk_url = 'http://{}:{}{}'.format(self.cashdesk_host, self.cashdesk_port, '/pay_in')
        cashdesk_status = requests.post(url=cashdesk_url, json=data)

        return cashdesk_status
