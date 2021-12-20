{{/*Compenents Names*/}}
{{- define "arksec.cluster.scanner" -}}
  {{- printf "%s-scanner" (include "arksec.fullname" .) -}}
{{- end -}}

{{/*Images Names*/}}
{{- define "arksec.cluster.scanner.init.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.scanner.init.image "global" .Values.global) }}
{{- end -}}

{{- define "arksec.cluster.scanner.engine.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.scanner.engine.image "global" .Values.global) }}
{{- end -}}

{{- define "arksec.cluster.scanner.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.scanner.server.image "global" .Values.global) }}
{{- end -}}

{{- define "arksec.cluster.scanner.clamav.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.scanner.clamav.image "global" .Values.global) }}
{{- end -}}

{{- define "arksec.cluster.migrate.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.migrate.image "global" .Values.global) }}
{{- end -}}