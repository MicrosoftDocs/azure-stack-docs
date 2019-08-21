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
ms.date: 08/22/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/22/2019

---

# Deploy the AKS Engine on Windows in Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can use a Windows machine in your Azure Stack to host the AKS Engine in order to deploy and manage a Kubernetes cluster. In this article, we look at preparing the client VM to manage your cluster for both connected and disconnected Azure Stack instances, check the install, and setting up the client VM on the ASDK.

## Prepare the client VM

The AKS Engine is a command-line tool used to deploy and manage your Kubernetes cluster. You can run the engine on a machine in your Azure Stack. From this machine, you will deploy the IaaS resources needed to run your cluster. You can then use the machine running the engine to perform management tasks on your cluster. 

When choosing your client machine, consider:

1. If the client machine should be recoverable in case of a disaster.
2. If you need your cluster management machine to be highly available.
3. How you will connect to the client machine and how the machine will interact with your cluster.

## Install in a connected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack connected to the Internet.

1. Create a Windows VM in your Azure Stack. For instructions, see [Quickstart: Create a Windows server VM by using the Azure Stack portal](https://docs.microsoft.com/azure-stack/user/azure-stack-quick-windows-portal).
2. Connect to your VM.
3. [Install Chocolatey using the PowerShell instructions.](https://chocolatey.org/install#install-with-powershellexe). 

    According to the Chocolaty website: Chocolatey is a package manager for Windows, like apt-get or yum but for Windows. It was designed to be a decentralized framework for quickly installing applications and tools that you need. It is built on the NuGet infrastructure currently using PowerShell as its focus for delivering packages from the distros to your door, err, computer.

1. Run the following command from an elevated prompt:

    ```PowerShell  
        choco install aks-engine
    ```

## Install in a disconnected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack disconnected from the Internet.

1.  From a machine with access to the Internet, go to GitHub [Azure/aks-engine](https://github.com/Azure/aks-engine/releases/latest). Download an archive (*.tar.gz) for a Windows machine, for example, `aks-engine-v0.38.8-windows-amd64.tar.gz`.

2.  Create a storage account in your Azure Stack instance to upload the archive file (*.tar.gz) with the AKS Engine binary. For instructions on using the Azure Storage Explorer, see [Azure Storage Explorer with Azure Stack](https://docs.microsoft.com/azure-stack/user/azure-stack-storage-connect-se).

3. Create a Widows VM in your Azure Stack. For instructions, see [Quickstart: Create a Windows server VM by using the Azure Stack portal](https://docs.microsoft.com/azure-stack/user/azure-stack-quick-windows-portal)

4.  From the Azure Stack storage account blob URL where you uploaded the archive file (*.tar.gz), download the file to your management VM. Extract the archive to the directory `/usr/local/bin`.

5. Connect to your VM.

6. [Install Chocolatey using the PowerShell instructions.](https://chocolatey.org/install#install-with-powershellexe). 

7.  Run the following command from an elevated prompt:

    ```PowerShell  
        choco install aks-engine
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

You will need to add a certificate when running the client VM for the AKS engine on the ASDK.

When you are using an ASDK your Azure Resource Manager endpoint is using a self-signed certificate, you need explicitly to add this certificate to the machine’s trusted certificate store. You can find the ASDK root certificate in any VM you deploy in the ASDK. For example, in an Ubuntu VM you will find it in this directory `/var/lib/waagent/Certificates.pem`. 

Copy the certificate file with the following command:

```bash
sudo cp /var/lib/waagent/Certificates.pem /usr/local/share/ca-certificates/azurestackca.crt

sudo update-ca-certificates
```

## Next steps

> [!div class="nextstepaction"]
> [Deploy a Kubernetes cluster with the AKS engine on Azure Stack](azure-stack-kubernetes-aks-engine-deploy-cluster.md)