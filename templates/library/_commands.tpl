{{/*
Renders a command that exporter the storage usage.
Usage:
{{ include "arksec.persistence.exporter.command" ( dict "dataRoot" .Values.path.to.the.dataRoot "exporterRoot" .Values.path.to.the.exporterRoot) }}
*/}}
{{- define "arksec.persistence.exporter.command" -}}
{{- $size := .dataRoot.size -}}
{{- $interval := .exporterRoot.interval -}}
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
      log "${YELLOW}INFO ${RESET} ==> ${*}"
  }

  while :
  do
    sleep {{ $interval }}

    timestamp=$(date +%s)
    
    persistence_request_bytes=$(( $(echo {{ $size }} | grep -Eo '\d+' ) * 1024 * 1024 * 1024 ))
    
    persistence_usage_bytes=$(( $(du -s /data | awk '{print $1}') * 1024 ))
    
    name=${POD_NAME}
    
    if echo ${name} | grep "console-base"; then
        type_app="console"
    elif echo ${name} | grep "cluster-base"; then
        type_app="cluster"
    fi
    if echo ${name} | grep "base-mongodb"; then
        type_component="mongodb"
    elif echo ${name} | grep "base-etcd"; then
        type_component="etcd"
    elif echo ${name} | grep "base-dgraph"; then
        type_component="dgraph"
    fi
    type="${type_app}-${type_component}"

    data_post="
    {
        \"timestamp\": \"${timestamp}\",
        \"name\": \"${name}\",
        \"type\": \"${type}\",
        \"persistence_request_bytes\": \"${persistence_request_byte}\",
        \"persistence_usage_bytes\": \"${persistence_usage_bytes}\"
    }
    "

    data_get="?timestamp=${timestamp}&name=${name}&type=${type}&persistence_request_bytes=${persistence_request_bytes}&persistence_usage_bytes=${persistence_usage_bytes}"

    # start push
    warn "*** PUSH SYSTEM STORAGE USAGE EVERY {{ $interval }} ***"
    
    # # method push
    # curl --location -X POST -H "Content-Type: application/json" "${BACKEND_URL}" -d "${data_post}"

    # method get
    res=$(curl -s -X GET "${BACKEND_URL}${data_get}")

    info "*** PARAMS: ${data_get} ***"
    info "*** RESULT: ${res} ***"
    echo ""
  done
{{- end -}}


{{- define "common.waitress.command" -}}
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

  if [ "${ETCD_ENDPOINTS}" ]; then
    etcd_host=$(echo "${ETCD_ENDPOINTS}" | awk -F "//" '{print $2}'  | awk -F ":" '{print $1}' )
    etcd_port=$(echo "${ETCD_ENDPOINTS}" | awk -F "//" '{print $2}'  | awk -F ":" '{print $2}' )
    if nc -v -z -w 5 "${etcd_host}" "${etcd_port}" &> /dev/null; then
      info "*** connected to ${ETCD_ENDPOINTS} ***"
    else
      warn "*** can not connect to ${ETCD_ENDPOINTS} ***"
    return 1
    fi
  fi

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

  if [ "${RABBITMQ_ENDPOINT}" ]; then
    rabbit_host=$(echo "${RABBITMQ_ENDPOINT}" | awk -F ":" '{print $1}' )
    rabbit_port=$(echo "${RABBITMQ_ENDPOINT}" | awk -F ":" '{print $2}' )
    if nc -v -z -w 5 "${rabbit_host}" "${rabbit_port}" &> /dev/null; then
      info "*** connected to ${RABBITMQ_ENDPOINT} ***"
    else
      warn "*** can not connect to ${RABBITMQ_ENDPOINT} ***"
    return 1
    fi
  fi 

  if [ "${DGRAPH_ENDPOINTS}" ]; then
    dgraph_host=$(echo "${DGRAPH_ENDPOINTS}" | awk -F ":" '{print $1}' )
    dgraph_port=$(echo "${DGRAPH_ENDPOINTS}" | awk -F ":" '{print $2}' )
    if nc -v -z -w 5 "${dgraph_host}" "${dgraph_port}" &> /dev/null; then
      info "*** connected to ${DGRAPH_ENDPOINTS} ***"
    else
      warn "*** can not connect to ${DGRAPH_ENDPOINTS} ***"
    return 1
    fi
  fi

  if [ "${KAFKA_ENDPOINTS}" ]; then
    kafka_host=$(echo "${KAFKA_ENDPOINTS}" | awk -F ":" '{print $1}' )
    kafka_port=$(echo "${KAFKA_ENDPOINTS}" | awk -F ":" '{print $2}' )
    if nc -v -z -w 5 "${kafka_host}" "${kafka_port}" &> /dev/null; then
      info "*** connected to ${KAFKA_ENDPOINTS} ***"
    else
      warn "*** can not connect to ${KAFKA_ENDPOINTS} ***"
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

    info "*** sleep {{ .Values.common.waitress.interval }} and then re-check. ***"
    sleep {{ .Values.common.waitress.interval }}
  done
  }

  wait_ready

{{- end -}}