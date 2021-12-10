# Auto-Instrumentation Examples
## Python app 

The python apps part of the framework are instrumented with [OpenTelemetry-Python](https://opentelemetry-python.readthedocs.io/en/stable/examples/auto-instrumentation/README.html)

For each of the application the-coffe-lover, the-coffee-bar, the-coffee-machine and the-cashdesk we execute `opentelemetry-auto-instrumentation python app_name -h`, e.g. opentelemetry-auto-instrumentation python the-coffee-bar -h. Configuration to the application can be provided by config file - example config file can be found in src/config/config.yaml or by application arguments.

More details in this [readme](https://github.com/SumoLogic/the-coffee-bar/tree/main/applications/python-the-coffee-bar-apps#readme) 

## Ruby APP

The ruby applications part of the framework are instrumented with [OpenTelemetry-Ruby](https://github.com/open-telemetry/opentelemetry-ruby) 

Each of the application machine-svc, water-svc, coffee-svc needs additional configuration - in this case everything is based on the environment variables.

For more [details](https://github.com/SumoLogic/the-coffee-bar/tree/main/applications/ruby-the-coffee-bar-apps) 

## Dotnet app

The ASP .NET Core application is auto-instrumented by OpenTelemetry-Dotnet.
 
In this situation the application requires some variables to be set 
Common
* SERVICE_NAME - defines the name of the service (calculator-svc by default)
* EXPORTER - defines the span exporter (otlp, zipkin, jaeger, console - otlp by default)
Specific for OTLP Exporter
* OTEL_EXPORTER_OTLP_ENDPOINT - defines the OTLP gRPC Collector Endpoint (e.g. http://localhost:4317)
Specific for Zipkin Exporter
* OTEL_EXPORTER_ZIPKIN_ENDPOINT - defines the Zipkin HTTP Collector Endpoint (e.g. localhost:9411/api/v2/spans)

For more [details](https://github.com/SumoLogic/the-coffee-bar/tree/main/applications/dotnet-core-the-coffee-bar-app) 
