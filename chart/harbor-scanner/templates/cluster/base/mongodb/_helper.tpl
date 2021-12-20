{{/*Compenents Names*/}}
{{- define "arksec.cluster.mongodb.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.mongodb.image "global" .Values.global) }}
{{- end -}}

{{/*Images Names*/}}
{{- define "arksec.cluster.mongodb" -}}
  {{- printf "%s-mongodb" (include "arksec.fullname" .) -}}
{{- end -}}