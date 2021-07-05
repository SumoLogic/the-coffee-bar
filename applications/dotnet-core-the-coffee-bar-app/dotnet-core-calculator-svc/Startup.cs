using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using OpenTelemetry;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

namespace dotnet_core_calculator_svc
{
    public class Startup
    {
        public void ConfigureServices(IServiceCollection services)
        {
            // If your application is .NET Standard 2.1 or above, and you are using an insecure (http) endpoint,
            // the following switch must be set before adding Exporter.
            AppContext.SetSwitch("System.Net.Http.SocketsHttpHandler.Http2UnencryptedSupport", true);

            services.AddControllers();
            
            // Switch between zipkin/jaeger/otlp by setting EXPORTER environment variable
            var exporter = System.Environment.GetEnvironmentVariable(
                "EXPORTER") ?? "otlp";
            switch (exporter)
            {
                case "jaeger":
                    services.AddOpenTelemetryTracing((builder) => builder
                        .AddAspNetCoreInstrumentation()
                        .SetResourceBuilder(ResourceBuilder.CreateDefault().AddService(
                            System.Environment.GetEnvironmentVariable("SERVICE_NAME") ?? "calculator-svc"))
                        .AddJaegerExporter(jaegerOptions =>
                        {
                            jaegerOptions.AgentHost = System.Environment.GetEnvironmentVariable(
                                "OTEL_EXPORTER_JAEGER_SPAN_HOST") ?? "localhost";
                            jaegerOptions.AgentPort = Int32.Parse(System.Environment.GetEnvironmentVariable(
                                "OTEL_EXPORTER_JAEGER_SPAN_PORT") ?? "6831") ;
                        }));
                    break;
                case "zipkin":
                    services.AddOpenTelemetryTracing((builder) => builder
                        .AddAspNetCoreInstrumentation()
                        .SetResourceBuilder(ResourceBuilder.CreateDefault().AddService(
                            System.Environment.GetEnvironmentVariable(
                                "SERVICE_NAME") ?? "calculator-svc"
                            ))
                        .AddZipkinExporter(zipkinOptions =>
                        {
                            zipkinOptions.Endpoint = new Uri(System.Environment.GetEnvironmentVariable(
                                "OTEL_EXPORTER_ZIPKIN_SPAN_ENDPOINT") ?? "http://localhost:9411/api/v2/spans");
                        }));
                    break;
                case "otlp":
                    services.AddOpenTelemetryTracing((builder) => builder
                        .AddAspNetCoreInstrumentation()
                        .SetResourceBuilder(ResourceBuilder.CreateDefault().AddService(
                            System.Environment.GetEnvironmentVariable("SERVICE_NAME") ?? "calculator-svc"))
                        .AddOtlpExporter(otlpOptions =>
                        {
                            otlpOptions.Endpoint = new Uri(System.Environment.GetEnvironmentVariable(
                                    "OTEL_EXPORTER_OTLP_ENDPOINT") ?? "http://localhost:4317");
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
            
            app.UseRouting();
            app.UseAuthorization();
            app.UseEndpoints(endpoints => { endpoints.MapControllers(); });
        }
    }
}
