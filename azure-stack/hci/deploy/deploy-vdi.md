---
title: Deploy virtual desktop infrastructure (VDI) on Azure Stack HCI
description: This topic provides guidance on how to plan, configure, and deploy virtual desktop infrastructure (VDI) on the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 1/05/2021
---

# Deploy virtual desktop infrastructure (VDI) on Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2

This topic provides guidance on how to plan, configure, and deploy virtual desktop infrastructure (VDI) on the Azure Stack HCI operating system. Leverage your Azure Stack HCI investment to deliver centralized, highly available, simplified, and secure management for the users in your organization. Use this guidance to enable scenarios like bring-your-own-device (BYOD) for your users, while providing them with a consistent and reliable experience for business-critical applications without sacrificing security.

## Overview
VDI uses server hardware to run desktop operating systems and software programs on a virtual machine (VM). In this way, VDI lets you run traditional desktop workloads on centralized servers. VDI advantages in a business setting include keeping sensitive company applications and data in a secure datacenter, and accommodating a BYOD policy without worrying about mixing personal data with corporate assets.

These advantages reduce liability when corporate assets are lost, and when sensitive data is exposed to potential corporate espionage and hackers. VDI has also become the standard to support remote and branch office workers and provide access to contractors and partners.

Azure Stack HCI offers the optimal platform for VDI. A validated HCI solution combined with Microsoft [Remote Desktop Services (RDS)](/windows-server/remote/remote-desktop-services/welcome-to-rds) lets you achieve a highly available and highly scalable architecture.

In addition, Azure Stack HCI VDI solutions provide the following unique cloud-based capabilities to protect VDI workloads and clients:
- Centrally managed updates using Azure Update Management
- Unified security management and advanced threat protection for VDI clients

## Deploy VDI
This section describes at a high level how to acquire hardware to deploy VDI on Azure Stack HCI and use Windows Admin Center for management. It also covers deploying RDS to support VDI.

### Step 1: Acquire hardware for VDI on Azure Stack HCI
Refer to your specific hardware instructions for this step. For more information, reference your preferred Microsoft hardware partner in the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net).

You use Windows Admin Center to [create an Azure Stack HCI cluster](./create-cluster.md) on an integrated system that has the operating system preinstalled from a variety of vendors in the catalog. For more information, see [Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci).

Otherwise, you'll need to deploy the operating system on your hardware. For details on Azure Stack HCI deployment options and installing Windows Admin Center, see [Deploy the Azure Stack HCI operating system](./operating-system.md).

   >[!NOTE]
   > In the catalog, you can filter to see vendor hardware that is optimized for this workload.

### Step 2: Set up Azure Update Management in Windows Admin Center
TBD


### Step 3: Deploy Remote Desktop Services (RDS) for VDI support
TBD



## Next steps
For more information related to VDI, see:
- [Windows Virtual Desktop pricing](https://azure.microsoft.com/pricing/details/virtual-desktop)
- [Supported configurations for Remote Desktop Services](/windows-server/remote/remote-desktop-services/rds-supported-config)
