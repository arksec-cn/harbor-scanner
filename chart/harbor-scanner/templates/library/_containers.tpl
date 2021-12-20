{{- define "common.waitress.container" -}}
- name: waitress
  image: {{ include "arksec.waitress.image" . }}
  imagePullPolicy: {{ .Values.global.imagePullPolicy }} 
  {{- with .Values.waitress.resources }}
  resources:
{{ toYaml . | indent 4 }}
  {{- end }}
  envFrom:
  - configMapRef:
      name: {{ include "arksec.cluster" . }}-endpoints
  command:
  - bash
  - -c
  - | 
    #!/usr/bin/env bash
    set -x
    GREEN='\033[38;5;2m'
    YELLOW='\033[38;5;3m'

    stderr_print() {
        local -r bool="${BITNAMI_QUIET:-false}"
        shopt -s nocasematch
        if ! [[ "$bool" = 1 || "$bool" =~ ^(yes|true)$ ]]; then
            printf "%b\\n" "${*}" >&2
        fi
    }

    log() {
        stderr_print "${CYAN}${MODULE:-} ${MAGENTA}$(date "+%T.%2N ")${RESET}${*}"
    }

    info() {
        log "${GREEN}INFO ${RESET} ==> ${*}"
    }

    warn() {
        log "${YELLOW}WARN ${RESET} ==> ${*}"
    }

    function check_all() {
    if [ "${MONGO_ENDPOINT}" ]; then
      mongo_host=$(echo "${MONGO_ENDPOINT}" | awk -F ":" '{print $1}' )
      mongo_port=$(echo "${MONGO_ENDPOINT}" | awk -F ":" '{print $2}' )
      if nc -v -z -w 5 "${mongo_host}" "${mongo_port}" &> /dev/null; then
        info "*** connected to ${MONGO_ENDPOINT} ***"
      else
        warn "*** can not connect to ${MONGO_ENDPOINT} ***"
      return 1
      fi
    fi
    }
    function wait_ready() {
    while :
    do
      if check_all; then
        info "*** check complated. have fun. ***"
      exit 0
      fi
      info "*** sleep {{ .Values.waitress.interval }} and then re-check. ***"
      sleep {{ .Values.waitress.interval }}
    done
    }

    wait_ready
{{- end -}}