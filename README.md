# Arksec Harbor Image Scanner

English | [简体中文](README-zh_CN.md)
## Introdution

[Arksec Inc](https://www.arksec.cn/) is a start-up security company providing complete cloud native security solution.
[`Arksec Harbor Image Scanner`] is the scanner which focus on scanning container images in Harbor image repository.

## Compatibility

### OS Release

- CentOS/RHEL 7-8系列

- Ubuntu 16.04, 18.04, 20.04

- SUSE Linux SP3/SP4/SP5

- 麒麟V10

### OS/Arch

- amd64

- arm64

### Orchestrator

- Kubernetes 1.12 - 1.20
- Openshift Container Platform 4.6 - 4.7

### Helm

- Helm 3.1.0+

## Installation 🚀

* Set Environment Variable

```bash
export REDSTONE_CHART="scanner"
export REDSTONE_RELEASE="[RELEASE]"
export REDSTONE_NAMESPACE="[NAMESPACE]"
```

* Install

```bash
kubectl create ns "${REDSTONE_NAMESPACE}"

helm install "${REDSTONE_RELEASE}" -n "${REDSTONE_NAMESPACE}" ./ \
--set global.imageProject=himalaya/dev \
--set global.imageTag=latest \
--set global.publicImageProject=public/dev \
--set global.publicImageTag=latest \
--set global.imagePullPolicy=IfNotPresent \
--set persistence.enabled=true \
--set persistence.type=hostPath
```

## Uninstall😭

1. Remove Helm Release

```bash
helm delete "${REDSTONE_RELEASE}" -n "${REDSTONE_NAMESPACE}"
```

2. Remove PV和PVC

```bash
# Linux
kubectl get pvc -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete pvc {} -n "${REDSTONE_NAMESPACE}"

kubectl get pv -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete pv {}
```
