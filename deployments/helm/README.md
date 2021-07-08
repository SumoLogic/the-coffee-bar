# Sumo Logic The Coffee Bar App Helm Chart

## Prerequisite

The Coffee Bar App require below listed things to be configured:

- `RUM HTTP Traces URL` (RUM_ENDPOINT_URL) - an endpoint where The Coffee Bar Frontend will send the spans 
- `Check Sweets AWS Lambda Function URL` (CHECK_SWEETS_URL) - an url of the CheckSweets AWS Lambda Function - [guide](../../applications/aws-lambdas/README.md)
- `helm3` - [Helm Installation guide](https://helm.sh/docs/intro/install/)

## Deployment

The Coffee Bar App deployment command:

```bash
helm3 upgrade --install sumologic-the-coffee-bar . \
  --create-namespace \
  --namespace mat-test \
  --set commands.extras.bar.sweetsUrl="<CHECK_SWEETS_URL>" \

//TODO
  --set envs.frontend[0].name=REACT_APP_COLLECTION_SOURCE_URL,envs.frontend[10].value="<RUM_ENDPOINT_URL>"
```

