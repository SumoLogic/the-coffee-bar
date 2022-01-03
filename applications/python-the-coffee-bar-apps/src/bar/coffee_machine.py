import logging as log
from datetime import datetime

import requests
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.util import undefined
from flask import Response
from src.common.http_server import HttpServer
from src.utils.cpu_increaser import increase_cpu, set_network_delay

GET_COFFEE_ENDPOINT = '/get_coffee'


class CoffeeMachine(HttpServer):

    def __init__(self, name: str = 'The Coffee Machine', host: str = 'localhost', port: int = 8084,
                 machine_svc_host: str = 'localhost', machine_svc_port: int = 9090,
                 spike_cron: str = '0 * * * *', spike_start_date: str = None,
                 spike_duration: int = 60, cpu_spike_processes: int = 1, network_delay: str = None):

        super().__init__(name, host, port)
        self.spike_cron = spike_cron
        self.spike_duration = spike_duration
        self.cpu_spike_processes = cpu_spike_processes
        self.network_delay = network_delay
        self.machine_svc_host = machine_svc_host
        self.machine_svc_port = machine_svc_port
        self.datetime_object = undefined

        try:
            if spike_start_date is not None:
                self.datetime_object = datetime.strptime(spike_start_date, '%Y-%m-%d %H:%M:%S')
        except:
            log.info('Invalid Date Format for CRON start date.')

        log.info('Spike start date is: %s', self.datetime_object)
        self.add_all_endpoints()

        # Increase CPU usage for some time and add network delay
        self.scheduler = BackgroundScheduler()
        self.cron = CronTrigger.from_crontab(self.spike_cron)

        if self.spike_duration is not None:
            self.scheduler.add_job(func=increase_cpu,
                                   trigger=self.cron,
                                   args=[self.spike_duration, self.cpu_spike_processes],
                                   next_run_time=self.datetime_object)
        if self.network_delay is not None:
            self.scheduler.add_job(func=set_network_delay,
                                   trigger=self.cron,
                                   args=[self.network_delay, self.spike_duration],
                                   next_run_time=self.datetime_object)

        self.scheduler.start()

    def add_all_endpoints(self):
        self.add_endpoint(endpoint=GET_COFFEE_ENDPOINT, endpoint_name='espresso', handler=self.prepare_coffee)

    def prepare_coffee(self, data):
        start_time = datetime.now()
        log.info('Preparing espresso coffee')

        coffee_machine_svc_url = 'http://{}:{}{}'.format(self.machine_svc_host, self.machine_svc_port,
                                                         '/prepare_coffee')

        coffee_status = requests.post(url=coffee_machine_svc_url, json=data)

        end_time = datetime.now()
        time_diff = (end_time - start_time)
        preparation_time = time_diff.total_seconds() * 1000
        if coffee_status.status_code == 200:
            log.info('Coffee done (Preparation time: %s ms)', preparation_time)
            return Response(coffee_status.text, status=coffee_status.status_code, mimetype='application/json')
        else:
            log.error('Missing some ingredients')
            return Response(coffee_status.text, status=coffee_status.status_code, mimetype='application/json')
