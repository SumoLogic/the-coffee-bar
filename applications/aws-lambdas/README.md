# The Coffee Bar App AWS Lambda Functions 

#### Deployment
```bash
./run.sh -r AWS_REGION
```

#### Environment variables

- `AWS_LAMBDA_EXEC_WRAPPER` - Set to `/opt/otel-instrument` to enable ADOT Python auto-instrumentation.
- `SUMOLOGIC_HTTP_TRACES_ENDPOINT_URL` - Set to Sumologic HTTP Traces URL.
- `OTEL_RESOURCE_ATTRIBUTES` - Set to `application=YOUR_APPLICATION_NAME`
- `OTEL_TRACES_SAMPLER` - Set to `always_on`
- `OTEL_SERVICE_NAME` - Set to YOUR_SERVICE_NAME

Details can be found [here](https://help.sumologic.com/Beta/AWS_Lambda_-_Python_function_instrumentation_with_Sumo_Logic_tracing).