---
title: Deploy the AKS engine on Windows in Azure Stack Hub 
description: Learn how to use a Windows machine in your Azure Stack Hub to host the AKS engine in order to deploy and manage a Kubernetes cluster.
author: mattbriggs

ms.topic: article
ms.date: 09/16/2020
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 09/16/2020

# Intent: As an Azure Stack Hub user, I want to learn how to host the AKS engine on a Windows VM so that I can deploy the AKS engine on Windows in Azure Stack Hub.
# Keyword: host aks on windows vm in azure stack hub 

---


# Install the AKS engine on Windows in Azure Stack Hub

You can use a Windows machine in your Azure Stack Hub to host the AKS engine in order to deploy and manage a Kubernetes cluster. In this article, you prepare the client VM to manage your cluster for connected and disconnected Azure Stack Hub instances, and verify the installation.
<!-- TZLASDKFIX2 Line above was previously:
In this article, we look at preparing the client VM to manage your cluster for both connected and disconnected Azure Stack Hub instances, check the install, and setting up the client VM on the ASDK.
-->
## Prepare the client VM

The AKS engine is a command-line tool used to deploy and manage your Kubernetes cluster. You can run the engine on a machine in your Azure Stack Hub. From this machine, you will execute the AKS engine to deploy the IaaS resources and software needed to run your cluster. You can then use the machine running the engine to perform management tasks on your cluster.

When choosing your client machine, consider:

1. If the client machine should be recoverable in case of a disaster.
3. How you will connect to the client machine and how the machine will interact with your cluster.

## Install in a connected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack Hub connected to the Internet.

1. Create a Windows VM in your Azure Stack Hub. For instructions, see [Quickstart: Create a Windows server VM by using the Azure Stack Hub portal](./azure-stack-quick-windows-portal.md).
2. Connect to your VM.
3. [Install Chocolatey using the PowerShell instructions.](https://chocolatey.org/install#install-with-powershellexe). 

    According to the Chocolatey website: Chocolatey is a package manager for Windows, like apt-get or yum but for Windows. It was designed to be a decentralized framework for quickly installing applications and tools that you need. It is built on the NuGet infrastructure currently using PowerShell as its focus for delivering packages from the distros to your door, err, computer.
4. Find the version of AKS engine in the [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-aks-engine-versions) table. The AKS Base Engine must be available in your Azure Stack Hub Marketplace. When running the command, you must specify the version `--version v0.48.0`. If you don't specify the version, the command will install the latest version, which may need an VHD image that is not available in your marketplace.
5. Run the following command from an elevated prompt and include the version number:

    ```PowerShell  
        choco install aks-engine --version 0.55.4 -y
    ```

> [!NOTE]  
> If this method for installation fails, you can try the steps in the [disconnected environment](#install-in-a-disconnected-environment), or [Try GoFish](azure-stack-kubernetes-aks-engine-troubleshoot.md#try-gofish), an alternate package manager.

## Install in a disconnected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack Hub disconnected from the Internet.

1.  From a machine with access to the Internet, go to GitHub [Azure/aks-engine](https://github.com/Azure/aks-engine/releases/latest). Download an archive (*.tar.gz) for a Windows machine, for example, `aks-engine-v0.38.8-windows-amd64.tar.gz`.

2.  Create a storage account in your Azure Stack Hub instance to upload the archive file (*.tar.gz) with the AKS engine binary. For instructions on using the Azure Storage Explorer, see [Azure Storage Explorer with Azure Stack Hub](./azure-stack-storage-connect-se.md).

3. Create a Windows VM in your Azure Stack Hub. For instructions, see [Quickstart: Create a Windows server VM by using the Azure Stack Hub portal](./azure-stack-quick-windows-portal.md)

4.  From the Azure Stack Hub storage account blob URL where you uploaded the archive file (*.tar.gz), download the file to your management VM. Extract the archive to a directory that you have access to from your command prompt.

5. Connect to your VM.

6. [Install Chocolatey using the PowerShell instructions.](https://chocolatey.org/install#install-with-powershellexe). 

7.  Run the following command from an elevated prompt. Include the right version number:

    ```PowerShell  
        choco install aks-engine --version 0.55.4 -y
    ```

## Verify the installation

Once your client VM is set up, check that you have installed the AKS engine.

1. Connect to your client VM.
2. Run the following command:

    ```PowerShell  
    aks-engine version
    ```

If you are unable to verify that you have installed the AKS engine on your client VM, see [Troubleshoot AKS engine install](azure-stack-kubernetes-aks-engine-troubleshoot.md).

## Next steps

> [!div class="nextstepaction"]
> [Deploy a Kubernetes cluster with the AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-cluster.md)
