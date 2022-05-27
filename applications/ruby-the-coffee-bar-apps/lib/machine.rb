$stdout.sync = true

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/json'
require 'net/http'
require 'uri'
require 'json'
require 'logger'

require_relative "opentelemetry-instrumentation"
require_relative "version"

class MultiIO
  def initialize(*targets)
     @targets = targets
  end

  def write(*args)
    @targets.each {|t| t.write(*args)}
  end

  def close
    @targets.each(&:close)
  end
end

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
    host = ARGV[0] || 'machine-svc'
    port = ARGV[1] || 9090

    set :environment, :production
    set :bind, host
    set :port, port

    configure do
        if ENV['SYSLOG'] != nil
            syslog = ENV['SYSLOG'].split(':')
            logger = RemoteSyslogLogger.new(syslog[0], syslog[1])
        else
            logger = ::Logger.new(STDOUT)
        end
        logger.formatter = proc do | severity, time, progname, msg |
            span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
            trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id
            "#{time}, #{severity}: #{msg} - trace_id=#{trace_id} - span_id=#{span_id}\n"
        end
        set :logger, logger
        use Rack::AccessLog, logger
    end

    logger.info "INFO - Starting Machine Service: #{host}:#{port}"

    coffee_host = ARGV[2] || 'coffee-svc'
    coffee_port = ARGV[3] || 9091
    coffee_uri = URI.parse('http://%s:%s/get_beans' % [coffee_host, coffee_port])
    logger.info "INFO - Coffee Service URI: #{coffee_uri}"

    water_host = ARGV[4] || 'water-svc'
    water_port = ARGV[5] || 9092
    water_uri = URI.parse('http://%s:%s/get_water' % [water_host, water_port])
    logger.info "INFO - Water Service URI: #{water_uri}"

    before do
        content_type :json
    end

    # For K8s livenessProbe
    get '/' do

        logger.info "Received possible K8s LivnessProbe request"
        status 200
        body "I'm alive!"
    end

    post '/prepare_coffee' do
        payload = JSON.parse(request.body.read)
        logger.info "Got new order: #{payload.inspect}"

        coffee = make_request(coffee_uri, payload)
        water = make_request(water_uri, payload)

        if coffee.code == "200" && water.code == "200"
            json body: { coffee_status: true, result: "Coffee done" }
            status 200
            logger.info "Coffee is ready"
        elsif coffee.code == "200" && water.code != "200"
            json body: { coffee_status: false, reason: water.body }
            status water.code
            logger.error "No water. I'm sorry"
        elsif coffee.code != "200" && water.code == "200"
            json body: { coffee_status: false, reason: coffee.body }
            status coffee.code
            logger.error "No grains. I'm sorry"
        else
            json body: { coffee_status: false, reason: "No water, no coffee grains" }
            status 500
            logger.error "No water, no grains. I'm sorry"

            ## Add event into span
            OpenTelemetry::Trace.current_span.add_event("exception", attributes: { 'exception.code' => '500', 'exception.message' => 'No water, no coffee' })
        end
    end

    run! if __FILE__ == $0
end
