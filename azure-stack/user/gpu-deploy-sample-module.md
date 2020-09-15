---
title:  Deploy a graphic processing unit (GPU) enabled IoT Module on Azure Stack Hub
description: How to deploy a graphic processing unit (GPU) enabled IoT Module on Azure Stack Hub
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: reference
ms.date: 09/25/2020
ms.reviewer: gara
ms.lastreviewed: 09/25/2020

# Intent: As a a developer on Azure Stack Hub, I want to deploy a solution using a Graphics Processing Unit (GPU) in order to deliver an processing intensive visualization application.
# Keyword: Graphics Processing Unit (GPU) module solution
---


# Deploy a GPU enabled IoT module on Azure Stack Hub

In this article you'll learn how to:
  - Deploy a GPU module to an IoT Edge VM on Azure Stack Hub.
  - Benchmark processing times for GPUs and CPUs.

**Included models**

This sample includes PyTorch and TensorFlow benchmarking sample code for CPU against GPU.

## Prerequisites

Before you begin, make sure you have:
  - A subscription as a user using Azure Active Director (Azure AD) to an Azure Stack Integrated System with an NVIDA GPU.
  - Install the NVIDIA GPU drivers. For instructions, see [Graphics processing unit (GPU) virtual machine (VM) on Azure Stack Hub](gpu-vms-about.md).
  - Install the latest IoT Edge runtime on a Linux VM in Azure Stack Hun. For instructions, see [Install the Azure IoT Edge runtime on Debian-based Linux systems](/azure/iot-edge/how-to-install-iot-edge-linux).
  - Provision a device. `what is this?`

  - An Azure subscription
      - If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.
      - An Azure Container Registry (ACR). Make a note of the ACR sign in server, username, and password.

  - The following development resources:
      - [Python 3.x](https://www.python.org/downloads/)
      - [Pip](https://pypi.org/project/pip/) for installing Python packages. This is usually is installed with your Python installation. If you have Pip installed, you may want to upgrade to the latest version. You can upgrade using pip, itself. Type: `pip install --upgrade pip`.
      - [Azure CLI 2.0](/cli/azure/install-azure-cli?view=azure-cli-latest)
      - [Git](https://git-scm.com/downloads)
      - [Docker](https://docs.docker.com/get-docker/)
      - [Visual Studio Code](https://code.visualstudio.com/)
      - [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) for Visual Studio Code
      - [Python Extension Pack](https://marketplace.visualstudio.com/items?itemName=donjayamanne.python-extension-pack) for Visual Studio Code


## Get the code

1.  Clone or download the code.

```bash  
git clone https://github.com/Azure-Samples/azure-intelligent-edge-patterns.git
```

## Configure and build containers
1.  Open the **GpuReferenceModules** folder in Visual Studio Code.
1.  Fill in the values in the following values in the **.env.template**` file for your Azure Container Registry.

    ```bash  
    REGISTRY_NAME=<YourAcrUri>
    REGISTRY_USER_NAME=<YourAcrUserName>
    REGISTRY_PASSWORD=<YourAcrPassword>
    ```

1.  Rename the file to `.env`.
1.  Sign into Docker by typing the following command in the Visual Studio Code integrated terminal. Use the username, password, and sign in server that you copied from your Azure container registry in the first section. You can also retrieve these values from the Access Keys section of your registry in the Azure portal.  

    ```bash  
    docker login -u <REGISTRY_USER_NAME> -p <REGISTRY_PASSWORD> <REGISTRY_NAME>.azurecr.io
    ```

1.  In the VS Code explorer, right-click the **deployment.iotedgevm.template.json**
    file and select Build and Push IoT Edge solution.

## Enable monitoring

1. Download [Azure IoT explorer](/azure/iot-pnp/howto-use-iot-explorer), and connect the application to your IoT Hub.

2. Select your IoT Device and navigate to Telemetry from the navigation menu.

3. Select **Start** to begin monitoring output from the IoT Edge Device.

## Deploy to Azure Stack Hub

You can also deploy modules using the Azure IoT Hub Toolkit extension, which used to be called the Azure IoT Toolkit extension, for Visual Studio Code. You have created a deployment manifest your scenario, the **deployment.json** file. Select a device to receive the deployment.

1.  In the VS Code command palette, run Azure IoT Hub: **Select IoT Hub**.

2.  Choose the subscription and IoT hub that contain the IoT Edge device that you want to configure.

3.  In the VS Code explorer, expand the Azure IoT Hub Devices section.

4.  Right-click the name of your IoT Edge device, then select **Create Deployment for Single Device**.

5.  Select the **deployment.amd64.json** file in the config folder and then select **Select Edge Deployment Manifest**. Do not use the `deployment.template.json` file.

6.  Select **Refresh**. You should see the GPU module running.

# Next Steps

  - Learn more about Azure Stack, Data Box Edge and the Intelligent Edge, [The future of computing: intelligent cloud and intelligent edge](https://azure.microsoft.com/overview/future-of-cloud)

  - Learn more about hybrid cloud applications, see [Hybrid Cloud Solutions](https://docs.microsoft.com/hybrid/app-solutions/)

  - Modify the code to this sample on [GitHub](https://github.com/Azure-Samples/azure-intelligent-edge-patterns).