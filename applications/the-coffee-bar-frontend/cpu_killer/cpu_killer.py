import asyncio
import logging as log
import subprocess
import sys
import time
from datetime import datetime
from multiprocessing.pool import Pool
from os import getenv

from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.util import undefined
from cron_descriptor import get_description


def magic_cpu_usage_increaser(period: int):
    start_time = time.time()
    while time.time() - start_time < period:
        pass


def increase_cpu(period: int, threads: int):
    log.info('Increasing CPU Usage - threads=%d' % threads)
    with Pool(threads) as p:
        p.map(magic_cpu_usage_increaser, [period])


def network_delay(delay: str, period: int):
    log.info('Adding network delay: %s' % delay)
    subprocess.call(['tcset', 'eth0', '--port', '3000', '--delay', delay])

    time.sleep(period)

    log.info('Removing network delay')
    subprocess.call(['tcdel', 'eth0', '--all'])


root = log.getLogger()
root.setLevel(log.INFO)
root.name = 'cpu_killer'

span_formattter = log.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

stdout_handler = log.StreamHandler(sys.stdout)
stdout_handler.setLevel(log.INFO)
stdout_handler.setFormatter(span_formattter)
root.addHandler(stdout_handler)

loop = asyncio.get_event_loop()
try:
    cpu_spike_processes = int(getenv('CPU_SPIKE_PROCESSES')) if getenv('CPU_SPIKE_PROCESSES') is not None else 475
    spike_duration = int(getenv('SPIKE_DURATION')) if getenv('SPIKE_DURATION') is not None else 60
    network_delay_time = str(getenv('NETWORK_DELAY')) if getenv('NETWORK_DELAY') is not None else '1sec'
    spike_start_date = str(getenv('SPIKE_START_DATE'))
    datetime_object = undefined
    try:
        if spike_start_date is not None:
            datetime_object = datetime.strptime(spike_start_date, '%Y-%m-%d %H:%M:%S')
    except:
        log.info('Invalid Date Format for CRON start date.')

    log.info('Cron Start Date %s', datetime_object)
    cron = str(getenv('SPIKE_CRON')) if getenv('SPIKE_CRON') is not None else '0 * * * *'

    scheduler = BackgroundScheduler()
    cron_trigger = CronTrigger.from_crontab(cron)

    scheduler.add_job(increase_cpu, cron_trigger, [spike_duration, cpu_spike_processes],
                      next_run_time=datetime_object)
    scheduler.add_job(network_delay, cron_trigger, [network_delay_time, spike_duration],
                      next_run_time=datetime_object)

    if spike_duration > 0:
        log.info('CPU KILLER enabled')
        log.info('SPIKE CRON %s' % get_description(cron))
        log.info('SPIKE START DATE %s' % datetime_object)
        log.info('CPU SPIKE PROCESSES %d' % cpu_spike_processes)
        log.info('SPIKE DURATION (s) %d' % spike_duration)
        log.info('NETWORK DELAY %s' % network_delay_time)
        scheduler.start()
        loop.run_forever()
    else:
        log.info('CPU/NETWORK KILLER disabled')
finally:
    loop.close()
