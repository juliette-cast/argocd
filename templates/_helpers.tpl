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

{{/*
Generate a deterministic UUID-like string from a cluster name by:
1. Computing the SHA256 sum (64 hex chars).
2. Taking the first 32 chars.
3. Splitting into 8-4-4-4-12 using end-index slicing.
*/}}
{{- define "uuidFromName" -}}
{{- $name := printf "%s" . | trim -}}
{{- $fullHash := sha256sum $name -}}
{{- /* Take the first 32 hex chars */ -}}
{{- $hash32 := $fullHash | substr 0 32 -}}
{{- /* Slices use [start:end] indexing */ -}}
{{- $part1 := $hash32 | substr 0 8 -}}    {{/*  0..8   = 8 chars  */}}
{{- $part2 := $hash32 | substr 8 12 -}}   {{/*  8..12 = 4 chars  */}}
{{- $part3 := $hash32 | substr 12 16 -}}  {{/* 12..16 = 4 chars  */}}
{{- $part4 := $hash32 | substr 16 20 -}}  {{/* 16..20 = 4 chars  */}}
{{- $part5 := $hash32 | substr 20 32 -}}  {{/* 20..32 = 12 chars */}}
{{- printf "%s-%s-%s-%s-%s" $part1 $part2 $part3 $part4 $part5 -}}
{{- end -}}

