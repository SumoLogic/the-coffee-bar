FROM ruby:3.0

WORKDIR /app

ADD Gemfile ./
RUN bundle install -j 8

ADD lib ./lib
