---
title: Deploy the AKS Engine on Windows in Azure Stack | Microsoft Docs
description: Learn how to use a Windows machine in your Azure Stack to host the AKS Engine in order to deploy and manage a Kubernetes cluster.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na (Kubernetes)
ms.devlang: nav
ms.topic: article
ms.date: 10/03/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 10/03/2019

---

# Install the AKS Engine on Windows in Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can use a Windows machine in your Azure Stack to host the AKS Engine in order to deploy and manage a Kubernetes cluster. In this article, we look at preparing the client VM to manage your cluster for both connected and disconnected Azure Stack instances, check the install, and setting up the client VM on the ASDK.

## Prepare the client VM

The AKS Engine is a command-line tool used to deploy and manage your Kubernetes cluster. You can run the engine on a machine in your Azure Stack. From this machine, you will execute the AKS Engine to deploy the IaaS resources and software needed to run your cluster. You can then use the machine running the engine to perform management tasks on your cluster.

When choosing your client machine, consider:

1. If the client machine should be recoverable in case of a disaster.
3. How you will connect to the client machine and how the machine will interact with your cluster.

## Install in a connected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack connected to the Internet.

1. Create a Windows VM in your Azure Stack. For instructions, see [Quickstart: Create a Windows server VM by using the Azure Stack portal](https://docs.microsoft.com/azure-stack/user/azure-stack-quick-windows-portal).
2. Connect to your VM.
3. [Install Chocolatey using the PowerShell instructions.](https://chocolatey.org/install#install-with-powershellexe). 

    According to the Chocolaty website: Chocolatey is a package manager for Windows, like apt-get or yum but for Windows. It was designed to be a decentralized framework for quickly installing applications and tools that you need. It is built on the NuGet infrastructure currently using PowerShell as its focus for delivering packages from the distros to your door, err, computer.
4. Find the version of AKS Engine in the [Supported Kubernetes Versions](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#supported-kubernetes-versions) table. The AKS Base Engine must be available in your Azure Stack Marketplace. When running the command, you must specify the version `--version v0.40.2`. If you don't specify the version, the command will install the latest version, which may need an VHD image that is not available in your marketplace.
5. Run the following command from an elevated prompt and include the version number:

    ```PowerShell  
        choco install aks-engine --version v0.40.2 -y
    ```

> [!Note]  
> If this method for installation fails, you can try the steps in the [disconnected environment](#install-in-a-disconnected-environment), or [Try GoFish](azure-stack-kubernetes-aks-engine-troubleshoot.md#try-gofish), an alternate package manager.

## Install in a disconnected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack disconnected from the Internet.

1.  From a machine with access to the Internet, go to GitHub [Azure/aks-engine](https://github.com/Azure/aks-engine/releases/latest). Download an archive (*.tar.gz) for a Windows machine, for example, `aks-engine-v0.38.8-windows-amd64.tar.gz`.

2.  Create a storage account in your Azure Stack instance to upload the archive file (*.tar.gz) with the AKS Engine binary. For instructions on using the Azure Storage Explorer, see [Azure Storage Explorer with Azure Stack](https://docs.microsoft.com/azure-stack/user/azure-stack-storage-connect-se).

3. Create a Windows VM in your Azure Stack. For instructions, see [Quickstart: Create a Windows server VM by using the Azure Stack portal](https://docs.microsoft.com/azure-stack/user/azure-stack-quick-windows-portal)

4.  From the Azure Stack storage account blob URL where you uploaded the archive file (*.tar.gz), download the file to your management VM. Extract the archive to a directory that you have access to from your command prompt.

5. Connect to your VM.

6. [Install Chocolatey using the PowerShell instructions.](https://chocolatey.org/install#install-with-powershellexe). 

7.  Run the following command from an elevated prompt. Include the right version number:

    ```PowerShell  
        choco install aks-engine --version v0.40.2 -y
    ```

## Verify the installation

Once your client VM is set up, check that you have installed the AKS engine.

1. Connect to your client VM.
2. Run the following command:

    ```PowerShell  
    aks-engine version
    ```

If you are unable to verify that you have installed the AKS Engine on your client VM, see [Troubleshoot AKS engine install](azure-stack-kubernetes-aks-engine-troubleshoot.md)


## ASDK installation

You will need to add a certificate when running the client VM for the AKS engine on the ASDK on a machine outside of the ASDK. If you're using a Windows VM within the ASDK environment itself, the machine already trusts the ASDK certificate. If your client machine is outside of the ASDK, you need to extract the certificate from the ASDK, and add it to the your Windows machine.

When you are using an ASDK your Azure Resource Manager endpoint is using a self-signed certificate, you need explicitly to add this certificate to the machine’s trusted certificate store. You can find the ASDK root certificate in any VM you deploy in the ASDK.

1. Export the CA root certificate. For instructions, see [Export the Azure Stack CA root certificate](https://docs.microsoft.com/azure-stack/user/azure-stack-version-profiles-azurecli2#export-the-azure-stack-ca-root-certificate)
2. Trust the Azure Stack CA root certificate. For instructions, see [Trust the Azure Stack CA root certificate](https://docs.microsoft.com/azure-stack/user/azure-stack-version-profiles-azurecli2#trust-the-azure-stack-ca-root-certificate).

## Next steps

> [!div class="nextstepaction"]
> [Deploy a Kubernetes cluster with the AKS engine on Azure Stack](azure-stack-kubernetes-aks-engine-deploy-cluster.md)
