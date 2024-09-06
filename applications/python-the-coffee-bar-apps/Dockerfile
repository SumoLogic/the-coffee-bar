FROM python:3.12.0a1-alpine

RUN apk add --no-cache bash net-tools iproute2 build-base gcc pkgconfig postgresql-dev linux-headers tzdata

RUN pip install pipenv

WORKDIR /opt/the-coffee-bar

COPY Pipfile setup.py README.md ./

RUN pipenv lock --clear --verbose

COPY src ./src
RUN pipenv install --system --verbose

RUN opentelemetry-bootstrap --action=install

ENV OTEL_PYTHON_TRACER_PROVIDER sdk_tracer_provider

# Fix for timezone
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime
