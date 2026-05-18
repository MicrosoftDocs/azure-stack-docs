---
title: Overview of Small Form Factor Deployments of Azure Local (preview)
description: Learn about small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# What are small form factor deployments of Azure Local (preview)?

Small form factor deployments let you run Azure Local on compact, Linux-based hardware designed for edge and distributed environments. Edge and IoT solutions often span thousands of geographically distributed devices. These environments can have limited connectivity, varied hardware, and complex lifecycle management requirements. Small form factor deployments help address these challenges by providing a consistent, Azure-managed platform for running applications at the edge.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About small form factor deployments

With small form factor deployments, you can:

- Deploy and manage edge infrastructure through Azure with a cloud-like experience.
- Run containerized workloads by using Docker, which is included in the base image.
- Run Kubernetes workloads by using the open-source K3s distribution.
- Support AI and IoT workloads on distributed devices.
- Standardize infrastructure across large-scale, geographically distributed environments.

Small form factor deployments are optimized for single-node and small-scale scenarios. They work well for retail locations, manufacturing sites, and other edge environments where traditional datacenter hardware isn't practical.

## Benefits

Small form factor deployments help you:

- Use a right-sized infrastructure footprint in environments with limited space, power, or cooling.
- Deploy on validated devices that are tested for compatibility and reliability.
- Reduce operational overhead by standardizing infrastructure across large device fleets.
- Better handle edge-specific challenges such as intermittent connectivity, limited bandwidth, and longer update cycles.

## Features

| Feature | Description |
| --------------------------------- | ----------------------------------------------- |
| Zero-touch provisioning (ZTP)     | Deploy consistent software across large fleets of devices by using a secure, FDO-compliant supply chain.   |
| Arc gateway URL management        | Provide cloud-native applications with a predictable set of URLs by using a built-in HTTP tunnel to Azure. |
| Secure, signed OS kernel          | Run a host operating system built with signed Microsoft packages and security updates.                     |
| Docker included in the base image | Start running containerized workloads without installing a separate container runtime.                     |
| Open-source K3s support           | Install and run a lightweight, upstream Kubernetes distribution on a provisioned device.                   |
| Validated IoT applications        | Run Azure IoT Operations and Foundry Local with configurations validated by Microsoft for each release.    |

## Supported devices

Azure Local small form factor deployments are validated on the following devices:

- ASUS NUC 14 Pro
- ASUS NUC 15 Pro
- Lenovo ThinkEdge SE30
- Lenovo ThinkEdge SE100
- OnLogic HX521

> [!IMPORTANT]
> We recommend using one of the supported devices listed here. Other hardware might work, but validation, documentation, and troubleshooting guidance for the preview apply only to these devices.

## Next steps

- [Set up your Azure subscription](small-form-factor-subscription-setup.md)