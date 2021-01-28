FROM python:3.8

RUN python -m pip install --upgrade pip

RUN pip install pipenv

WORKDIR /opt/the-coffee-bar

COPY Pipfile setup.py README.md ./

RUN pipenv lock --pre

COPY src ./src
RUN pipenv install --system

#RUN opentelemetry-bootstrap --action=install

ENV OPENTELEMETRY_PYTHON_TRACER_PROVIDER sdk_tracer_provider
