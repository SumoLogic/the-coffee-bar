import argparse
import logging as log

from src.bar.bar import Bar
from src.utils.logger import configure_logging
from src.utils.utils import args_to_conf_dict


def main():
    APP_NAME = 'The Coffee Bar'

    parser = argparse.ArgumentParser(description='The Coffee Bar v0.0.1')
    parser.add_argument('-H', '--host', type=str, help='HTTP Server Host')
    parser.add_argument('-P', '--port', type=int, help='HTTP Server Port')
    parser.add_argument('-m', '--coffeemachine-host', type=str, help='Coffe Machine Host')
    parser.add_argument('-n', '--coffeemachine-port', type=int, help='Coffee Machine Port')
    parser.add_argument('-j', '--cashdesk-host', type=str, help='Cashdesk Host')
    parser.add_argument('-k', '--cashdesk-port', type=int, help='Cashdeks Port')
    parser.add_argument('-s', '--sweets-url', type=str, help='Sweets Endpoint URL')
    parser.add_argument('-c', '--config', type=str, help='Configuration file path')
    parser.add_argument('-l', '--log-level', type=str, help='Application log level', default='info')
    args = parser.parse_args()

    configuration = args_to_conf_dict(args=args)

    configure_logging(args.log_level)

    log.info('********** Starting %s **********', APP_NAME)
    log.info('Configuration: %s', configuration)
    the_bar = Bar(name=APP_NAME, host=configuration['host'], port=configuration['port'],
                  coffee_machine_host=configuration['coffeemachine_host'],
                  coffee_machine_port=configuration['coffeemachine_port'],
                  cashdesk_host=configuration['cashdesk_host'],
                  cashdesk_port=configuration['cashdesk_port'],
                  sweets_url=configuration['sweets_url'],
                  )

    the_bar.run()


main()
