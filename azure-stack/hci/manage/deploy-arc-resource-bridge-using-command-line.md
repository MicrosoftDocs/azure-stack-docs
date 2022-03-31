---
title: Deploy Azure Arc Resource Bridge using command line
description: Learn how to deploy Azure Arc Resource Bridge on Azure Stack HCI using command line
author: ManikaDhiman
ms.topic: how-to
ms.date: 03/24/2022
ms.author: v-mandhiman
ms.reviewer: JasonGerend
---

# Deploy Azure Arc Resource Bridge using command line

> Applies to: Azure Stack HCI, version 21H2

To enable virtual machine (VM) provisioning through the Azure portal on Azure Stack HCI, you need to deploy [Azure Arc Resource Bridge](azure-arc-enabled-virtual-machines.md#what-is-azure-arc-resource-bridge).

You can deploy Azure Arc Resource Bridge on the Azure Stack HCI cluster using Windows Admin Center or command line.

This article describes how to use command line to deploy Azure Arc Resource Bridge, which includes:

- [Installing PowerShell modules and updating extensions](#install-powershell-modules-and-update-extensions)
- [Creating custom location](#create-a-custom-location-by-installing-azure-arc-resource-bridge)
- [Creating virtual network and gallery image](#create-virtual-network-and-gallery-image)


If you want to deploy Azure Arc Resource Bridge using Windows Admin Center, see [Deploy Azure Arc Resource Bridge using Windows Admin Center](deploy-arc-resource-bridge-using-wac.md).

For more information about VM provisioning through the Azure portal, see [VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-enabled-virtual-machines.md).

## Before you begin

Before you begin the Azure Arc Resource Bridge deployment, plan out and configure your physical and host network infrastructure. Reference the following sections:

- [Prerequisites for deploying Azure Arc Resource Bridge](azure-arc-enabled-virtual-machines.md#prerequisites-for-deploying-azure-arc-resource-bridge)
- [Network port requirements](azure-arc-enabled-virtual-machines.md#network-port-requirements)
- [Firewall URL exceptions](azure-arc-enabled-virtual-machines.md#firewall-url-exceptions)

## Install PowerShell modules and update extensions

To prepare to install Azure Arc Resource Bridge on an Azure Stack HCI cluster and create a VM cluster-extension, perform these steps through Remote Desktop Protocol (RDP) or console session. Remote Powershell isn't supported.

1. Install the required PowerShell modules by running the following cmdlet as an administrator on all servers of the Azure Stack HCI cluster:

   ```PowerShell
   Install-PackageProvider -Name NuGet -Force 
   Install-Module -Name PowershellGet -Force -Confirm:$false -SkipPublisherCheck  
   ```
   
   Restart any open PowerShell windows.
   
   ```PowerShell
   Install-Module -Name Moc -Repository PSGallery -AcceptLicense -Force
   Initialize-MocNode
   Install-Module -Name ArcHci -Force -Confirm:$false -SkipPublisherCheck -AcceptLicense
   ```

2. Restart PowerShell and then provide inputs for the following in the PowerShell window on any one server of the cluster, using the parameters described below.

   ```PowerShell
   $vswitchName="<Switch-Name>"
   $controlPlaneIP="<IP-address>" 
   $csv_path="<input-from-admin>"
   $vlanID="<vLAN-ID>" (Optional)
   $cloudServiceIP="<IP-address>" (Optional)
   ```

   **vswitchName**: Should match the name of the switch on the host. The network served by this vmswitch must be able to provide static IP addresses for the **controlPlaneIP**.
   
   **controlPlaneIP**: The IP address that is used for the load balancer in the Arc Resource Bridge. The IP address must be in the same subnet as the DHCP scope and must be excluded from the DHCP scope to avoid IP address conflicts.
   
   **csv_path**: A CSV volume path that is accessible from all servers of the cluster. This is used for caching OS images used for the Azure Arc Resource Bridge. It also stores temporary configuration files during installation and cloud agent configuration files after installation; for example, `C:\ClusterStorage\contosoVol\`.
   
   **vLanID** (optional): vLAN identifier.
   
   **cloudServiceIP** (required only for static IP configurations): The IP address of the cloud agent running underneath the resource bridge. This is required if the cluster servers have statically assigned IP addresses. The IP must be carved from the underlay network (physical network).

3. Prepare configuration for Azure Arc Resource Bridge:

   ```PowerShell
   $vnet=New-MocNetworkSetting -Name hcirb-vnet -vswitchName $vswitchName -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP [-vLanID=$vLANID]
   Set-MocConfig -workingDir $csv_path\ResourceBridge  -vnet $vnet -imageDir $csv_path\imageStore -skipHostLimitChecks -cloudConfigLocation $csv_path\cloudStore -catalog aks-hci-stable-catalogs-ext -ring stable [-CloudServiceIP <$CloudServiceIP>]
   Install-moc
   ```
   > [!TIP]
   > See Known Limitations if Azure Kubernetes Service is also enabled to run on this cluster.
   
   > [!TIP]
   > To provide a static IP address to the Azure Arc Resource Bridge VM, replace the previous command with:
   >
   > ```powershell
   > $vnet=New-MocNetworkSetting -Name hcirb-vnet -vswitchName $vswitchName -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP [-vLanID=$vLANID] -k8snodeippoolstart $staticIPaddress -k8snodeippoolend $staticIPaddress -gateway $gateway -dnsservers $dnsservers -ipaddressprefix $ipaddressprefix
   > ```

4. Update the required extensions:
   
   - Uninstall the old extensions:
     
     ```azurecli
     az extension remove --name arcappliance
     az extension remove --name connectedk8s
     az extension remove --name k8s-configuration
     az extension remove --name k8s-extension
     az extension remove --name customlocation
     az extension remove --name azurestackhci
     ```
   
   - Install the new extensions:
   
     ```azurecli
     az extension add --upgrade --name arcappliance
     az extension add --upgrade --name connectedk8s
     az extension add --upgrade --name k8s-configuration
     az extension add --upgrade --name k8s-extension
     az extension add --upgrade --name customlocation
     az extension add --upgrade --name azurestackhci
     ```

## Create a custom location by installing Azure Arc Resource Bridge

To create a custom location, install Azure Arc Resource Bridge by launching an elevated PowerShell window and perform these steps:

1. Provide inputs for the following, using the parameters described below.
   
   ```PowerShell
   $resource_group="<pre-created resource group in Azure>"
   $subscription="subscription ID in Azure"
   $Location="<Azure Region - Available regions include 'eastus', 'eastus2euap' and 'westeurope'>"
   $customloc_name="<name of the custom location, such as HCICluster -cl>"
   ```
   
   > [!TIP]
   > Run `Get-AzureStackHCI`to find these details.

2. Log in to your Azure subscription and get the extension and providers for Azure Arc Resource Bridge:
   
   ```azurecli
   az login --use-device-code
   az account set --subscription $subscription
   az provider register --namespace Microsoft.Kubernetes
   az provider register --namespace Microsoft.KubernetesConfiguration
   az provider register --namespace Microsoft.ExtendedLocation
   az provider register --namespace Microsoft.ResourceConnector
   az provider register --namespace Microsoft.AzureStackHCI
   az feature register --namespace Microsoft.ResourceConnector --name Appliances-ppauto
   ```
   
3. Run the following cmdlets:

   ```PowerShell
   $resource_name= ((Get-AzureStackHci).AzureResourceName) + "-arcbridge"
   mkdir $csv_path\ResourceBridge
   New-ArcHciConfigFiles -subscriptionID $subscription -location $Location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge
   az arcappliance prepare hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml
   ```
   
   ```PowerShell
   az arcappliance deploy hci --config-file  $csv_path\ResourceBridge\hci-appliance.yaml --outfile $env:USERPROFILE\.kube\config
   ```
   
   ```PowerShell
   az arcappliance create hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --kubeconfig $env:USERPROFILE\.kube\config
   ```
   
4. Verify that the Arc appliance is running. Keep running the following cmdlets until the appliance provisioning state is **Succeeded** and the status is **Running**. This operation can take up to five minutes.

   ```azurecli
   az arcappliance show --resource-group $resource_group --name $resource_name
   ```

5. Add the required extensions for VM management capabilities to be enabled via the newly deployed Arc Resource Bridge:

    ```azurecli
    $hciClusterId= (Get-AzureStackHci).AzureResourceUri
    az k8s-extension create --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --extension-type Microsoft.AZStackHCI.Operator --scope cluster --release-namespace helm-operator2 --configuration-settings Microsoft.CustomLocation.ServiceAccount=hci-vmoperator --configuration-protected-settings-file $csv_path\ResourceBridge\hci-config.json --configuration-settings HCIClusterID=$hciClusterId --auto-upgrade true
    ```

6. Verify that the extensions are installed. Keep running the following cmdlet until the extension provisioning state is **Succeeded**. This operation can take up to five minutes.

   ```azurecli
   az k8s-extension show --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator
   ```

7. Create a custom location for the Azure Stack HCI cluster, where **customloc_name** is the name of the custom location, such as "HCICluster -cl":

   ```azurecli
   az customlocation create --resource-group $resource_group --name $customloc_name --cluster-extension-ids "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name/providers/Microsoft.KubernetesConfiguration/extensions/hci-vmoperator" --namespace hci-vmoperator --host-resource-id "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name" --location $Location
   ```

Now you can navigate to the resource group in Azure and see the custom location and Azure Arc Resource Bridge that you've created for the Azure Stack HCI cluster.

## Create virtual network and gallery image

Now that the custom location is available, you can create or add virtual networks and gallery images for the custom location associated with the Azure Stack HCI cluster.

1. Create or add a network switch for VMs. Make sure you have an external vmswitch deployed on all hosts of the Azure Stack HCI cluster. Provide the vmswitch name that will be used for network interfaces during VM provisioning. The parameter **vnetName** should be the name of the virtual network from the hosts of the cluster, for example: "myvnet".

   ```azurecli
   $vnetName=<name of the vnet>
   az azurestackhci virtualnetwork create --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --network-type "Transparent" --name $vnetName
   ```

2. Create an OS gallery image that will be used for creating VMs by running the following cmdlets, supplying the parameters described below. Make sure you have a Windows or Linux VHDX image copied locally on the host. The VHDX image must be gen-2 type and have secure-boot enabled. It should reside on a Cluster Shared Volume available to all servers in the cluster. Arc-enabled Azure Stack HCI supports Windows and Linux operating systems.

   ```azurecli
   $galleryImageName=<gallery image name>
   $galleryImageSourcePath=<path to the source gallery image>
   $osType="<Windows/Linux>"
   az azurestackhci galleryimage create --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --image-path $galleryImageSourcePath --name $galleryImageName --os-type $osType
   ```
   
   **galleryImageName**: Name of the gallery image, for example: "win-os". Note that Azure rejects all names that contains the keyword "Windows".
   
   **galleryImageSourcePath**: Path to the source gallery image VHDX. Example: "C:\OSImages\winos.vhdx"
   
   **osType**: The OS type. Can be "Windows" or "Linux". Example: "Windows"

## Next steps

- [Go to the Azure portal to create VMs](https://portal.azure.com/#home)
- [Manage virtual machines in Azure portal](manage-virtual-machines-in-azure-portal.md)
