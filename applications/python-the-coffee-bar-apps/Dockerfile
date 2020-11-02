FROM python:3.8

RUN pip install pipenv

WORKDIR /opt/the-coffee-bar

COPY Pipfile setup.py README.md ./

RUN pipenv lock --pre

COPY src ./src
RUN pipenv install --system

ENV OPENTELEMETRY_PYTHON_TRACER_PROVIDER sdk_tracer_provider
