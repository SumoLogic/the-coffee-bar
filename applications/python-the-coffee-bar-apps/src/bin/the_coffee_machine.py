import argparse
import logging as log

from src.bar.coffee_machine import CoffeeMachine
from src.utils.config import Config, args_to_conf_dict, merge_configuration
from src.utils.logger import configure_logging

from cron_descriptor import get_description


def main():
    APP_NAME = 'The Coffee Machine'

    parser = argparse.ArgumentParser(description='The Coffee Machine v0.0.1')
    parser.add_argument('-H', '--host', type=str, help='HTTP Server Host')
    parser.add_argument('-P', '--port', type=int, help='HTTP Server Port')
    parser.add_argument('-m', '--machine-svc-host', type=str, help='Machine Service Host')
    parser.add_argument('-n', '--machine-svc-port', type=int, help='Machine Service Port')
    parser.add_argument('-c', '--config', type=str, help='Configuration file path')
    parser.add_argument('-i', '--cpu-increase-cron', type=str, help='CPU increase cron string')
    parser.add_argument('-s', '--cpu-increase-start-date', type=str, help='CPU increase cron start date string')
    parser.add_argument('-d', '--cpu-increase-duration', type=int, help='CPU increase duration [seconds]')
    parser.add_argument('-t', '--cpu-increase-threads', type=int, help='Number of threads for CPU increaser')
    parser.add_argument('-l', '--log-level', type=str, help='Application log level', default='info')
    args = parser.parse_args()

    if args.config:
        config = Config(config_path=args.config)
        conf_file = config.get_the_coffeemachine_config()
        conf_args = args_to_conf_dict(args=args)
        configuration = merge_configuration(from_file=conf_file, from_args=conf_args)
    else:
        configuration = args_to_conf_dict(args=args)

    configure_logging(args.log_level)

    log.info('********** Starting %s **********', APP_NAME)
    log.info('Configuration: %s', configuration)
    log.info('CPU Increaser CRON: %s', get_description(configuration['cpu_increase_cron']))
    log.info('CPU Increase start date: %s', configuration['cpu_increase_start_date'])

    coffee_machine = CoffeeMachine(name=APP_NAME, host=configuration['host'], port=configuration['port'],
                                   machine_svc_host=configuration['machine_svc_host'],
                                   machine_svc_port=configuration['machine_svc_port'],
                                   cpu_increase_cron=configuration['cpu_increase_cron'],
                                   cpu_increase_start_date=configuration['cpu_increase_start_date'],
                                   cpu_increase_duration=configuration['cpu_increase_duration'],
                                   cpu_increase_threads=configuration['cpu_increase_threads'])
    coffee_machine.run()


main()
