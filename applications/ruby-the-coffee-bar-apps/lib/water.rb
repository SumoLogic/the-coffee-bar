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

class Water < Sinatra::Base
    host = ARGV[0] || 'water-svc'
    port = ARGV[1] || 9092

    set :environment, :production
    set :bind, host
    set :port, port

    configure do
        if ENV['LOG_TO_FILE'] != nil
            log_file = File.open("/tmp/water-svc.log", "a")
            logger = ::Logger.new MultiIO.new(STDOUT, log_file)
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

    logger.info "INFO - Starting Water Service: #{host}:#{port}"

    # For K8s livenessProbe
    get '/' do
        logger.info "Received possible K8s LivnessProbe request"
        status 200
        body "I'm alive!"
    end

    post '/get_water' do
        payload = JSON.parse(request.body.read)
        logger.info "Received order for water in amount of #{payload['water']} ml"

        content_type :json

        if payload['water'] < 1
            status 503
            body "Not enough water"
            logger.error "ERROR - Not enough water - requested #{payload['water']} ml"

            ## Add event into span
            OpenTelemetry::Trace.current_span.add_event("exception", attributes: { 'exception.code' => '503', 'exception.message' => 'Not enough water' })
        else
            body "Water provided"
            logger.info "Water in amount of #{payload['water']} ml provided"
        end
    end

    run! if __FILE__ == $0
end
