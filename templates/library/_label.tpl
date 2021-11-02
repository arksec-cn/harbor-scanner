{{/*
Common labels
*/}}
{{- define "arksec.labels" -}}
helm.sh/chart: {{ include "arksec.chart" . }}
{{ include "arksec.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "arksec.selectorLabels" -}}
{{/*app.kubernetes.io/name: {{ include "arksec.name" . }}*/}}
app.kubernetes.io/name: arksec
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
