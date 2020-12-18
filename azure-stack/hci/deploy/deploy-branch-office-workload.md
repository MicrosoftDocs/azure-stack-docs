---
title: Deploy branch office and edge on Azure Stack HCI
description: This topic provides guidance on how to plan, configure, and deploy Branch office and edge scenarios on the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 12/18/2020
---

# Deploy branch office and edge on Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2

This topic provides guidance on how to plan, configure, and deploy Branch office and edge scenarios on the Azure Stack HCI operating system. Use Azure Stack HCI to run key virtual applications and workloads with highly availability on recommended hardware. The hardware supports two-node configurations for nested resiliency, USB thumb drive cluster witness, and administration via Windows Admin Center.

## Deploy Branch office and edge
This section describes at a high level how to get hardware for Branch office and edge on Azure Stack HCI and use Windows Admin Center for management. It also covers enabling Branch office and edge support, and deploying Azure IoT Edge to manage containers in the cloud.

### Step 1: Get hardware for Branch office and edge on Azure Stack HCI
Refer to your specific hardware instructions for this step. For more information, reference your preferred Microsoft hardware partner in the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net).

   >[!NOTE]
   > In the catalog, you can filter to see Branch office and edge hardware vendors.

For details on Azure Stack HCI deployment options and installing Windows Admin Center, see [Deploy the Azure Stack HCI operating system](./operating-system.md).

### Step 2: Set up Azure Monitor in Windows Admin Center
In Windows Admin Center, set up Azure Monitor to gain insight into the application, network, and server health of your Azure Stack HCI Branch office and edge deployment.

To learn more, see [Monitor Azure Stack HCI with Azure Monitor](../manage/azure-monitor.md).

You can also use Windows Admin Center to set up additional Azure hybrid services, such as Backup, File Sync, Site Recovery, Point-to-Site VPN, Update Management, and Security Center.

### Step 3: Enable Branch office and edge modern application support
TBD



## Next steps
For more information about Branch office and edge, and Azure IoT Edge, see:
- [Quickstart: Deploy your first IoT Edge module to a virtual Linux device](https://docs.microsoft.com/azure/iot-edge/quickstart-linux?view=iotedge-2018-06&preserve-view=true)
- [Quickstart: Deploy your first IoT Edge module to a virtual Windows device](https://docs.microsoft.com/azure/iot-edge/quickstart?view=iotedge-2018-06&preserve-view=true)
