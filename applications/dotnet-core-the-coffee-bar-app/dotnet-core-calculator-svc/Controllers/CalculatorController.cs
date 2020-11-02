using System.IO;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json.Linq;
using OpenTelemetry.Trace;

namespace dotnet_core_calculator_svc.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class CalculatorController : ControllerBase
    {
        private readonly ILogger<CalculatorController> _logger;

        public CalculatorController(ILogger<CalculatorController> logger)
        {
            _logger = logger;
        }

        [HttpPost]
        [Consumes("application/json")]
        public async Task<JsonResult> Post()
        {
            var traceId = Tracer.CurrentSpan.Context.TraceId;
            var spanId = Tracer.CurrentSpan.Context.SpanId;

            JsonResult result;
            using (var reader = new StreamReader(
                Request.Body,
                encoding: Encoding.UTF8,
                detectEncodingFromByteOrderMarks: false
            ))
            {
                var bodyString = await reader.ReadToEndAsync();

                _logger.LogInformation("Payment calculation for " + bodyString +
                                       " - trace_id=" + traceId +
                                       " - span_id=" + spanId
                );

                var value = JObject.Parse(bodyString);
                var productValue = value.GetValue("product").ToString();
                var amountValue = value.GetValue("amount").ToObject<int>();
                var priceValue = value.GetValue("price").ToObject<int>();
                var totalValue = priceValue * amountValue;

                _logger.LogInformation("Calculation done - " + amountValue + " * "
                                       + priceValue + " = " + totalValue +
                                       " - trace_id=" + traceId +
                                       " - span_id=" + spanId);

                result = new JsonResult(new
                {
                    product = productValue, amount = amountValue,
                    price = priceValue, total = totalValue
                });
            }

            return result;
        }
    }
}
