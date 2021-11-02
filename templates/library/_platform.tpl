{{- define "common.platform.name" -}}
{{- if .Values.global }}
    {{- if .Values.global.kubePlatform }}
    {{- .Values.global.kubePlatform -}}
    {{- else }}
    {{- print "kubernetes" -}}
    {{- end -}}
{{- else }}
{{- print "kubernetes" -}}
{{- end -}}
{{- end -}}

{{- define "common.platform.version" -}}
{{ .Capabilities.KubeVersion.Major }}.{{ .Capabilities.KubeVersion.Minor }}
{{- end -}}

{{- define "common.platform.number" -}}
{{ .Capabilities.KubeVersion.Major }}{{ .Capabilities.KubeVersion.Minor }}
{{- end -}}

{{- define "common.platform.openshiftPrivileged" -}}
{{- if eq "openshift" (include "common.platform.name" .) }}
securityContext:
  privileged: true
{{- end }}
{{- end -}}
