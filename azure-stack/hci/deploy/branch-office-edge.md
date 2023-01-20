---
title: Deploy branch office and edge on Azure Stack HCI
description: This topic provides guidance on how to plan, configure, and deploy branch office and edge scenarios on the Azure Stack HCI operating system.
author: hsuzuki
ms.author: hsuzuki
ms.topic: how-to
ms.date: 01/21/2021
---

# Deploy branch office and edge on Azure Stack HCI

[!INCLUDE [hci-applies-to-22h2-21h2-20h2](../../includes/hci-applies-to-22h2-21h2-20h2.md)]

This topic provides guidance on how to plan, configure, and deploy branch office and edge scenarios on the Azure Stack HCI operating system. The guidance positions your organization to run complex, highly available workloads in virtual machines (VMs) and containers in remote branch office and edge deployments. Computing at the edge shifts most data processing from a centralized system to the edge of the network, closer to a device or system that requires data quickly.

Use Azure Stack HCI to run virtualized applications and workloads with high availability on recommended hardware. The hardware supports clusters consisting of two servers configured with nested resiliency for storage, a simple, low-cost USB thumb drive cluster witness, and administration via the browser-based Windows Admin Center. For details on creating a USB device cluster witness, see [Deploy a file share witness](/windows-server/failover-clustering/file-share-witness).

Azure IoT Edge moves cloud analytics and custom business logic to devices so that you can focus on business insights instead of data management. Azure IoT Edge combines AI, cloud, and edge computing in containerized cloud workloads, such as Azure Cognitive Services, Machine Learning, Stream Analytics, and Functions. Workloads can run on devices ranging from a Raspberry Pi to a converged edge server. You use [Azure IoT Hub](https://azure.microsoft.com/services/iot-hub) to manage your edge applications and devices.

Adding Azure IoT Edge to your Azure Stack HCI branch office and edge deployments modernizes your environment to support the [CI/CD pipeline](/azure/iot-edge/how-to-continuous-integration-continuous-deployment) application deployment framework. DevOps personnel in your organization can deploy and iterate containerized applications that IT builds and supports via traditional VM management processes and tools.

Primary features of Azure IoT Edge:
- Open source software from Microsoft
- Runs on either Windows or Linux
- Runs “on the edge” to provide near-real time responses
- Secure software and hardware mechanisms
- Available in the [AI Toolkit for Azure IoT Edge](https://github.com/Azure/ai-toolkit-iot-edge)
- Open programmability support for: Java, .NET Core 2.0, Node.js, C, and Python
- Offline and intermittent connectivity support
- Native management from Azure IoT Hub

To learn more, see [What is Azure IoT Edge](/azure/iot-edge/about-iot-edge).

## Deploy branch office and edge
This section describes at a high level how to acquire hardware for branch office and edge deployments on Azure Stack HCI and use Windows Admin Center for management. It also covers deploying Azure IoT Edge to manage containers in the cloud.

### Acquire hardware from the Azure Stack HCI Catalog
First, you'll need to procure hardware. The easiest way to do that is to locate your preferred Microsoft hardware partner in the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) and purchase an integrated system with the Azure Stack HCI operating system preinstalled. In the catalog, you can filter to see vendor hardware that is optimized for this type of workload.

Otherwise, you'll need to deploy the Azure Stack HCI operating system on your own hardware. For details on Azure Stack HCI deployment options and installing Windows Admin Center, see [Deploy the Azure Stack HCI operating system](./operating-system.md).

Next, use Windows Admin Center to [create an Azure Stack HCI cluster](./create-cluster.md).

### Use container-based apps and IoT data processing
Now you’re ready to use modern container-based application development and IoT data processing. Use Windows Admin Center for the steps in this section to deploy a VM running Azure IoT Edge.

To learn more, see [What is Azure IoT Edge](/azure/iot-edge/about-iot-edge).

To deploy Azure IoT Edge on Azure Stack HCI:
1. Use Windows Admin Center to [create a new VM in Azure Stack HCI](/windows-server/manage/windows-admin-center/use/manage-virtual-machines#create-a-new-virtual-machine).

    For information on supported operating system versions, VM types, processor architectures, and system requirements, see [Azure IoT Edge supported systems](/azure/iot-edge/support).

1. If you don’t already have an Azure account, start a [free account](https://azure.microsoft.com/free).
1. In the Azure portal, [create an Azure IoT hub](/azure/iot-edge/quickstart#create-an-iot-hub).
1. In the Azure portal, [register an IoT Edge device](/azure/iot-edge/quickstart#register-an-iot-edge-device).

    >[!NOTE]
    > The IoT Edge device is on a VM running either Windows or Linux on Azure Stack HCI.

1. On the VM that you created in Step 1, [install and start the IoT Edge runtime](/azure/iot-edge/quickstart#install-and-start-the-iot-edge-runtime).

   >[!IMPORTANT]
   > You need the device string that you created in Step 4 to connect the runtime to Azure IoT Hub.

1. [Deploy a module](/azure/iot-edge/quickstart#deploy-a-module) to Azure IoT Edge.

    You can source and deploy pre-built modules from the [IoT Edge Modules](https://azuremarketplace.microsoft.com/marketplace/apps/category/internet-of-things?page=1&subcategories=iot-edge-modules) section of Azure Marketplace.

## Next steps
For more information about branch office and edge, and Azure IoT Edge, see:
- [Quickstart: Deploy your first IoT Edge module to a virtual Linux device](/azure/iot-edge/quickstart-linux?preserve-view=true&view=iotedge-2018-06)
- [Quickstart: Deploy your first IoT Edge module to a Windows device](/azure/iot-edge/quickstart?preserve-view=true&view=iotedge-2018-06)