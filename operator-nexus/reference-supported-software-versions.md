---
title: Supported software versions in Azure Operator Nexus 
description: Learn about supported software versions in Azure Operator Nexus. 
ms.topic: article
ms.date: 11/15/2025
author: scottsteinbrueck
ms.author: ssteinbrueck
ms.service: azure-operator-nexus
---

# Supported Kubernetes versions in Azure Operator Nexus

This document provides the list of software versioning supported as of Release 2511.2 of Azure Operator Nexus.
Please note that this list is subject to change as new software versions are released and validated. Nexus supports only the software versions listed in this document, which is up to N-2 versions from the latest validated version.

## Supported software versions

### Arista firmware

| Firmware release          | MD5 checksum(s)                                                                      | Supported Nexus runtime                       |
|---------------------------|--------------------------------------------------------------------------------------|-----------------------------------------------|
| EOS-4.33.1F               | 32-bit: 92bd63991108dbfb6f8ef3d2c15e9028<br>64-bit: 108401f80963ebbf764d4fd1a6273a52 | 5.0.0/5.0.1                                   |
| EOS-4.34.1F               | 32-bit: ffaf9bf536d35ccab538de358c5e0a75<br>64-bit: b7b8984d4d35de2545862d8cdd34d1f0 | 6.0.0/6.1.0                                   |

> [!Note]
> Management Switches (Arista devices) support only 32bit OS images and all other devices support only 64 bits OS images.

### Instance cluster AKS and Azure Linux stacks

| Stack release | Components |
|---------------|------------|
| NC 4.1.6        | Instance cluster AKS: 1.30.x)<br>Azure Linux (Mariner): 3.0.20250102 |
| NC 4.4.3        | Instance cluster AKS: 1.31.x)<br>Azure Linux (Mariner): 3.0.20250702 |
| NC 4.4.4        | Instance cluster AKS: 1.31.x)<br>Azure Linux (Mariner): 3.0.20250729 |
| NC 4.7.5        | Instance cluster AKS: 1.32.x)<br>Azure Linux (Mariner): 3.0.20250910 |

### Purity versions

| Product | Supported versions |
|---------|--------------------|
| Purity  | 6.5.1, 6.5.4, 6.5.6, 6.5.8, 6.5.10, 6.5.11 |


### Supported K8S versions
Versioning schema used for the Operator Nexus Kubernetes service, including the supported Kubernetes versions, are listed at [Supported Kubernetes versions in Azure Operator Nexus Kubernetes service](./reference-nexus-kubernetes-cluster-supported-versions.md).
