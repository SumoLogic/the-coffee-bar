from datetime import datetime
import logging as log
import subprocess
import time
from multiprocessing.pool import Pool


def magic_cpu_usage_increaser(period: int):
    start_time = time.time()
    while time.time() - start_time < period:
        pass
    log.error('Thread stuck in kernel module for %s seconds, waiting for file descriptor to be released.'
              'Too many open files.', period)


def increase_cpu(period: int, threads: int, interval_days: int, start_date: datetime, interval_based_trigger: str):
    if interval_based_trigger == 'false' or (interval_based_trigger == 'true' and (datetime.now().day - start_date.day) % interval_days == 0):
        log.info('Deploying new version 1.20.124')
        log.info('Upgrade initiated: admin mode by joe@sumocoffee.com')
        with Pool(threads) as p:
            p.map(magic_cpu_usage_increaser, [period])

        log.info('Deploying new version 1.20.123')
    else:
        log.info('Not yet time for the CPU trigger.')


def set_network_delay(delay: str, period: int, interval_days: int, start_date: datetime, interval_based_trigger: str):
    if interval_based_trigger == 'false' or (interval_based_trigger == 'true' and (datetime.now().day - start_date.day) % interval_days == 0):
        log.info('Adding network delay: %s' % delay)
        subprocess.call(['tcset', 'eth0', '--delay', delay])

        time.sleep(period)

        log.info('Removing network delay')
        subprocess.call(['tcdel', 'eth0', '--all'])
    else:
        log.info('Not yet time for the network trigger.')
