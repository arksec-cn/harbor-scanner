# 雅客云Harbor镜像扫描平台

## 产品介绍

[北京雅客云安全科技有限公司](https://www.arksec.cn/)是由硅谷领先网络安全公司资深技术专家、以色列领先网络安全公司高管团队成立的以基于云原生安全产品和服务为主的技术驱动型高新技术企业。

[雅客云Harbor镜像扫描平台]是雅客云安全推出的面向Harbor仓库中的镜像扫描的安全产品，可以全面有效的扫描发现镜像中存在的各种安全漏洞。

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

## 权限使用说明

安装阶段，使用ClusterRole为cluster-admin的账户进行产品部署，目的是快速创建产品运行所需要的服务账户，简化部署逻辑。

运行阶段，我们会为各服务绑定独立的服务账户，遵循权限最小化原则，为这些账户单独授权。

查看更为详细的ServiceAccount所使用的权限

```bash
# MacOS
helm template . --output-dir=/tmp | sort | uniq | grep "sa" | awk '{print $2}'  | xargs -n1 -I L cat "L"

# Linux
helm template . --output-dir=/tmp | sort | uniq | grep "sa" | awk '{print $2}'  | xargs -i cat {}
```

## 开始安装🚀

* 设置一次环境变量，在后续的操作中，都有可能使用这些变量。

```bash
export REDSTONE_CHART="arksec"
export REDSTONE_RELEASE="himalaya"
export REDSTONE_NAMESPACE="vegeta"
export REDSTONE_VERSION="v202010815"
export REDSTONE_APISERVER_EXTERNALURL="https://host-10-10-10-10:6443"
```

* 研发DEV环境安装

```bash
kubectl create ns "${REDSTONE_NAMESPACE}"

helm install "${REDSTONE_RELEASE}" -n "${REDSTONE_NAMESPACE}" ./ \
--set global.imageProject=himalaya/dev \
--set global.imageTag=latest \
--set global.publicImageProject=public/dev \
--set global.publicImageTag=latest \
--set global.imagePullPolicy=Always \
--set global.isDev=true \
--set global.meta.apiServer="${REDSTONE_APISERVER_EXTERNALURL}"
```

* Openshift环境安装

1. 需要对所有服务账户进行特权模式许可，权限的临时解决方案。

```bash
oc adm policy add-scc-to-user privileged -n default -z "default"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "default"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-base"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-backend"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-webhook"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-webhook-patch"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-network-controller"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-network-manager"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-ruleengine-controller"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-task-creator"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-task-master"
oc adm policy add-scc-to-user privileged -n "${REDSTONE_NAMESPACE}" -z "${REDSTONE_RELEASE}-${REDSTONE_CHART}-cluster-task-creator-alice"
```

2. 安装产品。因为目前两个环境还没有可用storageClass, 所以使用内置hostPath类型的PVC持久化数据。

```bash
oc new-project "${REDSTONE_NAMESPACE}"

helm install "${REDSTONE_RELEASE}" -n "${REDSTONE_NAMESPACE}" ./ \
--set global.kubePlatform=openshift \
--set global.imageProject=himalaya/dev \
--set global.imageTag=latest \
--set global.publicImageProject=public/dev \
--set global.publicImageTag=latest \
--set global.imagePullPolicy=Always \
--set global.isDev=true \
--set global.meta.apiServer="${REDSTONE_APISERVER_EXTERNALURL}" \
--set persistence.enabled=true \
--set persistence.type=hostPath
```

* 离线交付环境安装

1. ToB最重要一点是离线环境的安装，在容器场景下可以理解为是容器镜像的传输。使用[pack-x](https://gitlab.arksec.cn/az/pack-x)工具快速的将安装镜像同步至客户的镜像仓库。

2. 安装产品，需要设置正确的仓库用户名密码。

```bash
kubectl create ns "${REDSTONE_NAMESPACE}"

helm install "${REDSTONE_RELEASE}" -n "${REDSTONE_NAMESPACE}" ./ \
--set global.imageRegistry=registry.example.com \
--set global.imageRegistryUsername=admin \
--set global.imageRegistryPassword=Harbor12345 \
--set global.imageProject=himalaya/release \
--set global.imageTag="${REDSTONE_VERSION}" \
--set global.publicImageProject=public/release \
--set global.publicImageTag="${REDSTONE_VERSION}" \
--set global.isDev=false \
--set global.meta.apiServer="${REDSTONE_APISERVER_EXTERNALURL}" \
--set global.imagePullPolicy=IfNotPresent 
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

# MacOS
kubectl get pvc -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -n1 -I L kubectl delete pvc  -n "${REDSTONE_NAMESPACE}" "L"

kubectl get pv -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -n1 -I L kubectl delete pv "L"
```


## 意外处理😯

1. 没有使用Helm卸载资源，而是直接将项目的命名空间删除。将会导致一些全局资源无法卸载。可以使用下面方式手动删除。

```bash
kubectl get clusterrole -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete clusterrole {} -n "${REDSTONE_NAMESPACE}"

kubectl get clusterrolebinding -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete clusterrolebinding {} -n "${REDSTONE_NAMESPACE}"

kubectl get mutatingwebhookconfiguration -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete mutatingwebhookconfiguration {} -n "${REDSTONE_NAMESPACE}"

kubectl get validatingwebhookconfiguration -n "${REDSTONE_NAMESPACE}" -l app.kubernetes.io/name="${REDSTONE_CHART}" -l app.kubernetes.io/instance="${REDSTONE_RELEASE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete validatingwebhookconfiguration {} -n "${REDSTONE_NAMESPACE}"
```

2. 一些helm hook因为设置了删除策略，只有在release成功部署之后才会删除。如果在release安装期间将release卸载，将会导致这些hook无法卸载。可以使用下面指令将这些资源删除。

```bash
kubectl get jobs -n "${REDSTONE_NAMESPACE}" -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs -i kubectl delete jobs -n "${REDSTONE_NAMESPACE}" {}
```

## 打包和解包

1. 打包成Helm标准包

```bash
helm package . 

helm push arksec-2.0.1.tgz http://chartmuseus:5000/chartrepo
```

2. 打包成OCI镜像

```bash
export HELM_EXPERIMENTAL_OCI=1
helm chart save ./ registry.arksec.cn/himalaya/dev/helm-chart:v2.0.1
helm chart push registry.arksec.cn/himalaya/dev/helm-chart:v2.0.1
```

3. 从OCI镜像恢复

```bash
export HELM_EXPERIMENTAL_OCI=1
helm chart pull registry.arksec.cn/yitong.bai/helm-chart/arksec:v2.0.1
helm chart export registry.arksec.cn/yitong.bai/helm-chart/arksec:v2.0.1
```

