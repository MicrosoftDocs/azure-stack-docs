---
title: Troubleshooting common issues in Azure Kubernetes Service on Azure Stack HCI
description: This article provides information about troubleshooting Azure Kubernetes Service on Azure Stack HCI.
author: v-susbo
ms.topic: how-to
ms.date: 12/02/2020
ms.author: v-susbo
---

# AKS on Azure Stack HCI troubleshooting 

When you create or manage a Kubernetes cluster by using Azure Kubernetes Service on Azure Stack HCI, you might occasionally come across problems. This article provides troubleshooting guidelines to help you resolve those problems.

## Troubleshoot Azure Stack HCI issues
To troubleshoot cluster validation reporting for network and storage QoS (quality of service) settings across servers in an Azure Stack HCI cluster and verify that important rules are defined, see [Troubleshoot cluster validation reporting](../hci/manage/validate-qos.md).

To learn about troubleshooting problems with CredSSP, see [Troubleshoot CredSSP](../hci/manage/troubleshoot-credssp.md).

## Troubleshoot Windows worker nodes 
To sign in to a Windows worker node using SSH, first get the IP address of your node by running `kubectl get` and capturing the `EXTERNAL-IP` value.

> [!NOTE]
> You must pass the right location to your SSH private key. The following example uses the default location of %systemdrive%\akshci\.ssh\akshci_rsa, but you may need to change this location if you requested a different path by specifying the `-sshPublicKey` parameter for [Set-AksHciConfig](./set-akshciconfig.md).

To get the IP address of the Windows worker node:  

```
kubectl --kubeconfig=yourkubeconfig get nodes -o wide
```  

Use `ssh Administrator@ip` to SSH in to a Windows node:  

```
ssh -i $env:SYSTEMDRIVE\AksHci\.ssh\akshci_rsa administrator@<IP Address of the Node>
```
  
After you SSH in to the node, you can run `net user administrator *` to update your administrator password. 


## Troubleshoot Linux worker nodes 
To sign in to a Linux worker node using SSH, first get the IP address of your node by running `kubectl get` and capture the `EXTERNAL-IP` value.


   > [!NOTE]
   > You must pass the right location to your SSH private key. The following example uses the default location of %systemdrive%\akshci\.ssh\akshci_rsa, but you may need to change this location if you requested a different path by specifying the `-sshPublicKey` parameter for [Set-AksHciConfig](./set-akshciconfig.md).

To get the IP address of the Linux worker node:  

```
kubectl --kubeconfig=yourkubeconfig get nodes -o wide
```  

Use `ssh clouduser@ip` to SSH in to the Linux node: 

```
ssh -i $env:SYSTEMDRIVE\AksHci\.ssh\akshci_rsa clouduser@<IP Address of the Node>
```  

After you SSH in to the node, you can run `net user administrator *` to update your administrator password. 

## Troubleshoot Azure Arc Kubernetes
To learn about troubleshooting common scenarios related to connectivity, permissions, and Arc agents, see [Azure Arc enabled Kubernetes troubleshooting](/azure/azure-arc/kubernetes/troubleshooting).

## Next steps
- [Troubleshoot Windows Admin Center](./troubleshoot-windows-admin-center.md)
- [Resolve known issues](./troubleshoot-known-issues.md)

If you continue to run into problems when you're using Azure Kubernetes Service on Azure Stack HCI, you can file bugs through [GitHub](https://aka.ms/aks-hci-issues).
