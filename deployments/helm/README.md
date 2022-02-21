# Sumo Logic The Coffee Bar App Helm Chart

## Prerequisite

The Coffee Bar App require below listed things to be configured:

- *helm* - [Helm Installation guide](https://helm.sh/docs/intro/install/)
- *Sumologic OpenTelemetry Collector Hostname* (`OTELCOL_HOSTNAME`) - Sumologic Kubernetes Collection OT Collector hostname 
(RELEASE-NAME-sumologic-otelcol.NAMESPACE), default=collection-sumologic-otelcol.sumologic
- *RUM HTTP Traces URL* (`RUM_ENDPOINT_URL`) - an endpoint where The Coffee Bar Frontend will send the spans 
- *Check Sweets AWS Lambda Function URL* (`LAMBDA_SWEETS_URL`) - an url of the CheckSweets AWS Lambda Function - [guide](../../applications/aws-lambdas/README.md)

## Deployment

The Coffee Bar App deployment command:

```bash
helm upgrade --install sumologic-the-coffee-bar . \
  --namespace the-coffee-bar-ns \
  --set extras.otelColHostName="<OTELCOL_HOSTNAME>" \
  --set extras.lambdaSweetsUrl="<LAMBDA_SWEETS_URL>" \
  --set extras.rumColSourceUrl="<RUM_ENDPOINT_URL>"
```
