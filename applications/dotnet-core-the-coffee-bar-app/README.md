# The Calculator Svc
The ASP .NET Core application auto-instrumented by [OpenTelemetry-Dotnet].

## Content
* `dockerization`'s directory contains docker-compose files
* `dotnet-core-calculator-svc`'s directory contains sources of the application

## Prerequisities
* Installed [docker]
* Installed [docker-compose]

## How to build?

* To build docker image run:
    ```bash
    TAG=calculator-dotnet-1.1.0b4-1.0.0rc5
    
    # Build Image
    docker build -t sumo/the-coffee-bar-app:${TAG} .
    ```

## Application functionality
The Calculator-svc is responsible for doing some simple math based on the request. Example request:

```bash
curl -XPOST -d '{"product": "espresso", "amount": 2, "price": 3}' http://localhost:8080/Calculator
```

as result Calculator-svc returns JSON with product and calculated price e.g. `'{"product": "espresso", "price": 6}'`

    
## Usage
Application requires few environment variables to be configured.

`Common`
* `SERVICE_NAME` - defines the name of the service (calculator-svc by default)
* `EXPORTER` - defines the span exporter (otlp, zipkin, jaeger, console - otlp by default)

`Specific for OTLP Exporter`
* `OTEL_EXPORTER_OTLP_SPAN_ENDPOINT` - defines the OTLP gRPC Collector Endpoint (e.g. `localhost:55680`)

`Specific for Zipkin Exporter`
* `OTEL_EXPORTER_ZIPKIN_SPAN_ENDPOINT` - defines the Zipkin HTTP Collector Endpoint (e.g. `localhost:9411/api/v2/spans`)

`Specific for Jaeger Exporter`
* `OTEL_EXPORTER_JAEGER_SPAN_HOST` - defines the Jaeger UDP Collector Host Name (e.g. `localhost`)
* `OTEL_EXPORTER_JAEGER_SPAN_PORT` - defines the Jaeger UDP Collector Port (e.g. `6831`)

# Contact
In case of any issues please contact Mateusz 'mat' Rumian @ mrumian@sumologic.com


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)
   
   [docker]: <https://docs.docker.com/get-docker/>
   [docker-compose]: <https://docs.docker.com/compose/install/>
   [OpenTelemetry-Dotnet]: <https://github.com/open-telemetry/opentelemetry-dotnet>
