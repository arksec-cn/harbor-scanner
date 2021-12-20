
{{/*
Hiamalay Mongodb Endpoints
*/}}
{{- define "arksec.cluster.mongodb.host" -}}
    {{- template "arksec.cluster.mongodb" . }}
{{- end -}}

{{- define "arksec.cluster.mongodb.port" -}}
    {{- printf "%s" "27017" -}}
{{- end -}}

{{- define "arksec.cluster.mongodb.username" -}}
    {{- printf "%s" "admin" -}}
{{- end -}}

{{- define "arksec.cluster.mongodb.rawPassword" -}}
    {{- printf "%s" "Arksec12345" -}}
{{- end -}}

