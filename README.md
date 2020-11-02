# The Coffee Bar App 
The demo application instrumented by [OpenTelemetry] framework.

## Content
* `dockerization`'s directory contains docker-compose files
* `applications`'s directory contains sources of the application
    * `dotnet-core-calculator-svc` - contains sources of the `calculator-svc` application
    * `ruby-the-coffee-bar-apps` - contains sources of `machine-svc, coffee-svc and water-svc` applications
    * `python-the-coffee-bar-apps` - contains sources of `the-coffee-lover, the-coffee-bar, the-coffee-machine and 
    the-cashdesk` applications
    * `the-cashdesk` responsible for simple accounting and queries on the PostgreSQL DB
* `scripts` - directory contains build scripts

## Prerequisities
* Installed [docker]
* Installed [docker-compose]

## How to build?
Execute the build script `build_local_all.sh` from `scripts` directory. The script is going to build all of the 
applications in the docker images. 
    
## Usage


# Contact
In case of any issues please contact Mateusz 'mat' Rumian @ mrumian@sumologic.com


[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [pipenv]: <https://pypi.org/project/pipenv/>
   [jaeger]: <https://www.jaegertracing.io/docs/1.18/getting-started/#all-in-one>
   [docker]: <https://docs.docker.com/get-docker/>
   [docker-compose]: <https://docs.docker.com/compose/install/>
   [OpenTelemetry-Python]: <https://opentelemetry-python.readthedocs.io/en/stable/examples/auto-instrumentation/README.html>
   [Opentelemetry]: <https://opentelemetry.io/>
