{{/*
Expand the name of the chart.
*/}}
{{- define "castai-autoscaler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "castai-autoscaler.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "castai-autoscaler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "castai-autoscaler.labels" -}}
helm.sh/chart: {{ include "castai-autoscaler.chart" . }}
{{ include "castai-autoscaler.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "castai-autoscaler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "castai-autoscaler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "castai-autoscaler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "castai-autoscaler.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "uuidFromName" -}}
{{- $name := printf "%s" . | trim -}}
{{- /*
    1. sha256sum of the input name (64 hex chars).
    2. Take the first 32 chars (giving us a 32-length string).
    3. Use a regex to split it into 8-4-4-4-12.
*/ -}}
{{- $fullHash := sha256sum $name -}}
{{- $hash := $fullHash | substr 0 32 -}}
{{- $matches := regexFindSubmatch "^(.{8})(.{4})(.{4})(.{4})(.{12})$" $hash -}}

{{- if eq (len $matches) 6 -}}
  {{- printf "%s-%s-%s-%s-%s" (index $matches 1) (index $matches 2) (index $matches 3) (index $matches 4) (index $matches 5) -}}
{{- else -}}
  invalid-uuid
{{- end -}}
{{- end -}}
