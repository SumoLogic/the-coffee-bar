import json
import time
import threading

import logging as log
from src.utils.logger import configure_basic_logging


def to_json(obj) -> dict:
    if isinstance(obj, str):
        return json.loads(obj)
    elif isinstance(obj, dict):
        return obj


def magic_cpu_usage_increaser(period: int, thread_no: int, threads: int):
    configure_basic_logging('info')
    start_time = time.time()
    while time.time() - start_time < period:
        pass
    log.error('Thread 0x[%s] stuck in kernel module for 5 seconds, waiting for file descriptor to be released.'
              'Too many open files.', thread_no)

    # When last thread ends perform "roll back"
    if thread_no + 1 == threads:
        log.info('Deploying new version 1.20.123')


def increase_cpu(period: int, threads: int):
    configure_basic_logging('info')
    log.info('Deploying new version 1.20.124')
    log.info('Upgrade initiated: admin mode by joe@sumocoffee.com')
    thread_list = []

    for i in range(1, threads):
        t = threading.Thread(target=magic_cpu_usage_increaser, args=(period, i, threads))
        thread_list.append(t)

    for thread in thread_list:
        thread.start()

    for thread in thread_list:
        thread.join()
