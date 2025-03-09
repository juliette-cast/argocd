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
    1. Hash the input name (sha256)
    2. Take the first 32 hex chars
    3. Insert dashes to make 8-4-4-4-12
*/ -}}
{{- $hash := (sha256sum $name) | substr 0 32 -}}
{{- printf "%s-%s-%s-%s-%s" 
    ($hash | substr 0 8) 
    ($hash | substr 8 4) 
    ($hash | substr 12 4) 
    ($hash | substr 16 4) 
    ($hash | substr 20 12) 
-}}
{{- end -}}
