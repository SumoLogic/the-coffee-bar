import argparse
import logging as log

from src.bar.cash_desk import CashDesk
from src.utils.logger import configure_logging
from src.utils.utils import args_to_conf_dict


def main():
    APP_NAME = 'The Cashdesk'

    parser = argparse.ArgumentParser(description='The Cashdesk v0.0.1')
    parser.add_argument('-H', '--host', type=str, help='HTTP Server Host')
    parser.add_argument('-P', '--port', type=int, help='HTTP Server Port')
    parser.add_argument('-C', '--calculator-host', type=str, help='Calculator HTTP Server Host')
    parser.add_argument('-D', '--calculator-port', type=int, help='Calculator HTTP Server Port')
    parser.add_argument('-PH', '--proxy-svc-host', type=str, help='Proxy Service HTTP Server Host')
    parser.add_argument('-PP', '--proxy-svc-port', type=int, help='Proxy Service HTTP Server Port')
    parser.add_argument('-S', '--connection-string', type=str, help='Storage Connection String')
    parser.add_argument('-c', '--config', type=str, help='Config file path')
    parser.add_argument('-l', '--log-level', type=str, help='Application log level', default='info')
    args = parser.parse_args()

    configuration = args_to_conf_dict(args=args)

    configure_logging(args.log_level)

    log.info('********** Starting %s **********', APP_NAME)
    log.info('Configuration: %s', configuration)

    cashdesk = CashDesk(name=APP_NAME, host=configuration['host'], port=configuration['port'],
                        calculator_host=configuration['calculator_host'],
                        calculator_port=configuration['calculator_port'],
                        proxy_svc_host=configuration['proxy_svc_host'],
                        proxy_svc_port=configuration['proxy_svc_port'],
                        connection_string=configuration['connection_string'])

    cashdesk.run()


main()
