import argparse
import logging as log

from src.bar.bar import Bar
from src.utils.config import Config, args_to_conf_dict, merge_configuration
from src.utils.logger import configure_logging
from src.utils.tracing import configure_tracing


def main():
    APP_NAME = 'The Coffee Bar'

    parser = argparse.ArgumentParser(description='The Coffee Bar v0.0.1')
    parser.add_argument('-H', '--host', type=str, help='HTTP Server Host')
    parser.add_argument('-P', '--port', type=int, help='HTTP Server Port')
    parser.add_argument('-m', '--coffeemachine-host', type=str, help='Coffe Machine Host')
    parser.add_argument('-n', '--coffeemachine-port', type=int, help='Coffee Machine Port')
    parser.add_argument('-j', '--cashdesk-host', type=str, help='Cashdesk Host')
    parser.add_argument('-k', '--cashdesk-port', type=int, help='Cashdeks Port')
    parser.add_argument('-c', '--config', type=str, help='Configuration file path')
    parser.add_argument('-o', '--exporter-host', type=str, help='Jaeger Thrift Exporter Host')
    parser.add_argument('-p', '--exporter-port', type=str, help='Jaeger Thrift Exporter Port')
    parser.add_argument('-E', '--exporter-endpoint', type=str, help='Jaeger HTTP, Zipkin, OTLP Exporter Endpoint')
    parser.add_argument('-I', '--exporter-insecure', type=str, help='OTLP Exporter insecure flag')
    parser.add_argument('-e', '--exporter', type=str, help='Exporter type [jaeger_http, jaeger_thrift, otlp, zipkin]')
    parser.add_argument('-s', '--service-name', type=str, help='Service Name', default='the-coffee-bar')
    parser.add_argument('-l', '--log-level', type=str, help='Application log level', default='info')
    args = parser.parse_args()

    if args.config:
        config = Config(config_path=args.config)
        conf_file = config.get_the_coffee_bar_config()
        conf_args = args_to_conf_dict(args=args)
        configuration = merge_configuration(from_file=conf_file, from_args=conf_args)
    else:
        configuration = args_to_conf_dict(args=args)

    configure_tracing(configuration)
    configure_logging(args.log_level)

    log.info('********** Starting %s **********', APP_NAME)
    log.info('Configuration: %s', configuration)
    the_bar = Bar(name=APP_NAME, host=configuration['host'], port=configuration['port'],
                  coffee_machine_host=configuration['coffeemachine_host'],
                  coffee_machine_port=configuration['coffeemachine_port'],
                  cashdesk_host=configuration['cashdesk_host'],
                  cashdesk_port=configuration['cashdesk_port'])

    the_bar.run()


main()
