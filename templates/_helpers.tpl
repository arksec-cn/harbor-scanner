{{/*components names*/}}

{{- define "arksec.cluster" -}}
  {{- printf "%s-cluster" (include "arksec.fullname" .) -}}
{{- end -}}

{{- define "arksec.default.dockerconfigjson" -}}
  {{- printf "%s-default-dockerconfigjson" (include "arksec.fullname" .) -}}
{{- end -}}

{{- define "arksec.common.waitress.image" -}}
{{ include "common.public.images.image" (dict "imageRoot" .Values.common.waitress.image "global" .Values.global) }}
{{- end -}}
