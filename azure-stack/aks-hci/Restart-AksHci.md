---
title: Restart-AksHci
author: jessicaguan
description: The Restart-AksHci PowerShell command restarts AKS on Azure Stack HCI and removes all deployed Kubernetes clusters.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# Restart-AksHci

## Synopsis
Restart Azure Kubernetes Service on Azure Stack HCI and remove all deployed Kubernetes clusters.

## Syntax

### Restart AKS-HCI
```powershell
Restart-AksHci
```

## Description
Restarting Azure Kubernetes Service on Azure Stack HCI will remove all of your Kubernetes clusters if any, and the Azure Kubernetes Service host. The restart process will also uninstall the Azure Kubernetes Service on Azure Stack HCI agents and services from the nodes. It will then go back through the original install process steps until the host is recreated. The Azure Kubernetes Service on Azure Stack HCI configuration that you configured via Set-AksHciConfig and the downloaded VHDX images are preserved.

## Examples

### Example
```powershell
PS C:\> Restart-AksHci
```
