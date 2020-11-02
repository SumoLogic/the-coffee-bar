import json
import time
import threading

import logging as log


def to_json(obj) -> dict:
    if isinstance(obj, str):
        return json.loads(obj)
    elif isinstance(obj, dict):
        return obj


def magic_cpu_usage_increaser(period: int):
    start_time = time.time()
    while time.time() - start_time < period:
        pass


def increase_cpu(period: int, threads: int):
    log.info('Increasing CPU Usage - threads=%s', threads)
    thread_list = []

    for i in range(1, threads):
        t = threading.Thread(target=magic_cpu_usage_increaser, args=(period,))
        thread_list.append(t)

    for thread in thread_list:
        thread.start()

    for thread in thread_list:
        thread.join()
