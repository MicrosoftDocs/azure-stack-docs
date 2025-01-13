---
title: Connect with SSH to Azure Kubernetes Service nodes
description: Learn how to use Secure Shell Protocol (SSH) to connect to worker nodes for maintenance and troubleshooting in AKS enabled by Azure Arc.
author: sethmanheim
ms.topic: how-to
ms.custom: linux-related-content
ms.date: 06/27/2024
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha

# Intent: As an IT Pro, I want to learn how to use SSH to connect to my Windows and Linux worker nodes when I need to perform maintenance and troubleshoot issues. 
# Keyword: SSH connection maintenance worker nodes
---

# Connect with SSH to Windows or Linux worker nodes for maintenance and troubleshooting

[!INCLUDE [aks-hybrid-applies-to-azure-stack-hci-windows-server-sku](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

You might need to access Windows or Linux worker nodes in AKS enabled by Azure Arc for maintenance, log collection, or other troubleshooting operations. For security purposes, you must create a Secure Shell Protocol (SSH) connection to access the Windows or Linux worker nodes. To use SSH, you sign in using the node's IP address.

This article describes how to create an SSH connection to access both Windows and Linux nodes.

## Use SSH to connect to Windows worker nodes

To use SSH to sign in to a Windows worker node, run `kubectl get` to obtain the IP address of your node and capture the `EXTERNAL-IP` value.

> [!NOTE]
> You must pass the correct location to your SSH private key. The following example uses the default location of **%systemdrive%\akshci\.ssh\akshci_rsa**, but you might need to change this location if you requested a different path. To change the location, specify the `-sshPublicKey` parameter for [Set-AksHciConfig](./reference/ps/set-akshciconfig.md).

To obtain the IP address of the Windows worker node, run the following command:

```cmd
kubectl --kubeconfig=yourkubeconfig get nodes -o wide
```  

Next, run `ssh Administrator@ip` to connect to a Windows node:  

```cmd
ssh -i $env:SYSTEMDRIVE\AksHci\.ssh\akshci_rsa administrator@<IP Address of the Node>
```
  
After you use SSH to connect to the node, you can run `net user administrator *` to update your administrator password.

## Use SSH to connect to Linux worker nodes

To use SSH to sign in to a Linux worker node, first run `kubectl get` to obtain the IP address of your node and capture the `EXTERNAL-IP` value.

> [!NOTE]
> You must pass the correct location to your SSH private key. The following example uses the default location of **%systemdrive%\akshci\.ssh\akshci_rsa**, but you might need to change this location if you requested a different path. To change the location, specify the `-sshPublicKey` parameter for [Set-AksHciConfig](./reference/ps/set-akshciconfig.md).

To obtain the IP address of the Linux worker node:  

```cmd
kubectl --kubeconfig=yourkubeconfig get nodes -o wide
```  

Use `ssh clouduser@ip` to connect to the Linux node:

```cmd
ssh -i $env:SYSTEMDRIVE\AksHci\.ssh\akshci_rsa clouduser@<IP Address of the Node>
```  

After you use SSH to connect to the node, you can run `net user administrator *` to update your administrator password.

## Next steps

- [Known issues](known-issues.yml).
- [Windows Admin Center known issues](/azure-stack/aks-hci/known-issues-windows-admin-center).
