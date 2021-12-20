{{/*components names*/}}

{{- define "arksec.cluster" -}}
  {{- printf "%s-cluster" (include "arksec.fullname" .) -}}
{{- end -}}

{{- define "arksec.default.dockerconfigjson" -}}
  {{- printf "%s-default-dockerconfigjson" (include "arksec.fullname" .) -}}
{{- end -}}

{{- define "arksec.waitress.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.waitress.image "global" .Values.global) }}
{{- end -}}
