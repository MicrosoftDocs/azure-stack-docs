---
title: Known issues with AKS hybrid clusters provisioned from Azure
description: Known issues with AKS hybrid clusters provisioned from Azure
ms.topic: how-to
ms.custom:
  - devx-track-azurecli
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

Deploying Azure Arc Resource Bridge through command line must be performed with line of sight to the on-premises infrastructure. It can't be done in a remote PowerShell window from a machine that isn't a host of the Azure Stack HCI or Windows Server cluster.

## Issues with using AKS-HCI and Azure Arc Resource Bridge

AKS on Azure Stack HCI and Azure Arc Resource Bridge on the same Azure Stack HCI or Windows Server cluster must be enabled in the following deployment order
- Step 1: Deploy AKS host management cluster 
- Step 2: Deploy Arc Resource Bridge 

If Azure Arc Resource Bridge is already deployed, you can't deploy the AKS management cluster. Uninstall Azure Arc Resource Bridge before installing AKS host management cluster. You must uninstall in the following order:
- Step 1: Uninstall Arc Resource Bridge
- Step 2: Uninstall the AKS host management cluster

Uninstalling the AKS host management cluster will also uninstall Azure Arc Resource Bridge and all your AKS clusters. You can deploy a new Arc Resource Bridge again after cleanup, but it will not remember the AKS hybrid clusters that were created earlier.

## my AKS hybrid cluster create call has timed out 
If your AKS hybrid cluster create call has timed out, or if you see the AKS hybrid cluster resource come up on Azure but if you don't see any VMs/Kubernetes cluster on-premises, it's possible that the AKS hybrid cluster create command has timed out and failed silently. This can happen due to the following identified reasons:

### The infrastructure administrator didn't download the Kubernetes VHD image using `Add-ArcHciK8sGalleryImage`
Make sure the infrastructure administrator downloaded the Kubernetes VHD image using `Add-ArcHciK8sGalleryImage`. If your infrastructure administrator didn't download the Kubernetes VHD image, the AKS hybrid cluster create call will time out and fail silently. To download the Kubernetes VHD image, visit [this page.](/azure/aks/hybrid/create-aks-hybrid-preview-networks?tabs=staticip%2Clinux-vhd#download-the-kubernetes-vhd-file) This issue will be fixed in an upcoming release. 

### The AKS hybrid vnet you used ran out of IP addresses
If the AKS hybrid vnet used for creating the AKS hybrid cluster runs out of IP addresses, the AKS hybrid cluster create will time out and fail silently. Make sure your infrastructure administrator gives you access to another AKS hybrid vnet [by following this documentation.](/azure/aks/hybrid/create-aks-hybrid-preview-networks?tabs=staticip%2Clinux-vhd) At this point, it's not possible to edit an AKS hybrid vnet once it has been created.

### You used an uppercase character for your AKS hybrid cluster name
For this preview, you can't use any uppercase characters to name your AKS hybrid cluster resource. If you do so, the AKS hybrid cluster create call will time out and fail silently. This issue will be fixed in an upcoming release.

### Incorrect syntax for --kubernetes-version parameter during `az hybridaks create`
The `az hybridaks create` command will time out and fail silently if you supply a `--kubernetes-version` other than `v1.22.11.` Right now, we **only** support `v1.22.11`.

If none of the above reasons apply to you, open a [GitHub issue](https://github.com/Azure/aks-hci/issues) so that we may help you with your deployment.

## I cannot use the AksHci PowerShell module or Windows Admin Center to manage my Azure provisioned AKS hybrid clusters
Right now, you cannot use local AksHci PowerShell module or Windows Admin Center to manage your Azure provisioned AKS hybrid preview clusters. You can only use Azure CLI to manage your AKS hybrid clusters once they've been created. We'll be adding extra day 2 operations and scenarios both through a local CLI option as well as in Azure portal in upcoming releases.

## I cannot use `az connectedk8s` commands to manage my Azure provisioned AKS hybrid clusters
You cannot use `az connectedk8s` commands to manage Azure Arc on your Azure provisioned AKS hybrid preview clusters. This is because `az connectedk8s` points to `Microsoft.Kubernetes` Azure resource type and Azure provisioned AKS hybrid clusters have a different Azure resource type - `Microsoft.HybridContainerService`.

## After a period of time, `az hybridaks proxy` times out and doesn't respond to kubectl commands anymore
If this happens to you, close all open command line windows and start a fresh `az hybridaks proxy` session. You should be able to regain access to your AKS hybrid cluster via kubectl.

## When Azure Arc Resource Bridge is stopped, `az hybridaks` calls complete without errors but I don't see any AKS hybrid clusters on-premises
We strongly recommend to never stop Azure Arc Resource Bridge as this could lead to unexpected failures. If you have stopped your Arc Resource Bridge, restart it immediately. If you see unexpected issues, open a [GitHub issue](https://github.com/Azure/aks-hci/issues) and let us know that you stopped Arc Resource Bridge.

## When `az hybridaks create` fails the Azure resources on the Azure portal are not deleted
If your `az hybridaks create` command has failed, delete all corresponding Azure resources like AKS hybrid cluster and node pools and then retry the operation. If you try the same command again without deleting the Azure resources first, it might lead to unexpected failures.

## Default node pool name can't be changed
For this preview, we don't allow changing the name of the default node pool. This option will be added in an upcoming release.

## How to get the certificate based admin kubeconfig of Azure provisioned AKS hybrid cluster 

To get the certificate based kubeconfig of your AKS hybrid cluster, sign in to the Azure Stack HCI or Windows Server cluster and then run the following command.

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| $controlPlaneIP |  VM IP of the AKS hybrid cluster's control plane VM.  |
| $sshPrivateKey  |  SSH private key location of the AKS hybrid cluster. The default value is  `.\.ssh\id_rsa`  |
| $outfile  |  Location where you want to store the AKS hybrid Kubernetes cluster's kubeconfig. You will use this kubeconfig in `kubectl` commands to access the AKS hybrid cluster. |

```powershell
Get-TargetClusterAdminCredentials -controlPlaneIP $controlPlaneIP -sshPrivateKey $sshPrivateKey -outfile $outfile
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
