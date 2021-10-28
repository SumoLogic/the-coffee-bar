import threading
import time
from os import getenv
import asyncio
import sys
import logging as log
import subprocess
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.cron import CronTrigger
from cron_descriptor import get_description


def magic_cpu_usage_increaser(period: int):
    start_time = time.time()
    while time.time() - start_time < period:
        pass


def increase_cpu(period: int, threads: int):
    log.info('Increasing CPU Usage - threads=%d' % threads)
    thread_list = []

    for i in range(1, threads):
        t = threading.Thread(target=magic_cpu_usage_increaser, args=(period,))
        thread_list.append(t)

    for thread in thread_list:
        thread.start()

    for thread in thread_list:
        thread.join()


def network_delay_s(delay_s: int, period: int):
    log.info('Adding network delay: %dsec' % delay_s)
    delay = '{}sec'.format(delay_s)
    subprocess.call(['tcset', 'eth0', '--delay', delay])

    start_time = time.time()
    while time.time() - start_time < period * 60:
        time.sleep(1)

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
    cpu_increase_duration = int(getenv('DURATION')) if getenv('DURATION') is not None else 1
    network_delay = int(getenv('NETWORK_DELAY')) if getenv('NETWORK_DELAY') is not None else 3
    cron = str(getenv('CRON')) if getenv('CRON') is not None else '0 * * * *'

    scheduler = BackgroundScheduler()
    cron_trigger = CronTrigger.from_crontab(cron)

    scheduler.add_job(increase_cpu, cron_trigger, [cpu_increase_duration, cpu_increase_threads])
    scheduler.add_job(network_delay_s, cron_trigger, [network_delay, cpu_increase_duration])

    if cpu_increase_duration > 0:
        log.info('CPU KILLER enabled')
        log.info('CRON %s' % get_description(cron))
        log.info('THREADS %d' % cpu_increase_threads)
        log.info('DURATION %d' % cpu_increase_duration)
        log.info('NETWORK_DELAY %d' % network_delay)
        scheduler.start()
        loop.run_forever()
    else:
        log.info('CPU/NETWORK KILLER disabled')
finally:
    loop.close()
