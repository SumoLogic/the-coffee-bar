$stdout.sync = true

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'

require_relative "opentelemetry-instrumentation"
require_relative "version"


class Coffee < Sinatra::Base

    host = ARGV[0] || 'coffee-svc'
    port = ARGV[1] || 9091

    set :bind, host
    set :port, port
    puts "INFO - Starting Coffee Service: #{host}:#{port}"

    # For K8s livenessProbe
    get '/' do
        span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
        trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id
        puts "INFO - Received possible K8s LivnessProbe request - trace_id=#{trace_id} - span_id=#{span_id}"
        status 200
        body "I'm alive!"
    end

    post '/get_beans' do
        span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
        trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id

        payload = JSON.parse(request.body.read)
        puts "INFO - Received order for coffee grains #{payload['grains']} - trace_id=#{trace_id} - span_id=#{span_id}"

        content_type :json

        if payload['grains'] < 0
            status 502
            body "Lack of coffee grains"
            puts "ERROR - Lack of coffee grains in amount #{payload['grains']} - trace_id=#{trace_id} - span_id=#{span_id}"

            ## Add event into span
            OpenTelemetry::Trace.current_span.add_event("exception", attributes: { 'exception.code' => '502', 'exception.message' => 'Lack of coffee' })
        else
            body "Grains provided"
            puts "INFO - Coffee grains in amount #{payload['grains']} provided - trace_id=#{trace_id} - span_id=#{span_id}"
        end
    end

    run! if __FILE__ == $0
end
