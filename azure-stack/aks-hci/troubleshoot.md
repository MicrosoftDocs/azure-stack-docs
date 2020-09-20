---
title: Troubleshooting
description: Guide for troubleshooting Azure Kubernetes Service on Azure Stack HCI
author: davannaw-msft
ms.topic: how-to
ms.date: 09/22/2020
ms.author: dawhite
---

# Troubleshooting Azure Kubernetes Service on Azure Stack HCI

When you create or manage a Kubernetes cluster using Azure Kubernetes Service on Azure Stack HCI, you might occasionally come across problems. Below are the troubleshooting guidelines to help you resolve those issues. 

## Troubleshooting Azure Stack HCI
To troubleshoot cluster validation reporting for network and storage QoS (quality of service) settings across servers in an Azure Stack HCI cluster and verify that important rules are defined, visit [Troubleshoot cluster validation reporting](/azure-stack/hci/manage/validate-qos).

To troubleshoot issues with CredSSP, visit [Troubleshoot CredSSP](/azure-stack/hci/manage/troubleshoot-credssp).

## Troubleshooting Windows Admin Center
This product is currently in the public preview state, which means it is still in development. Currently there are several issues with the Windows Admin Center Azure Kubernetes Service extension: 
* Currently each server in the cluster of the system you are using to set up Azure Kubernetes Service on Azure Stack HCI must be a trusted server. This means that Windows Admin Center must be able to perform CredSSP operations on each server in the cluster, not just one or a few of them. 
* If you run into an error saying `msft.sme.aks couldn't load`, and the error tells you that loading chunks failed, use the latest version of Edge or Google Chrome and try again.
* Prior to starting either the Azure Kubernetes Service host set-up wizard or the creating the Kubernetes cluster wizard, you should sign into Azure through Windows Admin Center. Re-signing may be required during the workflow. If you are having difficulties signing into Azure through Windows Admin Center, try signing into your Azure account from another source, like the [Azure portal](https://portal.azure.com/). If you continue to encounter issues, check the [Windows Admin Center known issues](/windows-server/manage/windows-admin-center/support/known-issues) article before reaching out for support.
* In the current iteration of Azure Kubernetes Service on Azure Stack HCI deployment through Windows Admin Center, only the user who set up the Azure Kubernetes Service host can create Kubernetes clusters on the system. To work around this issue, copy the `.wssd` folder from the user profile who set up the Azure Kubernetes Service host to the user profile that will be launching the new Kubernetes cluster.
* If you receive an error in either wizard about a wrong configuration, perform cluster cleanup operations. This may involve removing the `C:\Program Files\AksHci\mocctl.exe` file.
* For CredSSP to function successfully within the cluster create wizard, Windows Admin Center must be installed and used by the same account. Installing with one account and then trying to use it with another will result in errors.
* During cluster deployment, there may be an issue with the helm.zip file transfer. This often results in an error saying the path to the helm.zip file does not exist or is not valid. To resolve this issue, go back and retry the deployment.
* If your deployment hangs for an extended period, you may be having CredSSP or connectivity issues. Try the following steps to troubleshoot your deployment: 
    1.	On the machine running WAC, run the following command in a PowerShell window: 
    ```PowerShell
    Enter-PSSession <servername>
    ```
    2.	If this command succeeds, then you can connect to the server, and there is not a connectivity issue.
    
    3.	If you are running into CredSSP issues, run this command to test the trust between the gateway machine and the target machine: 
    ```PowerShell
    Enter-PSSession –ComputerName <server> –Credential company\administrator –Authentication CredSSP
    ``` 
    You can also run the following command to test the trust in accessing the local gateway: 
    ```PowerShell
    Enter-PSSession -computer localhost -credential (Get-Credential)
    ``` 
* If you are using Azure Arc and have multiple tenant IDs, run the following command to specify your desired tenant prior to deployment. A failure to do so might cause deployment failure.

```Azure CLI
az login –tenant <tenant>
```
* If you have just created a new Azure account and have not logged into the account on your gateway machine, you may experience issues registering your WAC gateway with Azure. To mitigate this issue, sign into your Azure account in another browser tab or window, then register the WAC gateway to Azure.

## Troubleshooting Windows worker nodes 
To log in to a Windows worker node, first get the IP address of your node by running `kubectl get` and note the `EXTERNAL-IP` value:

```PowerShell
kubectl get nodes -o wide
``` 
SSH into the node using `ssh Administrator@ip`. Once you ssh into the node, run `net user administrator *` to update your administrator’s password. 

## Troubleshooting Azure Arc for Kubernetes
To troubleshoot some common scenarios related to connectivity, permissions, and Arc agents, visit [Azure Arc enabled Kubernetes troubleshooting](/azure/azure-arc/kubernetes/troubleshooting).

## Next steps
If you continue to run into issues while using Azure Kubernetes Service on Azure Stack HCI, file bugs through [GitHub](https://aka.ms/aks-hci-issues).  
