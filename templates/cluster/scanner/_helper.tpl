{{/*Compenents Names*/}}
{{- define "arksec.cluster.scanner" -}}
  {{- printf "%s-cluster-scanner" (include "arksec.fullname" .) -}}
{{- end -}}

{{/*Images Names*/}}
{{- define "arksec.cluster.scanner.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cluster.scanner.image "global" .Values.global) }}
{{- end -}}

{{- define "arksec.cluster.scanner.server.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cluster.scanner.server.image "global" .Values.global) }}
{{- end -}}

{{- define "arksec.cluster.scanner.feed.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cluster.scanner.feed.image "global" .Values.global) }}
{{- end -}}

{{- define "arksec.cluster.scanner.clamav.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cluster.scanner.clamav.image "global" .Values.global) }}
{{- end -}}


{{- define "arksec.cluster.migrate.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.cluster.migrate.image "global" .Values.global) }}
{{- end -}}