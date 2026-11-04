---
title: Overview of Small Form Factor Deployments of Azure Local (preview)
description: Learn about small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 10/19/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# What are small form factor deployments of Azure Local (preview)?

Small form factor deployments let you run Azure Local on compact, Linux-based hardware designed for physical AI use cases. IoT and Physical AI solutions often span thousands of geographically distributed locations. These environments can have limited connectivity, varied hardware, and complex lifecycle management requirements. Small form factor deployments help address these challenges by providing a consistent, Azure-managed platform for running applications at the edge.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

[!INCLUDE [workload-availability-note](../includes/workload-availability-note.md)]

## About small form factor deployments

With small form factor deployments, you can:

- Deploy and manage edge infrastructure through Azure with a cloud-like experience.
- Run containerized workloads by using Docker, which is included in the base image.
- Run Kubernetes workloads by using AKS or the open-source K3s distribution.
- Support AI and IoT workloads on distributed devices.
- Standardize infrastructure across geographically distributed edge environments.

Small form factor deployments are optimized for single-node and small-scale scenarios. They work well for retail locations, manufacturing sites, and other edge environments where traditional datacenter hardware isn't practical.

## Benefits

Small form factor deployments help you:

- Simplify provisioning and management of AI Inference workloads in physical AI scenarios.
- Use a right-sized infrastructure footprint in environments with limited space, power, or cooling.
- Reduce operational overhead by standardizing infrastructure across large device fleets.
- Better handle edge-specific challenges such as intermittent connectivity, limited bandwidth, and longer update cycles.

## Features

The following table describes the key features of small form factor deployments.

| Feature | Description |
| --------------------------------- | ----------------------------------------------- |
| Zero-touch provisioning (ZTP)     | Deploy consistent software across large fleets of devices by using a secure, FDO-compliant supply chain.   |
| Arc gateway URL management        | Provide cloud-native applications with a predictable set of URLs by using a built-in HTTP tunnel to Azure. |
| Secure, signed OS kernel          | Run a host operating system built with signed Microsoft packages and security updates.                     |
| K3s and Docker                   | Run container workloads using quick, simple tools.                                                        |
| Azure Kubernetes Service (AKS)    | Deploy and run a managed AKS cluster on your provisioned device.                                           |
| Foundry Local                    | Run AI inference on-premises on any silicon accelerators.                                                     |
| Azure IoT Operations (AIO)       | Manage and aggregate data from cameras, controllers, and other real-world devices.                         |

## Supported devices

Azure Local small form factor deployments are validated on the following devices:

- [ASUS NUC 14 Pro](https://www.asus.com/displays-desktops/nucs/nuc-mini-pcs/asus-nuc-14-pro/)
- [ASUS NUC 15 Pro](https://www.asus.com/displays-desktops/nucs/nuc-mini-pcs/asus-nuc-15-pro/)
- [Lenovo ThinkEdge SE30](https://www.lenovo.com/us/en/p/desktops/thinkedge/thinkedge-se30/len102c0004?orgRef=https%253A%252F%252Fwww.bing.com%252F)
- [Lenovo ThinkEdge SE100](https://www.lenovo.com/us/en/p/servers-storage/servers/edge/thinkedge-se100/len21te0020?orgRef=https%253A%252F%252Fwww.bing.com%252F&clickid=whp0Rqw5BxyZT-5wqgy1oyjRUkuWSZV3z3IU3U0&irgwc=1&afsrc=1&PID=2003851&acid=ww:affiliate:bv0as6&cid=us:affiliate:cxsaam)
- [NVIDIA Jetson Thor Developer Kit](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-thor/) (minimum required [Jetson UEFI Firmware: v39.2.x](https://docs.nvidia.com/jetson/agx-thor-devkit/user-guide/latest/twa_uefi_iso_compatibility.html))
- [OnLogic HX521](https://www.onlogic.com/store/hx521-azurelocal/)
- [OnLogic K521](https://www.onlogic.com/store/k521-azurelocal/)

> [!IMPORTANT]
> Use one of the supported devices listed here. Other hardware might work, but validation, documentation, and troubleshooting guidance for the preview apply only to these devices.

## Next steps

- [Prepare to deploy Azure Local on small form factor devices](small-form-factor-prepare-to-deploy.md).
