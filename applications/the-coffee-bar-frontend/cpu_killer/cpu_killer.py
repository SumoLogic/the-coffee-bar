import asyncio
import logging as log
from multiprocessing.pool import Pool
from os import getenv
import subprocess
import sys
import time

from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from apscheduler.util import undefined
from cron_descriptor import get_description
from datetime import datetime


def magic_cpu_usage_increaser(period: int):
    start_time = time.time()
    while time.time() - start_time < period:
        pass


def increase_cpu(period: int, threads: int):
    log.info('Increasing CPU Usage - threads=%d' % threads)
    with Pool(threads) as p:
        p.map(magic_cpu_usage_increaser, [period])


def network_delay(delay_s: int, period: int):
    log.info('Adding network delay: %dsec' % delay_s)
    delay = '{}sec'.format(delay_s)
    subprocess.call(['tcset', 'eth0', '--delay', delay])

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
    cpu_increase_threads = int(getenv('THREADS_NO')) if getenv('THREADS_NO') is not None else 475
    increase_duration_s = int(getenv('DURATION')) if getenv('DURATION') is not None else 60
    network_delay_s = int(getenv('NETWORK_DELAY')) if getenv('NETWORK_DELAY') is not None else 3
    cron_start_date = str(getenv('CRON_START_DATE'))
    datetime_object = undefined
    try:
        if cron_start_date is not None:
            datetime_object = datetime.strptime(cron_start_date, '%Y-%m-%d %H:%M:%S')
    except:
        log.info('Invalid Date Format for CRON start date.')

    log.info('Cron Start Date %s', datetime_object)
    cron = str(getenv('CRON')) if getenv('CRON') is not None else '0 */12 * * */4'

    scheduler = BackgroundScheduler()
    cron_trigger = CronTrigger.from_crontab(cron)

    scheduler.add_job(increase_cpu, cron_trigger, [increase_duration_s, cpu_increase_threads],
                      next_run_time=datetime_object)
    scheduler.add_job(network_delay, cron_trigger, [network_delay_s, increase_duration_s], next_run_time=datetime_object)

    if increase_duration_s > 0:
        log.info('CPU KILLER enabled')
        log.info('CRON %s' % get_description(cron))
        log.info('CRON START DATE %s' % datetime_object)
        log.info('THREADS %d' % cpu_increase_threads)
        log.info('DURATION (s) %d' % increase_duration_s)
        log.info('NETWORK DELAY (s) %d' % network_delay_s)
        scheduler.start()
        loop.run_forever()
    else:
        log.info('CPU/NETWORK KILLER disabled')
finally:
    loop.close()