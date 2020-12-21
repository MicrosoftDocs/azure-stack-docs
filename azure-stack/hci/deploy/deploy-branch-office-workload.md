---
title: Deploy branch office and edge on Azure Stack HCI
description: This topic provides guidance on how to plan, configure, and deploy branch office and edge scenarios on the Azure Stack HCI operating system.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 12/21/2020
---

# Deploy branch office and edge on Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2

This topic provides guidance on how to plan, configure, and deploy branch office and edge scenarios on the Azure Stack HCI operating system. Use Azure Stack HCI to run key virtual applications and workloads with highly availability on recommended hardware. The hardware supports two-node configurations for nested resiliency, USB thumb drive cluster witness, and administration via Windows Admin Center.

Azure IoT Edge moves cloud analytics and custom business logic to devices so that you can focus on business insights instead of data management. Azure IoT Edge combines AI, cloud, and edge computing in containerized cloud workloads, such as Azure Cognitive Services, Machine Learning, Stream Analytics, and Functions. Workloads can run on devices ranging from a Raspberry Pi to a converged edge server. You use [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) to manage your edge applications and devices.

Adding Azure IoT Edge to your Azure Stack HCI branch office and edge deployments modernizes your environment to support the [CI/CD pipeline](https://docs.microsoft.com/azure/iot-edge/how-to-continuous-integration-continuous-deployment) application deployment framework. DevOps personnel in your organization can deploy and iterate containerized applications that IT builds and supports via traditional VM management processes and tools.

Primary features of Azure IoT Edge:
- Open source software from Microsoft
- Runs on either Windows or Linux
- Runs “on the edge” to provide near-real time responses
- Secure software and hardware mechanisms
- Available in the [AI Toolkit for Azure IoT Edge](https://github.com/Azure/ai-toolkit-iot-edge)
- Open programmability support for: Java, .Net Core 2.0, Node.js, C, and Python
- Offline and intermittent connectivity support
- Native management from Azure IoT Hub

To learn more, see [What is Azure IoT Edge](https://docs.microsoft.com/azure/iot-edge/about-iot-edge).

## Deploy branch office and edge
This section describes at a high level how to acquire hardware for branch office and edge on Azure Stack HCI and use Windows Admin Center for management. It also covers enabling branch office and edge support, and deploying Azure IoT Edge to manage containers in the cloud.

### Step 1: Get hardware for branch office and edge on Azure Stack HCI
Refer to your specific hardware instructions for this step. For more information, reference your preferred Microsoft hardware partner in the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net).

   >[!NOTE]
   > In the catalog, you can filter to see branch office and edge hardware vendors.

For details on Azure Stack HCI deployment options and installing Windows Admin Center, see [Deploy the Azure Stack HCI operating system](./operating-system.md).

### Step 2: Set up Azure Monitor in Windows Admin Center
In Windows Admin Center, set up Azure Monitor to gain insight into the application, network, and server health of your Azure Stack HCI branch office and edge deployment.

To learn more, see [Monitor Azure Stack HCI with Azure Monitor](../manage/azure-monitor.md).

You can also use Windows Admin Center to set up additional Azure hybrid services, such as Backup, File Sync, Site Recovery, Point-to-Site VPN, Update Management, and Security Center.

### Step 3: Enable branch office and edge modern application support
After setting up branch office and edge on Azure Stack HCI, you’re ready to enable your environment to support modern container-based application development and IoT data processing. Use Windows Admin Center for the steps in this section to deploy a virtual machine (VM) running Azure IoT Edge.

To learn more, see [What is Azure IoT Edge](https://docs.microsoft.com/azure/iot-edge/about-iot-edge).

To deploy Azure IoT Edge on Azure Stack HCI:
1. Use Windows Admin Center to [create a new VM in Azure Stack HCI](https://docs.microsoft.com/windows-server/manage/windows-admin-center/use/manage-virtual-machines#create-a-new-virtual-machine).

    For information on supported operating system versions, VM types, processor architectures, and system requirements, see [Azure IoT Edge supported systems](https://docs.microsoft.com/azure/iot-edge/support).

1. If you don’t already have an Azure account, start a [free account](https://azure.microsoft.com/free).
1. In the Azure portal, [create an Azure IoT Hub](https://docs.microsoft.com/azure/iot-edge/quickstart#create-an-iot-hub).
1.	In the Azure portal, [register an IoT Edge device](https://docs.microsoft.com/azure/iot-edge/quickstart#register-an-iot-edge-device).

    >[!NOTE]
    > The IoT Edge device is on a VM running either Windows or Linux on Azure Stack HCI.

1. On the VM that you created in Step 1, [install and start the IoT Edge runtime](https://docs.microsoft.com/azure/iot-edge/quickstart#install-and-start-the-iot-edge-runtime).

   >[!IMPORTANT]
   > You need the device string that you created in Step 4 to connect the runtime to Azure IoT Hub.

1. [Deploy a module](https://docs.microsoft.com/azure/iot-edge/quickstart#deploy-a-module) to Azure IoT Edge.

    You can source and deploy pre-built modules from the [IoT Edge Modules](https://azuremarketplace.microsoft.com/marketplace/apps/category/internet-of-things?page=1&subcategories=iot-edge-modules) section of Azure Marketplace.

## Next steps
For more information about branch office and edge, and Azure IoT Edge, see:
- [Quickstart: Deploy your first IoT Edge module to a virtual Linux device](https://docs.microsoft.com/azure/iot-edge/quickstart-linux?view=iotedge-2018-06&preserve-view=true)
- [Quickstart: Deploy your first IoT Edge module to a virtual Windows device](https://docs.microsoft.com/azure/iot-edge/quickstart?view=iotedge-2018-06&preserve-view=true)
