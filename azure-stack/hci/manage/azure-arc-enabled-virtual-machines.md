---
title: VM provisioning through Azure portal on Azure Stack HCI 
description: How to set up Azure Arc enabled Azure Stack HCI for cloud-based virtual machine provisioning and management

author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/24/2022
---

# VM provisioning through Azure portal on Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, version 21H2

Azure Stack HCI, version 21H2 customers can use Azure portal to provision and manage on-premises Windows and Linux virtual machines (VMs) running on Azure Stack HCI clusters. With [Azure Arc](https://azure.microsoft.com/services/azure-arc/), IT administrators can delegate permissions and roles to app owners and DevOps teams to enable self-service VM management for their Azure Stack HCI clusters through the Azure cloud control plane. Using [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates, VM provisioning can be easily automated in a secure cloud environment.

## Benefits of Azure Arc-enabled Azure Stack HCI

With Azure Arc-enabled Azure Stack HCI, you can perform various operations from Azure portal, such as:

- Create a VM
- Start, stop, and restart a VM
- Control access and add Azure tags
- Add and remove virtual disks and network interfaces
- Update memory and virtual CPUs for the VM

By using Azure portal to provision and manage on-premises and cloud VMs, users get a consistent experience. Users can access their VMs only, not the host fabric, enabling role-based access control and self-service.

## What is Azure Arc Resource Bridge?

A resource bridge is required to enable VM provisioning through Azure portal on Azure Stack HCI. Azure Arc Resource Bridge is a Kubernetes-backed, lightweight VM that enables users to perform full lifecycle management of resources on Azure Stack HCI from the Azure control plane, including Azure portal, Azure CLI, and Azure PS. Azure Arc Resource Bridge also creates Azure Resource Manager entities for VM disks, VM images, VM interfaces, VM networks, custom locations, and VM cluster extensions.

A **custom location** for an Azure Stack HCI cluster is analogous to an Azure region. As an extension of the Azure location construct, custom locations allow tenant administrators to use their Azure Stack HCI clusters as target location for deploying Azure services.

A **cluster extension** is the on-premises equivalent of an Azure Resource Manager resource provider. The Azure Stack HCI cluster extension helps manage VMs on an Azure Stack HCI cluster in the same way that the "Microsoft.Compute" resource provider manages VMs in Azure, for example.

   > [!NOTE]
   > **Arc Appliance** is an earlier name for Arc Resource Bridge, and you may see the term used in some places like the PowerShell commands or on Azure Portal. The feature has also been called self-service VMs in the past; however, this is only one of the several capabilities available with Arc-enabled Azure Stack HCI.

## Azure Arc Resource Bridge deployment overview

To enable Azure Arc-based VM operations on your Azure Stack HCI cluster, you must:

1.    Install Azure Arc Resource Bridge on the Azure Stack HCI cluster and create a VM cluster extension. This can be done using Windows Admin Center or PowerShell.
2.    Create a custom location for the Azure Stack HCI cluster.
3.    Create virtual network projections which will be used by VM network interfaces.
4.    Create OS gallery images for provisioning VMs.

The following sections describe these steps in more detail. 

Only one Arc Resource Bridge can be deployed on a cluster. Each Azure Stack HCI cluster can have only one custom location. Each virtual switch on the Azure Stack HCI cluster can have one virtual network. Multiple OS images can be added to the gallery. Additional virtual networks and images can be added any time after the initial setup.

## Prerequisites for deploying Azure Arc Resource Bridge

Deploying Azure Arc Resource Bridge requires the following:

- The latest version of Azure CLI installed on all servers of the cluster.
  - To install Azure CLI on each cluster node, use RDP connection.
  - Follow the instructions in [Install Azure CLI](/cli/azure/install-azure-cli-windows).
- Arc Resource Bridge has the following resource requirements:
  - At least 50GB of space in C:\.
  - At least 4 cores
  - At least 6GiB of memory
- A virtual switch of type "External". Make sure the switch has external internet connectivity. This virtual switch and its name must be the same across all servers in the Azure Stack HCI cluster.
- A DHCP server with enough IP addresses for Resource Bridge VM. You can have a tagged or untagged DHCP server. We currently do not support proxy configurations.
- An IP address for the load balancer running inside the Resource Bridge. The IP address needs to be in the same subnet as the DHCP scope and must be excluded from the DHCP scope to avoid IP address conflicts.
- An IP address for the cloud agent running inside the Resource Bridge. If the Azure Stack HCI cluster servers were assigned static IP addresses, then provide an explicit IP address for the cloud agent. The IP address for the cloud agent must be in the same subnet as the IP addresses of Azure Stack HCI cluster servers.
- A shared cluster volume to store configuration details and the OS image for your Resource Bridge VM.
- An Azure subscription ID where your Resource Bridge, custom location, and cluster extension resources will reside.

## Network port requirements

When you deploy Azure Arc Resource Bridge on Azure Stack HCI, the following firewall ports are automatically opened on each server in the cluster.

| **Port** | **Service** |
|:---------|:------------|
| 45000    | wssdagent gRPC server |
| 45001    | wssdagent gRPC authentication |
| 55000    | wssdcloudagent gRPC server |
| 65000    | wssdcloudagent gRPC authentication |

## Firewall URL exceptions

The following firewall URL exceptions are needed on all servers in the Azure Stack HCI cluster.

| **URL** | **Port** | **Service** | **Notes** |
|:--------|:---------|:------------|:----------|
| https://helm.sh/blog/get-helm-sh/ | 443 | Download agent | Used to download the Helm binaries |
| https://storage.googleapis.com/ | 443 | Cloud init | Downloading Kubernetes binaries |
| https://azurecliprod.blob.core.windows.net/ | 443 | Cloud init | Downloading binaries and containers |
| https://443 | 443 | TCP | Used to support Azure Arc agents |
| *.blob.core.windows.net | 443 | TCP | Required for downloads |
| *.dl.delivery.mp.microsoft.com, *.do.dsp.mp.microsoft.com | 80, 443 | Download agent | Downloading VHD images |
| ecpacr.azurecr.io | 443 | Kubernetes | Downloading container images |
| git://:9418 | 9418 | TCP | Used to support Azure Arc agents |

## Install PowerShell modules and update extensions

To prepare to install Azure Arc Resource Bridge on an Azure Stack HCI cluster and create a VM cluster-extension, perform these steps (through RDP or console session; remote Powershell isn't supported):

1. Install the required PowerShell modules by running the following cmdlet as administrator on all servers of the Azure Stack HCI cluster:

   ```PowerShell
   Install-PackageProvider -Name NuGet -Force 
   Install-Module -Name PowershellGet -Force -Confirm:$false -SkipPublisherCheck  
   Install-Module -Name Moc -Repository PSGallery -AcceptLicense -Force
   Initialize-MocNode
   Install-Module -Name ArcHci -RequiredVersion 0.2.7 -Force -Confirm:$false -SkipPublisherCheck -AcceptLicense
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
   
   **controlPlaneIP**: The IP address which will be used for the load balancer in the Arc Resource Bridge. The IP address needs to be in the same subnet as the DHCP scope and must be excluded from the DHCP scope to avoid IP address conflicts.
   
   **csv_path**: A CSV volume path which is accessible from all servers of the cluster. This will be used for caching OS images used for the Resource Bridge. It also stores temporary configuration files during installation and cloud agent configuration files after installation; for example, C:\ClusterStorage\contosoVol\.
   
   **vLanID** (optional): vLAN identifier
   
   **cloudServiceIP** (required only for static IP configurations): The IP address of the cloud agent running underneath the resource bridge. This is required if the cluster servers have statically assigned IP addresses. The IP must be carved from the underlay network (physical network).

3. Prepare configuration for Arc Resource Bridge:

   ```PowerShell
   $vnet=New-MocNetworkSetting -Name hcirb-vnet -vswitchName $vswitchName -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP [-vLanID=$vLANID]
   Set-MocConfig -workingDir $csv_path\ResourceBridge  -vnet $vnet -imageDir $csv_path\imageStore -skipHostLimitChecks -cloudConfigLocation $csv_path\cloudStore -catalog aks-hci-stable-catalogs-ext -ring stable [-CloudServiceIP <$CloudServiceIP>]
   Install-moc
   ```
   > [!TIP]
   > Please see Known Limitations if Azure Kubernetes Service is also enabled to run on this cluster.
   
   > [!TIP]
   > To provide a static IP address to the Arc Resource Bridge VM, replace the previous command with:
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

To create a custom location, install Azure Arc Resource Bridge by launching an elevated PowerShell window and following these steps:

1. Provide inputs for the following, using the parameters described below.
   
   ```PowerShell
   $resource_group="<pre-created resource group in Azure>"
   $subscription="subscription ID in Azure"
   $Location="<Azure Region - Available regions include 'eastus', 'eastus2euap' and 'westeurope'>"
   $customloc_name="<name of the custom location, such as HCICluster -cl>"
   ```
   
   > [!TIP]
   > These details can be found by running `Get-AzureStackHCI`.

2. Log in to your Azure subscription and get the extension and providers for Arc Resource Bridge:
   
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
   New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge
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

5.  Add the required extensions for VM management capabities to be enabled via the newly deployed Arc Resource Bridge:

    ```azurecli
    $hciClusterId= (Get-AzureStackHci).AzureResourceUri
    az k8s-extension create --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --extension-type Microsoft.AZStackHCI.Operator --scope cluster --release-namespace helm-operator2 --configuration-settings Microsoft.CustomLocation.ServiceAccount=hci-vmoperator --configuration-protected-settings-file $csv_path\ResourceBridge\hci-config.json --configuration-settings HCIClusterID=$hciClusterId --auto-upgrade true
    ```

6. Verify that the extensions are installed. Keep running the following cmdlets until the extension provisioning state is **Succeeded**. This operation can take up to five minutes.

   ```azurecli
   az k8s-extension show --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator
   ```

7. Create a custom location for the Azure Stack HCI cluster, where **customloc_name** is the name of the custom location, such as "HCICluster -cl":

   ```azurecli
   az customlocation create --resource-group $resource_group --name $customloc_name --cluster-extension-ids "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name/providers/Microsoft.KubernetesConfiguration/extensions/hci-vmoperator" --namespace hci-vmoperator --host-resource-id "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name" --location $Location
   ```

Now you can navigate to the resource group in Azure and see the custom location and Arc Resource Bridge that you've created for the Azure Stack HCI cluster.

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

## View your cluster in Azure portal & manage virtual machines

IT or cluster administrators can create and manage VMs and the associated disks, network interfaces from the Azure Stack HCI resource page in [Azure portal](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.AzureStackHCI%2Fclusters). The cluster resource page provides links to view & access Azure Arc Resource Bridge and Custom Location associated with the Azure Stack HCI cluster. From the Azure Stack HCI cluster resource page in Portal, admins can provision and manage VMs by navigating to **Virtual Machines** under **Resources** in the left nav on Azure portal. Other Azure Active Directory (AAD) user or groups with **Owner** or **Contributor** access on this subscription will also be able to view, create & manage VMs on this Azure Stack HCI cluster.

For VM management from the Virtual Machines blade in Azure Portal, use the following steps:

1. From your browser, go to the [Azure portal](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Compute%2FVirtualMachines). You'll see a unified browsing experience for Azure and Arc VMs.

2. Select **Add**, and then select **Azure Arc machine** from the drop-down.

3. Select the Azure subscription and resource group where you want to deploy the VM.

4. Provide the VM name and then select a custom location that your administrator has shared with you.

   > [!IMPORTANT]
   > Names for all entities of a VM should be in lower case and may use "-" and numbers.
   
5. Select an image from the image gallery for the VM you'll create.

6. If you selected a Windows image, provide a username and password for the administrator account. For Linux VMs, provide SSH keys.

7. **(Optional)** Create new or add more disks to the VM by providing a name and size. You can also choose the disk type to be static or dynamic.

8. **(Optional)** Create or add network interface (NIC) cards for the VM by providing a name for the network interface. Then select the network and choose static or dynamic IP addresses.

9. **(Optional)** Add tags to the VM resource if necessary.

10. Review all the properties, and then select **Create**. It should take a few minutes to provision the VM.

## Uninstall Azure Arc Resource Bridge

To uninstall Azure Arc Resource Bridge and remove VM management on an Azure Arc-enabled Azure Stack HCI cluster, complete the following steps.

1. Remove the virtual network:

   ```azurecli
   az azurestackhci virtualnetwork delete --subscription $subscription --resource-group $resource_group --name $vnetName --yes
   ```

2. Remove the gallery images:

   ```azurecli
   az azurestackhci galleryimage delete --subscription $subscription --resource-group $resource_group --name $galleryImageName
   ```

3. Remove the custom location:

   ```azurecli
   az customlocation delete --resource-group $resource_group --name $customloc_name --yes
   ```

4. Remove the Kubernetes extension:

   ```azurecli
   az k8s-extension delete --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --yes
   ```

5. Remove the appliance:

   ```azurecli
   az arcappliance delete hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --yes
   ```

   > [!NOTE]
   > On every attempt to reinstall the appliance, remove the ".wssd\python" python folder in the user profile folder using this cmdlet:
   > 
   > rmdir $env:USERPROFILE\\.wssd\python -Recurse -Force

6. Remove the config files:

   ```PowerShell
   Remove-ArcHciConfigFiles
   ```

7. Uninstall the moc setup after testing:

   ```PowerShell
   Uninstall-Moc
   ```

## Debugging

Please see the support topics for any errors and their remediation steps. If the error condition is not mentioned or you need additional help, please contact Microsoft support.
For issues related to Arc VM management, you can generate logs from the cluster using the **Get-ArcHCILogs** cmdlet.

```PowerShell
Get-ArcHCILogs -workDirectory <path>
```

The `workDirectory` is located under the following path: `$csv_path\ResourceBridge\kvatoken.tok`. Please provide the absolute file path name. Optionally, you can provide the `-logDir` parameter, to provide the path to the directory in which generated logs will be saved. If you don't provide either the path or parameter, the location defaults to the current working directory.

## Limitations and known issues

- All resource names should use only lower case letters, numbers and hypens. The resource names must be unique for an Azure Stack HCI cluster.
- Arc Resource Bridge provisioning through CLI should be performed on a local HCI server using PowerShell. It can't be done in a remote PowerShell window from a machine that is not a host of the Azure Stack HCI cluster. To connect on each node of the Azure Stack HCI cluster, use RDP connected with a domain user admin of the cluster.
- Enabling Azure Kubernetes and Arc-enabled Azure Stack HCI for VMs on the same Azure Stack HCI cluster requires the following deployment order:
      - First, the AKS management cluster.
      - And then, Arc Resource Bridge for Arc-enabled VMs.
If Arc Resource Bridge is already deployed, the AKS management cluster should not be deployed unless the Arc Resource Bridge has been removed.

While deploying Arc Resource bridge when the AKS management cluster is available on the cluster, you don't need to perform the following steps:
**new-MocNetworkSetting**, **set-MocConfig** and **install-Moc**.

Uninstallation of these features should also be done in the following order:

1. Uninstall Arc Resource Bridge.
2. Uninstall the AKS management cluster.

Uninstalling the AKS management cluster can impair Arc VM management capabilities. You can deploy a new Arc Resource Bridge again after cleanup, but it will not remember the VM entities that were created earlier.

- VMs provisioned from Windows Admin Center, PowerShell or other HyperV management tools will not be visible in portal for management.
- Updating Arc VMs on Azure Stack HCI must be done from Azure management plane only. Any modifications to these VMs from other management tools will not be updated in Azure portal.
- Arc VMs must be created in the same Azure subscription as the Custom location.
- An IT admininstrator will not be able to view or manage VMs from cluster resource page in Azure portal, if they are created in a subscription where the IT administrator does not have at least read-only access role.
- If the Arc for servers agents are installed on VMs provisioned through Azure portal, there will be two projections of the VMs on Azure Portal.
- Arc VM Management is currently not available for stretched cluster configurations on Azure Stack HCI.

## FAQ

The following section answers some frequently asked questions about Azure Arc-enabled Azure Stack HCI.

### Can I create virtual machines on a tagged vLAN?
  
vLAN tagged VMs is currently not supported.

### Can Azure Kubernetes Service on Azure Stack HCI and Azure Arc Resource Bridge co-exist on the same Azure Stack HCI cluster?

Yes. Azure Kubernetes Service on Azure Stack HCI and VM provisioning from Azure portal can be deployed on the same Arc-enabled Azure Stack HCI cluster. This requires deploying the AKS-HCI management cluster first and then Arc Resource Bridge. In this configuration, uninstalling Azure Kubernetes Service from Azure Stack HCI cluster will also remove Arc Resource Bridge.

### Can I use SDN for Azure Stack HCI VMs created from Azure portal?
  
SDN is currently not supported for VMs created from Azure portal.

### My environment does not support dynamic DNS updates, how can I successfully deploy Arc Resource Bridge?

If you cannot enable dynamic DNS updates in your DNS environment, you must pre-create records in the Active Directory and the DNS. You can create a generic cluster service in Active Directory with the name `ca-cloudagent` (or a name of your choice), but do not exceed 32 characters in length. You also need to create an associated DNS record pointing to the FQDN of the generic cluster service with the provided `cloudservicecidr` address. More details on the steps in this process can be found in the [Failover Clustering article](/windows-server/failover-clustering/prestage-cluster-adds).

### Is there a fee to use Arc management for VMs on Azure Stack HCI cluster?

VM management for Azure Stack HCI from the Azure control plane does not have any additional fees. Some VM extensions may have a fee.

### Can I use the same name for gallery image projections & will the existing VMs use the new image?

Two images with the same name will result in errors at the time of creating them. This is true for other resources as well, such as virtual networks, virtual hard disks etc. An updated image will not change existing VMs that were using it. A copy of the VM image is created at the time VM creation.

### How can I delete a gallery image?

Gallery images and all other entities can be removed from CLI or from the Azure portal. [See examples here](azure-arc-enabled-virtual-machines.md#uninstall-azure-arc-resource-bridge).

### If I delete a gallery image would all the VMs also get deleted which are deployed?

Deleting a gallery image does not affect the VMs that were created using that gallery image. The VMs will not be able to show the image name in the VM details.

### If I re-install the Arc Resource Bridge will the VMs also be re-deployed?

If an Arc Resource Bridge is deleted, then management through the Azure control plane (portal, Az CLI etc.) will be unavailable. The VMs will remain on the cluster and are only manageable through on-premises tools (Windows Admin Center, PowerShell etc.).

Re-deploying an Arc Resource Bridge will not enable Arc management of existing VMs. However, all new VMs created using the new Resource Bridge can be managed from the Azure control plane.

### What should I do if the deployment of Arc Resource Bridge did not succeed?

Please see the [Debugging section](#debugging) for common errors. If you are re-deploying the Arc Resource Bridge, please make sure to clean up the previous deployment completely following the [Uninstall procedure](#uninstall-azure-arc-resource-bridge).



## Next steps

Now you're ready to create VMs in Azure portal.

> [!div class="nextstepaction"]
> [Go to Azure portal](https://portal.azure.com/#home)
