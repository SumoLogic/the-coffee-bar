import logging as log
from datetime import datetime, timedelta

import requests
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.triggers.interval import IntervalTrigger
from apscheduler.util import undefined
from flask import Response
from src.common.http_server import HttpServer
from src.utils.cpu_increaser import outage_start, network_outage_start, crashloopbackoff_outage_start

GET_COFFEE_ENDPOINT = '/get_coffee'

log.getLogger('apscheduler.executors.default').setLevel(log.DEBUG)


class CoffeeMachine(HttpServer):

    def __init__(self, name: str = 'The Coffee Machine', host: str = 'localhost', port: int = 8084,
                 machine_svc_host: str = 'localhost', machine_svc_port: int = 9090,
                 spike_cron: str = '0 * * * *', interval_based_trigger: str = 'false', spike_interval_days: int = 0, spike_interval_hours: int = 1, spike_start_date: str = None,
                 spike_duration: int = 60, cpu_spike_processes: int = 1, network_delay: str = None):

        super().__init__(name, host, port)
        self.spike_duration = spike_duration
        self.cpu_spike_processes = cpu_spike_processes
        self.network_delay = network_delay
        self.machine_svc_host = machine_svc_host
        self.machine_svc_port = machine_svc_port
        self.start_date_datetime = undefined
        self.interval_based_trigger = interval_based_trigger
        self.spike_interval_hours = 1
        self.spike_interval_days = 0
        self.start_date_datetime_interval = datetime.now() + timedelta(hours = self.spike_interval_hours)
        self.add_all_endpoints()

        # Increase CPU usage for some time and add network delay
        self.scheduler = BackgroundScheduler(job_defaults={'max_instances': 2})

        if self.interval_based_trigger == 'true':
            self.spike_interval_days = spike_interval_days
            self.spike_interval_hours = spike_interval_hours
            self.start_date_datetime_interval = datetime.now() + timedelta(hours = self.spike_interval_hours)
            self.trigger = IntervalTrigger(hours=self.spike_interval_hours)
            log.info('Interval Trigger Next Fire Time: %s)', self.trigger.get_next_fire_time)

        else:
            self.spike_cron = spike_cron
            self.trigger = CronTrigger.from_crontab(self.spike_cron)
            log.info('CRON Trigger Next Fire Time: %s)',  self.trigger.get_next_fire_time)

        try:
            if spike_start_date is not None:
                self.start_date_datetime = datetime.strptime(spike_start_date, '%Y-%m-%d %H:%M:%S')
                self.start_date_datetime_interval = self.start_date_datetime
        except:
            log.info('Invalid Date Format for CRON start date.')

        log.info('Spike Start Date: %s', self.start_date_datetime)

        if self.spike_duration is not None:
            self.scheduler.add_job(func=outage_start,
                                   trigger=self.trigger,
                                   args=[self.spike_duration, self.cpu_spike_processes, self.spike_interval_days, self.start_date_datetime_interval, self.interval_based_trigger],
                                   next_run_time=self.start_date_datetime)
        if self.network_delay is not None:
            self.scheduler.add_job(func=network_outage_start,
                                   trigger=self.trigger,
                                   args=[self.network_delay, self.spike_duration, self.spike_interval_days, self.start_date_datetime_interval, self.interval_based_trigger],
                                   next_run_time=self.start_date_datetime)

        self.scheduler.start()
        # Todo pass in values.yaml and in command template to make below configurable with duration
        crashloopbackoff_outage_start()

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
