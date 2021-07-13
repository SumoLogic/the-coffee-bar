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
{{- default .Chart.Name }}
{{- end }}

{{- define "sumologic.thecoffeebar.metadata.name.frontend" -}}
{{ template "sumologic.thecoffeebar.fullname" . }}-frontend
{{- end -}}

{{- define "sumologic.thecoffeebar.metadata.name.frontend.service" -}}
{{ template "sumologic.thecoffeebar.metadata.name.frontend" . }}
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
{{ template "sumologic.thecoffeebar.metadata.name.bar" . }}
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
{{ template "sumologic.thecoffeebar.metadata.name.cashdesk" . }}
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
{{ template "sumologic.thecoffeebar.metadata.name.coffeemachine" . }}
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
{{ template "sumologic.thecoffeebar.metadata.name.calculatorsvc" . }}
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
{{ template "sumologic.thecoffeebar.metadata.name.machinesvc" . }}
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
{{ template "sumologic.thecoffeebar.metadata.name.watersvc" . }}
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
{{ template "sumologic.thecoffeebar.metadata.name.coffeesvc" . }}
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
postgres-persistent-volume
{{- end }}

{{- define "sumologic.thecoffeebar.selectorLabels.postgres.volume.claim" -}}
postgres-persistent-volume-claim
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
{{ define "sumologic.thecoffeebar.args.bar" }}
- /bin/bash
- -c
- "opentelemetry-instrument python3 src/bin/the_coffee_bar.py \
  --host={{ template "sumologic.thecoffeebar.metadata.name.bar.service" . }} \
  --port=8082 \
  --coffeemachine-host={{ template "sumologic.thecoffeebar.metadata.name.coffeemachine.service" . }} \
  --coffeemachine-port=8083 \
  --cashdesk-host={{ template "sumologic.thecoffeebar.metadata.name.cashdesk.service" . }} \
  --cashdesk-port=8084 \
  --sweets-url={{ .Values.commands.extras.bar.sweetsUrl }}"
{{- end }}

{{ define "sumologic.thecoffeebar.args.cashdesk" }}
- /bin/bash
- -c
- "opentelemetry-instrument python3 src/bin/the_cashdesk.py \
  --host={{ template "sumologic.thecoffeebar.metadata.name.cashdesk.service" . }} \
  --port=8084 \
  --calculator-host={{ template "sumologic.thecoffeebar.metadata.name.calculatorsvc.service" . }} \
  --calculator-port=8090 \
  --connection-string={{ printf "postgresql://account:account@%s:5432/account" ( include "sumologic.thecoffeebar.metadata.name.postgres.service" .) }}"
{{- end }}

{{ define "sumologic.thecoffeebar.args.coffeemachine" }}
- /bin/bash
- -c
- "opentelemetry-instrument python3 src/bin/the_coffee_machine.py \
  --host={{ template "sumologic.thecoffeebar.metadata.name.coffeemachine.service" . }} \
  --port=8083 \
  --machine-svc-host={{ template "sumologic.thecoffeebar.metadata.name.machinesvc.service" . }} \
  --machine-svc-port=9090 \
  --cpu-increase-interval=10 \
  --cpu-increase-duration=5 \
  --cpu-increase-threads=475"
{{- end }}

{{ define "sumologic.thecoffeebar.args.machinesvc" }}
- /bin/bash
- -c
- "ruby lib/machine.rb \
  {{ template "sumologic.thecoffeebar.metadata.name.machinesvc.service" . }} \
  9090 \
  {{ template "sumologic.thecoffeebar.metadata.name.coffeesvc.service" . }} \
  9091 \
  {{ template "sumologic.thecoffeebar.metadata.name.watersvc.service" . }} \
  9092"
{{- end }}

{{ define "sumologic.thecoffeebar.args.watersvc" }}
- /bin/bash
- -c
- "ruby lib/water.rb \
  {{ template "sumologic.thecoffeebar.metadata.name.watersvc.service" . }} \
  9092"
{{- end }}

{{ define "sumologic.thecoffeebar.args.coffeesvc" }}
- /bin/bash
- -c
- "ruby lib/coffee.rb \
  {{ template "sumologic.thecoffeebar.metadata.name.coffeesvc.service" . }} \
  9091"
{{- end }}

{{ define "sumologic.thecoffeebar.command.clicker" }}
{{- $frontendHost := ( include "sumologic.thecoffeebar.metadata.name.frontend.service" . ) -}}
{{ printf "[\"node\", \"src/clicker.js\", \"http://%s:3000\"]" $frontendHost }}
{{- end }}