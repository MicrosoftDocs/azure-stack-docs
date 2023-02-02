---
title: AKS Edge Essentials System Requirements 
description: Requirements and supported version 
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 01/26/2023
ms.custom: template-concept
---

# AKS Edge Essentials requirements and support matrix

The following are the requirements on the host machine that runs AKS Edge Essentials:

## Hardware requirements

  | Specs | Local cluster | Arc-connected cluster and GitOps|
  | ---------- | --------- |--------- |
  | Host OS | Windows 10/11 IoT Enterprise/Enterprise/Pro and Windows Server 2019, 2022||
  | Total physical memory | 4 GB with at least 2 GB free | 8 GB with at least 4 GB free  |
  | CPU | 2 vCPUs, clock speed at least 1.8 GHz |4 vCPUs, clock speed at least 1.8 GHz|
  | Disk space | At least 14 GB free |At least 14 GB free |

To better understand the concept of vCPUs, [read this article](https://social.technet.microsoft.com/wiki/contents/articles/1234.hyper-v-concepts-vcpu-virtual-processor-q-a.aspx).

### OS requirements

Install Windows 10/11 IoT Enterprise/Enterprise/Pro on your machine and activate Windows. We recommend using the latest [client version 22H2 (OS build 19045)](/windows/release-health/release-information) or [Server 2022 (OS build 20348)](/windows/release-health/windows-server-release-info). You can [download a version of Windows 10 here](https://www.microsoft.com/software-download/windows10) or [Windows 11 here](https://www.microsoft.com/software-download/windows11).

## Maximum hardware specifications supported

| Parameter | Permissible limit |
  | ---------- | --------- |
  | Maximum number of VMs per machine  | 1 Linux VM + 1 Windows VM (optional) |
  | Maximum number of vCPUs per machine  | 16 vCPUs |
  | Maximum number of machines per cluster | 15 machines |

## Feature support matrix

||General Availability(GA)   |Experimental|
|------------|-----------|--------|
|Kubernetes (K8S)|Version : 1.24.3| - |
|Kubernetes (K3S)|Version : 1.24.3| - |
|Network plugin | Calico on K8S <br/> Flannel on K3S | Flannel on K8S <br/> Calico on K3S|
|Configuration| * Single machine Kubernetes<br/> * Full Kubernetes (on single machine)|Full Kubernetes (on multiple machines)

## Next steps

- [Set up your machine](./aks-edge-howto-setup-machine.md)
