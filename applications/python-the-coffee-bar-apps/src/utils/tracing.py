from opentelemetry import trace
from opentelemetry.exporter.jaeger import JaegerSpanExporter
from opentelemetry.exporter.otlp.trace_exporter import OTLPSpanExporter
from opentelemetry.exporter.zipkin import ZipkinSpanExporter
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import (
    ConsoleSpanExporter,
    SimpleExportSpanProcessor,
    BatchExportSpanProcessor,
)


def configure_tracing(configuration: dict):
    # OTLP Exporter configuration
    if configuration['exporter'] == 'otlp':
        service_name = {
            'service.name': configuration['service_name']
        }
        resource = Resource(service_name)
        trace.set_tracer_provider(TracerProvider(resource=resource))
        exporter = OTLPSpanExporter(endpoint='{}:{}'.format(configuration['exporter_host'],
                                                            configuration['exporter_port']))
        trace.get_tracer(__name__)
        span_processor = BatchExportSpanProcessor(exporter)
        trace.get_tracer_provider().add_span_processor(span_processor)

    # Jaeger HTTP Exporter configuration
    elif configuration['exporter'] == 'jaeger_http':
        exporter = JaegerSpanExporter(
            service_name=configuration['service_name'],
            collector_host_name=configuration['exporter_host'],
            collector_port=configuration['exporter_port'],
        )
        trace.set_tracer_provider(TracerProvider())
        trace.get_tracer(__name__)
        span_processor = BatchExportSpanProcessor(exporter)
        trace.get_tracer_provider().add_span_processor(span_processor)

    # Jaeger Thrifth Compact Exporter configuration
    elif configuration['exporter'] == 'jaeger_thrift':
        exporter = JaegerSpanExporter(
            service_name=configuration['service_name'],
            agent_host_name=configuration['exporter_host'],
            agent_port=configuration['exporter_port'],
        )
        trace.set_tracer_provider(TracerProvider())
        trace.get_tracer(__name__)
        span_processor = BatchExportSpanProcessor(exporter)
        trace.get_tracer_provider().add_span_processor(span_processor)
    # Zipkin Exporter configuration
    elif configuration['exporter'] == 'zipkin':
        exporter = ZipkinSpanExporter(
            service_name=configuration['service_name'],
            url=configuration['exporter_host']
        )
        trace.set_tracer_provider(TracerProvider())
        trace.get_tracer(__name__)
        span_processor = BatchExportSpanProcessor(exporter)
        trace.get_tracer_provider().add_span_processor(span_processor)

    # Console Exporter configuration
    elif configuration['exporter'] == 'console':
        trace.set_tracer_provider(TracerProvider())
        trace.get_tracer_provider().add_span_processor(
            SimpleExportSpanProcessor(ConsoleSpanExporter())
        )
    else:
        raise ValueError('Only Otlp, Jaeger Thrift/HTTP and Zipkin exporters are supported. '
                         'Please check your configuration.')
