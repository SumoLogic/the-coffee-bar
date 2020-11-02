using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace dotnet_core_calculator_svc
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureLogging(loggingBuilder =>
                    loggingBuilder.Configure(options =>
                        options.ActivityTrackingOptions =
                            ActivityTrackingOptions.TraceId
                            | ActivityTrackingOptions.SpanId))
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                    webBuilder.UseUrls(System.Environment.GetEnvironmentVariable(
                        "SERVER_ENDPOINT"));
                });
    }
}
