FROM ruby:3.4.3

WORKDIR /app

ADD Gemfile ./
RUN bundle install -j 8

ADD lib ./lib
