---
title: Troubleshooting AKS
description: This article provides information about troubleshooting Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: davannaw-msft
ms.topic: how-to
ms.date: 09/22/2020
ms.author: dawhite
---

# Troubleshooting Azure Kubernetes Service on Azure Stack HCI

When you create or manage a Kubernetes cluster by using Azure Kubernetes Service on Azure Stack HCI, you might occasionally come across problems. This article provides troubleshooting guidelines to help you resolve those problems.

## Troubleshooting Azure Stack HCI
To troubleshoot cluster validation reporting for network and storage QoS (quality of service) settings across servers in an Azure Stack HCI cluster and verify that important rules are defined, see [Troubleshoot cluster validation reporting](../hci/manage/validate-qos.md).

To learn about troubleshooting problems with CredSSP, see [Troubleshoot CredSSP](../hci/manage/troubleshoot-credssp.md).

## Troubleshooting Windows Admin Center
This product is in public preview, which means it's still in development. There are currently some issues with the Windows Admin Center Azure Kubernetes Service extension: 
* Currently, each server in the cluster of the system you're using to set up Azure Kubernetes Service on Azure Stack HCI must be a trusted server. So Windows Admin Center must be able to run CredSSP operations on every server in the cluster, not just on one or a few of them. 
* If you get an error that says `msft.sme.aks couldn't load`, and the error says that loading chunks failed, use the latest version of Microsoft Edge or Google Chrome and try again.
* Before you start either the wizard for setting up Azure Kubernetes Service host or the wizard for creating a Kubernetes cluster, you should sign in to Azure through Windows Admin Center. You might need to sign in again during the workflow. If you're having difficulties signing in to Azure through Windows Admin Center, try signing in to your Azure account from another source, like the [Azure portal](https://portal.azure.com/). If you continue to have problems, check the [Windows Admin Center known issues](/windows-server/manage/windows-admin-center/support/known-issues) article before you contact support.
* In the current iteration of Azure Kubernetes Service on Azure Stack HCI deployment through Windows Admin Center, only the user who set up the Azure Kubernetes Service host can create Kubernetes clusters on the system. To work around this issue, copy the .wssd folder from the profile of the user who set up the Azure Kubernetes Service host to the profile of the user who will be creating the new Kubernetes cluster.
* If you receive an error in either wizard about a wrong configuration, perform cluster cleanup operations. These operations might involve removing the C:\Program Files\AksHci\mocctl.exe file.
* For CredSSP to function successfully in the cluster creation wizard, Windows Admin Center must be installed and used by the same account. If you install Windows Admin Center with one account and try to use it with another, you'll get errors.
* During cluster deployment, you might encounter a problem with the helm.zip file transfer. This problem often causes an error that says the path to the helm.zip file doesn't exist or isn't valid. To resolve this problem, retry the deployment.
* If your deployment hangs for an extended period, you might be having CredSSP or connectivity problems. Try these steps to troubleshoot your deployment: 
    1.	On the machine running Windows Admin Center, run the following command in a PowerShell window: 
          ```PowerShell
          Enter-PSSession <servername>
          ```
    2.	If this command succeeds, you can connect to the server and there's no connectivity issue.
    
    3.	If you're having CredSSP problems, run this command to test the trust between the gateway machine and the target machine: 
          ```PowerShell
          Enter-PSSession –ComputerName <server> –Credential company\administrator –Authentication CredSSP
          ``` 
        You can also run the following command to test the trust in accessing the local gateway: 
          ```PowerShell
          Enter-PSSession -computer localhost -credential (Get-Credential)
          ``` 
* If you're using Azure Arc and have multiple tenant IDs, run the following command to specify your desired tenant before deployment. If you don't, your deployment might fail.

   ```Azure CLI
   az login –tenant <tenant>
   ```
* If you've just created a new Azure account and haven't signed in to the account on your gateway machine, you might experience problems with registering your Windows Admin Center gateway with Azure. To mitigate this problem, sign in to your Azure account in another browser tab or window, and then register the Windows Admin Center gateway to Azure.

### Creating Windows Admin Center logs
When you report problems with Windows Admin Center, it's a good idea to attach logs to help the development team diagnose your problem. Errors in Windows Admin Center generally come in one of two forms: 
- Events that appear in the event viewer on the machine running Windows Admin Center 
- JavaScript problems that surface in the browser console 

To collect logs for Windows Admin Center, use the Get-SMEUILogs.ps1 script that's provided in the public preview package. 
 
To use the script, run this command in the folder where your script is stored: 
 
```PowerShell
./Get-SMEUILogs.ps1 -ComputerNames [comp1, comp2, etc.] -Destination [comp3] -HoursAgo [48] -NoCredentialPrompt
```
 
The command has the following parameters:
 
* `-ComputerNames`: A list of machines you want to collect logs from.
* `-Destination`: The machine you want to aggregate the logs to.
* `-HoursAgo`: The start time for collecting logs, expressed in hours before the time you run the script.
* `-NoCredentialPrompt`: A switch to turn off the credentials prompt and use the default credentials in your current environment.
 
If you have difficulties running this script, you can run the following command to view the Help text: 
 
```PowerShell
GetHelp .\Get-SMEUILogs.ps1 -Examples
```

## Troubleshooting Windows worker nodes 
To sign in to a Windows worker node, first get the IP address of your node by running `kubectl get`. Note the `EXTERNAL-IP` value.

```PowerShell
kubectl get nodes -o wide
``` 
SSH into the node by using `ssh Administrator@ip`. After you SSH into the node, you can run `net user administrator *` to update your administrator password. 

## Troubleshooting Linux worker nodes 
To sign in to a Linux worker node, first get the IP address of your node by running `kubectl get`. Note the `EXTERNAL-IP` value.

```PowerShell
kubectl get nodes -o wide
``` 
SSH into the node by using `ssh clouduser@ip`. 

## Troubleshooting Azure Arc Kubernetes
To learn about troubleshooting common scenarios related to connectivity, permissions, and Arc agents, see [Azure Arc enabled Kubernetes troubleshooting](/azure/azure-arc/kubernetes/troubleshooting).

## Next steps
If you continue to run into problems when you're using Azure Kubernetes Service on Azure Stack HCI, you can file bugs through [GitHub](https://aka.ms/aks-hci-issues).  
