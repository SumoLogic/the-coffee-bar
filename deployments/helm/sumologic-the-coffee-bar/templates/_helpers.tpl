{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sumologic.thecoffeebar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sumologic.thecoffeebar.fullname" -}}
{{- .Values.fullnameOverride | default .Chart.Name }}
{{- end }}

{{- define "sumologic.thecoffeebar.metadata.name.frontend" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-frontend
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.frontend.service" -}}
the-coffee-bar-frontend
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.frontend.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.frontend" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.frontend.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.frontend" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.bar" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-bar
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.bar.service" -}}
the-coffee-bar
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.bar.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.bar" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.bar.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.bar" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.cashdesk" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-cashdesk
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.cashdesk.service" -}}
the-cashdesk
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.cashdesk.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.cashdesk" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.cashdesk.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.cashdesk" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.coffeemachine" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-coffeemachine
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.coffeemachine.service" -}}
the-coffee-machine
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.coffeemachine.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.coffeemachine" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.coffeemachine.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.coffeemachine" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.calculatorsvc" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-calculator-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.calculatorsvc.service" -}}
calculator-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.calculatorsvc.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.calculatorsvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.calculatorsvc.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.calculatorsvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.postgres" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-postgres-db
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.postgres.service" -}}
{{ template "sumologic.thecoffeebar.metadata.name.postgres" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.postgres.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.postgres" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.postgres.statefulset" -}}
{{ template "sumologic.thecoffeebar.metadata.name.postgres" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.postgres.volume" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-postgres-volume
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.postgres.volume.claim" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-postgres-volume-claim
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.machinesvc" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-machine-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.machinesvc.service" -}}
machine-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.machinesvc.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.machinesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.machinesvc.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.machinesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.watersvc" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-water-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.watersvc.service" -}}
water-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.watersvc.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.watersvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.watersvc.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.watersvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.coffeesvc" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-coffee-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.coffeesvc.service" -}}
coffee-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.coffeesvc.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.coffeesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.coffeesvc.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.coffeesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.clicker" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-clicker
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.clicker.service" -}}
{{ template "sumologic.thecoffeebar.metadata.name.clicker" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.clicker.configmap" -}}
{{ template "sumologic.thecoffeebar.metadata.name.clicker" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.clicker.deployment" -}}
{{ template "sumologic.thecoffeebar.metadata.name.clicker" . }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "sumologic.thecoffeebar.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "sumologic.thecoffeebar.labels.common" -}}
helm.sh/chart: {{ include "sumologic.thecoffeebar.chart" . }}
{{ include "sumologic.thecoffeebar.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "sumologic.thecoffeebar.labels.app.frontend" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-frontend
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.frontend.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.frontend" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.frontend.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.frontend" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.frontend.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.frontend" . }}
{{- end -}}


{{- define "sumologic.thecoffeebar.labels.app.bar" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-bar
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.bar.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.bar" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.bar.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.bar" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.bar.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.bar" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.cashdesk" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-cashdesk
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.cashdesk.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.cashdesk" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.cashdesk.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.cashdesk" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.cashdesk.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.cashdesk" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.coffeemachine" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-coffeemachine
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.coffeemachine.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.coffeemachine" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.coffeemachine.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.coffeemachine" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.coffeemachine.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.coffeemachine" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.calculatorsvc" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-calculator-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.calculatorsvc.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.calculatorsvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.calculatorsvc.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.calculatorsvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.calculatorsvc.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.calculatorsvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.postgres" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-postgres-db
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.postgres.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.postgres" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.postgres.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.postgres" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.postgres.statefulset" -}}
{{- template "sumologic.thecoffeebar.labels.app.postgres" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.postgres.configmap" -}}
{{- template "sumologic.thecoffeebar.labels.app.postgres" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.postgres.volume" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-postgres-volume
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.postgres.volume.claim" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-postgres-volume-claim
{{- end -}}


{{- define "sumologic.thecoffeebar.labels.app.machinesvc" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-machine-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.machinesvc.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.machinesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.machinesvc.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.machinesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.machinesvc.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.machinesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.watersvc" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-water-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.watersvc.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.watersvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.watersvc.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.watersvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.watersvc.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.watersvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.coffeesvc" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-coffee-svc
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.coffeesvc.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.coffeesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.coffeesvc.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.coffeesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.coffeesvc.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.coffeesvc" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.clicker" -}}
{{- template "sumologic.thecoffeebar.fullname" . }}-clicker
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.clicker.pod" -}}
{{- template "sumologic.thecoffeebar.labels.app.clicker" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.clicker.service" -}}
{{- template "sumologic.thecoffeebar.labels.app.clicker" . }}
{{- end -}}

{{- define "sumologic.thecoffeebar.labels.app.clicker.deployment" -}}
{{- template "sumologic.thecoffeebar.labels.app.clicker" . }}
{{- end -}}


{{/*
Selector labels
*/}}
{{- define "sumologic.thecoffeebar.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sumologic.thecoffeebar.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.frontend" -}}
frontend
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.bar" -}}
bar
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.cashdesk" -}}
cashdesk
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.coffeemachine" -}}
coffeemachine
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.calculatorsvc" -}}
calculator-svc
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.machinesvc" -}}
machine-svc
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.watersvc" -}}
water-svc
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.coffeesvc" -}}
coffee-svc
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.clicker" -}}
clicker
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.postgres" -}}
postgres-db
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.postgres.volume" -}}
{{ include "sumologic.thecoffeebar.fullname" . }}-pv
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.postgres.volume.claim" -}}
{{ include "sumologic.thecoffeebar.fullname" . }}-pvc
{{- end }}



{{/*
Create the name of the service account to use
*/}}
{{- define "sumologic.thecoffeebar.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "sumologic.thecoffeebar.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create commands/args
*/}}

{{ define "sumologic.thecoffeebar.command.bar" }}
- opentelemetry-instrument
- the-coffee-bar
- --host={{ template "sumologic.thecoffeebar.metadata.name.bar.service" . }}
- --port=8082
- --coffeemachine-host={{ template "sumologic.thecoffeebar.metadata.name.coffeemachine.service" . }}
- --coffeemachine-port=8083
- --cashdesk-host={{ template "sumologic.thecoffeebar.metadata.name.cashdesk.service" . }}
- --cashdesk-port=8084
{{- if .Values.extras.lambdaSweetsUrl }}
- --sweets-url={{ .Values.extras.lambdaSweetsUrl }}
{{ end }}
{{- end }}

{{ define "sumologic.thecoffeebar.command.cashdesk" }}
- opentelemetry-instrument
- the-cashdesk
- --host={{ template "sumologic.thecoffeebar.metadata.name.cashdesk.service" . }}
- --port=8084
- --calculator-host={{ template "sumologic.thecoffeebar.metadata.name.calculatorsvc.service" . }}
- --calculator-port=8090
- --connection-string={{ printf "postgresql://account:account@%s:5432/account" ( include "sumologic.thecoffeebar.metadata.name.postgres.service" .) }}
{{- end }}

{{ define "sumologic.thecoffeebar.command.coffeemachine" }}
- opentelemetry-instrument
- the-coffee-machine
- --host={{ template "sumologic.thecoffeebar.metadata.name.coffeemachine.service" . }}
- --port=8083
- --machine-svc-host={{ template "sumologic.thecoffeebar.metadata.name.machinesvc.service" . }}
- --machine-svc-port=9090
- --interval_based_cron=$(INTERVAL_BASED_CRON)
- --spike-cron=$(SPIKE_CRON)
- --spike_interval_days=$(SPIKE_INTERVAL_DAYS)
- --spike-start-date=$(SPIKE_START_DATE)
- --spike-duration=$(SPIKE_DURATION)
- --cpu-spike-processes=$(CPU_SPIKE_PROCESSES)
- --network-delay=$(NETWORK_DELAY)
{{- end }}

{{ define "sumologic.thecoffeebar.command.machinesvc" }}
- ruby
- lib/machine.rb
- {{ template "sumologic.thecoffeebar.metadata.name.machinesvc.service" . }}
- "9090"
- {{ template "sumologic.thecoffeebar.metadata.name.coffeesvc.service" . }}
- "9091"
- {{ template "sumologic.thecoffeebar.metadata.name.watersvc.service" . }}
- "9092"
{{- end }}

{{ define "sumologic.thecoffeebar.command.watersvc" }}
- ruby
- lib/water.rb
- {{ template "sumologic.thecoffeebar.metadata.name.watersvc.service" . }}
- "9092"
{{- end }}

{{ define "sumologic.thecoffeebar.command.coffeesvc" }}
- ruby
- lib/coffee.rb
- {{ template "sumologic.thecoffeebar.metadata.name.coffeesvc.service" . }}
- "9091"
{{- end }}

{{ define "sumologic.thecoffeebar.command.clicker" }}
- node
- src/clicker.js
- {{ printf "http://%s:3000" ( include "sumologic.thecoffeebar.metadata.name.frontend.service" . ) }}
{{- end }}

{{ define "sumologic.thecoffeebar.command.calculatorsvc" }}
- dotnet
- dotnet-core-calculator-svc.dll
- {{ printf "http://%s:8090" ( include "sumologic.thecoffeebar.metadata.name.calculatorsvc.service" . ) }}
{{- end }}

{{ define "sumologic.thecoffeebar.command.frontend" }}
- /bin/sh
- '-c'
- python3 ./cpu_killer/cpu_killer.py & npm start
{{- end }}

{{/*
Create envs
*/}}

{{ define "sumologic.thecoffeebar.envs.otel.exporter.otlp.grpc" }}
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: {{ printf "http://%s:4317" .Values.extras.otelColHostName | quote }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.python.otel.exporter.otlp.proto.http" }}
- name: OTEL_TRACES_EXPORTER
  value: otlp_proto_http
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: {{ printf "http://%s:55681/v1/traces" .Values.extras.otelColHostName | quote }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.otel.exporter.otlp.http" }}
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: {{ printf "http://%s:55681" .Values.extras.otelColHostName | quote }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.frontend" }}
{{- range $name, $value := .Values.envs.frontend }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
- name: REACT_APP_COFFEE_BAR_URL
  value: {{ printf "http://%s:8082/order" ( include "sumologic.thecoffeebar.metadata.name.bar.service" . ) | quote }}
- name: REACT_APP_COLLECTION_SOURCE_URL
  value: {{ .Values.extras.rumColSourceUrl | quote }}
- name: REACT_APP_PROPAGATION_CORS_URLS
  value: {{ printf "[/^http:\\\\/\\\\/%s:8082\\\\/.*/,]" ( include "sumologic.thecoffeebar.metadata.name.bar.service" . ) | quote }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.bar" }}
{{- range $name, $value := .Values.envs.bar }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- include "sumologic.thecoffeebar.envs.python.otel.exporter.otlp.proto.http" . }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.cashdesk" }}
{{- range $name, $value := .Values.envs.cashdesk }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- include "sumologic.thecoffeebar.envs.python.otel.exporter.otlp.proto.http" . }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.coffeemachine" }}
{{- range $name, $value := .Values.envs.coffeemachine }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- include "sumologic.thecoffeebar.envs.python.otel.exporter.otlp.proto.http" . }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.machinesvc" }}
{{- range $name, $value := .Values.envs.machinesvc }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- include "sumologic.thecoffeebar.envs.otel.exporter.otlp.http" . }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.watersvc" }}
{{- range $name, $value := .Values.envs.watersvc }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- include "sumologic.thecoffeebar.envs.otel.exporter.otlp.http" . }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.coffeesvc" }}
{{- range $name, $value := .Values.envs.coffeesvc }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- include "sumologic.thecoffeebar.envs.otel.exporter.otlp.http" . }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.calculatorsvc" }}
{{- range $name, $value := .Values.envs.calculatorsvc }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- include "sumologic.thecoffeebar.envs.otel.exporter.otlp.grpc" . }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.clicker" }}
{{- range $name, $value := .Values.envs.clicker }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- end }}

{{ define "sumologic.thecoffeebar.envs.postgres" }}
{{- range $name, $value := .Values.envs.postgres }}
- name: {{ $name }}
  value: {{ $value | quote -}}
{{ end }}
{{- end }}
