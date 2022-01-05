import argparse
import logging as log

from src.bar.coffee_lover import CoffeeLover
from src.utils.logger import configure_basic_logging
from src.utils.utils import args_to_conf_dict


def main():
    APP_NAME = 'The Coffee Lover'

    parser = argparse.ArgumentParser(description='The Coffee Lover v0.0.1')
    parser.add_argument('-H', '--host', type=str, help='The Coffee Bar Server Host')
    parser.add_argument('-P', '--port', type=int, help='The Coffe Bar Server Port')
    parser.add_argument('-r', '--ratio', type=int, help='Time interval for requests [s]')
    parser.add_argument('-c', '--config', type=str, help='Configuration file path')
    parser.add_argument('-l', '--log-level', type=str, help='Application log level', default='info')
    args = parser.parse_args()

    configuration = args_to_conf_dict(args=args)

    configure_basic_logging(args.log_level)

    log.info('********** Starting %s **********', APP_NAME)
    log.info('Configuration: %s', configuration)

    coffee_lover = CoffeeLover(bar_host=configuration['host'], bar_port=configuration['port'],
                               ratio=configuration['ratio'])

    coffee_lover.run()


main()
