FROM ruby:3.2.5

WORKDIR /app

ADD Gemfile ./
RUN bundle install -j 8

ADD lib ./lib
