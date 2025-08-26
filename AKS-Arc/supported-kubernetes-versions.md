---
title: Supported Kubernetes versions for AKS enabled by Azure Arc
description: Understand the Kubernetes version support policy and lifecycle of clusters for Azure Kubernetes Service enabled by Azure Arc.
services: container-service
ms.topic: article
ms.date: 07/17/2025
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 07/17/2025
ms.reviewer: rcheeran

# Intent: As an IT Pro, I want to know how Kubernetes versions are supported, as well as the lifecycle of clusters in AKS enabled by Azure Arc.
# Keyword: supported Kubernetes versions

---

# Supported Kubernetes versions in AKS Arc

This article describes the supported Kubernetes versions for Azure Kubernetes Service enabled by Azure Arc. AKS Arc releases new Kubernetes minor versions approximately every three months.

## Kubernetes versions

Kubernetes uses the standard [Semantic Versioning](https://semver.org/) versioning scheme for each version:

```output
[major].[minor].[patch]

Example:
  1.29.2
  1.29.5
```

Each number in the version indicates general compatibility with the previous version:

* **Major versions** change when incompatible API updates or backwards compatibility may be broken.
* **Minor versions** change when functionality updates are made that are backwards compatible to the other minor releases.
* **Patch versions** change when backwards-compatible bug fixes are made.

You should install the latest patch release of the minor version you're running. For example, if your production cluster is on **`1.29.2`**. **`1.29.5`** is the latest available patch version available for the **1.29** series, you should upgrade to **1.29.5** as soon as possible to ensure your Kubernetes cluster is fully patched and supported.

## AKS Arc Kubernetes release calendar

|  K8s minor version | Supported Azure Local versions | Current status | Last release with Kubernetes patch/CVE updates |
|--------------|-------------------|--------------|------------|
| 1.32 | 2510 (Tentative) | TBD | TBD |
| 1.31 | [2508](aks-whats-new-23h2.md#features-and-improvements) | Generally Available | TBD |
| 1.30 | [2508, 2507, 2503](aks-whats-new-23h2.md#features-and-improvements) | Generally Available | 2512 |
| 1.29 | [2508, 2507, 2503](aks-whats-new-23h2.md#features-and-improvements), [2411](aks-whats-new-23h2.md#features-and-improvements), [2408](aks-whats-new-23h2.md#release-2408) | Generally available | 2509 |
| 1.28 | [2507, 2503](aks-whats-new-23h2.md#features-and-improvements), [2411](aks-whats-new-23h2.md#features-and-improvements), [2408](aks-whats-new-23h2.md#release-2408), [2405](aks-whats-new-23h2.md#release-2405) | No more patch versions/CVE updates | 2507 release |
| 1.27 | [2411](aks-whats-new-23h2.md#features-and-improvements), [2408](aks-whats-new-23h2.md#release-2408), [2405](aks-whats-new-23h2.md#release-2405), 2402 | No more patch versions/CVE updates | 2411 release |
| 1.26 | [2405](aks-whats-new-23h2.md#release-2405), 2402 and older | No more patch versions/CVE updates | 2405 release |

> [!NOTE]
> Kubernetes version 1.32 is planned for the next Azure Local release  - 2510.
> Kubernetes version 1.29 will be no longer be supported after the 2509 release. 

### AKS Arc supported Kubernetes minor and patch versions per release

| Release             | Supported minor & patch versions                 |
|---------------------|--------------------------------------------------|
| 2508                | 1.29.12, 1.29.13, 1.30.8, 1.30.9, 1.31.4, 1.31.5 |
| 2507                | 1.28.12, 1.28.14, 1.29.7, 1.29.9, 1.30.3, 1.30.4 |
| 2503                | 1.28.12, 1.28.14, 1.29.7, 1.29.9, 1.30.3, 1.30.4 |
| 2411                | 1.27.7, 1.27.9, 1.28.5, 1.28.9, 1.29.2, 1.29.4   |
| 2408                | 1.27.7, 1.27.9, 1.28.5, 1.28.9, 1.29.2, 1.29.4   |
| 2405                | 1.26.10, 1.26.12, 1.27.7, 1.27.9, 1.28.3, 1.28.5 |

## Kubernetes version support policy

AKS Arc defines a generally available (GA) version as a version that's available for download when deploying or updating clusters.
AKS Arc supports three GA minor versions:

* The latest GA version (N).
* The two previous minor versions (N-1 and N-2).

For example, if AKS introduces **1.30** today, support is provided for the following versions:

| New minor version    |    Supported Version List |
| -----------------    |    ---------------------- |
| 1.30                 |    1.30, 1.29, 1.28       |

When a new minor version is introduced, the oldest minor version and patch releases supported are deprecated and removed. For example, the current supported version list is:

* 1.29
* 1.28
* 1.27

When AKS releases 1.30.\*, all the 1.27.\* versions are removed and go out of support in 30 days.

In addition to this policy, AKS Arc supports a maximum of two patch releases of a given minor version. Given the following supported versions:

```output
Current Supported Version List
------------------------------
1.29.8, 1.29.7, 1.28.10, 1.28.9
```

If AKS releases 1.29.9 and 1.28.11, the oldest patch versions are deprecated and removed, and the supported version list becomes:

```output
New Supported Version List
----------------------
1.29.*9*, 1.29.*8*, 1.28.*11*, 1.28.*10*
```

AKS Arc reserves the right to deprecate patches if a critical CVE or security vulnerability is detected. For awareness on patch availability and any ad-hoc deprecation, see the version release notes.  

AKS Arc might also support preview versions, which are explicitly labeled as previews.

> [!NOTE]
> If you're running an unsupported Kubernetes version, you are asked to upgrade when requesting support for the cluster. Clusters running unsupported Kubernetes releases are not covered by the [AKS Arc support policies](./support-policies.md).

### Supported `kubectl` versions

You can use one minor version older or newer of `kubectl` relative to your **kube-apiserver** version, consistent with the [Kubernetes support policy for kubectl](https://kubernetes.io/docs/setup/release/version-skew-policy/#kubectl).

For example, if your **kube-apiserver** is at 1.17, then you can use versions 1.16 to 1.18 of `kubectl` with that **kube-apiserver**.
To install or update your version of `kubectl`, run `az aks install-cli`.

## Release and deprecation process

For new minor versions of Kubernetes:

* AKS Arc publishes a pre-announcement with the planned date of a new version release and respective old version deprecation in the [AKS release notes](https://aka.ms/aks-hci-relnotes) at least 30 days prior to removal.
* Users have 30 days from version removal to upgrade to a supported minor version release to continue receiving support.

### Supported versions policy exceptions

AKS Arc reserves the right to add or remove new/existing versions with one or more critical production-impacting bugs or security issues without advance notice.

Specific patch releases may be skipped or rollout accelerated, depending on the severity of the bug or security issue.

## FAQ

### How does Microsoft notify me of new Kubernetes versions?

The AKS Arc team publishes pre-announcements with planned dates of new Kubernetes versions in the AKS Arc documentation.

### How often should I expect to upgrade Kubernetes versions to stay in support?

Starting with Kubernetes 1.19, the [open source community expanded support to one year](https://kubernetes.io/blog/2020/08/31/kubernetes-1-19-feature-one-year-support/). AKS Arc commits to enabling patches and support matching the upstream commitments. For Kubernetes clusters on 1.19 and greater, you'll be able to upgrade a minimum of once a year to stay on a supported version.

### What happens when a user upgrades a Kubernetes cluster with a minor version that isn't supported?

If you're on the n-3 version or older, it means you're outside of support and are asked to upgrade. When your upgrade from version n-3 to n-2 succeeds, you're back within our support policies. For example:

* If the oldest supported Kubernetes version is 1.27 and you are on 1.26 or older, you're outside of support.
* When you successfully upgrade from 1.26 to 1.27 or greater, you're back within the support window.

Downgrades are not supported.

### What does "outside of support" mean?

"Outside of support" means that:

* The version you're running is outside of the supported versions list.
* You'll be asked to upgrade the cluster to a supported version when requesting support, unless you're within the 30-day grace period after version deprecation.

Additionally, AKS Arc doesn't make any runtime (or other) guarantees for clusters outside of the supported versions list.

### What happens when I scale a Kubernetes cluster with a minor version that isn't supported?

For minor versions not supported by AKS Arc, scaling in or out should continue to work. Since there are no Quality of Service guarantees, we recommend upgrading to bring your cluster back into support.

### Can I skip multiple Kubernetes versions during a cluster upgrade?

When you upgrade a supported AKS cluster, Kubernetes minor versions can't be skipped. For example, upgrades between:

* **1.12.x** -> **1.13.x**: allowed.
* **1.13.x** -> **1.14.x**: allowed.
* **1.12.x** -> **1.14.x**: not allowed.

To upgrade from **1.12.x** -> **1.14.x**:

1. Upgrade from **1.12.x** -> **1.13.x**.
1. Upgrade from **1.13.x** -> **1.14.x**.

You can only skip multiple versions when upgrading from an unsupported version back into a supported version. For example, you can upgrade from an unsupported 1.10.x to a supported 1.15.x.

### Can I create a new 1.xx.x cluster during its 30-day support window?

No. Once a version is deprecated/removed, you cannot create a cluster with that version. As the change rolls out, you see the old version removed from your version list. This process can take up to two weeks from the announcement, progressively by region.

### I am on a freshly deprecated version. Can I still add new node pools, or do I have to upgrade?

No. You can't add node pools from the deprecated version to your cluster.

## Next steps

For information about how to upgrade your cluster, see [Update the Kubernetes version of AKS clusters](./cluster-upgrade.md).
