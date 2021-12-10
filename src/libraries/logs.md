# Logs

OpenTelemetry does not provide a dedicated logging API nor libraries for creating logs right now. There are mature libraries which do that already and support for those projects is planned instead. Most probably that will be an appender which will correlate logs with traces.

## How to create simple logs

Standard libraries for programming languages provide simple logging capabilites out of the box. You can use them to create logs. If your application follows [The Twelve-Factor App](https://12factor.net/logs) standard "it should write its logs, unbuffered, to `stdout`".  
Later, the execution environment like _systemd_, _Docker_ or _Kubernetes_ takes care of routing this event stream to the local file or sending to other systems like [Sumo Logic](http://sumologic.com) directly.

If your application logs are written to the local file they can be collected by [OpenTelemetry Collector](../otelcol/logs.md) for further processing.  
You can find more on that topic in the [OpenTelemetry Collector / Logs](../otelcol/logs.md) section.

### Example

Let's assume that your application writes logs to `stdout` and runs inside a `Docker container`.

As a result, by default on a Linux machine those logs are written to the `/var/lib/docker/containers/<container-id>/<container-id>-json.log` file.

The log file from Docker container can be scraped by the [OpenTelemetry Collector](../otelcol/logs.md) with the help of [filelogreceiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/filelogreceiver). This receiver will tail the log file and for each line emit a new record for further processing inside the [OpenTelemetry Collector](../otelcol/README.md). It will also attach a `file name` metadata to this record.  

## Correlating logs and traces

When you use the OpenTelemetry appender for logging library you can correlate logs with traces.
