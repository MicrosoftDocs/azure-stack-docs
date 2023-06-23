---
title: Create AKS hybrid networks for AKS hybrid clusters created from Azure
description: Create AKS hybrid networks for AKS hybrid clusters created from Azure
author: abha
ms.author: abha
ms.topic: how-to
ms.date: 09/29/2022
---

# How to create AKS hybrid networks for Azure

> Applies to: Windows Server 2019 or 2022, Azure Stack HCI

Once you've deployed Azure Arc Resource Bridge, the infrastructure administrator also needs to create AKS hybrid networks on-premises and connect these networks to Azure. You can choose between DHCP and static IP based networking for your AKS hybrid clusters. 

## Before you begin
Before you begin, make sure you meet the following requirements:
- Have access to an Azure subscription.
- Have installed the Azure Arc Resource Bridge, deployed the AKS hybrid extension and created a Custom Location. If you have not, visit [Deploy Azure Arc Resource Bridge](deploy-arc-resource-bridge-windows-server.md).
- Make sure that the IP addresses you give here do not overlap with the VIP pool or k8sNodePool you created by running `New-AksHciNetworkSetting`, `New-AksHciClusterNetwork`, or `New-ArcHciAksConfigFiles`.


IP address exhaustion can lead to Kubernetes cluster deployment failures. As an admin, you must make sure that the network object you create below contains sufficient usable IP addresses. For more information, you can [learn more about IP address planning](concepts-node-networking.md#minimum-ip-address-reservations-for-an-aks-hybrid-deployment).

## Install pre-requisite PowerShell modules
Run the following commands on all nodes of your Azure Stack HCI or Windows Server cluster:

```PowerShell
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted 
Install-PackageProvider -Name NuGet -Force  
Install-Module -Name PowershellGet -Force 
Exit 
```

Open a new elevated PowerShell window and run the following command on all nodes of your Azure Stack HCI or Windows Server cluster:

```PowerShell
Install-Module -Name ArcHci -Repository PSGallery -AcceptLicense -Force -RequiredVersion 0.2.23
Exit 
```

## Choose between Static IP [recommended] and DHCP based networks

You can choose between Static IP and DHCP based networks for your AKS hybrid clusters. Run the following commands from any one node on your physical cluster.

### [Static IP](#tab/staticip)

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

```powershell
New-ArcHciVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsServers -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -k8snodeippoolstart $vmPoolStart -k8snodeippoolend $vmPoolEnd 
```

#### Static IP based network with Vlan

```powershell
New-ArcHciVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsServers -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -k8snodeippoolstart $vmPoolStart -k8snodeippoolend $vmPoolEnd -vlanID $vlanid
```

### [DHCP](#tab/dhcp)

| Parameter  |  Parameter details |
| -----------| ------------ |
| $clustervnetname | The name of your virtual network for AKS hybrid clusters |
| $vswitchname | The name of your VM switch |
| $vipPoolStart | The start IP address of the VIP pool. The IP addresses in the VIP pool will be used for the API Server and for Kubernetes services. Make sure your VIP pool is in the same subnet as the DHCP server but excluded from the DHCP scope. |
| $vipPoolEnd | The end IP address of the VIP pool. |

```powershell
New-ArcHciVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd
```

#### DHCP based network with Vlan

```powershell
New-ArcHciVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -vlanid $vlanid
```
---

## Connect your on-premises AKS hybrid network to Azure 

Once you've created the on-premises network, run the following command to connect it to Azure.

| Parameter  |  Parameter details |
| -----------| ------------ |
| $clustervnetname | The name of your on-premises virtual network for AKS hybrid clusters. |
| $customlocationID  | ARM ID of the custom location you created on top of Azure Arc Resource Bridge. You can get the ARM ID using `az customlocation show --name <custom location name> --resource-group <azure resource group> --query "id" -o tsv`

```azurecli
az hybridaks vnet create -n <Name of your Azure connected AKS hybrid vnet> -g $resource_group --custom-location $customlocationID --moc-vnet-name $clustervnetname
```

## Assign user role RBAC access to create AKS hybrid clusters

If someone other than you will be creating the AKS hybrid clusters, use the following steps to assign RBAC access to other users in your organization:

1. Go to the Azure portal, navigate to the subscription and then the resource group that you used to create your appliance, custom location, and connected your on-premises network.
2. Go to IAM in the left-hand side of the portal.
3. Select **Role assignment** -> **Add assignment**.
4. Type the name of the end user and assign them **contributor** access.


## Download the Kubernetes VHD file

Run the following command to download the VHD file specific for `v1.22.11` Kubernetes version. For this preview release, you can only download the VHD file for Kubernetes version 1.22.11:

### [For Linux nodes](#tab/linux-vhd)
```powershell
Import-Module 'C:\Program Files\WindowsPowerShell\Modules\ArcHci\0.2.23\ArcHci.psm1' -Force
$mocConfig = Get-MocConfig
$k8sVersion = "1.22.11"
$mocVersion = "1.0.16.10113"
$imageType = "Linux"
$imageName = Get-LegacyKubernetesGalleryImageName -imagetype $imageType -k8sVersion $k8sVersion
$galleryImage = $null

# Check if requested k8s gallery image is already present
try {
    $galleryImage = Get-MocGalleryImage -name $imageName -location $mocConfig.cloudLocation
} catch {}

if ($null -ine $galleryImage) {
    Write-Output "$imageType $k8sVersion k8s gallery image already present in MOC"
} else {
    $imageRelease = Get-ImageReleaseManifest -imageVersion $mocVersion -operatingSystem $imageType -k8sVersion $k8sVersion -moduleName "Moc"

    Write-Output "Downloading $imageType $k8sVersion k8s gallery image"
    $result = Get-ImageRelease -imageRelease $imageRelease -imageDir $mocConfig.imageDir -moduleName "Moc" -releaseVersion $mocVersion

    Write-Output "Adding $imageType $k8sVersion k8s gallery image to MOC"
    New-MocGalleryImage -name $imageName -location $mocConfig.cloudLocation -imagePath $result -container "MocStorageContainer"
}
```

### [For Windows nodes](#tab/windows-vhd)
```powershell
Import-Module 'C:\Program Files\WindowsPowerShell\Modules\ArcHci\0.2.23\ArcHci.psm1' -Force
$mocConfig = Get-MocConfig
$k8sVersion = "1.22.11"
$mocVersion = "1.0.16.10113"
$imageType = "Windows"
$imageName = Get-LegacyKubernetesGalleryImageName -imagetype $imageType -k8sVersion $k8sVersion
$galleryImage = $null

# Check if requested k8s gallery image is already present
try {
    $galleryImage = Get-MocGalleryImage -name $imageName -location $mocConfig.cloudLocation
} catch {}

if ($null -ine $galleryImage) {
    Write-Output "$imageType $k8sVersion k8s gallery image already present in MOC"
} else {
    $imageRelease = Get-ImageReleaseManifest -imageVersion $mocVersion -operatingSystem $imageType -k8sVersion $k8sVersion -moduleName "Moc"

    Write-Output "Downloading $imageType $k8sVersion k8s gallery image"
    $result = Get-ImageRelease -imageRelease $imageRelease -imageDir $mocConfig.imageDir -moduleName "Moc" -releaseVersion $mocVersion

    Write-Output "Adding $imageType $k8sVersion k8s gallery image to MOC"
    New-MocGalleryImage -name $imageName -location $mocConfig.cloudLocation -imagePath $result -container "MocStorageContainer"
}


```

---

## Give the end user the following details

If someone other than you will be creating the AKS hybrid cluster, provide the following details to the AKS hybrid cluster creator:

| Parameter |  Parameter details |
| --------- | ------------------|
| Azure subscription ID | The Azure subscription ID you used for all the above steps.
| Custom-location-id  | ARM ID of the custom location you created on top of Azure Arc Resource Bridge. You can get the ARM ID using `az customlocation show --name <custom location name> --resource-group <azure resource group> --query "id" -o tsv`
| vnet-id | ARM ID of the Azure hybridaks vnet you created in this document. You can get the ARM ID using `az hybridaks vnet show --name <vnet name> --resource-group <azure resource group> --query "id" -o tsv` |

## Next steps

[Create and manage AKS hybrid clusters using Azure CLI](create-aks-hybrid-preview-cli.md)
