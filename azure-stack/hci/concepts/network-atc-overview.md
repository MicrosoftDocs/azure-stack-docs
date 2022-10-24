---
title: Network ATC overview 
description: This topic introduces Network ATC for Azure Stack HCI.
author: dcuomo
ms.topic: how-to
ms.date: 04/22/2022
ms.author: jgerend 
ms.reviewer: JasonGerend
---

# Network ATC overview 

> Applies to: Azure Stack HCI, version 21H2 and later

Deployment and operation of Azure Stack HCI networking can be a complex and error-prone process. Due to the configuration flexibility provided with the host networking stack, there are many moving parts that can be easily misconfigured or overlooked. Staying up to date with the latest best practices is also a challenge as improvements are continuously made to the underlying technologies. Additionally, configuration consistency across HCI cluster nodes is important as it leads to a more reliable experience.

Network ATC can help:

- Reduce host networking deployment time, complexity, and errors
- Deploy the latest Microsoft validated and supported best practices
- Ensure configuration consistency across the cluster
- Eliminate configuration drift

## Definitions

Here is some new terminology:

**Intent**: An intent is a definition of how you intend to use the physical adapters in your system. An intent has a friendly name, identifies one or more physical adapters, and includes one or more intent types.

An individual physical adapter can only be included in one intent. By default, an adapter does not have an intent (there is no special status or property given to adapters that don't have an intent). You can have multiple intents; the number of intents you have will be limited by the number of adapters in your system.

**Intent type**: Every intent requires one or more intent types. The currently supported intent types are:

- Management - adapters are used for management access to nodes
- Compute - adapters are used to connect virtual machine (VM) traffic to the physical network
- Storage - adapters are used for SMB traffic including Storage Spaces Direct
- Stretch - adapters are set up in a similar manner as a storage intent with the exception of RDMA not used for stretch adapters. 

Any combination of the intent types can be specified for any specific single intent. However, certain intent types can only be specified in one intent:

- Management: Can be defined in a maximum of one intent
- Compute: Unlimited
- Storage: Can be defined in a maximum of one intent
- Stretch: Can be defined in a maximum of one intent

**Override**: By default, Network ATC deploys the most common configuration, asking for the smallest amount of user input. Overrides allow you to customize your deployment if required. For example, you may choose to modify the VLANs used for storage adapters from the defaults.

Network ATC allows you to modify all configuration that the OS allows. However, the OS limits some modifications to the OS and Network ATC respects these limitations. For example, a virtual switch does not allow modification of SR-IOV after it has been deployed.

## Next steps

- Review Network ATC defaults and example deployment options. See [Deploy host networking with Network ATC](../deploy/network-atc.md).
- Configure Network ATC using PowerShell. See [Step 4: Configure host networking](../deploy/create-cluster-powershell.md#step-4-configure-host-networking).
- Manage Network ATC after deployment. See [Manage host networking using Network ATC](../manage/manage-network-atc.md).
