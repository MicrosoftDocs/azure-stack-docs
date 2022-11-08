---
title: Set up Azure Arc VM management using command line
description: Learn how to set up Azure Arc VM management on Azure Stack HCI using command line.
author: ManikaDhiman
ms.topic: how-to
ms.date: 10/06/2022
ms.author: v-mandhiman
ms.reviewer: alkohli
---

# Set up Azure Arc VM management using command line

> Applies to: Azure Stack HCI, versions 22H2 and version 21H2

This article describes how to use Azure Command-Line Interface (CLI) to set up Azure Arc VM management, which includes:

- [Installing PowerShell modules and updating extensions](#install-powershell-modules-and-update-extensions)
- [Creating custom location](#create-a-custom-location-by-installing-azure-arc-resource-bridge)
- [Creating virtual network](create-virtual-networks.md)

To set up Azure Arc VM management using Windows Admin Center, see [Set up Azure Arc VM management using Windows Admin Center](deploy-arc-resource-bridge-using-wac.md).

For an overview of Azure Arc VM management, see [What is Azure Arc VM management?](azure-arc-vm-management-overview.md)

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure:

- The latest version of Azure CLI is installed. You must install this on all servers in your Azure Stack HCI cluster.

  - To install Azure CLI on each server in a cluster, use Remote Desktop Protocol (RDP) connection.

  - For instructions on installing Azure CLI, see [Install Azure CLI](/cli/azure/install-azure-cli-windows).

    - If you're using a local installation, sign in to the Azure CLI by using the [az login](/cli/azure/reference-index#az-login) command. To finish the authentication process, follow the steps displayed in your terminal. For other sign-in options, see [Sign in with the Azure CLI](/cli/azure/authenticate-azure-cli).

    - When you're prompted, install the Azure CLI extension on first use. For more information about extensions, see [Use extensions with the Azure CLI](/cli/azure/azure-cli-extensions-overview).

    - Run [az version](/cli/azure/reference-index?#az-version) to find the version and dependent libraries that are installed. To upgrade to the latest version, run [az upgrade](/cli/azure/reference-index?#az-upgrade).

- To complete the [prerequisites for setting up Azure Arc VM management](azure-arc-vm-management-prerequisites.md).

## Install PowerShell modules and update extensions

In preparation to install Azure Arc Resource Bridge on an Azure Stack HCI cluster and create a VM cluster-extension, perform these steps through RDP or console session. Remote PowerShell isn't supported.

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

1. Restart PowerShell and then provide inputs for the following in the PowerShell window on any one server of the cluster. Refer to the following table for a description of these parameters.

   ```PowerShell
   $vswitchName="<Switch-Name>"
   $controlPlaneIP="<IP-address>"
   $csv_path="<input-from-admin>"
   $vlanID="<vLAN-ID>" (Optional)
   $VMIP_1="<static IP address for Resource Bridge VM>" (required only for static IP configurations)   
   $VMIP_2="<static IP address for Resource Bridge VM>" (required only for static IP configurations)   
   $DNSServers="<comma separated list of DNS servers. For example: @("192.168.250.250","192.168.250.255") for a list of DNS servers. Or "192.168.250.250" for a single DNS server>" (required only for static IP configurations)
   $IPAddressPrefix="<network address in CIDR notation>" (required only for static IP configurations)
   $Gateway="<IPv4 address of the default gateway>" (required only for static IP configurations)
   $cloudServiceIP="<IP-address>" (required only for static IP configurations)
   ```

   where:

   | Parameter | Description |
   | ----- | ----------- |
   | **vswitchName** | Should match the name of the switch on the host. The network served by this vmswitch must be able to provide static IP addresses for the **controlPlaneIP**.|
   | **controlPlaneIP** | The IP address that is used for the load balancer in the Arc Resource Bridge. The IP address must be in the same subnet as the DHCP scope and must be excluded from the DHCP scope to avoid IP address conflicts. If DHCP is used to assign the control plane IP, then the IP address needs to be reserved. |
   | **csv_path** | A CSV volume path that is accessible from all servers of the cluster. This is used for caching OS images used for the Azure Arc Resource Bridge. It also stores temporary configuration files during installation and cloud agent configuration files after installation. For example: `C:\ClusterStorage\contosoVol`.|
   | **vlanID** | (Optional) vLAN identifier. A `0` value means there's no vLAN ID for optional DNS servers.|
   | **VMIP_1, VMIP_2** | (Required only for static IP configurations) IP address for the Arc Resource Bridge. If you don't specify these parameters, the Arc Resource Bridge will get an IP address from an available DHCP server. |
   | **DNSServers** | (Required only for static IP configurations) Comma separated list of DNS servers. For example: <br>- For a list of DNS servers: `@("192.168.250.250","192.168.250.255")`<br>- For a single DNS server: `"192.168.250.250"` |
   | **IPAddressPrefix** | (Required only for static IP configurations) Network address in CIDR notation. For example: "192.168.0.0/16". |
   | **Gateway** | (Required only for static IP configurations) IPv4 address of the default gateway. |
   | **cloudServiceIP** | (Required only for static IP configurations) The Arc Resource Bridge requires a cloud agent to run on the host. This cloud agent is installed as a [Failover Cluster generic service](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005). cloudServiceIP is the IP address of the Failover Cluster generic service hosting the cloud agent. This IP address must match the IP address of the network that is used for all client access and cluster communications. |

1. Prepare configuration for Azure Arc Resource Bridge. This step varies depending on whether Azure Kubernetes Service (AKS) on Azure Stack HCI is installed or not.
   - **If AKS on Azure Stack HCI is installed.** Skip this step and proceed to step 4 to update the required extensions.
   - **If AKS on Azure Stack HCI is not installed.** Run the following cmdlets to provide an IP address to your Azure Arc Resource Bridge VM:
   
      ### [For static IP address](#tab/for-static-ip-address)

      ```PowerShell
      $vnet=New-MocNetworkSetting -Name hcirb-vnet -vswitchName $vswitchName -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP  

      Set-MocConfig -workingDir $csv_path\ResourceBridge -vnet $vnet -imageDir $csv_path\imageStore -skipHostLimitChecks -cloudConfigLocation $csv_path\cloudStore -catalog aks-hci-stable-catalogs-ext -ring stable -CloudServiceIP $cloudServiceIP -createAutoConfigContainers $false

      Install-Moc
      ```

      ### [For dynamic IP address](#tab/for-dynamic-ip-address)

      ```PowerShell
      $vnet=New-MocNetworkSetting -Name hcirb-vnet -vswitchName $vswitchName -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP

      Set-MocConfig -workingDir $csv_path\ResourceBridge -vnet $vnet -imageDir $csv_path\imageStore -skipHostLimitChecks -cloudConfigLocation $csv_path\cloudStore -catalog aks-hci-stable-catalogs-ext -ring stable -createAutoConfigContainers $false

      Install-Moc
      ```
      ---

      > [!TIP]
      > See [Limitations and known issues](troubleshoot-arc-enabled-vms.md#limitations-and-known-issues) if Azure Kubernetes Service is also enabled to run on this cluster.

1. Update the required extensions.
   
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

1. Run the following cmdlets. Refer to the following table for a description of the parameters.
   
   ```PowerShell
   $resource_group="<pre-created resource group in Azure>"
   $subscription="subscription ID in Azure"
   $Location="<Azure Region - Available regions include 'eastus' and 'westeurope'>"
   $customloc_name="<name of the custom location, such as <HCIClusterName>-cl>"
   ```
   where:

   | Parameter | Description |
   | ----- | ----------- |
   | **resource_group** | Name of the pre-created resource group in Azure. |
   | **subscription** | Subscription ID in Azure. |
   | **Location** | Name of the Azure region. Specify one of the following available regions: **eastus** or **westeurope**. |
   | **customloc_name** | Name of the custom location, such as HCIClusterName-cl. |

   > [!TIP]
   > Run `Get-AzureStackHCI` to find these details.

1. Sign in to your Azure subscription and get the extension and providers for Azure Arc Resource Bridge:
   
   ```azurecli
   az login --use-device-code
   az account set --subscription $subscription
   az provider register --namespace Microsoft.Kubernetes --wait
   az provider register --namespace Microsoft.KubernetesConfiguration --wait
   az provider register --namespace Microsoft.ExtendedLocation --wait
   az provider register --namespace Microsoft.ResourceConnector --wait
   az provider register --namespace Microsoft.AzureStackHCI --wait
   az provider register --namespace Microsoft.HybridConnectivity --wait
   ```

1. Run the following cmdlets based on your networking configurations:

   ### [For static IP address](#tab/for-static-ip-address)

   1. Create the configuration file for Arc Resource Bridge:
      ```PowerShell
      $resource_name= ((Get-AzureStackHci).AzureResourceName) + "-arcbridge"
      mkdir $csv_path\ResourceBridge
      New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP  -k8snodeippoolstart $VMIP_1 -k8snodeippoolend $VMIP_2 -gateway $Gateway -dnsservers $DNSServers -ipaddressprefix $IPAddressPrefix -vLanID $vlanID
      ```
      > [!IMPORTANT]
      > The configuration files are required to perform essential az arcappliance CLI commands. Make sure you store these files in a secure and safe location for future use.

   1. Validate the Arc Resource Bridge configuration file and perform preliminary environment checks:
      ```powershell
      az arcappliance validate hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml
      ```
  
   1. Download images used to create the Arc Resource Bridge VM from the cloud and make a copy to Azure Stack HCI:
      ```PowerShell
      az arcappliance prepare hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml
      ```
   
   1. Build the Azure ARM resource and on-premises appliance VM for Arc Resource Bridge:
      ```PowerShell
      az arcappliance deploy hci --config-file  $csv_path\ResourceBridge\hci-appliance.yaml --outfile $env:USERPROFILE\.kube\config
      ```
      > [!IMPORTANT]
      > Prepare and deploy can take up to 30 minutes to complete.
      >
      > If the `deploy` cmdlet fails, clean up the installation and retry the `deploy` cmdlet. Run the following cmdlet to clean up the installation:
      >
      >```powershell
      >az arcappliance delete hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --yes
      >```
      > While there can be a number of reasons why the Arc Resource Bridge deployment fails, one of them is KVA timeout error. For more information about the KVA timeout error and how to troubleshoot it, see [KVA timeout error](../manage/troubleshoot-arc-enabled-vms.md#kva-timeout-error).
   
   1. Create the connection between the Azure ARM resource and on-premises appliance VM of Arc Resource Bridge:
      ```PowerShell
      az arcappliance create hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --kubeconfig $env:USERPROFILE\.kube\config
      ```

   ### [For dynamic IP address](#tab/for-dynamic-ip-address)

   1. Create the configuration file for Arc Resource Bridge:
      ```PowerShell
      $resource_name= ((Get-AzureStackHci).AzureResourceName) + "-arcbridge"
      mkdir $csv_path\ResourceBridge
      New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vLanID $vlanID
      ```
      > [!IMPORTANT]
      > The configuration files are required to perform essential `az arcappliance` CLI commands. Make sure you store these files in a secure and safe location for future use.

   1. Validate the Arc Resource Bridge configuration file and perform preliminary environment checks:
      ```powershell
      az arcappliance validate hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml
      ```
   1. Download images used to create the Arc Resource Bridge VM from the cloud and make a copy to Azure Stack HCI:
      ```PowerShell
      az arcappliance prepare hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml
      ```
   1. Build the Azure ARM resource and on-premises appliance VM for Arc Resource Bridge:
      ```PowerShell
      az arcappliance deploy hci --config-file  $csv_path\ResourceBridge\hci-appliance.yaml --outfile $env:USERPROFILE\.kube\config
      ```
      > [!IMPORTANT]
      > Prepare and deploy can take up to 30 minutes to complete.
      >
      > If the `deploy` cmdlet fails, clean up the installation and retry the `deploy` cmdlet. Run the following cmdlet to clean up the installation:
      >
      >```powershell
      >az arcappliance delete hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --yes
      >```
      > While there can be a number of reasons why the Arc Resource Bridge deployment fails, one of them is KVA timeout error. For more information about the KVA timeout error and how to troubleshoot it, see [KVA timeout error](../manage/troubleshoot-arc-enabled-vms.md#kva-timeout-error).

   1. Create the connection between the Azure ARM resource and on-premises appliance VM of Arc Resource Bridge:
      ```PowerShell
      az arcappliance create hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --kubeconfig $env:USERPROFILE\.kube\config
      ```
   ---

1. Verify that the Arc appliance is running. Keep running the following cmdlets until the appliance provisioning state is **Succeeded** and the status is **Running**. This operation can take up to five minutes.

   ```azurecli
   az arcappliance show --resource-group $resource_group --name $resource_name
   ```

1. Add the required extensions for VM management capabilities to be enabled via the newly deployed Arc Resource Bridge:

    ```azurecli
    $hciClusterId= (Get-AzureStackHci).AzureResourceUri
    az k8s-extension create --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --extension-type Microsoft.AZStackHCI.Operator --scope cluster --release-namespace helm-operator2 --configuration-settings Microsoft.CustomLocation.ServiceAccount=hci-vmoperator --configuration-protected-settings-file $csv_path\ResourceBridge\hci-config.json --configuration-settings HCIClusterID=$hciClusterId --auto-upgrade true
    ```

1. Verify that the extensions are installed. Keep running the following cmdlet until the extension result is **Succeeded**. This operation can take up to five minutes.

   ```azurecli
   az k8s-extension show --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --out table --query '[provisioningState]'
   ```

1. Create a custom location for the Azure Stack HCI cluster, where **customloc_name** is the name of the custom location, such as "HCICluster -cl":

   ```azurecli
   az customlocation create --resource-group $resource_group --name $customloc_name --cluster-extension-ids "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name/providers/Microsoft.KubernetesConfiguration/extensions/hci-vmoperator" --namespace hci-vmoperator --host-resource-id "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name" --location $Location
   ```

Now you can navigate to the resource group in Azure and see the custom location and Azure Arc Resource Bridge that you've created for the Azure Stack HCI cluster.

## Next steps

- Create a VM image
    - [Starting from an Azure Marketplace image](./virtual-machine-image-azure-marketplace.md).
    - [Starting from an image in Azure Storage account](./virtual-machine-image-storage-account.md).
    - [Starting from an image in local share on your Azure Stack HCI](./virtual-machine-image-local-share.md).
