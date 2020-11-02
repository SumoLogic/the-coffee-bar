import logging as log
import sys

from opentelemetry import trace

_LOG_LEVEL = {
    'critical': log.CRITICAL,
    'error': log.ERROR,
    'warning': log.WARNING,
    'info': log.INFO,
    'debug': log.DEBUG
}


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

    root = log.getLogger()
    root.setLevel(log_level)

    span_formattter = SpanFormatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s '
                                    '- trace_id=%(trace_id)s - span_id=%(span_id)s')

    stdout_handler = log.StreamHandler(sys.stdout)
    stdout_handler.setLevel(log_level)
    stdout_handler.setFormatter(span_formattter)
    root.addHandler(stdout_handler)

    return log


def configure_basic_logging(log_level: str):
    log_level = _LOG_LEVEL[log_level]

    root = log.getLogger()
    root.setLevel(log_level)

    span_formattter = log.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

    stdout_handler = log.StreamHandler(sys.stdout)
    stdout_handler.setLevel(log_level)
    stdout_handler.setFormatter(span_formattter)
    root.addHandler(stdout_handler)

    return log
