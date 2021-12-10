# Metrics

## Manual Instrumentation 
The python apps part of the framework are instrumented with ManualTelemetry-Python. These metrics are configured using statsd . 
To receive the Statsd metrics you can configure it in otelcol.yaml receivers. The otelcol.yaml can be found at deployments/docker-compose.

Sample Configuration for Python App:

  statsd:
    endpoint: "0.0.0.0:8125" # default
    aggregation_interval: 60s  # default
    enable_metric_type: true   # default
    is_monotonic_counter: true # default
    timer_histogram_mapping:
      - statsd_type: "histogram"
        observer_type: "gauge"
      - statsd_type: "timing"
        observer_type: "gauge"

Samples of metrics generated in Sumo portal : 

    {
    _collector="tcb-otc-distro",
    _collectorId="000000000*****",
    _source="tcb-otc-distro",
    _sourceCategory="tcb-otc-distro",
    _sourceHost="otelcol",
    _sourceId="0000000000000000",
    _sourceName="OTC Metric Input"
    metric_type="counter"
    }

## Auto Instrumentation for Python App:
The Coffee Bar App can be Auto instrumented using Open Telementary. 

    batcher_mode = "stateful"
    metrics.set_meter_provider(MeterProvider())
    meter = metrics.get_meter(__name__, batcher_mode == "stateful")
    exporter = ConsoleMetricsExporter()
    controller = PushController(meter, exporter, 5)

    staging_label_set = meter.get_label_set({"environment": "staging"})

    requests_counter = meter.create_metric(
        name="requests",
        description="number of requests",
        unit="1",
        value_type=int,
        metric_type=Counter,
        label_keys=("environment",),

Samples of metrics generated : 

ConsoleMetricsExporter(data="Counter(name="requests", description="number of requests")", label_set="(('environment', 'staging'),)", value=25)

For more details refer : https://opentelemetry-python-yusuket.readthedocs.io/en/latest/getting-started.html#adding-metrics

    


