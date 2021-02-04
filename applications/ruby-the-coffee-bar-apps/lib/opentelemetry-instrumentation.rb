require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'

Bundler.require

OpenTelemetry::SDK.configure do |c|
    c.use_all
    c.add_span_processor(
        OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(
          OpenTelemetry::Exporter::OTLP::Exporter.new()
        )
      )
end
