---
title: Troubleshooting
description: Guide for troubleshooting Azure Kubernetes Service on Azure Stack HCI
author: davannaw-msft
ms.topic: how-to
ms.date: 09/01/2020
ms.author: dawhite
---

# Troubleshooting Azure Kubernetes Service on Azure Stack HCI
When you create or manage a Kubernetes cluster using Azure Kubernetes Service on Azure Stack HCI, you might occasionally come across problems. Below are the troubleshooting guidelines to help you resolve those issues. 

## Troubleshooting Windows Admin Center
This product is currently in the public preview state, which means it is still in development. Currently there are several issues with the Windows Admin Center Azure Kubernetes Service extension: 
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
``` cmd
az login –tenant<tenant>
```
* If you have just created a new Azure account and have not logged into the account on your gateway machine, you may experience issues registering your WAC gateway with Azure. To mitigate this issue, sign into your Azure account in another browser tab or window, then register the WAC gateway to Azure.
* If you believe you are having issues with Arc during deployment, you may run the following command to view the status of your Arc pods: 
``` cmd
kubectl –kubeconfig=$kcl get pods -A
```