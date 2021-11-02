
{{/*
Hiamalay Mongodb Endpoints
*/}}
{{- define "arksec.cluster.mongodb.host" -}}
  {{- if eq .Values.cluster.mongodb.type "internal" -}}
    {{- template "arksec.cluster.mongodb" . }}
  {{- else -}}
    {{- .Values.cluster.mongodb.external.host -}}
  {{- end -}}
{{- end -}}

{{- define "arksec.cluster.mongodb.port" -}}
  {{- if eq .Values.cluster.mongodb.type "internal" -}}
    {{- printf "%s" "27017" -}}
  {{- else -}}
    {{- .Values.cluster.mongodb.external.port -}}
  {{- end -}}
{{- end -}}

{{- define "arksec.cluster.mongodb.username" -}}
  {{- if eq .Values.cluster.mongodb.type "internal" -}}
    {{- printf "%s" "admin" -}}
  {{- else -}}
    {{- .Values.cluster.mongodb.external.username -}}
  {{- end -}}
{{- end -}}

{{- define "arksec.cluster.mongodb.rawPassword" -}}
  {{- if eq .Values.cluster.mongodb.type "internal" -}}
    {{- printf "%s" "Arksec12345" -}}
  {{- else -}}
    {{- .Values.cluster.mongodb.external.password -}}
  {{- end -}}
{{- end -}}

