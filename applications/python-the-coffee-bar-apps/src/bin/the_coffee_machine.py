import argparse
import logging as log

from cron_descriptor import get_description
from src.bar.coffee_machine import CoffeeMachine
from src.utils.logger import configure_logging
from src.utils.utils import args_to_conf_dict


def main():
    APP_NAME = 'The Coffee Machine'

    parser = argparse.ArgumentParser(description='The Coffee Machine v0.0.1')
    parser.add_argument('-H', '--host', type=str, help='HTTP Server Host')
    parser.add_argument('-P', '--port', type=int, help='HTTP Server Port')
    parser.add_argument('-m', '--machine-svc-host', type=str, help='Machine Service Host')
    parser.add_argument('-n', '--machine-svc-port', type=int, help='Machine Service Port')
    parser.add_argument('-c', '--config', type=str, help='Configuration file path')
    parser.add_argument('-i', '--spike-cron', type=str, help='CPU/Network delay CRON string')
    parser.add_argument('-ci', '--interval_based_cron', type=str, help='Use interval trigger in addition to CRON. - true/false')
    parser.add_argument('-sd', '--spike_interval_days', type=str, help='How many days to skip?')
    parser.add_argument('-s', '--spike-start-date', type=str, help='CPU/Network delay cron start date string')
    parser.add_argument('-d', '--spike-duration', type=int, help='CPU/Network delay spike duration [seconds]')
    parser.add_argument('-t', '--cpu-spike-processes', type=int, help='Number of processes for CPU increaser')
    parser.add_argument('-e', '--network-delay', type=str, help='Network Delay - NUMBERsec or NUMBERms')
    parser.add_argument('-l', '--log-level', type=str, help='Application log level', default='info')
    args = parser.parse_args()

    configuration = args_to_conf_dict(args=args)

    configure_logging(args.log_level)

    log.info('********** Starting %s **********', APP_NAME)
    log.info('Configuration: %s', configuration)
    log.info('Spike CRON: %s', get_description(configuration['spike_cron']))
    log.info('Spike start date: %s', configuration['spike_start_date'])
    log.info('Network delay: %s', configuration['network_delay'])

    coffee_machine = CoffeeMachine(name=APP_NAME, host=configuration['host'], port=configuration['port'],
                                   machine_svc_host=configuration['machine_svc_host'],
                                   machine_svc_port=configuration['machine_svc_port'],
                                   spike_cron=configuration['spike_cron'],
                                   interval_based_cron=configuration['interval_based_cron'],
                                   spike_interval_days=configuration['spike_interval_days'],
                                   spike_start_date=configuration['spike_start_date'],
                                   spike_duration=configuration['spike_duration'],
                                   cpu_spike_processes=configuration['cpu_spike_processes'],
                                   network_delay=configuration['network_delay'])
    coffee_machine.run()


main()
