# The Coffee Machine App 
The Ruby application auto-instrumented by [OpenTelemetry-Ruby].

## Content
* `lib`'s directory contains sources of the application
    * `machine` is accepting the orders for coffee
    * `coffee` is providing coffee (sometimes lack of coffee is possible)
    * `water` is providing water (sometimes lack of water is possible)
* `Gemfile`'s file contains all the libraries needed for application execution
* `Dockerfile`'s file contains all needed commands to build docker image of the application

## Prerequisities
* Installed [ruby]
* Installed [docker]
* Installed [docker-compose] (optional)

## How to build?

```bash
TAG=ruby-apps-1.0.0-0.21.3-0.20.5

# Build Image
docker build -t sumo/the-coffee-bar-app:${TAG} .
 ```
  
## Usage
Each of the application `machine-svc, water-svc, coffee-svc` needs some configuration - in this case everything is 
based on the environment variables. Application supports right now only OTLP Span Exporter.

- **machine.rb environment variables**
    ```bash
    HOST - define host name for Sinatra server
    PORT - define port for Sinatra server
    COFFEE_HOST - define host name where Coffee Sinatra server is running
    COFFEE_PORT - define port on which Coffee Sinatra server is running
    WATER_HOST - define host name where Water Sinatra server is running
    WATER_PORT - define port on which Water Sinatra server is running
    OTEL_RESOURCE_ATTRIBUTES - define service-name for Jaeger exporter (service.name=NAME)
    OTEL_EXPORTER_OTLP_SPAN_ENDPOINT - define HTTP OTLP collector endpoint
    OTEL_EXPORTER_OTLP_INSECURE - define HTTP/HTTPS (false/true) for HTTP OTLP collector endpoint
    ```

- **coffee.rb environment variables**
    ```bash
    HOST - define host name for Sinatra server
    PORT - define port for Sinatra server
    OTEL_RESOURCE_ATTRIBUTES - define service-name for Jaeger exporter (service.name=NAME)
    OTEL_EXPORTER_OTLP_SPAN_ENDPOINT - define HTTP OTLP collector endpoint
    OTEL_EXPORTER_OTLP_INSECURE - define HTTP/HTTPS (false/true) for HTTP OTLP collector endpoint
    ```

- **water.rb environment variables**
    ```bash
    HOST - define host name for Sinatra server
    PORT - define port for Sinatra server
    OTEL_RESOURCE_ATTRIBUTES - define service-name for Jaeger exporter (service.name=NAME)
    OTEL_EXPORTER_OTLP_SPAN_ENDPOINT - define HTTP OTLP collector endpoint
    OTEL_EXPORTER_OTLP_INSECURE - define HTTP/HTTPS (false/true) for HTTP OTLP collector endpoint
    ```
    
# Contact
In case of any issues please contact Mateusz 'mat' Rumian @ mrumian@sumologic.com


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [jaeger]: <https://www.jaegertracing.io/docs/1.18/getting-started/#all-in-one>
   [ruby]: <https://www.ruby-lang.org/en/>
   [docker]: <https://docs.docker.com/get-docker/>
   [docker-compose]: <https://docs.docker.com/compose/install/>
   [OpenTelemetry-Ruby]: <https://github.com/open-telemetry/opentelemetry-ruby>
