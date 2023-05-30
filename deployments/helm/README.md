# Sumo Logic The Coffee Bar App Helm Chart

## Prerequisite

The Coffee Bar App require below listed things to be configured:

- *helm* - [Helm Installation guide](https://helm.sh/docs/intro/install/)
- *Sumologic OpenTelemetry Collector Hostname* (`OTELCOL_HOSTNAME`) - Sumologic Kubernetes Collection OT Collector hostname 
(RELEASE-NAME-sumologic-otelcol.NAMESPACE), default=collection-sumologic-otelcol.sumologic
- *RUM HTTP Traces URL* (`RUM_ENDPOINT_URL`) - an endpoint where The Coffee Bar Frontend will send the spans 
- *Check Cakes AWS Lambda Function URL* (`LAMBDA_CAKES_URL`) - an url of the CheckCakes AWS Lambda Function - [guide](../../applications/aws-lambdas/README.md)

## Deployment

The Coffee Bar App deployment command:

```bash
helm upgrade --install sumologic-the-coffee-bar . \
  --namespace the-coffee-bar-ns \
  --set extras.otelColHostName="<OTELCOL_HOSTNAME>" \
  --set extras.lambdaCakesUrl="<LAMBDA_CAKES_URL>" \
  --set extras.rumColSourceUrl="<RUM_ENDPOINT_URL>"
```

On successful installation, you would be required to run 3 additional commands (printed on the shell) to complete the setup.
`NOTE:` If you are setting up the application in a local cluster, an ingress host name might not be present. In such cases, refer to the [Additional Steps](#additional-steps) section further.

Now, run the following command to interact with the UI on the host `localhost:3000`
```bash
kubectl -n the-coffee-bar-ns port-forward deployment.apps/sumologic-the-coffee-bar-frontend 3000:3000
```

## Additional Steps
`NOTE:` These are only required when an ingress host name is not present. In such cases, to enable frontend-backend communication, run the following commands in order:

```bash
BAR_BACKEND_URL=localhost
```

```bash
kubectl --namespace the-coffee-bar-ns set env deployment/sumologic-the-coffee-bar-frontend REACT_APP_COFFEE_BAR_URL=http://localhost:8082/order
```

```bash
kubectl --namespace the-coffee-bar-ns set env deployment/sumologic-the-coffee-bar-frontend REACT_APP_PROPAGATION_CORS_URLS='[/^http:\/\/localhost:8082\/.*/,/^http:\/\/the-coffee-bar:8082\/.*/,]'
```

These will redirect frontend API calls to `localhost:8082`.

Now, run the following commands to interact with the UI on the host `localhost:3000`
```bash
kubectl -n the-coffee-bar-ns port-forward deployment.apps/sumologic-the-coffee-bar-frontend 3000:3000
```
```bash
kubectl -n the-coffee-bar-ns port-forward deployment.apps/sumologic-the-coffee-bar-bar 8082:8082
```

## Troubleshooting
<details>
<summary>Issue 1: CORS error while sending request to localhost:8082 from localhost:3000</summary>

- To resolve this, you have to enable the backend to accept requests from localhost (127.0.0.1). To do this, update the `--host=the-coffee-bar` to `--host=127.0.0.1` in the `sumologic-the-coffee-bar-bar` yaml file. You can also set the host to `0.0.0.0` to allow requests from any origin.
</details>

<details>
<summary>Issue 2: no matches for kind "CronJob" in version "batch/v1beta1" on running helm install command</summary>

- This error occurs when you are using a K8s version above v1.21. To resolve this error, update the `apiVersion: batch/v1beta1` to `apiVersion: batch/v1` in the following files:
```bash
restartcronbar.yaml
restartcronclicker.yaml
restartcroncashdesk.yaml
restartcronpostgres.yaml
```
</details>

<details>
<summary>Issue 3: Frontend service Pods in CrashLoopBackOff state</summary>

- To resolve this, you need to increase the memory requests/limits given to the frontend service in [this](https://github.com/SumoLogic/the-coffee-bar/blob/main/deployments/helm/sumologic-the-coffee-bar/values.yaml) file
```bash
  frontend:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 1000m
      memory: 768Mi
```
</details>