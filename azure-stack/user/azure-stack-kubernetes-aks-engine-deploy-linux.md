---
title: Install AKS engine on Linux in Azure Stack Hub 
description: Learn how to use a Linux machine in your Azure Stack Hub to host AKS engine in order to deploy and manage a Kubernetes cluster.
author: sethmanheim

ms.topic: article
ms.date: 01/12/2023
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 05/05/2022

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# Install AKS engine on Linux in Azure Stack Hub

You can use a Linux machine in your Azure Stack Hub to host AKS engine in order to deploy and manage a Kubernetes cluster. In this article, we look at preparing the client VM to manage your cluster for both connected and disconnected Azure Stack Hub instances, check the install, and setting up the client VM on the ASDK.

## Prepare the client VM

AKS engine is a command-line tool used to deploy and manage your Kubernetes cluster. You can run the engine on a machine in your Azure Stack Hub. From this machine, you use AKS engine to deploy the IaaS resources and software needed to run your cluster. You can then use the machine running the engine to perform management tasks on your cluster.

When choosing your client machine, consider:

1. Whether the client machine should be recoverable in a disaster.
2. How you will connect to the client machine and how the machine will interact with your cluster.

## Install in a connected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack Hub connected to the Internet.

1. Create a Linux VM in your Azure Stack Hub. For instructions, see [Quickstart: Create a Linux server VM by using the Azure Stack Hub portal](./azure-stack-quick-linux-portal.md).
2. Connect to your VM.
3. Use your package manager to check that you have the following tools installed:
    - `jq` a JSON processor.
    - `curl` - a tool for transferring files using a variety of network protocols.
    - `openssh` an ssh client.
    - `tar` a tool used to work with TAR archives.
4. Install Azure CLI. Packages for Azure CLI are available for most distributions. You can find instructions at [Install the Azure CLI on Linux](/cli/azure/install-azure-cli-linux).
5. Find the version of AKS engine in the [AKS engine and Azure Stack version mapping table](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping) table. The AKS Base Image must be available in your Azure Stack Hub Marketplace. When running the command, you must specify the version `--version v0.xx.x`. If you don't specify the version, the command will install the latest version, which may need a VHD image that is not available in your marketplace.
    > [!NOTE]  
    > You can find the mapping of Azure Stack Hub to AKS engine version number in the [AKS engine release notes](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).
6. Run the following command:

    For AKS Engine versions 0.73.0 and below:

    ```bash  
    sudo apt update
    sudo apt install jq
    curl -o get-akse.sh https://raw.githubusercontent.com/Azure/aks-engine/master/scripts/get-akse.sh
    chmod 700 get-akse.sh
    ./get-akse.sh --version v0.xx.x
    ```
    
    For AKS Engine versions 0.75.3 and above:

    ```bash  
    sudo apt update
    sudo apt install jq
    curl -o get-akse.sh https://raw.githubusercontent.com/Azure/aks-engine-azurestack/master/scripts/get-akse.sh
    chmod 700 get-akse.sh
    ./get-akse.sh --version v0.xx.x
    ```

    > [!NOTE]  
    > If your installation method fails, try the steps in the [disconnected environment](#install-in-a-disconnected-environment).

## Install in a disconnected environment

You can install the client VM to manage your Kubernetes cluster on an Azure Stack Hub disconnected from the Internet.

1.  From a machine with access to the internet: 
    
    For AKS Engine versions 0.73.0 and below, go to GitHub [Azure/aks-engine](https://github.com/Azure/aks-engine/releases/latest). Download an archive (*.tar.gz) for a Linux machine, for example, `aks-engine-v0.xx.x-linux-amd64.tar.gz`. 

    For AKS Engine versions 0.75.3 and above, go to GitHub [Azure/aks-engine-azurestack](https://github.com/Azure/aks-engine-azurestack/releases/latest). Download an archive (*.tar.gz) for a Linux machine, for example,`aks-engine-azurestack-v0.xx.x-linux-amd64.tar.gz`. 
    
    Find the version of AKS engine in the [Supported Kubernetes Versions table](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).

2.  Create a storage account in your Azure Stack Hub instance to upload the archive file (*.tar.gz) with the AKS engine binary. For instructions on using the Azure Storage Explorer, see [Azure Storage Explorer with Azure Stack Hub](./azure-stack-storage-connect-se.md).

3. Create a Linux VM in your Azure Stack Hub. For instructions, see [Quickstart: Create a Linux server VM by using the Azure Stack Hub portal](./azure-stack-quick-linux-portal.md).

3.  From the Azure Stack Hub storage account blob URL where you uploaded the archive file (*.tar.gz), download the file to your management VM. Extract the archive to the directory `/usr/local/bin`.

4. Connect to your VM.

5.  Run the following command:

    For AKS Engine versions 0.73.0 and below:

    ```bash  
    curl -o aks-engine-v0.xx.x-linux-amd64.tar.gz <httpurl/aks-engine-v0.xx.x-linux-amd64.tar.gz>
    tar xvzf aks-engine-v0.xx.x-linux-amd64.tar.gz -C /usr/local/bin
    ```
    
    For AKS Engine versions 0.75.3 and above:

    ```bash  
    curl -o aks-engine-azurestack-v0.xx.x-linux-amd64.tar.gz <httpurl/aks-engine-azurestack-v0.xx.x-linux-amd64.tar.gz>
    tar xvzf aks-engine-azurestack-v0.xx.x-linux-amd64.tar.gz -C /usr/local/bin
    ```

## Verify the installation

Once your client VM is set up, check that you have installed AKS engine.

1. Connect to your client VM.
2. Run the following command:

> [!Note]
> For AKSe version 0.75.3 and above, the command to check the current version of your AKS engine is `aks-engine-azurestack version`. 

   ```bash  
   aks-engine version
   ```

3. If Azure Resource Manager endpoint is using a self-signed certificate, you need to explicitly add the root certificate to trusted certificate store of the machine. You can find the root certificate in the VM in this directory: /var/lib/waagent/Certificates.pem. Copy the certificate file with the following command: 

   ```bash
   sudo cp /var/lib/waagent/Certificates.pem /usr/local/share/ca-certificates/azurestackca.crt 
   sudo update-ca-certificates
   ```

If you are unable to verify that you have installed AKS engine on your client VM, see [Troubleshoot AKS engine install](azure-stack-kubernetes-aks-engine-troubleshoot.md)


## ASDK installation

You will need to add a certificate when running the client VM for AKS engine on the ASDK.

When you are using an ASDK your Azure Resource Manager endpoint is using a self-signed certificate, you need explicitly to add this certificate to the machine's trusted certificate store. You can find the ASDK root certificate in any VM you deploy in the ASDK. For example, in an Ubuntu VM you will find it in this directory `/var/lib/waagent/Certificates.pem`. 

Copy the certificate file with the following command:

```bash
sudo cp /var/lib/waagent/Certificates.pem /usr/local/share/ca-certificates/azurestackca.crt

sudo update-ca-certificates
```

## Next steps

> [!div class="nextstepaction"]
> [Deploy a Kubernetes cluster with AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-cluster.md)
