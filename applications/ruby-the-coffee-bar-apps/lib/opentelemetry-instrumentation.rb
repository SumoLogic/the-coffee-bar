require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'

Bundler.require

OpenTelemetry::SDK.configure do |c|
    c.use_all
end
