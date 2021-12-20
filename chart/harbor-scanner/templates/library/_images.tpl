{{/*
Return the image name
{{ include "common.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "common.images.image.global.first" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $projectName := .imageRoot.project -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $tag := .imageRoot.tag | toString -}}
{{- if .global }}
    {{- if .global.imageRegistry }}
     {{- $registryName = .global.imageRegistry -}}
    {{- end -}}
    {{- if .global.imageProject }}
     {{- $projectName = .global.imageProject -}}
    {{- end -}}
    {{- if .global.imageTag }}
     {{- $tag = .global.imageTag | toString -}}
    {{- end -}}
{{- end -}}
{{- if $registryName }}
{{- printf "%s/%s/%s:%s" $registryName $projectName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s/%s:%s" $projectName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{- define "common.images.image" -}}
{{- $registryName := .global.imageRegistry -}}
{{- $projectName := .global.imageProject -}}
{{- $tag := .global.imageTag | toString -}}
{{- $repositoryName := .imageRoot.repository -}}

{{- if .imageRoot.registry }}
    {{- $registryName = .imageRoot.registry -}}
{{- end -}}
{{- if .imageRoot.project }}
    {{- $projectName = .imageRoot.project -}}
{{- end -}}
{{- if .imageRoot.tag }}
    {{- $tag = .imageRoot.tag | toString -}}
{{- end -}}

{{- if $registryName }}
{{- printf "%s/%s/%s:%s" $registryName $projectName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s/%s:%s" $projectName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the public image name
{{ include "common.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "common.public.images.image.global.first" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $projectName := .imageRoot.project -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $tag := .imageRoot.tag | toString -}}
{{- if .global }}
    {{- if .global.publicImageProject }}
     {{- $projectName = .global.publicImageProject -}}
    {{- end -}}
    {{- if .global.publicImageTag }}
     {{- $tag = .global.publicImageTag | toString -}}
    {{- end -}}
{{- end -}}
{{- if $registryName }}
{{- printf "%s/%s/%s:%s" $registryName $projectName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s/%s:%s" $projectName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{- define "common.public.images.image" -}}
{{- $registryName := .global.imageRegistry -}}
{{- $projectName := .global.publicImageProject -}}
{{- $tag := .global.publicImageTag | toString -}}
{{- $repositoryName := .imageRoot.repository -}}

{{- if .imageRoot.registry }}
    {{- $registryName = .imageRoot.registry -}}
{{- end -}}
{{- if .imageRoot.project }}
    {{- $projectName = .imageRoot.project -}}
{{- end -}}
{{- if .imageRoot.tag }}
    {{- $tag = .imageRoot.tag | toString -}}
{{- end -}}

{{- if $registryName }}
{{- printf "%s/%s/%s:%s" $registryName $projectName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s/%s:%s" $projectName $repositoryName $tag -}}
{{- end -}}
{{- end -}}
