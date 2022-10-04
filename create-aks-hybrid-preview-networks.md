---
title: Create AKS hybrid networks for AKS hybrid clusters created from Azure
description: Create AKS hybrid networks for AKS hybrid clusters created from Azure
author: abha
ms.author: abha
ms.topic: how-to
ms.date: 09/29/2022
---
> Applies to: Windows Server 2019 or 2022, Azure Stack HCI

# Overview
Once you've deployed Azure Arc Resource Bridge, the infrastructure administrator also needs to create AKS hybrid networks on-premises and connect these networks to Azure. You can choose between DHCP and static IP based networking for your AKS hybrid clusters. 

Make sure that the IP addresses you give here do not overlap with the VIP pool or k8sNodePool you created by running `New-AksHciNetworkSetting` or `New-AksHciClusterNetwork` or `New-ArcHciAksConfigFiles`.

IP address exhaustion can lead Kubernetes cluster deployment failures. As an admin, you need to make sure that the network object you will create below contains sufficient usable IP addresses. For more information, you can [learn more about IP address planning](https://docs.microsoft.com/azure-stack/aks-hci/concepts-node-networking#minimum-ip-address-reservations-for-an-aks-on-azure-stack-hci-deployment).


## Static IP based network (recommended)

| Parameter  |  Parameter details |
| -----------| ------------ |
| $clustervnetname | The name of your virtual network for AKS hybrid clusters |
| $vswitchname | The name of your VM switch |
| $ipaddressprefix | The IP address value of your subnet |
| $gateway | The IP address value of your gateway for the subnet |
| $dnsservers | The IP address value(s) of your DNS servers |
| $vmPoolStart | The start IP address of your VM IP pool. The address must be in range of the subnet. |
| $vmPoolEnd | The end IP address of your VM IP pool. The address must be in range of the subnet. |
| $vipPoolStart | The start IP address of the VIP pool. The address must be within the range of the subnet. The IP addresses in the VIP pool will be used for the API Server and for Kubernetes services. |
| $vipPoolEnd | The end IP address of the VIP pool |
| $appliancekubeconfig | The location where you stored Arc Resource Bridge's kubeconfig |

```powershell
New-KvaVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsServers -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -k8snodeippoolstart $vmPoolStart -k8snodeippoolend $vmPoolEnd -kubeconfig $appliancekubeconfig
```

#### Static IP based network with Vlan
```powershell
New-KvaVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsServers -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -k8snodeippoolstart $vmPoolStart -k8snodeippoolend $vmPoolEnd -kubeconfig $appliancekubeconfig -vlanID $vlanid
```

### DHCP based network

| Parameter  |  Parameter details |
| -----------| ------------ |
| $clustervnetname | The name of your virtual network for AKS hybrid clusters |
| $vswitchname | The name of your VM switch |
| $vipPoolStart | The start IP address of the VIP pool. The IP addresses in the VIP pool will be used for the API Server and for Kubernetes services. Make sure your VIP poo is in the same subnet as the DHCP server but excluded from the DHCP scope. |
| $vipPoolEnd | The end IP address of the VIP pool. |
| $appliancekubeconfig | The location where you stored Arc Resource Bridge's kubeconfig |

```powershell
New-KvaVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -kubeconfig $appliancekubeconfig
```

#### DHCP based network with Vlan
```powershell
New-KvaVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -kubeconfig $appliancekubeconfig -vlanid $vlanid
```

## Connect your on-premises network to Azure 

| Parameter  |  Parameter details |
| -----------| ------------ |
| $clustervnetname | The name of your on-premises virtual network for AKS hybrid clusters. |
| $customlocationID  | ARM ID of the custom location you created in step 4. You can get the ARM ID using `az customlocation show --name <custom location name> --resource-group <azure resource group> --query "id" -o tsv`

```powershell
az hybridaks vnet create -n "hybridaksvnet" -g $resource_group --custom-location $customlocationID --moc-vnet-name $clustervnetname
```

## Assign user role RBAC access to create AKS hybrid clusters

Use the following steps to create AKS hybrid clusters and assign RBAC access:

1. Go to Azure Portal, navigate to the subscription and then resource group that you used to create your Appliance, custom location and connected your on-premises network.
2. Go to IAM in the left-hand side of the portal.
3. Click **Role assignment** -> **Add assignment**.
4. Type in the name of the end user and assign them *contributor* access.


## Download the Kubernetes VHD file 
Run the following command to download the Linux VHD file specific to the Kubernetes version. For this preview release, you can only download the VHD file for Kubernetes version 1.21.9

```powershell
Add-KvaGalleryImage -kubernetesVersion 1.21.9
```

## Give the end user the following details 
Provide the following details to the end user:

| Parameter |  Parameter details |
| --------- | ------------------|
| Azure subscription ID | The Azure subscription ID you used for all the above steps.
| Custom-location-id  | ARM ID of the custom location you created in step 4. You can get the ARM ID using `az customlocation show --name <custom location name> --resource-group <azure resource group> --query "id" -o tsv`
| vnet-id | ARM ID of the Azure hybridaks vnet you created in step 6. You can get the ARM ID using `az hybridaks vnet show --name <vnet name> --resource-group <azure resource group> --query "id" -o tsv` |

# Next Steps
[Create and manage AKS hybrid clusters from Azure CLI]()
