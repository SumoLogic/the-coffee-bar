$stdout.sync = true

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'

require_relative "opentelemetry-instrumentation"
require_relative "version"


class Water < Sinatra::Base
    set :port, ENV['PORT'] || 9092
    set :bind, ENV['HOST'] || 'water-svc'

    post '/get_water' do

        span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
        trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id

        payload = JSON.parse(request.body.read)
        puts "INFO - Received order for water in amount of #{payload['water']} ml - trace_id=#{trace_id} - span_id=#{span_id}"

        content_type :json

        if payload['water'] < 0
            status 503
            body "Not enough water"
            puts "ERROR - Not enough water - requested #{payload['water']} ml - trace_id=#{trace_id} - span_id=#{span_id}"

            ## Add event into span
            OpenTelemetry::Trace.current_span.add_event("exception", attributes: { 'exception.code' => '503', 'exception.message' => 'Not enough water' })
        else
            body "Water provided"
            puts "INFO - Water in amount of #{payload['water']} ml provided - trace_id=#{trace_id} - span_id=#{span_id}"
        end
    end

    run! if __FILE__ == $0
end
