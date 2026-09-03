---
title: Supported Kubernetes versions in Azure Operator Nexus Kubernetes service
description: Learn the Kubernetes version support policy and lifecycle of clusters in Azure Operator Nexus Kubernetes service
ms.topic: feature-availability
ms.date: 07/10/2026
author: eak13
ms.author: ekarandjeff
ms.service: azure-operator-nexus
---

# Supported Kubernetes versions in Azure Operator Nexus Kubernetes service

This article provides an overview of the versioning schema used for the Operator Nexus Kubernetes service, including the supported Kubernetes versions. It explains the differences between major, minor, and patch versions, and provides guidance on upgrading Kubernetes versions and what to expect from the upgrade experience. It also covers the version support lifecycle, including end of support for each version bundle. Features, previously known as add-ons, are software components included in each version bundle. [Components version and breaking changes](#components-version-and-breaking-changes) articulates the feature versions included in the version bundles. For more in-depth information about features, see [Nexus Kubernetes Cluster Features](./concepts-nexus-kubernetes-cluster.md#nexus-kubernetes-cluster-features).

The Kubernetes community releases minor versions roughly every three months. The support window for a given version is one year. 

Minor version releases might include new capabilities and improvements. Patch releases are more frequent (sometimes weekly) and are intended for critical bug fixes within a minor version. Patch releases include fixes for security vulnerabilities or major bugs.

## Kubernetes versions

Kubernetes uses the standard [Semantic Versioning](https://semver.org/) versioning scheme for each version:

```bash
[major].[minor].[patch]

Examples:
 1.24.7
 1.25.4
```

Each number in the version indicates general compatibility with the previous version:

- **Major version numbers** change when breaking changes to the API might be introduced.
- **Minor version numbers** change when functionality updates are made that are backwards compatible to the other minor releases.
- **Patch version numbers** change when backwards-compatible bug fixes are made.

Stay up to date with the latest available patches. For example, if your production cluster is on **`1.25.4`**, and **`1.25.6`** is the latest available patch version for the _1.25_ series, upgrade to **`1.25.6`** as soon as possible to ensure your cluster is fully patched and supported. For more information, see [Upgrading Kubernetes versions](./howto-kubernetes-cluster-upgrade.md).

## Nexus Kubernetes release calendar

View the upcoming version releases on the Nexus Kubernetes release calendar.

> [!NOTE]
> Read more about [our support policy for Kubernetes versioning](#kubernetes-version-support-policy).

For the past release history, see [Kubernetes history](https://github.com/kubernetes/kubernetes/releases).

> [!TIP]
> To programmatically retrieve the live Kubernetes Versions catalog for a specific Nexus Cluster, including each bundle's general availability, end of support, end of extended availability dates, packaged components, and upgrade paths, see [List supported Kubernetes versions for Azure Operator Nexus](./howto-list-supported-kubernetes-versions.md).

[!INCLUDE [supported-versions](./includes/kubernetes-cluster/supported-versions.md)]

## Nexus Kubernetes service version components

An Operator Nexus Kubernetes service version consists of two discrete components that combine into a single representation:

- The Kubernetes version. For example, 1.25.4, is the version of Kubernetes that you deploy in Operator Nexus. Azure AKS supplies these packages, including all patch versions that Operator Nexus supports. For more information on Azure AKS versions, see [AKS Supported Kubernetes Versions](/azure/aks/supported-kubernetes-versions).
- A [Version Bundle](#version-bundles) number that encapsulates the Kubernetes version, features, and operating system (OS) image used by nodes in the Operator Nexus Kubernetes cluster, as a single number. For example, `2`.

The API represents the combination of these values as the single `kubernetesVersion`. For example, `1.25.4-2` or the alternatively supported `v` notation: `v1.25.4-2`.


### Version bundles

A version bundle is a secondary value added to the Kubernetes version. Version bundles account for cases where the Kubernetes version is unchanged, but the operating system and/or features are updated with a Nexus release. Such updates might include, but aren't limited to, updated operating system images, patch releases for features, and the introduction of new platform features.

Before April 2025, version bundle numbers incremented starting from `1`. The numbers varied depending on how long a particular Kubernetes patch version was available on Nexus. After April 2025, all version bundles in the same release use the same release identifier, such as `-4.4.0` or `-4.5.0`.

Version bundles help you plan and manage the process of upgrading your Kubernetes clusters offered by the Operator Nexus Kubernetes service.

All Nexus cluster upgrades follow the standard Kubernetes versions skew policy. In some cases, you might need more than one upgrade to bring a cluster to the desired Kubernetes version. You can skip over any version bundle release, but you can't downgrade to a previous version bundle series.

You should only apply changes to the configuration of a deployed Operator Nexus Kubernetes cluster within a Kubernetes minor version upgrade, not during a patch version upgrade. Examples of configuration changes that you can apply during the minor version upgrade include:

- Changing the configuration of the kube-proxy from using the iptables to ipvs.
- Changing the container networking interface (CNI) from one product to another.

### Choosing a version bundle for an upgrade scenario

Operator Nexus enables you to upgrade from any patch version in one Kubernetes minor version to any patch version in the next Kubernetes minor version, so you have flexibility. For example, you can upgrade from `1.31.1-x.x.x` to `1.32.x-x.x.x` regardless of whether an intermediate `1.31.2-x.x.x` version exists.

When Microsoft releases new version bundles, all the Kubernetes patch versions in that version bundle release use the same versions of both OS and Features. Only the Kubernetes code differs between them. Here are a few examples of upgrade routes that might be desirable:

#### Kubernetes version update

To patch or update the Kubernetes minor version, select an available Kubernetes version from the same version bundle series. For example, if `1.32.1-4.4.0` is your current version bundle, and `1.33.1-4.4.0` is the latest `1.33.x` version bundle, select `1.33.1-4.4.0`.

#### OS and component version update

To patch or update OS or platform components while maintaining the same Kubernetes version, select a version bundle within the same Kubernetes minor version as your cluster, but with a later release number. For example, if `1.32.1-4.4.0` is your current version bundle, and `1.32.1-4.5.0` is the latest `1.32.1` version bundle, choose the `1.32.1-4.5.0` bundle.

#### Kubernetes, OS, and component version update

To patch or update Kubernetes version, OS version, and platform components together, select the latest release version for the subsequent Kubernetes minor version. For example, if `1.32.1-4.4.0` is your current version bundle and the latest version bundle for the subsequent Kubernetes minor version is `1.33.2-4.5.0`, select `1.33.2-4.5.0` to upgrade all components.

In the first two cases, you might need to accept an updated Kubernetes version or component version if a version bundle containing the desired upgrades isn't released. In this case, any subsequent Kubernetes minor version works, but the version bundle with the latest release version is the most up-to-date and secure version of that Kubernetes minor version. Choose the latest release version for a given version bundle.

### Components version and breaking changes

Before upgrading to any of the available minor versions, review the following important changes:

- The `azure-arc-k8sagents` version refers to the version of this feature shipped with the version bundle. The Arc-enabled Kubernetes agent is set to auto upgrade to the latest version of the agent whenever it's available.
- Starting with 4.6.0, the `ipam-cni-plugin` version reflects the internal app version (4.6.0-32) versus the chart version (1.0.10). For 4.6.0, both versions are shown for transition's sake.
- When a high-risk or known breaking change exists, the system automatically blocks certain upgrade paths. Examples include double-jumps across CoreDNS versions, which only support n-1 to n upgrades, and the etcd upgrade issue described in the following caution. In such cases, you must first upgrade to an intermediate version bundle before you can upgrade to the latest version bundle. Ensure that your upgrade path decisions are valid and don't rely solely on the available upgrades presented in the CLI or API.
- Higher jumps across version bundles introduce more risk to the upgrade process. Upgrade your cluster frequently to stay up to date with the latest Kubernetes versions, OS images, and feature versions for the best experience with Nexus Kubernetes.

<!-- prettier-ignore-start -->
> [!CAUTION]
> **Don't upgrade a Nexus Kubernetes version bundle from version 4.3.0 or earlier to a version bundle that is 4.6.0 or later without first upgrading to version bundle 4.4.0 or 4.5.0.** An external etcd bug affects upgrades from etcd version v3.5 to v3.6. There's a high likelihood that a Nexus Kubernetes v4.3.0 or earlier upgrade to v4.6.0 or later fails due to this etcd issue. For more information, see [How to Prevent a Common Failure when Upgrading etcd v3.5 to v3.6](https://etcd.io/blog/2025/upgrade_from_3.5_to_3.6_issue/).
>
> To mitigate this potential upgrade issue, perform a two-step upgrade. First, upgrade the cluster to a version bundle that is produced in either the 4.4 or 4.5 release. Then, upgrade to a new version bundle from either 4.6 or 4.7. Here's a simplified summary of the recommended upgrade path:
> :::image type="content" source="media/nexus-kubernetes/etcd-upgrade-issue-generic.png" alt-text="Flow diagram providing a general overview of the Nexus Kubernetes upgrade process addressing the etcd issue.":::
>
> For example, you have a cluster that is currently on version bundle v1.30.8-4.3.0 and want to upgrade to a Kubernetes version available in the 4.7 release (v1.31 for n+1). You must first upgrade the cluster to version bundle v1.31.10-4.5.0. Then, you can perform a subsequent upgrade to version bundle v1.31.12-4.7.0. The upgrade path in this scenario is:
> :::image type="content" source="media/nexus-kubernetes/etcd-upgrade-issue-specific.png" alt-text="Flow diagram of a specific Nexus Kubernetes version bundle upgrade addressing the etcd issue.":::
<!-- prettier-ignore-end -->

#### Current version bundle information

Starting with 4.8.0, the reference table lists both the application version and the chart version for features that have both. The format is `app version/chart version`. This update enables mapping chart versions to application versions. You might see the features' chart versions in the output of the Nexus Kubernetes create and update commands. External links to features' release notes are based on application version where available.

`azure-arc-k8sagent` is an exception. The chart manifest has the versions flipped so the application version appears in the chart version and vice versa. For consistency purposes, the reference table reflects the versions where they should be displayed.

If a feature has the same value for both application and chart versions, it indicates the chart version is the only available version.

`OS Image`, `coredns image`, `etcd image`, `kube-vip image`, and `pause image` just have the image version identifier.

To assist with readability, the latest five version bundles are included in the current version section. Older versions are listed in the [Older version bundle information section](#older-version-bundle-information).

<!-- prettier-ignore-start -->
| Kubernetes Version | Release Identifier | OS Image | azure-arc-k8sagents | azure-arc-servers | calico | cloud-provider-kubevirt | coredns image | csi-nfs | csi-volume | etcd image | ipam-cni-plugin | kube-vip image | metallb | metrics-server | multus | node-local-dns | pause image | sriov-dp |
|---|---|---|----|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| v1.31.14<br>v1.31.100<br>v1.32.10<br>v1.32.11<br>v1.33.11<br>v1.33.12<br>v1.34.7<br>v1.34.8<br>v1.35.4<br>v1.35.5<br>v1.36.0<br>v1.36.1<br> | 4.12.0 | [Azure Linux 3.0.20260602](https://github.com/microsoft/azurelinux/releases/tag/3.0.20260602-3.0) | [1.34.2](/azure/azure-arc/kubernetes/release-notes)/1.0 | v1.2.9/v1.2.9 | [v3.30.7](https://github.com/projectcalico/calico/releases/tag/v3.30.7)/v1.9.3 | 0.5.1-4.3.0.20260616/v1.0.10 | [v1.13.2-15](https://github.com/coredns/coredns/releases/tag/v1.13.2) | [v4.13.3](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.13.3)/10.4.0-59 | 10.4.0-59/10.4.0-59 | [v3.6.7-8](https://github.com/etcd-io/etcd/releases/tag/v3.6.7) | 10.0.0-17/v1.0.18 | [v1.0.0-11](https://github.com/kube-vip/kube-vip/releases/tag/v1.0.0) | [v0.14.9-10](https://github.com/metallb/metallb/releases/tag/v0.14.9)/v1.3.7 | [v0.8.0-15](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.8.0)/v1.0.10 | [4.2.4](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/4.2.4)/v2.0.0 | [1.26.0-13](https://github.com/kubernetes/dns/releases/tag/1.26.0)/v1.2.7 | 3.10.1-3 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0)/v1.1.12 |
| v1.30.100<br>v1.30.14<br>v1.31.100<br>v1.31.14<br>v1.32.10<br>v1.32.11<br>v1.33.10<br>v1.33.11<br>v1.34.6<br>v1.34.7<br> | 4.11.0 | [Azure Linux 3.0.20260304](https://github.com/microsoft/azurelinux/releases/tag/3.0.20260304-3.0) | [1.33.0](/azure/azure-arc/kubernetes/release-notes)/1.0 | v1.2.8/v1.2.8 | [v3.30.7](https://github.com/projectcalico/calico/releases/tag/v3.30.7)/v1.9.2 | 0.5.1-3.3.0.20260506/v1.0.9 | [v1.13.2-9](https://github.com/coredns/coredns/releases/tag/v1.13.2) | [v4.13.2](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.13.2)/10.3.0-62 | 10.3.0-62/10.3.0-62 | [v3.6.7-4](https://github.com/etcd-io/etcd/releases/tag/v3.6.7) | 10.0.0-15/v1.0.17 | [v1.0.0-7](https://github.com/kube-vip/kube-vip/releases/tag/v1.0.0) | [v0.14.9-6](https://github.com/metallb/metallb/releases/tag/v0.14.9)/v1.3.6 | [v0.8.0-8](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.8.0)/v1.0.9 | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2)/v1.4.8 | [1.26.0-10](https://github.com/kubernetes/dns/releases/tag/1.26.0)/v1.2.6 | 3.10.1-3 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0)/v1.1.11 |
| v1.30.100<br>v1.30.14<br>v1.31.100<br>v1.31.14<br>v1.32.10<br>v1.32.11<br>v1.33.7<br>v1.33.8<br> | 4.10.0 | [Azure Linux 3.0.20260304](https://github.com/microsoft/azurelinux/releases/tag/3.0.20260304-3.0) | [1.32.7](/azure/azure-arc/kubernetes/release-notes)/1.0 | v1.2.6/v1.2.6 | [v3.30.6](https://github.com/projectcalico/calico/releases/tag/v3.30.6)/v1.9.1 | 0.5.1-1.3.0.20250702/v1.0.8 | [v1.12.1-11](https://github.com/coredns/coredns/releases/tag/v1.12.1) | [v4.13.1](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.13.1)/10.2.0-76 | 10.2.0-76/10.2.0-76 | [v3.6.7-3](https://github.com/etcd-io/etcd/releases/tag/v3.6.7) | 10.0.0-11/v1.0.15 | [v1.0.0-6](https://github.com/kube-vip/kube-vip/releases/tag/v1.0.0) | [v0.14.9-6](https://github.com/metallb/metallb/releases/tag/v0.14.9)/v1.3.6 | [v0.8.0-8](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.8.0)/v1.0.9 | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2)/v1.4.6 | [1.26.0-9](https://github.com/kubernetes/dns/releases/tag/1.26.0)/v1.2.5 | 3.10.1-3 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0)/v1.1.10 |
| v1.30.100<br>v1.30.14<br>v1.31.13<br>v1.31.14<br>v1.32.10<br>v1.33.6<br>v1.33.7<br> | 4.9.0 | [Azure Linux 3.0.20250910](https://github.com/microsoft/azurelinux/releases/tag/3.0.20250910-3.0) | [1.31.7](/azure/azure-arc/kubernetes/release-notes)/1.0 | v1.2.6/v1.2.6 | [v3.30.2](https://github.com/projectcalico/calico/releases/tag/v3.30.2)/v1.9.0 | 0.5.1-1.3.0.20250702/v1.0.8 | [v1.12.1-9](https://github.com/coredns/coredns/releases/tag/v1.12.1) | [v4.12.1](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.12.1)/10.0.0-10 | 10.0.0-10/10.0.0-10 | [v3.6.3-5](https://github.com/etcd-io/etcd/releases/tag/v3.6.3) | 10.0.0-4/v1.0.13 | [v1.0.0-4](https://github.com/kube-vip/kube-vip/releases/tag/v1.0.0) | [v0.14.9-5](https://github.com/metallb/metallb/releases/tag/v0.14.9)/v1.3.5 | [v0.8.0-5](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.8.0)/v1.0.8 | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2)/v1.4.6 | [1.26.0-6](https://github.com/kubernetes/dns/releases/tag/1.26.0)/v1.2.4 | 3.10.1-3 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0)/v1.1.10 |
| v1.30.13<br>v1.30.14<br>v1.31.12<br>v1.31.13<br>v1.32.8<br>v1.32.9<br>v1.33.4<br>v1.33.5<br> | 4.8.0 | [Azure Linux 3.0.20250910](https://github.com/microsoft/azurelinux/releases/tag/3.0.20250910-3.0) | [1.30.1](/azure/azure-arc/kubernetes/release-notes)/1.0 | v1.2.5/v1.2.5 | [v3.29.2](https://github.com/projectcalico/calico/releases/tag/v3.29.2)/v1.8.0 | 0.5.1-1.3.0.20250702/v1.0.8 | [v1.12.1-4](https://github.com/coredns/coredns/releases/tag/v1.12.1) | [v4.12.1](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.12.1)/4.8.0-26 | 4.8.0-26/4.8.0-26 | [v3.6.3-2](https://github.com/etcd-io/etcd/releases/tag/v3.6.3) | 4.8.0-143/v1.0.12 | [v1.0.0-2](https://github.com/kube-vip/kube-vip/releases/tag/v1.0.0) | [v0.14.9-3](https://github.com/metallb/metallb/releases/tag/v0.14.9)/v1.3.4 | [v0.8.0-2](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.8.0)/v1.0.7 | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2)/v1.4.5 | [1.26.0-3](https://github.com/kubernetes/dns/releases/tag/1.26.0)/v1.2.3 | 3.10-5 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0)/v1.1.8 |
<!-- prettier-ignore-end -->

> [!IMPORTANT]
> Version 1.30 LTS support ended on July 31, 2026. Users should upgrade their Nexus Kubernetes clusters to a later version bundle. Ideally, upgrade clusters to the latest Kubernetes version which ensures new features and security updates are available.

#### Older version bundle information

<!-- prettier-ignore-start -->
| Kubernetes Version | Release Identifier | OS Image | azure-arc-k8sagents | azure-arc-servers | calico | cloud-provider-kubevirt | coredns image | csi-nfs | csi-volume | etcd image | ipam-cni-plugin | kube-vip image | metallb | metrics-server | multus | node-local-dns | pause image | sriov-dp |
|---|---|---|----|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| v1.30.13<br>v1.30.14<br>v1.31.11<br>v1.31.12<br>v1.32.7<br>v1.32.8<br>v1.33.3<br>v1.33.4<br> | 4.7.0 | [Azure Linux 3.0.20250729](https://github.com/microsoft/azurelinux/releases/tag/3.0.20250729-3.0) | [1.29.3](/azure/azure-arc/kubernetes/release-notes)/1.0 | v1.2.4/v1.2.4 | [v3.29.2](https://github.com/projectcalico/calico/releases/tag/v3.29.2)/v1.8.0 | 0.5.1-1.3.0.20250602/v1.0.7 | [v1.11.4-4](https://github.com/coredns/coredns/releases/tag/v1.11.4) | [v4.11.0](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.11.0)/4.7.0-30 | 4.7.0-30/4.7.0-30 | [v3.6.3-1](https://github.com/etcd-io/etcd/releases/tag/v3.6.3) | 4.7.0-141/v1.0.11 | [v0.9.2-2](https://github.com/kube-vip/kube-vip/releases/tag/v0.9.2) | [v0.14.9-2](https://github.com/metallb/metallb/releases/tag/v0.14.9)/v1.3.3 | [v0.8.0-1](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.8.0)/v1.0.6 | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2)/v1.4.4 | [1.26.0-2](https://github.com/kubernetes/dns/releases/tag/1.26.0)/v1.2.2 | 3.10-4 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0)/v1.1.7 |
| v1.33.2<br>v1.33.1<br>v1.32.6<br>v1.32.5<br>v1.31.10<br>v1.31.9<br>v1.30.14<br>v1.30.13<br> | 4.6.0 | [Azure Linux 3.0.20250702-3.0](https://github.com/microsoft/azurelinux/releases/tag/3.0.20250702-3.0) | [1.28.0](/azure/azure-arc/kubernetes/release-notes) | v1.2.3 | [v3.29.2](https://github.com/projectcalico/calico/releases/tag/v3.29.2) | 1.0.7 | [v1.10.1-1](https://github.com/coredns/coredns/releases/tag/v1.10.1) | [v4.11.0](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.11.0) | 4.6.0-32 | [v3.6.3-1](https://github.com/etcd-io/etcd/releases/tag/v3.6.3) | 1.0.10/4.6.0-32 | [v0.9.2-2](https://github.com/kube-vip/kube-vip/releases/tag/v0.9.2) | [v0.14.9-1](https://github.com/metallb/metallb/releases/tag/v0.14.9) | [v0.7.2-7](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.7.2) | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2) | [1.26.0-1](https://github.com/kubernetes/dns/releases/tag/1.26.0) | 3.10-4 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0) |
| v1.33.2<br>v1.33.1<br>v1.32.6<br>v1.32.5<br>v1.31.10<br>v1.31.9<br>v1.30.14<br>v1.30.13<br> | 4.5.0 | [Azure Linux 3.0.20250702-3.0](https://github.com/microsoft/azurelinux/releases/tag/3.0.20250702-3.0) | 1.27.0 | v1.2.2 | [v3.29.2](https://github.com/projectcalico/calico/releases/tag/v3.29.2) | 1.0.7 | v1.10.1-1 | [v4.11.0](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.11.0) | 4.5.0-48 | v3.5.21-2 | v1.0.9 | v0.8.9 | v0.14.9-1 | [v0.7.2-7](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.7.2) | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2) | 1.26.0-1 | 3.10-3 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0) |
| v1.32.4<br>v1.32.1<br>v1.31.8<br>v1.31.7<br>v1.30.12<br>v1.30.9<br> | 4.4.0 | [Azure Linux 3.0.20250429-3.0](https://github.com/microsoft/azurelinux/releases/tag/3.0.20250429-3.0) | 1.26.0 | v1.2.1 | [v3.29.2](https://github.com/projectcalico/calico/releases/tag/v3.29.2) | 1.0.6 | v1.10.1-1 | [v4.11.0](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.11.0) | 4.4.0-49 | v3.5.21-1 | v1.0.8 | v0.8.9 | v0.14.9-1 | [v0.7.2](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.7.2) | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2) | 1.25.0-2 | 3.10-3 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0) |
| v1.32.1<br>v1.31.5<br>v1.31.4<br>v1.30.9<br>v1.30.8<br>v1.29.13<br>v1.29.12 | 4.3.0 | v1.30.x and newer: [Azure Linux 3.0.20250311-3.0](https://github.com/microsoft/azurelinux/releases/tag/3.0.20250311-3.0)<br>1.29.x and older: [Azure Linux 2.0.20250304-2.0](https://github.com/microsoft/azurelinux/releases/tag/2.0.20250304-2.0) | 1.24.4 | v1.2.0 | [v3.29.2](https://github.com/projectcalico/calico/releases/tag/v3.29.2) | 1.0.5 | v1.9.4-4 | [v4.11.0](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.11.0) | 4.3.0-45 | v3.5.15-1 | v1.0.7 | v0.8.5 | v0.14.5-9 | [v0.7.2](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.7.2) | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2) | 1.23.1-1 | 3.1 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0) |
| v1.31.4<br>v1.31.3<br>v1.30.8<br>v1.30.7<br>v1.29.12<br>v1.29.11 | 4.2.0 | v1.30.x and newer: [Azure Linux 3.0.20250206-3.0](https://github.com/microsoft/azurelinux/releases/tag/3.0.20250206-3.0)<br>1.29.x and older: [Azure Linux 2.0.20250207-2.0](https://github.com/microsoft/azurelinux/releases/tag/2.0.20250207-2.0) | 1.23.3 | v1.1.0 | [v3.29.1](https://github.com/projectcalico/calico/releases/tag/v3.29.1) | v1.0.4 | v1.9.4-4 | [v4.10.0](https://github.com/kubernetes-csi/csi-driver-nfs/releases/tag/v4.10.0) | v1.0.13 | v3.5.15-1 | v1.0.5 | v0.8.5 | v0.14.5-7 | [v0.7.2](https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.7.2) | [v4.0.2](https://github.com/k8snetworkplumbingwg/multus-cni/releases/tag/v4.0.2) | 1.23.1-1 | 3.1 | [v3.7.0](https://github.com/k8snetworkplumbingwg/sriov-network-device-plugin/releases/tag/v3.7.0) |
<!-- prettier-ignore-end -->

### Version bundle features

<!-- prettier-ignore-start -->
| Feature      | Version Bundle |
|--------------------|----------------|
| Volume orchestration connectivity is TLS encrypted | Beginning from 1.28.9-1, 1.28.0-5, 1.27.9-1, 1.27.3-5, 1.26.12-1, 1.26.6-5, 1.25.11-5, and 1.25.6-7 |
| Cluster nodes are Azure Arc-enabled | Beginning from 1.25.6-4, 1.25.11-2, 1.26.3-4, 1.26.6-2, 1.27.1-4, 1.27.3-2, and 1.28.0-2 |
| nexus-shared volumes have their capacity attribute enforced as a volume size limit | Beginning from v1.27.13-3, v1.27.9-5, v1.28.11-4, v1.28.12-3, v1.29.6-4, v1.29.7-3, v1.30.3-1 |
<!-- prettier-ignore-end -->

## Upgrading Kubernetes versions

For more information about upgrading your cluster, see [Upgrade an Azure Operator Nexus Kubernetes Service cluster](./howto-kubernetes-cluster-upgrade.md).

## Kubernetes version support policy

Operator Nexus supports three minor versions of Kubernetes:

- The latest GA minor version released in Operator Nexus (which is _N_).
- Two previous minor versions.
- Each supported minor version also supports up to two latest stable patches while the previous patches are under [extended availability policy](#extended-availability-policy) for the lifetime of the minor version.

Operator Nexus Kubernetes service provides a standardized duration of support for each minor version of Kubernetes that it releases. Versions adhere to two different timelines, reflecting:

- Duration of support – How long a version is actively maintained. At the end of the supported period, the version is considered `End of Support`.
- Extended availability – How long a version can be selected for deployment after `End of Support`.

The supported window of Kubernetes versions on Operator Nexus is known as `N-2`: (N (Latest release) - 2 (minor versions)), and `.letter` represents patch versions.

For example, if Operator Nexus introduces _1.17.a_ today, it supports the following versions:

| New minor version | Supported Version List                         |
| ----------------- | ---------------------------------------------- |
| 1.17.a            | 1.17.a, 1.17.b, 1.16.c, 1.16.d, 1.15.e, 1.15.f |

When Operator Nexus introduces a new minor version, the oldest supported minor version and patch releases go out of support. For example, the current supported version list is:

```text
1.17.a
1.17.b
1.16.c
1.16.d
1.15.e
1.15.f
```

When Operator Nexus releases 1.18.\*, all the 1.15.\* versions go out of support.

### Support timeline

Operator Nexus Kubernetes service typically provides support for 12 months from the initial AKS GA release of a minor version. This timeline follows the timing of Azure AKS, which includes a declared Long-Term Support version 1.27.

Supported versions:

- You can deploy them as new Operator Nexus Kubernetes clusters.
- You can upgrade to them from prior versions, limited by normal upgrade paths.
- They might include extra patches or Version Bundles within the minor version.

> [!NOTE]
> In exceptional circumstances, Microsoft might terminate Nexus Kubernetes service support early or immediately if it identifies a vulnerability or security concern. If this situation occurs, Microsoft proactively notifies customers and works to mitigate any potential issues.

### End of support

`End of Support` means Microsoft no longer produces patches or version bundles. You might not be able to upgrade the cluster because the latest supported versions are no longer available. In this event, the only way to upgrade is to completely recreate the Nexus Kubernetes cluster by using the newer version that is supported. To return to a supported version, you might be able to use unsupported upgrades through `Extended availability`.

## Extended availability policy

During the extended availability period for unsupported Kubernetes versions, users don't receive security patches or bug fixes. For detailed information on support categories, see the following table.

| Support category                           | N-2 to N  | Extended availability |
| ------------------------------------------ | --------- | --------------------- |
| Upgrades from N-3 to a supported version   | Supported | Supported             |
| Node pool scaling                          | Supported | Supported             |
| Cluster or node pool creation              | Supported | Supported             |
| Kubernetes components (including Features) | Supported | Not supported         |
| Component updates                          | Supported | Not supported         |
| Component hotfixes                         | Supported | Not supported         |
| Applying Kubernetes bug fixes              | Supported | Not supported         |
| Applying Kubernetes security patches       | Supported | Not supported         |
| Node image security patches                | Supported | Not supported         |

> [!NOTE]
> Operator Nexus relies on the releases and patches from [Kubernetes](https://kubernetes.io/releases/), which is an open-source project that only supports a sliding window of three minor versions. Operator Nexus can only guarantee [full support](#kubernetes-version-support-policy) while those versions are being serviced upstream. Since the Kubernetes project doesn't produce more patches for unsupported versions, Operator Nexus can either leave those versions unpatched or fork. Due to this limitation, extended availability doesn't support anything that relies on Kubernetes upstream.

### Abandoned Nexus Kubernetes clusters

After the end of the extended availability period, the K8s version is removed from Nexus. At this point, any existing Nexus Kubernetes clusters that are based on this K8s version become abandoned. The only supported operation on abandoned clusters is deletion. Importantly, once a cluster is abandoned, upgrading to a later K8s version isn't possible.

## Supported `kubectl` versions

You can use a `kubectl` version that's one minor version older or newer than your _kube-apiserver_ version, consistent with the [Kubernetes support policy for kubectl](https://kubernetes.io/docs/setup/release/version-skew-policy/#kubectl).

For example, if your _kube-apiserver_ is at _1.17_, you can use `kubectl` versions _1.16_ to _1.18_ with that _kube-apiserver_.

To install or update `kubectl` to the latest version, run:

### [Azure CLI](#tab/azure-cli)

```azurecli
az aks install-cli
```

### [Azure PowerShell](#tab/azure-powershell)

```powershell
Install-AzAksKubectl -Version latest
```

---

## Long Term Support (LTS)

The Kubernetes community releases a new minor version approximately every four months. Each version has a support window of one year. In Azure Kubernetes Service (AKS), this support window is called "Community support."

AKS supports versions of Kubernetes that are within this Community support window. This support ensures that AKS receives bug fixes and security updates from community releases.

This release cadence delivers the latest Kubernetes features and up-to-date security. However, it might be challenging to stay current based on the number of clusters you need to maintain.

### Support types

After approximately one year, the Kubernetes version exits Community support and your AKS clusters are now at risk as bug fixes and security updates become unavailable.

AKS provides one year Community support and one year of long-term support (LTS) to back port security fixes from the community upstream in our public repository. Our upstream LTS working group contributes efforts back to the community to provide our customers with a longer support window.

LTS provides an extended period of time to plan and test upgrades over a two-year period from the General Availability of a Kubernetes version.

<!-- prettier-ignore-start -->
|  | Community Support | Long Term Support |
|--|--|--|
| **When to use** | When you can keep up with upstream Kubernetes releases | Scenarios where your applications aren't compatible with the changes introduced in newer Kubernetes versions, and you can't transition to a continuous release cycle due to technical constraints or other factors |
| **Support versions** | Three-GA minor versions | One Kubernetes version for two years |
<!-- prettier-ignore-end -->

> [!IMPORTANT]
> Kubernetes version 1.27 is the first supported LTS version of Kubernetes on Operator Nexus Kubernetes service.
> The next LTS version after 1.27 is 1.30, which starts its LTS support in October 2024.
> From Kubernetes version 1.30 forward, all Nexus Kubernetes versions are LTS-compatible.

### Migrate from LTS to the next LTS release

Nexus Kubernetes clusters don't support direct upgrades between LTS versions. To transition from one LTS version to the next, you have two options:

- Create a new cluster with the desired LTS version and move your workloads to this new cluster.
- Perform a series of intermediate upgrades through the supported versions before reaching the next LTS version.

## FAQ

### How does Microsoft notify me of new Kubernetes versions?

Microsoft updates this article periodically with planned dates for new Kubernetes versions.

### How often should I expect to upgrade Kubernetes versions to stay in support?

Starting with Kubernetes 1.19, the [open source community expanded support to one year](https://kubernetes.io/blog/2020/08/31/kubernetes-1-19-feature-one-year-support/). Operator Nexus commits to enabling patches and support that match the upstream commitments. For Operator Nexus clusters on 1.19 and greater, you need to upgrade at least once a year to stay on a supported version.

### What happens when you upgrade a Kubernetes cluster to a minor version that isn't supported?

If you're on the _N-3_ version or older, you're outside of the support window. When you upgrade from version N-3 to N-2, you're back within the support window. For example:

- If the oldest supported AKS version is _1.25.x_ and you're on _1.24.x_ or older, you're outside of support.
- Successfully upgrading from _1.24.x_ to _1.25.x_ or higher brings you back within the support window.
- "Skip-level upgrades" aren't supported. To upgrade from _1.23.x_ to _1.25.x_, you must upgrade first to _1.24.x_ and then to _1.25.x_.

Downgrades aren't supported.

### What happens if I don't upgrade my cluster?

If you don't upgrade your cluster, you continue to receive support for the Kubernetes version you're running until the end of the support period. After that, you no longer receive support for your cluster. You need to upgrade your cluster to a supported version to continue receiving support.

### What happens if I don't upgrade my cluster before the end of the Extended availability period?

If you don't upgrade your cluster before the end of the Extended availability period, you can no longer upgrade your cluster to a supported version or scale-out agent pools. You need to recreate your cluster by using a supported version to continue receiving support.

### What does "Outside of Support" mean?

"Outside of Support" means that:

- The version you're running is outside of the supported versions list.
- You're asked to upgrade the cluster to a supported version when requesting support.

Additionally, Operator Nexus doesn't make any runtime or other guarantees for clusters that aren't on the supported versions list.

### What happens when a user scales a Kubernetes cluster with a minor version that isn't supported?

For minor versions that Operator Nexus doesn't support, scaling in or out should continue to work. Since there are no guarantees with quality of service, upgrade to bring your cluster back into support.

### Can I skip multiple Kubernetes versions during cluster upgrade?

When you upgrade a supported Operator Nexus Kubernetes cluster, you can't skip Kubernetes minor versions. Kubernetes control planes [version skew policy](https://kubernetes.io/releases/version-skew-policy/) doesn't support minor version skipping. For example, upgrades between:

- _1.12.x_ -> _1.13.x_: allowed.
- _1.13.x_ -> _1.14.x_: allowed.
- _1.12.x_ -> _1.14.x_: not allowed.

To upgrade from _1.12.x_ -> _1.14.x_:

1. Upgrade from _1.12.x_ -> _1.13.x_.
1. Upgrade from _1.13.x_ -> _1.14.x_.

### Can I create a new cluster during its extended availability window?

Yes, you can create a new 1.xx.x cluster during its extended availability window. However, create a new cluster by using the latest supported version.

### Can I upgrade a cluster to a newer version during its extended availability window?

Yes, you can upgrade an N-3 cluster to N-2 during its extended availability window. If your cluster is currently on N-4, use the extended availability to first upgrade from N-4 to N-3. After the N-3 upgrade finishes, proceed with the upgrade to a supported version (N-2).

### I'm on an extended availability window, can I still add new node pools or must I upgrade?

Yes, you can add node pools to the cluster.
