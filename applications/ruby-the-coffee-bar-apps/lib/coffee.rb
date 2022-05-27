$stdout.sync = true

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
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

class Coffee < Sinatra::Base

    host = ARGV[0] || 'coffee-svc'
    port = ARGV[1] || 9091

    set :environment, :production
    set :bind, host
    set :port, port

    configure do
        log_file = File.open("/tmp/coffee-svc.log", "a")
        logger = ::Logger.new MultiIO.new(STDOUT, log_file)
        logger.formatter = proc do | severity, time, progname, msg |
            span_id = OpenTelemetry::Trace.current_span.context.hex_span_id
            trace_id = OpenTelemetry::Trace.current_span.context.hex_trace_id
            "#{time}, #{severity}: #{msg} - trace_id=#{trace_id} - span_id=#{span_id}\n"
        end
        set :logger, logger
        use Rack::AccessLog, logger
    end

    logger.info "Starting Coffee Service: #{host}:#{port}"

    # For K8s livenessProbe
    get '/' do
        logger.info "Received possible K8s LivnessProbe request"
        status 200
        body "I'm alive!"
    end

    post '/get_beans' do
        payload = JSON.parse(request.body.read)
        logger.info "Received order for coffee grains #{payload['grains']}"

        content_type :json

        if payload['grains'] < 1
            status 502
            body "Lack of coffee grains"
            logger.error "Lack of coffee grains in amount #{payload['grains']}"

            ## Add event into span
            OpenTelemetry::Trace.current_span.add_event("exception", attributes: { 'exception.code' => '502', 'exception.message' => 'Lack of coffee' })
        else
            body "Grains provided"
            logger.info "Coffee grains in amount #{payload['grains']} provided"
        end
    end

    run! if __FILE__ == $0
end
