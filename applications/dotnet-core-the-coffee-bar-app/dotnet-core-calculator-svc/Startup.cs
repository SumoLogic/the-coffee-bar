using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using OpenTelemetry.Trace;

namespace dotnet_core_calculator_svc
{
    public class Startup
    {
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            
            // Switch between zipkin/jaeger/otlp by setting EXPORTER environment variable
            var exporter = System.Environment.GetEnvironmentVariable(
                "EXPORTER") ?? "otlp";
            switch (exporter)
            {
                case "jaeger":
                    services.AddOpenTelemetryTracing((builder) => builder
                        .AddAspNetCoreInstrumentation()
                        .AddJaegerExporter(jaegerOptions =>
                        {
                            jaegerOptions.ServiceName = System.Environment.GetEnvironmentVariable(
                                "SERVICE_NAME") ?? "calculator-svc";
                            jaegerOptions.AgentHost = System.Environment.GetEnvironmentVariable(
                                "OTEL_EXPORTER_JAEGER_SPAN_HOST") ?? "localhost";
                            jaegerOptions.AgentPort = Int32.Parse(System.Environment.GetEnvironmentVariable(
                                "OTEL_EXPORTER_JAEGER_SPAN_PORT") ?? "6831") ;
                        }));
                    break;
                case "zipkin":
                    services.AddOpenTelemetryTracing((builder) => builder
                        .AddAspNetCoreInstrumentation()
                        .AddZipkinExporter(zipkinOptions =>
                        {
                            zipkinOptions.ServiceName = System.Environment.GetEnvironmentVariable(
                                "SERVICE_NAME") ?? "calculator-svc";
                            zipkinOptions.Endpoint = new Uri(System.Environment.GetEnvironmentVariable(
                                "OTEL_EXPORTER_ZIPKIN_SPAN_ENDPOINT") ?? "localhost:9411/api/v2/spans");
                        }));
                    break;
                case "otlp":
                    services.AddOpenTelemetryTracing((builder) => builder
                        .AddAspNetCoreInstrumentation()
                        .SetResource(OpenTelemetry.Resources.Resources.CreateServiceResource(
                            System.Environment.GetEnvironmentVariable("SERVICE_NAME") ?? "calculator-svc"))
                        .AddOtlpExporter(otlpOptions =>
                        {
                            otlpOptions.Endpoint =
                                new Uri(System.Environment.GetEnvironmentVariable(
                                    "OTEL_EXPORTER_OTLP_SPAN_ENDPOINT") ?? "localhost:55680").ToString();
                        }));
                    break;
                case "console":
                    services.AddOpenTelemetryTracing((builder) => builder
                        .AddAspNetCoreInstrumentation()
                        .AddConsoleExporter());
                    break;
            }
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints => { endpoints.MapControllers(); });
        }
    }
}
