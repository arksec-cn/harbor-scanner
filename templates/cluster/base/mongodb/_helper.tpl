{{/*Compenents Names*/}}
{{- define "arksec.cluster.mongodb.image" -}}
{{ include "common.public.images.image" (dict "imageRoot" .Values.cluster.mongodb.internal.image "global" .Values.global) }}
{{- end -}}

{{/*Images Names*/}}
{{- define "arksec.cluster.mongodb" -}}
  {{- printf "%s-cluster-mongodb" (include "arksec.fullname" .) -}}
{{- end -}}