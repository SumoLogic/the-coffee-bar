import argparse
import logging as log

from src.bar.cash_desk import CashDesk
from src.utils.config import Config, args_to_conf_dict, merge_configuration
from src.utils.logger import configure_logging
from src.utils.tracing import configure_tracing


def main():
    APP_NAME = 'The Cashdesk'

    parser = argparse.ArgumentParser(description='The Cashdesk v0.0.1')
    parser.add_argument('-H', '--host', type=str, help='HTTP Server Host')
    parser.add_argument('-P', '--port', type=int, help='HTTP Server Port')
    parser.add_argument('-C', '--calculator-host', type=str, help='Calculator HTTP Server Host')
    parser.add_argument('-D', '--calculator-port', type=int, help='Calculator HTTP Server Port')
    parser.add_argument('-S', '--connection-string', type=str, help='Storage Connection String')
    parser.add_argument('-c', '--config', type=str, help='Config file path')
    parser.add_argument('-o', '--exporter-host', type=str, help='Tracing Exporter Host or URL')
    parser.add_argument('-p', '--exporter-port', type=str, help='Tracing Exporter Port')
    parser.add_argument('-e', '--exporter', type=str, help='Exporter type [jaeger_http, jaeger_thrift, otlp, zipkin]')
    parser.add_argument('-s', '--service-name', type=str, help='Service Name', default='the-cashdesk')
    parser.add_argument('-l', '--log-level', type=str, help='Application log level', default='info')
    args = parser.parse_args()

    if args.config:
        config = Config(config_path=args.config)
        conf_file = config.get_the_cashdesk_config()
        conf_args = args_to_conf_dict(args=args)
        configuration = merge_configuration(from_file=conf_file, from_args=conf_args)
    else:
        configuration = args_to_conf_dict(args=args)

    configure_tracing(configuration)
    configure_logging(args.log_level)

    log.info('********** Starting %s **********', APP_NAME)
    log.info('Configuration: %s', configuration)

    cashdesk = CashDesk(name=APP_NAME, host=configuration['host'], port=configuration['port'],
                        calculator_host=configuration['calculator_host'],
                        calculator_port=configuration['calculator_port'],
                        connection_string=configuration['connection_string'])

    cashdesk.run()


main()
