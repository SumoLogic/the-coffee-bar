$stdout.sync = true

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/json'
require 'net/http'
require 'uri'
require 'json'

require_relative "opentelemetry-instrumentation"
require_relative "version"

def make_request(uri, order)
    header = {'Content-Type': 'application/json'}

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = order.to_json

    # Send the request
    response = http.request(request)

    return response
end


class Machine < Sinatra::Base
    set :port, ENV['PORT'] || 9090
    set :bind, ENV['HOST'] || 'machine-svc'

    coffee_host = ENV['COFFEE_HOST'] || 'coffee-svc'
    coffee_port = ENV['COFFEE_PORT'] || 9091
    coffee_uri = URI.parse('http://%s:%s/get_coffee' % [coffee_host, coffee_port])

    water_host = ENV['WATER_HOST'] || 'water-svc'
    water_port = ENV['WATER_PORT'] || 9092
    water_uri = URI.parse('http://%s:%s/get_water' % [water_host, water_port])

    before do
        content_type :json
    end

    post '/prepare_coffee' do
        span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
        trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id
        payload = JSON.parse(request.body.read)
        puts "INFO - Got new order: #{payload.inspect} - trace_id=#{trace_id} - span_id=#{span_id}"

        coffee = make_request(coffee_uri, payload)
        water = make_request(water_uri, payload)

        if coffee.code == "200" && water.code == "200"
            json body: { coffee_status: true, reason: "Coffee done" }
            status 200
            puts "INFO - Coffee is ready - trace_id=#{trace_id} - span_id=#{span_id}"
        elsif coffee.code == "200" && water.code != "200"
            json body: { coffee_status: false, reason: water.body }
            status water.code
            puts "ERROR - No water. I'm sorry - trace_id=#{trace_id} - span_id=#{span_id}"
        elsif coffee.code != "200" && water.code == "200"
            json body: { coffee_status: false, reason: coffee.body }
            status coffee.code
            puts "ERROR - No grains. I'm sorry - trace_id=#{trace_id} - span_id=#{span_id}"
        else
            json body: { coffee_status: false, reason: "No water, no coffee grains" }
            status 500
            puts "ERROR - No water, no grains. I'm sorry - trace_id=#{trace_id} - span_id=#{span_id}"

            ## Add event into span
            OpenTelemetry::Trace.current_span.add_event("exception", attributes: { 'exception.code' => '500', 'exception.message' => 'No water, no coffee' })
        end
    end

    run! if __FILE__ == $0
end
