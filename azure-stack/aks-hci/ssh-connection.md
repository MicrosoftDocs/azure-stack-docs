---
title: Connect with SSH to Azure Kubernetes Service on Azure Stack HCI nodes
description: Learn how to connect with SSH to worker nodes for maintenance and troubleshooting in AKS on Azure Stack HCI.
author: mattbriggs
ms.topic: how-to
ms.date: 05/18/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha
---

# Connect with SSH to Windows or Linux worker nodes for maintenance and troubleshooting

You may need to access Windows or Linux worker nodes in AKS on Azure Stack HCI for maintenance, log collection, or other troubleshooting operations. For security purposes, you'll need to create an SSH connection to access the Windows or Linux worker nodes. To SSH to the nodes, you sign in using the node's IP address.

This topic describes how to create an SSH connection to access both Windows and Linux nodes.

## Connect to Windows worker nodes using SSH
To sign in to a Windows worker node using SSH, first get the IP address of your node by running `kubectl get` and capturing the `EXTERNAL-IP` value.

> [!NOTE]
> You must pass the right location to your SSH private key. The following example uses the default location of %systemdrive%\akshci\.ssh\akshci_rsa, but you may need to change this location if you requested a different path by specifying the `-sshPublicKey` parameter for [Set-AksHciConfig](./reference/ps/set-akshciconfig.md).

To get the IP address of the Windows worker node, run the following command:  

```
kubectl --kubeconfig=yourkubeconfig get nodes -o wide
```  

Next, use `ssh Administrator@ip` to SSH in to a Windows node:  

```
ssh -i $env:SYSTEMDRIVE\AksHci\.ssh\akshci_rsa administrator@<IP Address of the Node>
```
  
After you SSH in to the node, you can run `net user administrator *` to update your administrator password. 

## Connect to Linux worker nodes using SSH
To sign in to a Linux worker node using SSH, first get the IP address of your node by running `kubectl get` and capture the `EXTERNAL-IP` value.

> [!NOTE]
> You must pass the right location to your SSH private key. The following example uses the default location of %systemdrive%\akshci\.ssh\akshci_rsa, but you may need to change this location if you requested a different path by specifying the `-sshPublicKey` parameter for [Set-AksHciConfig](./reference/ps/set-akshciconfig.md).

To get the IP address of the Linux worker node:  

```
kubectl --kubeconfig=yourkubeconfig get nodes -o wide
```  

Use `ssh clouduser@ip` to SSH in to the Linux node: 

```
ssh -i $env:SYSTEMDRIVE\AksHci\.ssh\akshci_rsa clouduser@<IP Address of the Node>
```  

After you SSH in to the node, you can run `net user administrator *` to update your administrator password. 

## Next steps
- [Known issues](/azure-stack/aks-hci/known-issues)
- [Windows Admin Center known issues](/azure-stack/aks-hci/known-issues-windows-admin-center)
