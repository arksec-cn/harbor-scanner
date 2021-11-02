{{- define "common.waitress.container" -}}
- name: waitress
  image: {{ include "arksec.common.waitress.image" . }}
  imagePullPolicy: {{ .Values.global.imagePullPolicy }} 
  {{- with .Values.common.waitress.resources }}
  resources:
{{ toYaml . | indent 4 }}
  {{- end }}
  envFrom:
  - configMapRef:
      name: {{ include "arksec.cluster" . }}-endpoints
  command:
{{ include "common.waitress.command" . | indent 2 }}
{{- end -}}
