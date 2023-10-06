---
title: AKS Edge Essentials system requirements 
description: Requirements and supported versions for AKS Edge Essentials. 
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 10/05/2023
ms.custom: template-concept
---

# AKS Edge Essentials requirements and support matrix

This article describes the requirements for the host machine that runs AKS Edge Essentials:

## Hardware requirements

  | Specs | Local cluster | Arc-connected cluster and GitOps|
  | ---------- | --------- |--------- |
  | Host OS | Windows 10/11 IoT Enterprise/Enterprise/Pro and Windows Server 2019, 2022||
  | Total physical memory | 4 GB with at least 2.5 GB free | 8 GB with at least 4.5 GB free  |
  | CPU | 2 vCPUs, clock speed at least 1.8 GHz |4 vCPUs, clock speed at least 1.8 GHz|
  | Disk space | At least 14 GB free |At least 14 GB free |

To better understand the concept of vCPUs, [see this article](https://social.technet.microsoft.com/wiki/contents/articles/1234.hyper-v-concepts-vcpu-virtual-processor-q-a.aspx).

You can run AKS Edge Essentials in an Azure VM. You can create a Windows VM with either Windows 10/11 IoT Enterprise/Enterprise/Pro and Windows Server 2019, 2022 SKU, on a VM image that supports nested virtualization such as the [Dv5 and Dsv5-series](/azure/virtual-machines/dv5-dsv5-series) virtual machines.

> [!CAUTION]
> Running AKS Edge Essentials on a virtual machine, using nested virtualization is an experimental feature and is recommended only for developer use cases.  

### OS requirements

Install Windows 10/11 IoT Enterprise/Enterprise/Pro on your machine and activate Windows. We recommend using the latest [client version 22H2 (OS build 19045)](/windows/release-health/release-information) or [Server 2022 (OS build 20348)](/windows/release-health/windows-server-release-info). You can [download a version of Windows 10 here](https://www.microsoft.com/software-download/windows10) or [Windows 11 here](https://www.microsoft.com/software-download/windows11).

## Maximum hardware specifications supported

| Parameter | Permissible limit |
  | ---------- | --------- |
  | Maximum number of VMs per machine  | 1 Linux VM + 1 Windows VM (optional) |
  | Maximum number of vCPUs assigned to virtual machines  | 16 vCPUs |
  | Maximum number of machines per cluster | 15 machines |

## GA feature support matrix

- **Infrastructure**: Install AKS Edge Essentials on physical host machines.
- **Kubernetes Distribution supported**: Kubernetes (K8S) - Version: 1.24.3 and on Kubernetes (K3S) - Version: 1.24.3
- **Deployment options**: Single-machine clusters and full Kubernetes deployment on single machines only. Full deployment across multiple machines isn't supported in GA.
- **Workloads**: Only Linux worker nodes.
- **Network plugins**: Calico on K8S and Flannel on K3S.

## Experimental or prerelease features

- **Infrastructure**: Installing AKS Edge Essentials on a virtual machine using nested virtualization is experimental.
- **Deployment options**: Full Kubernetes deployment on multiple machines.
- **Workloads**: Windows worker nodes.
- **Network plugins**: Flannel on K8S and Calico on K3S.

## Next steps

- [Set up your machine](./aks-edge-howto-setup-machine.md)
