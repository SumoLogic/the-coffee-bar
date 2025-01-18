FROM ruby:3.3.7

WORKDIR /app

ADD Gemfile ./
RUN bundle install -j 8

ADD lib ./lib
