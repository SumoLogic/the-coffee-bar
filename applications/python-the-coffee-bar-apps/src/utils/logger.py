import logging as log
import os
import sys
from logging.handlers import SysLogHandler

from opentelemetry import trace

_LOG_LEVEL = {
    'critical': log.CRITICAL,
    'error': log.ERROR,
    'warning': log.WARNING,
    'info': log.INFO,
    'debug': log.DEBUG
}

BASIC_FORMAT = log.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
CPU_INCREASER_FILE_NAME = 'cpu_increaser.py'


class NoCpuIncreaserFilter(log.Filter):
    def filter(self, record: log.LogRecord) -> bool:
        return not record.filename == CPU_INCREASER_FILE_NAME


class OnlyCpuIncreaserFilter(log.Filter):
    def filter(self, record: log.LogRecord) -> bool:
        return record.filename == CPU_INCREASER_FILE_NAME


class SpanFormatter(log.Formatter):
    def format(self, record: log.LogRecord):
        context = trace.get_current_span().get_span_context()
        trace_id = context.trace_id
        span_id = context.span_id

        if trace_id != 0:
            record.trace_id = '{trace:032x}'.format(trace=trace_id)
            record.span_id = '{span:016x}'.format(span=span_id)
        else:
            record.trace_id = None
            record.span_id = None

        return super().format(record)


def configure_logging(log_level: str):
    log_level = _LOG_LEVEL[log_level]

    span_formatter = SpanFormatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s '
                                   '- trace_id=%(trace_id)s - span_id=%(span_id)s')

    console_handler = log.StreamHandler(sys.stdout)
    console_handler.setFormatter(span_formatter)
    console_handler.addFilter(NoCpuIncreaserFilter())

    cpu_increaser_logging = log.StreamHandler(sys.stdout)
    cpu_increaser_logging.setFormatter(BASIC_FORMAT)
    cpu_increaser_logging.addFilter(OnlyCpuIncreaserFilter())

    # Configure basic logging
    log.basicConfig(level=log_level, handlers=[console_handler, cpu_increaser_logging])

    if os.getenv('SYSLOG'):
        syslog_address = os.getenv('SYSLOG').split(':')
        syslog_handler = SysLogHandler(address=(syslog_address[0], int(syslog_address[1])))
        syslog_handler.setLevel(log_level)
        syslog_handler.setFormatter(span_formatter)
        root = log.getLogger(__name__)
        root.addHandler(syslog_handler)

    return log


def configure_basic_logging(log_level: str):
    log_level = _LOG_LEVEL[log_level]

    root = log.getLogger(__name__)
    root.setLevel(log_level)

    stdout_handler = log.StreamHandler(sys.stdout)
    stdout_handler.setLevel(log_level)
    stdout_handler.setFormatter(BASIC_FORMAT)
    root.addHandler(stdout_handler)

    return log
