using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Microsoft.Extensions.Logging;

namespace dotnet_core_calculator_svc;

public class Startup
{
    public void ConfigureServices(IServiceCollection services)
    {
        // If your application is .NET Standard 2.1 or above, and you are using an insecure (http) endpoint,
        // the following switch must be set before adding Exporter.
        AppContext.SetSwitch("System.Net.Http.SocketsHttpHandler.Http2UnencryptedSupport", true);

        services.AddControllers();

        var resource = ResourceBuilder.CreateDefault()
            .AddEnvironmentVariableDetector()
            .AddTelemetrySdk();

        services.AddOpenTelemetryTracing(builder => builder
            .AddAspNetCoreInstrumentation()
            .SetResourceBuilder(resource)
            .AddOtlpExporter()
        );
    }
    public void Configure(IApplicationBuilder app, IHostEnvironment env, ILoggerFactory loggerFactory)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRouting();
            app.UseAuthorization();
            app.UseEndpoints(endpoints => { endpoints.MapControllers(); });

            // Optional logging to file
            var log_to_file = Environment.GetEnvironmentVariable("LOG_TO_FILE");
            if (log_to_file != null) loggerFactory.AddFile("/tmp/calculator-svc.log");
        }
}
