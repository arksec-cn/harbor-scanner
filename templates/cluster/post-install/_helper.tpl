{{/*Compenents Names*/}}
{{- define "arksec.cluster.init" -}}
  {{- printf "%s-cluster-init" (include "arksec.fullname" .) -}}
{{- end -}}

