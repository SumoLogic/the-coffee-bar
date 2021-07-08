using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using OpenTelemetry.Trace;

namespace dotnet_core_calculator_svc.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class IndexController : Controller
    {
        private readonly ILogger<IndexController> _logger;
        
        public IndexController(ILogger<IndexController> logger)
        {
            _logger = logger;
        }
        
        [HttpGet][Route("/")]
        public IActionResult Index()
        {    
            var traceId = Tracer.CurrentSpan.Context.TraceId;
            var spanId = Tracer.CurrentSpan.Context.SpanId;
            _logger.LogInformation("I'm alive! Possible K8s LivenessProbe request." +
                                   " - trace_id=" + traceId +
                                   " - span_id=" + spanId);
            return Ok("I'm alive!");
        }
    }
}