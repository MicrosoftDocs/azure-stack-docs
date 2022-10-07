---
title: Known issues with AKS hybrid clusters provisioned from Azure
description: Known issues with AKS hybrid clusters provisioned from Azure
ms.topic: how-to
ms.date: 10/03/2022
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 10/03/2022
ms.reviewer: abha
# Intent: As an IT Pro, I want to learn how to create and manage AKS hybrid clusters on-premises from Azure
---

# Troubleshooting and known issues

## KVA timeout error

Azure Arc Resource Bridge is a Kubernetes management cluster that is deployed in an Arc Resource Bridge VM directly on the on-premises infrastructure. While trying to deploy Azure Arc resource bridge, a "KVA timeout error" may appear if there's a networking problem that doesn't allow communication of the Arc Resource Bridge VM to the host, DNS, network or internet. This error is typically displayed for the following reasons:

- The Arc Resource Bridge VM ($VMIP) doesn't have DNS resolution.
- The Arc Resource Bridge VM ($VMIP) or $controlPlaneIP don't have internet access.
- The host isn't able to reach $controlPlaneIP or $VMIP.

To resolve this error, ensure that all IP addresses assigned to the Arc Resource Bridge VM can be resolved by DNS and have access to the internet, and that the host can successfully route to the IP addresses.

## Issues with using Remote Desktop

Deploying Azure Arc Resource Bridge through command line must be performed with line of sight to the on-premises infrastructure. It can't be done in a remote PowerShell window from a machine that isn't a host of the Azure Stack HCI or Windows Server cluster. To connect on each node of the Azure Stack HCI or Windows Server cluster, use Remote Desktop Protocol (RDP) connected with a domain user admin of the cluster.

## Issues with using AKS-HCI and Azure Arc Resource Bridge

AKS on Azure Stack HCI and Azure Arc Resource Bridge on the same Azure Stack HCI or Windows Server cluster must be enabled in the following deployment order:
    1. Deploy AKS management cluster 
    2. Deploy Arc Resource Bridge 

If Azure Arc Resource Bridge is already deployed, you cannot deploy the AKS management cluster. Uninstall Azure Arc Resource Bridge before installing AKS-HCI. You must uninstall these in the following order:
    1. Uninstall Arc Resource Bridge
    2. Uninstall the AKS management cluster

Uninstalling the AKS management cluster will also uninstall Azure Arc Resource Bridge and all your AKS clusters. You can deploy a new Arc Resource Bridge again after cleanup, but it will not remember the AKS hybrid clusters that were created earlier.

## How to collect logs

Sign in to the Azure Stack HCI or Windows Server cluster and collect logs using the following command: 

```powershell
Get-ArcHciLogs
```

## How to get cert-based admin kubeconfig of AKS hybrid cluster provisioned through Azure

To get the certificate based kubeconfig of your AKS hybrid cluster, sign in to the Azure Stack HCI or Windows Server cluster and then run the following command:

```powershell
Get-TargetClusterAdminCredentials -clusterName <aks hybrid cluster-name> -outfile <location where you want to store the target cluster kubeconfig> -kubeconfig <kubeconfig of Arc Resource Bridge>
```

## How to uninstall the AKS hybrid cluster provisioning from Azure preview

```azurecli
az login
az account set -s <subscriptionID>
```

### Step 1: Delete all preview AKS-HCI clusters and Azure vnets created using Az CLI

```azurecli
az hybridaks delete --resource-group <resource group name> --name <aks-hybrid cluster name>
```

```azurecli
az hybridaks vnet delete --resource-group <resource group name> --name <vnet name>
```

### Step 2: Delete the custom location

```azurecli
az customlocation delete --name <custom location name> --resource-group <resource group name>
```

### Step 3: Delete the cluster extension

```azurecli
az k8s-extension delete --resource-group <resource group name> --cluster-name <arc appliance name> --cluster-type appliances --name <aks-hybrid extension name>
```

### Step 4: Delete the Arc Resource Bridge

```azurecli
az arcappliance delete hci --config-file "<path to working directory>\hci-appliance.yaml"
```

### Step 5: Delete the ArcHCI config files

```powershell
Remove-ArcHciAksConfigFiles -workDirectory <path to working directory>
```
