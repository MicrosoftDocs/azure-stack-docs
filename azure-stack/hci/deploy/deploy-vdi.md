---
title: Deploy virtual desktop infrastructure (VDI) on Azure Stack HCI
description: This topic provides guidance on how to plan, configure, and deploy virtual desktop infrastructure (VDI) on the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 01/15/2021
---

# Deploy virtual desktop infrastructure (VDI) on Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2

This topic provides guidance on how to plan, configure, and deploy virtual desktop infrastructure (VDI) on the Azure Stack HCI operating system. Leverage your Azure Stack HCI investment to deliver centralized, highly available, simplified, and secure management for the users in your organization. Use this guidance to enable scenarios like bring-your-own-device (BYOD) for your users, while providing them with a consistent and reliable experience for business-critical applications without sacrificing security.

## Overview
VDI uses server hardware to run desktop operating systems and software programs on a virtual machine (VM). In this way, VDI lets you run traditional desktop workloads on centralized servers. VDI advantages in a business setting include keeping sensitive company applications and data in a secure datacenter, and accommodating a BYOD policy without worrying about mixing personal data with corporate assets. VDI has also become the standard to support remote and branch office workers and provide access to contractors and partners.

Azure Stack HCI offers the optimal platform for VDI. A validated Azure Stack HCI solution combined with Microsoft [Remote Desktop Services (RDS)](/windows-server/remote/remote-desktop-services/welcome-to-rds) lets you achieve a highly available and highly scalable architecture.

In addition, Azure Stack HCI VDI provides the following unique cloud-based capabilities to protect VDI workloads and clients:
- Centrally managed updates using Azure Update Management
- Unified security management and advanced threat protection for VDI clients

## Deploy VDI
This section describes at a high level how to acquire hardware to deploy VDI on Azure Stack HCI and use Windows Admin Center for management. It also covers deploying RDS to support VDI.

### Step 1: Acquire hardware for VDI on Azure Stack HCI
First, you'll need to procure hardware. The easiest way to do that is to locate your preferred Microsoft hardware partner in the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net) and purchase an integrated system with the Azure Stack HCI operating system preinstalled. In the catalog, you can filter to see vendor hardware that is optimized for this type of workload. Be sure to consult your hardware partner to make sure the hardware can support the number of virtual desktops that you want to host on your cluster.

Otherwise, you'll need to deploy the Azure Stack HCI operating system on your own hardware. For details on Azure Stack HCI deployment options and installing Windows Admin Center, see [Deploy the Azure Stack HCI operating system](./operating-system.md).

Next, use Windows Admin Center to [create an Azure Stack HCI cluster](./create-cluster.md).

### Step 2: Set up Azure Update Management in Windows Admin Center
In Windows Admin Center, set up [Azure Update Management](/windows-server/manage/windows-admin-center/azure/azure-update-management) to quickly assess the status of available updates, schedule required updates, and review deployment results to verify applied updates.

To get started with Azure Update Management, you need a subscription to Microsoft Azure. If you don’t have a subscription, you can sign up for a [free trial](https://azure.microsoft.com/free).

You can also use Windows Admin Center to set up additional Azure hybrid services, such as Backup, File Sync, Site Recovery, Point-to-Site VPN, and Azure Security Center.

### Step 3: Deploy Remote Desktop Services (RDS) for VDI support
After completing your Azure Stack HCI deployment and registering with Azure to use Update Management, you’re ready to use the guidance in this section to build and deploy RDS to support VDI.

To build and deploy RDS:
1. [Deploy your Remote Desktop environment](/windows-server/remote/remote-desktop-services/rds-deploy-infrastructure)
1. [Create an RDS session collection](/windows-server/remote/remote-desktop-services/rds-create-collection) to share apps and resources
1. [License your RDS deployment](/windows-server/remote/remote-desktop-services/rds-client-access-license)
1. Direct your users to install a [Remote Desktop client](/windows-server/remote/remote-desktop-services/clients/remote-desktop-clients) to access apps and resources
1. Add Connection Brokers and Session Hosts to enable high availability:
    - [Scale out an existing RDS collection with an RD Session Host farm](/windows-server/remote/remote-desktop-services/rds-scale-rdsh-farm)
    - [Add high availability to the RD Connection Broker infrastructure](/windows-server/remote/remote-desktop-services/rds-connection-broker-cluster)
    - [Add high availability to the RD Web and RD Gateway web front](/windows-server/remote/remote-desktop-services/rds-rdweb-gateway-ha)
    - [Deploy a two-node Storage Spaces Direct file system for UPD storage](/windows-server/remote/remote-desktop-services/rds-storage-spaces-direct-deployment)

## Next steps
For more information related to VDI, see:
- [Supported configurations for Remote Desktop Services](/windows-server/remote/remote-desktop-services/rds-supported-config)
