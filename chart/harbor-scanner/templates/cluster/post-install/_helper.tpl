{{/*Compenents Names*/}}
{{- define "arksec.cluster.init" -}}
  {{- printf "%s-init" (include "arksec.fullname" .) -}}
{{- end -}}

