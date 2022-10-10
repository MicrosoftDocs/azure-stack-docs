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

# Limitations and known issues

## KVA timeout error

Azure Arc Resource Bridge is a Kubernetes management cluster that is deployed in an Arc Resource Bridge VM directly on the on-premises infrastructure. While trying to deploy Azure Arc resource bridge, a "KVA timeout error" may appear if there's a networking problem that doesn't allow communication of the Arc Resource Bridge VM to the host, DNS, network or internet. This error is typically displayed for the following reasons:

- The Arc Resource Bridge VM ($VMIP) doesn't have DNS resolution.
- The Arc Resource Bridge VM ($VMIP) or $controlPlaneIP don't have internet access.
- The host isn't able to reach $controlPlaneIP or $VMIP.

To resolve this error, ensure that all IP addresses assigned to the Arc Resource Bridge VM can be resolved by DNS and have access to the internet, and that the host can successfully route to the IP addresses.

## Issues with using Remote Desktop

Deploying Azure Arc Resource Bridge through command line must be performed with line of sight to the on-premises infrastructure. It can't be done in a remote PowerShell window from a machine that isn't a host of the Azure Stack HCI or Windows Server cluster.

## Issues with using AKS-HCI and Azure Arc Resource Bridge

AKS on Azure Stack HCI and Azure Arc Resource Bridge on the same Azure Stack HCI or Windows Server cluster must be enabled in the following deployment order:
    1. Deploy AKS host management cluster 
    2. Deploy Arc Resource Bridge 

If Azure Arc Resource Bridge is already deployed, you cannot deploy the AKS management cluster. Uninstall Azure Arc Resource Bridge before installing AKS host management cluster. You must uninstall in the following order:
    1. Uninstall Arc Resource Bridge
    2. Uninstall the AKS host management cluster

Uninstalling the AKS host management cluster will also uninstall Azure Arc Resource Bridge and all your AKS clusters. You can deploy a new Arc Resource Bridge again after cleanup, but it will not remember the AKS hybrid clusters that were created earlier.

## AKS hybrid cluster names does not support uppercase characters
For this preview, you cannot use any uppercase characters to name your AKS hybrid Azure resource. If you do so, the AKS hybrid cluster create call will fail silently. This will be fixed in an upcoming release.

## After a period of time, `az hybridaks proxy` times out and does not respond to kubectl commands anymore
If this happens to you, close all open command line windows and start a fresh `az hybridaks proxy` session. You should be able to regain access to your AKS hybrid cluster via kubectl.

## I can see the AKS hybrid Azure resource object on the Azure portal but I do not see any VMs/Kubernetes cluster on my on-premises infrastructure
Sometimes, it is possible that while the Azure resource object for the AKS hybrid cluster was created, the on-premises Kubernetes cluster failed to come up. This may happen due to many reasons such as -
- IP address exhaustion in the AKS hybrid vnet supplied during AKS hybrid cluster create
- The infrastructure administrator did not download the right Kubernetes VHD image using `Add-KvaGalleryImage`

If the above reasons do not apply to you, open a [support ticket](/help-support).

## When Azure Arc Resource Bridge is stopped, `az hybridaks` calls complete without errors as if they are successful but nothing happens on-premises
We strongly recommend to never stop Azure Arc Resource Bridge as this could lead to unexpected failures. If you have stopped your Arc Resource Bridge, restart it immediately. If you see unexpected issues, [contact support](/help-support) and let them know that you stopped Arc Resource Bridge.

## When `az hybridaks create` fails the Azure resources on the Azure portal are not deleted
If your `az hybridaks create` command has failed, delete all corresponding Azure resources like AKS hybrid cluster and node pools and then retry the operation. If you try the same command again without deleting the Azure resources first, it might lead to unexpected failures.

## How to get the certificate based admin kubeconfig of AKS hybrid cluster provisioned through Azure

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
