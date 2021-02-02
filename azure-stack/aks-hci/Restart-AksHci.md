---
external help file: 
Module Name: Aks.Hci
online version: 
schema: 
---

# Restart-AksHci

## SYNOPSIS
Restart Azure Kubernetes Service on Azure Stack HCI and remove all deployed Kubernetes clusters.

## SYNTAX

### Restart AKS-HCI
```powershell
Restart-AksHci
```

## DESCRIPTION
Restarting Azure Kubernetes Service on Azure Stack HCI will remove all of your Kubernetes clusters if any, and the Azure Kubernetes Service host. It will also uninstall the Azure Kubernetes Service on Azure Stack HCI agents and services from the nodes. It will then go back through the original install process steps until the host is recreated. The Azure Kubernetes Service on Azure Stack HCI configuration that you configured via Set-AksHciConfig and the downloaded VHDX images are preserved.

## EXAMPLES

### Example
```powershell
PS C:\> Restart-AksHci
```
