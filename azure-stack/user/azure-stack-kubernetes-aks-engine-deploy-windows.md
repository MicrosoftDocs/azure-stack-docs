---
title: Deploy AKS engine on Windows in Azure Stack Hub 
description: Learn how to use a Windows machine in your Azure Stack Hub to host AKS engine in order to deploy and manage a Kubernetes cluster.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.date: 03/06/2025
ms.author: sethm
ms.reviewer: sumsmith
ms.lastreviewed: 03/04/2021

# Intent: As an Azure Stack Hub user, I want to learn how to host AKS engine on a Windows VM so that I can deploy AKS engine on Windows in Azure Stack Hub.
# Keyword: host aks on windows vm in azure stack hub 

---


# Install AKS engine on Windows in Azure Stack Hub

Binary downloads for the latest version of AKS Engine are available [on Github](https://github.com/Azure/aks-engine-azurestack/releases/latest). Download the package for your operating system, and extract the **aks-engine** file for AKS Engine versions 0.73.0 and below. For AKS Engine versions 0.75.3 and above, extract the **aks-engine-azurestack** file (and optionally add it to your `$PATH` environment variable for more convenient CLI usage).

## Prepare the client VM

The AKS engine is a command-line tool used to deploy and manage your Kubernetes cluster. You can run the engine on a machine in your Azure Stack Hub. From this machine, execute the AKS engine to deploy the IaaS resources and software needed to run your cluster. You can then use the machine running the engine to perform management tasks on your cluster.

When choosing your client machine, consider:

1. Whether the client machine should be recoverable in a disaster.
1. How do you connect to the client machine, and how does the machine interact with your cluster?

## Install AKS Engine in a connected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack Hub connected to the Internet.

# [AKS Engine 0.81.1 or later](#tab/later)
To install AKS Engine version 0.81.1 or later:

1. Create a Windows VM in your Azure Stack Hub. For instructions, see [Quickstart: Create a Windows server VM by using the Azure Stack Hub portal](./azure-stack-quick-windows-portal.md).
1. Connect to your VM.
1. Go to the [Azure/aks-engine-azurestack](https://github.com/Azure/aks-engine-azurestack/releases/latest) GitHub repo. Download an archive (*.tar.gz) for a Windows machine, for example, `aks-engine-azurestack-v0.xx.x-windows-amd64.tar.gz`. Find the version of AKS Engine in the [Supported Kubernetes Versions table](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).

# [AKS Engine 0.80.2 or earlier](#tab/earlier)

To install AKS Engine version 0.80.2 or earlier:

1. [Install Chocolatey using the PowerShell instructions](https://chocolatey.org/install#install-with-powershellexe).
1. Install [Azure CLI](/cli/azure/install-azure-cli-windows). Select the download link, and choose "**Run**". Choose the setup steps as needed.
1. Find the version of AKS engine in the [AKS engine and Azure Stack version mapping table](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping) table. The AKS Base Engine must be available in your Azure Stack Hub Marketplace. When running the command, you must specify the version `--version v0.xx.x`. If you don't specify the version, the command installs the latest version, which may need a VHD image that is not available in your marketplace.
    > [!NOTE]  
    > You can find the mapping of Azure Stack Hub to AKS engine version number in the [AKS engine release notes](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).
1. Run the following command from an elevated prompt and include the version number:

    > [!NOTE]
    > For AKSe version 0.75.3 and above, the command to install AKS engine is `choco install aks-engine-azurestack`.

    ```PowerShell  
        choco install aks-engine --version 0.xx.x -y
    ```

    > [!NOTE]  
    > If this method for installation fails, you can try the steps for a disconnected environment below.

---

## Install AKS Engine in a disconnected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack Hub disconnected from the Internet.

1. From a machine with access to the Internet, go to the [Azure/aks-engine-azurestack](https://github.com/Azure/aks-engine-azurestack/releases/latest) GitHub repo. Download an archive (*.tar.gz) for a Windows machine, for example, `aks-engine-azurestack-v0.xx.x-windows-amd64.tar.gz`. Find the version of AKS engine in the [Supported Kubernetes Versions table](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).

1. Create a storage account in your Azure Stack Hub instance to upload the archive file (*.tar.gz) with the AKS engine binary. For instructions on using the Azure Storage Explorer, see [Azure Storage Explorer with Azure Stack Hub](./azure-stack-storage-connect-se.md).

1. Create a Windows VM in your Azure Stack Hub. For instructions, see [Quickstart: Create a Windows server VM by using the Azure Stack Hub portal](./azure-stack-quick-windows-portal.md)

1. Connect to your VM.

1. From the Azure Stack Hub storage account blob URL where you uploaded the archive file (*.tar.gz), download the file to your management VM. Extract the archive to a directory that you have access to from your command prompt.

## Verify the installation

Once your client VM is set up, check that you have installed AKS engine.

1. Connect to your client VM.
2. Run the following command:

    > [!Note]
    > For AKSe version 0.75.3 and above, the command to check the current version of your AKS engine is `aks-engine-azurestack version`.

    ```PowerShell  
    aks-engine version
    ```

If you are unable to verify that you have installed AKS engine on your client VM, see [Troubleshoot AKS engine install](azure-stack-kubernetes-aks-engine-troubleshoot.md).

## Next steps

> [!div class="nextstepaction"]
> [Deploy a Kubernetes cluster with AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-cluster.md)
