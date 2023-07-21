# 雅客云Harbor镜像扫描平台

简体中文 | [English](README.md)

## 产品介绍

[北京雅客云安全科技有限公司](https://www.arksec.cn/)是由硅谷领先网络安全公司资深技术专家、以色列领先网络安全公司高管团队成立的以基于云原生安全产品和服务为主的技术驱动型高新技术企业。

[`雅客云Harbor镜像扫描平台`]是雅客云安全推出的面向Harbor仓库中的镜像进行扫描的安全产品，可以全面有效的扫描发现镜像中存在的各种安全漏洞。

## 注意事项

该项目已迁移至 [GitHub - arkseclabs/harbor-scanner.](https://github.com/arkseclabs/harbor-scanner)

### 推荐使用 kubectl 安装

```console
$ kubectl create namespace arksec-system
$ kubectl apply --filename https://raw.githubusercontent.com/arksec-cn/harbor-scanner/main/all-in-one.yaml --namespace arksec-system
```
