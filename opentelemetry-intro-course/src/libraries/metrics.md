# Metrics
A metric is a measurement about a service, captured at runtime. Logically, the moment of capturing one of these measurements is known as a metric event which consists not only of the measurement itself, but the time that it was captured and associated metadata.
Application and request metrics are important indicators of availability and performance. Custom metrics can provide insights into how availability indicators impact user experience or the business. Collected data can be used to alert of an outage or trigger scheduling decisions to scale up a deployment automatically upon high demand.
Refer : https://opentelemetry.io/docs/concepts/data-sources/

## Statsd Metrics for Python App:

StatsD is originally a simple daemon to aggregate and summarize application metrics. With StatsD, applications are to be instrumented by developers using language-specific client libraries. These libraries will then communicate with the StatsD daemon using its dead-simple protocol, and the daemon will then generate aggregate metrics and relay them to virtually any graphing or monitoring backend.
In the coffee bar app we have used Statsd library to collect the metrics . In the python app we have directly imported Statsd library . 
Sample code : 
    import statsd
Different types of Metrics by Statsd :
- Counters : They are treated as a count of a type of event per second.
- Timers : Timers are meant to track how long something took.
- Gauges : Gauges are a constant data type. They are not subject to averaging, and they don’t change unless you change them.


## OpenTelemetry Auto Instrumentation for Python App:
The librars used for Auto instrumentation can be imported directly . 
Sample code: 
    from opentelemetry import metrics
    from opentelemetry.sdk.metrics import Counter, MeterProvider
    from opentelemetry.sdk.metrics.export import ConsoleMetricsExporter
    from opentelemetry.sdk.metrics.export.controller import PushController


OpenTelemetry defines three metric instruments today:

- counter: a value that is summed over time – you can think of this like an odometer on a car; it only ever goes up.
- measure: a value that is aggregated over time. This is more akin to the trip odometer on a car, it represents a value over   some defined range.
- observer: captures a current set of values at a particular point in time, like a fuel gauge in a vehicle.
