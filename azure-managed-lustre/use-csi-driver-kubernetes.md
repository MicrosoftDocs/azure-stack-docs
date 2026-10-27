---
title: Use the Azure Managed Lustre CSI Driver with Azure Kubernetes Service
description: Learn how to use an Azure Managed Lustre storage system with your Kubernetes containers in Azure Kubernetes Service (AKS).
ms.topic: overview
ms.date: 10/23/2026
author: pauljewellmsft
ms.author: akashdubey
ms.reviewer: brianl
ms.custom: sfi-image-nochange

# Intent: As an IT pro, I want to be able to use a Lustre file system with the apps I've deployed on Kubernetes.
# Keyword: 

---

# Use the Azure Managed Lustre CSI driver with Azure Kubernetes Service

By using the [Azure Lustre CSI Driver for Kubernetes](https://github.com/kubernetes-sigs/azurelustre-csi-driver), you can use [Azure Managed Lustre](/azure/azure-managed-lustre) as persistent storage for workloads running in [Azure Kubernetes Service (AKS)](/azure/aks/). This driver is based on the Container Storage Interface (CSI) specification.

## Supported Kubernetes and AKS versions

The Azure Lustre CSI Driver for Kubernetes is compatible with [AKS](/azure/aks/). Other Kubernetes installations aren't currently supported.

Version 0.6.0 requires Kubernetes 1.29 or later because the node plugin uses a native sidecar container.

> [!IMPORTANT]
> Version 0.6.0 provides images for Ubuntu 22.04 (`Ubuntu2204`), Ubuntu 24.04 (`Ubuntu2404`), and Azure Linux 3 (`AzureLinux3`) node pools. The Jammy DaemonSet also targets Ubuntu 20.04 (`Ubuntu2004`) Confidential VM node pools as a deprecated compatibility path. Windows node pools aren't supported.

The Azure Lustre CSI Driver for Kubernetes is compatible with [Azure Managed Lustre](/azure/azure-managed-lustre). Other Lustre installations aren't currently supported.

### Azure Lustre CSI Driver versions

These articles document the v0.6.0 release. Use a versioned release instead of the `main` branch for production deployments.

Version 0.6.0 uses separate node images for Ubuntu 22.04 (Jammy), Ubuntu 24.04 (Noble), and Azure Linux 3. Both the Helm chart and script installer deploy all three node DaemonSets. Kubernetes schedules the appropriate driver pod by using the `kubernetes.azure.com/os-sku-effective` node label. Jammy and Azure Linux 3 node images support amd64; Noble supports amd64 and arm64.

The controller uses the Noble image, which supports amd64 and arm64.

| Driver version | Image | AKS node OS SKU | Supported k8s version | Lustre client version | Dynamic Provisioning |
|----------------|-------|-----------------|-----------------------|-----------------------|----------------------|
| v0.6.0 (Jammy) | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.6.0-jammy | `Ubuntu2204`; `Ubuntu2004` Confidential VM node pools | 1.29+ | 2.15.8 | ✅ |
| v0.6.0 (Noble) | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.6.0-noble | `Ubuntu2404` | 1.29+ | 2.17.0 | ✅ |
| v0.6.0 (Azure Linux 3) | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.6.0-azurelinux3 | `AzureLinux3` | 1.29+ | 2.17.0 | ✅ |
| v0.4.0 (Jammy) | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.4.0-jammy | `Ubuntu2204`; `Ubuntu2004` Confidential VM node pools | 1.21+ | 2.15.7 | ✅ |
| v0.4.0 (Noble) | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.4.0-noble | `Ubuntu2404` | 1.21+ | 2.16.1 | ✅ |
| v0.3.1 | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.3.1 | Ubuntu Linux | 1.21+ | 2.15.7 | ✅ |
| v0.3.0 | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.3.0 | Ubuntu Linux | 1.21+ | 2.15.5 | ✅ |
| v0.2.0 | mcr.microsoft.com/oss/v2/kubernetes-csi/azurelustre-csi:v0.2.0 | Ubuntu Linux | 1.21+ | 2.15.5 | ❌ |
| v0.1.18 | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.18 | Ubuntu Linux | 1.21+ | 2.15.5 | ❌ |
| v0.1.17 | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.17 | Ubuntu Linux | 1.21+ | 2.15.5 | ❌ |
| v0.1.15 | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.15 | Ubuntu Linux | 1.21+ | 2.15.4 | ❌ |
| v0.1.14 | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.14 | Ubuntu Linux | 1.21+ | 2.15.3 | ❌ |
| v0.1.13 | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.13 | Ubuntu Linux | 1.21+ | 2.15.4 | ❌ |
| v0.1.12 | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.12 | Ubuntu Linux | 1.21+ | 2.15.3 | ❌ |
| v0.1.11 | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.11 | Ubuntu Linux | 1.21+ | 2.15.1 | ❌ |
| v0.1.10 | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.10 | Ubuntu Linux | 1.21+ | 2.15.2 | ❌ |

For a complete list of all driver releases and their changelog, see the [Azure Lustre CSI driver releases page](https://github.com/kubernetes-sigs/azurelustre-csi-driver/releases).

> [!NOTE]
> Version 0.6.0 requires AKS node pools that report the `kubernetes.azure.com/os-sku-effective` label, in addition to the Kubernetes version requirement shown in the table.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A terminal environment with the Azure CLI tools installed. See [Get started with the Azure CLI](/cli/azure/get-started-with-azure-cli).
- [kubectl](https://kubernetes.io/docs/reference/kubectl), the Kubernetes management tool, installed in your terminal environment. See [Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster by using the Azure CLI](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster).
- `cluster-admin` permissions to install or replace the driver and its cluster-scoped resources.
- [Helm 3](https://helm.sh/docs/intro/install/), version 3.8.0 or later, for the recommended Helm installation method.
- Bash and `curl` for the script installation method; `git` for the script uninstall procedure.
- An AKS cluster that meets the [compatibility requirements](#supported-kubernetes-and-aks-versions).
- For static provisioning, an existing Azure Managed Lustre deployment. Dynamic provisioning creates the file system. See the [Azure Managed Lustre documentation](/azure/azure-managed-lustre).
- **Network connectivity** between your AKS cluster and Azure Managed Lustre virtual network. See [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md) for configuration options.
- Sufficient subnet IP addresses and the inbound and outbound access described in [Azure Managed Lustre network prerequisites](amlfs-prerequisites.md#network-prerequisites). New private subnets need an explicit outbound connection, such as a NAT gateway.
- Access from the installation machine to `mcr.microsoft.com` for Helm, or `raw.githubusercontent.com` for the script; access to `github.com` for the uninstall script's source checkout. AKS nodes need access to MCR, `packages.microsoft.com`, and their node image's OS package repositories.
- Appropriate nodes for the controller deployment, plus eligible nodes for your Lustre workloads. For custom-tainted nodes, see the [node pool guidance](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/install-csi-driver.md#node-pool-taints-and-tolerations).

## Provisioning methods

The Azure Lustre CSI Driver supports two provisioning methods:

### Dynamic provisioning (available in v0.3.0+)

Dynamic provisioning allows the CSI driver to automatically create Azure Managed Lustre file systems on demand when persistent volume claims are created.

> [!NOTE]
> Dynamic provisioning is available starting with Azure Lustre CSI Driver version 0.3.0. For more information, see the [v0.3.0 release notes](https://github.com/kubernetes-sigs/azurelustre-csi-driver/releases/tag/v0.3.0).

For full step-by-step instructions, see [Use dynamic provisioning with the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-dynamic-provisioning.md).

### Static provisioning

Static provisioning uses an existing Azure Managed Lustre file system. This method involves:
- Creating storage classes that reference existing Lustre clusters
- Specifying the Lustre MGS IP address
- Suitable for scenarios where you have preexisting Lustre infrastructure

For full step-by-step instructions, see [Use static provisioning with the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-static-provisioning.md).

## Install the CSI driver

Install the driver once for either provisioning method. For shared cluster preparation, Helm or script installation, and readiness checks, see [Install the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-install.md).

## Upgrade the CSI driver

For maintenance planning, workload and mount preflight checks, installation, verification, and recovery, see [Upgrade or uninstall the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-upgrade.md).

## Uninstall the driver

Stop every workload that uses Lustre and confirm that no Lustre mounts remain before removing the driver. For the Helm and script uninstall procedures, see [Uninstall the driver](use-container-storage-interface-driver-upgrade.md#uninstall-the-driver).

## Troubleshooting

To troubleshoot issues with the Azure Lustre CSI Driver, see the [v0.6.0 CSI driver troubleshooting guide](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/csi-debug.md) in the GitHub repository.

Common issues include:

- **Network connectivity problems** - verify virtual network peering or subnet configuration between AKS and Azure Managed Lustre.
- **Incorrect configuration** - verify the MGS IP address in your storage class.
- **Pod scheduling issues** - verify that the node's effective OS SKU is `Ubuntu2204`, `Ubuntu2404`, `AzureLinux3`, or `Ubuntu2004` for a Confidential VM node pool. Check node architecture and taints too.
- **No v0.6.0 node pod on an AKS node** - verify that the `kubernetes.azure.com/os-sku-effective` label is present and matched by the Jammy, Noble, or Azure Linux 3 DaemonSet.
- **A DaemonSet has zero desired pods** - this condition is expected if no eligible nodes match that flavor. Confirm that every intended workload node has a CSI node pod.
- **Upgrade rollout timeout** - inspect the DaemonSet status, affected pod events, and both `lustre-loader` and `azurelustre` container logs before retrying.
- **Ready pods using an old Lustre client** - compare the loaded kernel module version with the expected version in [Verify the upgrade](use-container-storage-interface-driver-upgrade.md#verify-the-upgrade).
- **Helm ownership errors** - follow the [uninstall/reinstall procedure](use-container-storage-interface-driver-upgrade.md#install-v060) instead of installing over existing script-managed resources.
- **Image pull or Lustre client installation failures** - verify node egress to `mcr.microsoft.com` and `packages.microsoft.com`.
- **Permission issues during dynamic provisioning** - check the identity that the CSI controller uses against the [dynamic provisioning permission requirements](use-container-storage-interface-driver-dynamic-provisioning.md#permissions).

For provisioning-specific issues, see [Dynamic provisioning troubleshooting](use-container-storage-interface-driver-dynamic-provisioning.md#troubleshooting) or [Static provisioning troubleshooting](use-container-storage-interface-driver-static-provisioning.md#troubleshooting).

For additional troubleshooting resources, see:

- [Troubleshoot Azure Managed Lustre CSI driver extension errors](/troubleshoot/azure/azure-kubernetes/extensions/troubleshoot-azurelustre-csi-extension-errors)
- [Azure Managed Lustre troubleshooting](troubleshoot-deployment.md)
- [Azure Lustre CSI Driver GitHub repository](https://github.com/kubernetes-sigs/azurelustre-csi-driver)

## Related content

- [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md).
- [Install the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-install.md)
- [Use dynamic provisioning with the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-dynamic-provisioning.md)
- [Use static provisioning with the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-static-provisioning.md)
- [Upgrade or uninstall the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-upgrade.md)
- [Validate CSI driver image security](use-container-storage-interface-driver-image-security.md).
- [Export data from Azure Managed Lustre to Blob Storage](export-data.md)
- [Azure Lustre CSI Driver GitHub repository](https://github.com/kubernetes-sigs/azurelustre-csi-driver)
