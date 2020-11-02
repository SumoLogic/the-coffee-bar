import logging as log

import argparse

from src.bar.coffee_lover import CoffeeLover
from src.utils.config import Config, args_to_conf_dict, merge_configuration
from src.utils.logger import configure_basic_logging
from src.utils.tracing import configure_tracing


def main():
    APP_NAME = 'The Coffee Lover'

    parser = argparse.ArgumentParser(description='The Coffee Lover v0.0.1')
    parser.add_argument('-H', '--host', type=str, help='The Coffee Bar Server Host')
    parser.add_argument('-P', '--port', type=int, help='The Coffe Bar Server Port')
    parser.add_argument('-r', '--ratio', type=int, help='Time interval for requests [s]')
    parser.add_argument('-c', '--config', type=str, help='Configuration file path')
    parser.add_argument('-o', '--exporter-host', type=str, help='Tracing Exporter Host or URL')
    parser.add_argument('-p', '--exporter-port', type=str, help='Tracing Exporter Port')
    parser.add_argument('-e', '--exporter', type=str, help='Exporter type [jaeger_http, jaeger_thrift, otlp, zipkin]')
    parser.add_argument('-s', '--service-name', type=str, help='Service Name', default='the-coffee-lover')
    parser.add_argument('-l', '--log-level', type=str, help='Application log level', default='info')
    args = parser.parse_args()

    if args.config:
        config = Config(config_path=args.config)
        conf_file = config.get_the_coffee_lover_config()
        conf_args = args_to_conf_dict(args=args)
        configuration = merge_configuration(from_file=conf_file, from_args=conf_args)
    else:
        configuration = args_to_conf_dict(args=args)

    configure_tracing(configuration)
    configure_basic_logging(args.log_level)

    log.info('********** Starting %s **********', APP_NAME)
    log.info('Configuration: %s', configuration)

    coffee_lover = CoffeeLover(bar_host=configuration['host'], bar_port=configuration['port'],
                               ratio=configuration['ratio'])

    coffee_lover.run()


main()
