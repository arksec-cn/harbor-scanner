# 雅客云Harbor镜像扫描平台

## 产品介绍

[北京雅客云安全科技有限公司](https://www.arksec.cn/)是由硅谷领先网络安全公司资深技术专家、以色列领先网络安全公司高管团队成立的以基于云原生安全产品和服务为主的技术驱动型高新技术企业。

[雅客云Harbor镜像扫描平台]是雅客云安全推出的面向Harbor仓库中的镜像进行扫描的安全产品，可以全面有效的扫描发现镜像中存在的各种安全漏洞。

产品使用[Helm](https://helm.sh)包管理器进行资源管理。使用`helm-chart`轻松的在[Kubernetes](http://kubernetes.io)集群安装、升级或是卸载`雅客云Harbor镜像扫描平台`。

## 兼容性说明

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

## 开始安装🚀

* 设置一次环境变量，在后续的操作中，都有可能使用这些变量。

```bash
export REDSTONE_CHART="arksec"
export REDSTONE_RELEASE="scanner"
export REDSTONE_NAMESPACE="scanner"
```

* 安装

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

> **Tip**: Helm会等待所有资源创建成功之后退出，赤岩石系统有较多的启动顺序逻辑，所以`helm install`指令大概要运行5分钟，这个是正常的。可以使用`kubectl get pods -n vegeta -w`进行观测。


## 卸载指南😭

1. 卸载Helm Release

```bash
helm delete "${REDSTONE_RELEASE}" -n "${REDSTONE_NAMESPACE}"
```

> **Tip**: 这个命令会删除所有K8s资源，并且删除这个Release。但是不会删除PVCs和CRDs资源。这类数据存储的资源强制用户手动删除。

2. 删除PV和PVC

```bash
# Linux
kubectl get pvc -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete pvc {} -n "${REDSTONE_NAMESPACE}"

kubectl get pv -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete pv {} 
```


## 意外处理😯

1. 没有使用Helm卸载资源，而是直接将项目的命名空间删除。将会导致一些全局资源无法卸载。可以使用下面方式手动删除。

```bash
kubectl get clusterrole -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete clusterrole {} -n "${REDSTONE_NAMESPACE}"

kubectl get clusterrolebinding -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete clusterrolebinding {} -n "${REDSTONE_NAMESPACE}"
```

2. 一些helm hook因为设置了删除策略，只有在release成功部署之后才会删除。如果在release安装期间将release卸载，将会导致这些hook无法卸载。可以使用下面指令将这些资源删除。

```bash
kubectl get jobs -n "${REDSTONE_NAMESPACE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete jobs -n "${REDSTONE_NAMESPACE}" {}
```
