---
title: Create Azure Local Virtual Machines Enabled by Azure Arc on Multi-rack Deployments (Preview)
description: Learn how to view your Azure Local multi-rack deployment in the Azure portal and create Azure Local virtual machines enabled by Azure Arc (Preview).
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/11/2025
---

# Create Azure Local virtual machines enabled by Azure Arc for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create Azure Local virtual machines (VMs) enabled by Azure Arc, using the VM images that you created on multi-rack deployments of Azure Local. You can create Azure Local VMs using the Azure CLI, Azure portal, or Azure Resource Manager (ARM) template.

> [!NOTE]
> Arc gateway isn't supported on Azure Local VMs.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About Azure Local resource

Use the [Azure Local resource page](../index.yml) for the following operations:<!--update link-->

- Create and manage Azure Local VM resources such as VM images, disks, network interfaces.
- View and access custom location associated with the Azure Local instance.
- Provision and manage VMs.

The procedure to create VMs is described in the next section.

## Prerequisites

Before you create an Azure Local VM, make sure that the following prerequisites are complete:

# [Azure CLI](#tab/azurecli)

- Access to an Azure subscription with the appropriate RBAC role and permissions assigned. For more information, see [RBAC roles for Azure Local VM management](../index.yml)<!--update link-->.
- Access to a resource group where you want to provision the VM.
- Access to one or more VM images on your Azure Local. These VM images could be created using [VM image starting from an image in Azure Storage account](../index.yml)<!--update link-->.
    > [!NOTE]
    > If you’re deploying a Windows VM, make sure that the appropriate VirtIO drivers are present in the image.
- A custom location for your Azure Local instance that you'll use to provision VMs. The custom location will also show up in the **Overview** page for Azure Local.
- If using a client to connect to your Azure Local, see [Connect to Azure Local via Azure CLI client](../index.yml)<!--update link-->.
- Access to a network interface that you created on a logical network or virtual network subnet associated with Azure Local. You can choose a network interface with static IP allocation. For more information, see how to [Create network interfaces](../index.yml)<!--update link-->.

# [Azure portal](#tab/azureportal)

- Access to an Azure subscription with the appropriate RBAC role and permissions assigned. For more information, see [RBAC roles for Azure Local VM management](../index.yml)<!--update link-->.
- Access to a resource group where you want to provision the VM.
- Access to one or more VM images on your Azure Local.
    > [!NOTE]
    > If you’re deploying a Windows VM, make sure that the appropriate VirtIO drivers are present in the image.
- A custom location for your Azure Local instance that you'll use to provision VMs. The custom location will also show up in the **Overview** page for Azure Local.
- Details of your proxy server to provide during VM creation. Azure Local VMs wouldn't have external connectivity to enable guest management without proxy details configured at the time of creation.

# [Azure Resource Manager template](#tab/armtemplate)

- Access to an Azure subscription with the appropriate RBAC role and permissions assigned. For more information, see [RBAC roles for Azure Local VM management](../index.yml)<!--update link-->.
- Access to a resource group where you want to provision the VM.
- Access to one or more VM images on your Azure Local. These VM images could be created using [VM image starting from an image in Azure Storage account](../index.yml)<!--update link-->.
- A custom location for your Azure Local instance that you'll use to provision VMs. The custom location will also show up in the **Overview** page for Azure Local.
- Access to a logical network or virtual network subnet that you associate with the VM on your Azure Local instance. For more information, see how to [Create logical network](../index.yml)<!--update link-->.
- [Download the sample Azure Resource Manager template](../index.yml)<!--update link--> in the GitHub Azure QuickStarts repo. You use this template to create a VM.

<!--# [Bicep template](#tab/biceptemplate)

[!INCLUDE [hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

- Access to a logical network that you associate with the VM on your Azure Local. For more information, see how to [Create logical network](./create-logical-networks.md).
- [Download the sample Bicep template](https://aka.ms/hci-vmbiceptemplate)

# [Terraform template](#tab/terraformtemplate)

[!INCLUDE[hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

- Access to a logical network that you associate with the VM of your Azure Local. For more information, see [Create logical networks](../manage/create-logical-networks.md).
- Make sure Terraform is installed and up to date on your machine.
    - To verify your Terraform version, run the `terraform -v` command.
    
    Here's an example of sample output:
    ```output
    PS C:\Users\username\terraform-azurenn-avm-res-azurestackhci-virtualmachineinstance> terraform -v 
    Terraform vi.9.8 on windows_amd64
    + provider registry.terraform.io/azure/azapi vl.15.0 
    + provider registry.terraform.io/azure/modtm V0.3.2 
    + provider registry.terraform.io/hashicorp/azurerm v3.116.0 
    + provider registry.terraform.io/hashicorp/random V3.6.3
    ```
- Make sure Git is installed and up to date on your machine.
    -  To verify your version of Git, run the `git --version` command.
-->
---

## Create Azure Local VMs

Follow these steps to create a VM on Azure Local.

# [Azure CLI](#tab/azurecli)

Follow these steps on the client running az CLI that is connected to Azure Local.

## Sign in and set subscription

1. [Connect to a machine](../index.yml)<!--update link--> on Azure Local.


1. Sign in. Type:

    ```azurecli
    az login --use-device-code
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

### Create a Windows VM

In Azure Local preview version, you can create a VM that has network interface with static IP allocation.

> [!NOTE]
> If you need more than one network interface for your VM, create one or more interfaces now before you create the VM. Adding a network interface after the VM is provisioned isn't supported in the preview version.

Here we create a VM that uses specific memory and processor counts.

1. Set some parameters.

    ```azurecli
    $vmName ="local-vm"
    $subscription =  "<Subscription ID>"
    $resource_group = "local-rg"
    $customLocationName = "local-cl"
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    $computerName = "mycomputer"
    $userName = "local-user"
    $password = "<Password for the VM>"
    $imageName ="ws22server"<!--comment from DR: We need to double check - Is this Name or ID KK -->
    $nicName ="local-vnic" 
    $httpProxy = "<Proxy server address>"
    $httpsProxy = "<Proxy server address>"
    ```

    The parameters for VM creation are tabulated as follows:

    | Parameters | Description |
    |------------|-------------|
    | **name**  |Name for the VM that you create for Azure Local. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking)|
    | **admin-username** |Username for the user on the VM you're deploying on Azure Local. |
    | **admin-password** |Password for the user on the VM you're deploying on Azure Local. |
    | **image-name** |Name of the VM image used to provision the VM. |
    | **location** |Azure regions as specified by `az locations`. For example, this could be `eastus`, `westeurope`. |
    | **resource-group** |Name of the resource group where you create the VM. For ease of management, we recommend that you use the same resource group as Azure Local. |
    | **subscription** |Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for VM on Azure Local. |
    | **custom-location** |Use this to provide the custom location associated with Azure Local where you're creating this VM. |
    | **authentication-type** |Type of authentication to use with the VM. The accepted values are `all`, `password`, and `ssh`. Default is password for Windows and SSH public key for Linux. Use `all` to enable both `ssh` and `password` authentication.     |
    | **nics** |Names or the IDs of the network interfaces associated with your VM. You must have atleast one network interface when you create a VM, to enable guest management.|
    | **memory-mb** |Memory in Megabytes allocated to your VM. If not specified, defaults are used.|
    | **processors** |The number of processors allocated to your VM. If not specified, defaults are used.|
    | **proxy-configuration** |Use this parameter to configure a proxy server for your VM. It is required to enable guest management on your VM. For more information, see [Create a VM with proxy configured](../index.yml)<!--update link-->.  |
    | **zone** | (Optional) Name of the availability zone (rack) where you want the VM to be placed. You can choose the availability zone by looking at the list of availability zones. <!--Comment from SR: Need to either create a new doc or have this be added to an existing doc.--> |
    | **strict-placement** | (Optional) Choose strict placement if you want a VM to only be scheduled on the specified availability zone. If the specified zone doesn’t have capacity or is unavailable, VM creation will fail. If you specify no for this parameter, the VM will be scheduled on the specified zone on a best-effort basis. <!--comment from SR: can you please confirm the parameter names in the latest az cli?--> |

1. Run the following commands to create the applicable VM.

    **To create a standard Azure Local VM for multi-rack deployments:**

   ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --zone $zone –strict-placement true --enable-agent true --enable-vm-config-agent true --proxy-configuration http_proxy=$httpProxy https_proxy=$httpsProxy no_proxy="" cert_file_path="" 
   ```

The VM is successfully created when the `provisioningState` shows as `succeeded`in the output.

<!--unresolved comments present on the following note-->
> [!NOTE]
> The VM created has guest management enabled by default. It is required to provide HTTP proxy to enable guest management properly.

### Create a Linux VM

To create a Linux VM, use the same command that you used to create the Windows VM.

- The gallery image specified should be a Linux image.
- For Linux VMs, we recommend using SSH keys. For SSH keys, you need to pass the `ssh-key-values` parameters along with `authentication-type ssh`.
- If you want to use username and password, use the `authentication-type password` parameter.

> [!IMPORTANT]
> The VM created has guest management enabled by default. It is required to provide HTTP proxy to enable guest management properly.

### Create a VM with proxy configured

Use this parameter **proxy-configuration** to configure a proxy server for your VM.

Proxy configuration for VMs is applied only to the onboarding of the Azure connected machine agent and set as environment variables within the guest VM operating system. Browsers and applications on the VM aren't necessarily all enabled with this proxy configuration.

As such, you may need to specifically set the proxy configuration for your applications if they don't reference the environment variables set within the VM.

If creating a VM behind a proxy server, run the following command:

<!--unresolved comments present on the following code block-->
```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" -- --zone $zone –strict-placement true --proxy-configuration http_proxy="<Http URL of proxy server>" https_proxy="<Https URL of proxy server>" no_proxy="<URLs which bypass proxy>" cert_file_path="<Certificate file path for your machine>"
```

You can input the following parameters for `proxy-server-configuration`:

| Parameters | Description |
|------------|-------------|
| **http_proxy**  |HTTP URLs for proxy server. An example URL is:`http://proxy.example.com:3128`.  |
| **https_proxy**  |HTTPS URLs for proxy server. The server may still use an HTTP address as shown in this example: `http://proxy.example.com:3128`. |
| **no_proxy**  |URLs, which can bypass proxy. Typical examples would be `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8`.|
| **cert_file_path**  |Select the certificate file used to establish trust with your proxy server. An example is: `C:\Users\Palomino\proxycert.crt`. |

Here's a sample command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --proxy-configuration http_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" https_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" no_proxy="localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8,s-cluster.test.contoso.com" cert_file_path="C:\ClusterStorage\UserStorage_1\server.crt"
```

For proxy authentication, you can pass the username and password combined in a URL as follows:`"http://username:password@proxyserver.contoso.com:3128"`.

# [Azure portal](#tab/azureportal)

Follow these steps in Azure portal for Azure Local.

> [!IMPORTANT]
> Setting the proxy server during VM creation required to enable guest management on your Azure Local VM for multi-rack deployments.

1. Go to **Azure Arc cluster view** > **Virtual machines**.
1. From the top command bar, select **+ Create VM**.

   :::image type="content" source="media/multi-rack-create-arc-virtual-machines/select-create-vm.png" alt-text="Screenshot of select + Add/Create VM." lightbox="media/multi-rack-create-arc-virtual-machines/select-create-vm.png":::

1. On the **Basics** tab, input the following parameters in the **Project details** section:

   :::image type="content" source="media/multi-rack-create-arc-virtual-machines/create-virtual-machines-project-details.png" alt-text="Screenshot of Project details on Basics tab." lightbox="media/multi-rack-create-arc-virtual-machines/create-virtual-machines-project-details.png":::

    1. **Subscription** – The subscription is tied to the billing. Choose the subscription that you want to use to deploy this VM.

    1. **Resource group** – Create new or choose an existing resource group where you deploy all the resources associated with your VM.

1. In the **System details** section, input the following parameters:

    <!--update screenshot--
    :::image type="content" source="media/multi-rack-create-arc-virtual-machines/create-virtual-machines-instance-details.png" alt-text="Screenshot of system details on Basics tab." lightbox="media/multi-rack-create-arc-virtual-machines/create-virtual-machines-instance-details.png":::-->

    1. **Virtual machine name** – Enter a name for your VM. The name should follow all the naming conventions for Azure virtual machines.  
    
        > [!IMPORTANT]
        > VM names should be in lowercase letters and can include hyphens and numbers.

    1. **custom-location** – Select the custom location for your VM. The custom locations are filtered to only show those locations that are enabled for Azure Local.
    
        **The Virtual machine kind** is automatically set to **Azure Local**. <!--verify this-->

    1. **Security type** - Only **Standard** security type is supported and selected by default. For more information about Trusted launch Azure Local VMs, see [What is Trusted launch for Azure Local Virtual Machines?](../index.yml)<!--update link-->.

   1. **Image** - Select from the VM images you previously created on your Azure Local instance.
    
        1. If you selected a Windows image, provide a username and password for the administrator account, and then confirm the password.
 
        <!--:::image type="content" source="media/multi-rack-create-arc-virtual-machines/create-arc-vm-windows-image.png" alt-text="Screenshot showing how to Create a VM using Windows VM image." lightbox="media/multi-rack-create-arc-virtual-machines/create-arc-vm-windows-image.png":::-->

        1. If you selected a Linux image, you can choose between password and ssh key.

           <!--:::image type="content" source="media/multi-rack-create-arc-virtual-machines/create-arc-vm-linux-vm-image.png" alt-text="Screenshot showing how to Create a VM using a Linux VM image." lightbox="media/multi-rack-create-arc-virtual-machines/create-arc-vm-linux-vm-image.png":::-->

    1. **Virtual processor count** – Specify the number of vCPUs you would like to use to create the VM.

    1. **Memory** – Specify the memory in MB for the VM you intend to create.

    1. **Memory type** – Only **Static** memory type is supported and selected by default.
    
    1. **Availability Zone** - Name of the availability zone (rack) where you want the VM to be placed.
     
    1. **Strict placement** - Choose strict placement if you want a VM to only be scheduled on the specified availability zone. If the specified zone doesn’t have capacity or is unavailable, VM creation will fail. If you specify no for this field, the VM will be scheduled on the specified zone on a best-effort basis.
 

1. In the **VM extensions** section, select the checkbox to enable guest management and input the following parameters. You can install extensions on VMs where the guest management is enabled.

    > [!NOTE]
    > - Add at least one network interface through the **Networking** tab to complete guest management setup.
    > - The network interface that you enable, must have a valid IP address and internet access by setting VM proxy.

1. In the VM proxy configuration section, to configure a proxy for your VM, input the following parameters:

    > [!NOTE]
    > Proxy configuration for VMs is applied only to the onboarding of the Azure connected machine agent and set as environment variables within the guest VM operating system. Browsers and applications on the VM aren't necessarily all enabled with this proxy configuration. As such, you may need to specifically set the proxy configuration for your applications if they don't reference the environment variables set within the VM.

    <!--:::image type="content" source="media/multi-rack-create-arc-virtual-machines/arc-vm-proxy-configuration.png" alt-text="Screenshot of local VM administrator on Basics tab." lightbox="media/multi-rack-create-arc-virtual-machines/arc-vm-proxy-configuration.png":::-->

    - **Http proxy** - Provide an HTTP URL for the proxy server. An example URL is: `http://proxy.example.com:3128`.
    - **Https proxy** - Provide an HTTPS URL for the proxy server. The server may still use an HTTP address as shown in this example: `http://proxy.example.com:3128`.
    - **No proxy** - Specify URLs to bypass the proxy. Typical examples would be: `localhost,127.0.0.1`,`.svc,10.0.0.0/8`,`172.16.0.0/12`,`192.168.0.0/16`,`100.0.0.0/8`.
    - **Certificate file** - Select the certificate file used to establish trust with your proxy server.

    > [!NOTE]
    > For proxy authentication, you can pass the username and password combined in a URL as follows: `http://username:password@proxyserver.contoso.com:3128`.

1. Set the local VM administrator account credentials used when connecting to your VM via RDP. For Windows VM, in the **Administrator account** section, input the following parameters:

    <!--:::image type="content" source="media/multi-rack-create-arc-virtual-machines/create-virtual-machines-administrator-account-domain-join.png" alt-text="Screenshot of guest management enabled inVM extensions on Basics tab." lightbox="media/multi-rack-create-arc-virtual-machines/create-virtual-machines-administrator-account-domain-join.png":::-->

    1. Specify the local VM administrator account username.
    1. Specify the password and then **Confirm password**.

1. If you selected a Windows VM image, you can domain join your Windows VM. In the **Domain join** section, input the following parameters:
   
    1. Select **Enable domain join**.

    1. Only the Active Directory domain join is supported and selected by default.  
    
    1. Provide the UPN of an Active Directory user who has privileges to join the virtual machine to your domain.
       
       > [!IMPORTANT]
       > For your Active Directory, if your SAM Account Name and UPN are different, enter the SAM Account Name in the UPN field as: `SAMAccountName@domain`. 
    
    1. Provide the domain administrator password. If using SAM Account Name in the UPN field, enter the corresponding password.

    1. Specify domain or organizational unit. You can join virtual machines to a specific domain or to an organizational unit (OU) and then provide the domain to join and the OU path.
    
        If the domain isn't specified, the suffix of the Active Directory domain join UPN is used by default. For example, the user *guspinto@contoso.com* would get the default domain name *contoso.com*.

        For LinuxVM, provide root user details.

        <!--add screenshot-->

1. **(Optional)** Create new or add more disks to the VM.

   <!--:::image type="content" source="media/multi-rack-create-arc-virtual-machines/create-new-disk.png" alt-text="Screenshot of new disk added during Create a VM." lightbox="media/multi-rack-create-arc-virtual-machines/create-new-disk.png":::-->

    1. Select **+ Add new disk**.
    1. Provide a **Name** and **Size**.
    1. Select **Add**. After it's created, you can see the new disk in the list view.
    
    <!--update screenshot
       :::image type="content" source="media/multi-rack-create-arc-virtual-machines/create-new-disk.png" alt-text="Screenshot of new disk added during Create a VM." lightbox="media/multi-rack-create-arc-virtual-machines/create-new-disk.png":::-->

1. **(Optional)** Create or add a network interface for the VM.

    > [!NOTE]
    > - If you enabled guest management, you must add at least one network interface.
    > - If you need more than one network interface with static IPs for your VM, create one or more interfaces now before you create the VM. Adding a network interface with static IP, after the VM is provisioned, isn't supported.

    <!--:::image type="content" source="media/multi-rack-create-arc-virtual-machines/add-new-network-interface.png" alt-text="Screenshot of network interface added during Create a VM." lightbox="media/multi-rack-create-arc-virtual-machines/add-new-network-interface.png":::-->

    1. Provide a **Name** for the network interface.
    1. From the drop-down list, select the **Network**. Based on the logical network selected, you see the IPv4 type automatically populate as **Static** or **DHCP**.
    1. For **Static** IP, choose the **Allocation method** as **Automatic** or **Manual**. For **Manual** IP, provide an IP address.

    >[!NOTE]
    > To create a VM with virtual network, use Azure CLI or Arm templates.

    1. Select **Add**.

1. **(Optional)** Add tags to the VM resource if necessary.

1. Review all the properties of the VM.

    <!--update screenshot
    :::image type="content" source="media/multi-rack-create-arc-virtual-machines/review-virtual-machine.png" alt-text="Screenshot of review page during Create a VM." lightbox="media/multi-rack-create-arc-virtual-machines/review-virtual-machine.png":::-->

1. Select **Create**. It should take a few minutes to provision the VM.

# [Azure Resource Manager template](#tab/armtemplate)

Follow these steps to deploy the Resource Manager template:

1. In the Azure portal, from the top search bar, search for *deploy a custom template*. Select **Deploy a custom template** from the available options.

1. On the **Select a template** tab, select **Build your own template in the editor**.

   <!--:::image type="content" source="media/multi-rack-create-arc-virtual-machines/build-own-template.png" alt-text="Screenshot of build your own template option in Azure portal." lightbox="media/multi-rack-create-arc-virtual-machines/build-own-template.png":::-->

1. You see a blank template.

   <!--:::image type="content" source="media/multi-rack-create-arc-virtual-machines/blank-template.png" alt-text="Screenshot of blank Resource Manager template in Azure portal." lightbox="media/multi-rack-create-arc-virtual-machines/blank-template.png":::-->

1. Replace the blank template with the template that you downloaded during the prerequisites step.

    This template creates an Azure Local VM for multi-rack deployments. First, a virtual network interface is created. You can optionally enable domain-join and attach a virtual disk to the VM you create. Finally, the VM is created with the guest management enabled.
<!--open comments present in the json code snippet-->
   ```json
    {
        "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
        "contentVersion": "1.0.0.0",
        "parameters": {
            "name": {
                "type": "String",
                "metadata": {
                    "description": "The name of the Virtual Machine."
                }
            },
            "location": {
                "type": "String",
                "metadata": {
                    "description": "The Azure region where the resources will be deployed."
                }
            },
            "customLocationId": {
                "type": "String",
                "metadata": {
                    "description": "The custom location ID where the resources will be deployed."
                }
            },
            "adminUsername": {
                "type": "String",
                "metadata": {
                    "description": "The username for the administrator account of the VM."
                }
            },
            "adminPassword": {
                "type": "SecureString",
                "metadata": {
                    "description": "The password for the administrator account of the VM. This should be a secure string."
                }
            },
            "securityType": {
                "type": "String",
                "metadata": {
                    "description": "The type of security configuration for the VM."
                }
            },
            "vNicName": {
                "type": "String",
                "metadata": {
                    "description": "The name of the vNic."
                }
            },
            "privateIPAddress": {
                "type": "String",
                "metadata": {
                    "description": "The IP address for the network interface."
                }
            },
            "subnetId": {
                "type": "String",
                "metadata": {
                    "description": "The Azure Resource Manager ID of the logical network or virtual network subnet for the network interface."
                }
            },
            "vmSize": {
                "type": "String",
                "metadata": {
                    "description": "The size of the virtual machine instance. It is 'Default' by default."
                }
            },
            "enableVirtualDisk": {
                "type": "bool",
                "metadata": {
                    "description": "Enable or disable the virtual disk."
                }
            },
            "diskName": {
                "type": "String",
                "defaultValue": "",
                "metadata": {
                    "description": "The name of the virtual data disk for your VM. Required if enableVirtualDisk is true."
                }
            },
            "diskSize": {
                "type": "Int",
                "defaultValue": 0,
                "metadata": {
                    "description": "Specify the size of the additional virtual disk to be added to your VM. Required if enableVirtualDisk is true."
                }
            },
            "processors": {
                "type": "Int",
                "metadata": {
                    "description": "The number of processors for the virtual machine."
                }
            },
            "memoryMB": {
                "type": "Int",
                "metadata": {
                    "description": "The amount of memory in MB for the virtual machine."
                }
            },
            "imageReferenceId": {
                "type": "String",
                "metadata": {
                    "description": "The Azure Resource Manager ID of the image to be used for the virtual machine."
                }
            },
            "enableDomainJoin": {
                "type": "bool",
                "metadata": {
                    "description": "Enable or disable the domain join extension."
                }
            },
            "domainToJoin": {
                "type": "String",
                "defaultValue": "",
                "metadata": {
                    "description": "The domain to join. Required if enableDomainJoin is true."
                }
            },
            "orgUnitPath": {
                "type": "String",
                "defaultValue": "",
                "metadata": {
                    "description": "The Organizational Unit path. Optional, used if enableDomainJoin is true."
                }
            },
            "domainUsername": {
                "type": "String",
                "defaultValue": "",
                "metadata": {
                    "description": "The domain username. Required if enableDomainJoin is true."
                }
            },
            "domainPassword": {
                "type": "SecureString",
                "defaultValue": "",
                "metadata": {
                    "description": "The domain password. Required if enableDomainJoin is true."
                }
            }
        },
        "variables": {
            "domainJoinExtensionName": "[if(parameters('enableDomainJoin'), concat(parameters('name'),'/joindomain'), '')]",
            "virtualDiskName": "[if(parameters('enableVirtualDisk'), parameters('diskName'), '')]"
        },
        "resources": [
            {
                "type": "Microsoft.HybridCompute/machines",
                "apiVersion": "2023-03-15-preview",
                "name": "[parameters('name')]",
                "location": "[parameters('location')]",
                "kind": "HCI",
                "identity": {
                    "type": "SystemAssigned"
                }
            },
            {
                "condition": "[parameters('enableVirtualDisk')]",
                "type": "Microsoft.AzureStackHCI/virtualHardDisks",
                "apiVersion": "2025-09-01-preview",
                "name": "[variables('virtualDiskName')]",
                "location": "[parameters('location')]",
                "extendedLocation": {
                    "type": "CustomLocation",
                    "name": "[parameters('customLocationId')]"
                },
                "properties": {
                    "diskSizeGB": "[parameters('diskSize')]",
                }
            },
            {
                "type": "Microsoft.AzureStackHCI/networkInterfaces",
                "apiVersion": "2025-09-01-preview",
                "name": "[parameters('vNicName')]",
                "location": "[parameters('location')]",
                "extendedLocation": {
                    "type": "CustomLocation",
                    "name": "[parameters('customLocationId')]"
                },
                "properties": {
                    "ipConfigurations": [
                        {
                            "name": "[parameters('vNicName')]",
                            "properties": {
                                "privateIPAddress": "[parameters('privateIPAddress')]",
                                "subnet": {
                                    "id": "[parameters('subnetId')]"
                                }
                            }
                        }
                    ]
                }
            },
            {
                "type": "Microsoft.AzureStackHCI/VirtualMachineInstances",
                "apiVersion": "2023-09-01-preview",
                "name": "default",
                "extendedLocation": {
                    "type": "CustomLocation",
                    "name": "[parameters('customLocationId')]"            },
                "dependsOn": [
                    "[resourceId('Microsoft.HybridCompute/machines', parameters('name'))]",
                    "[resourceId('Microsoft.AzureStackHCI/networkInterfaces', parameters('vNicName'))]",
                    "[resourceid('Microsoft.AzureStackHCI/virtualHardDisks', parameters('diskName'))]"
                ],
                "properties": {
                    "osProfile": {
                        "adminUsername": "[parameters('adminUsername')]",
                        "adminPassword": "[parameters('adminPassword')]",
                        "computerName": "[parameters('name')]",
                        "windowsConfiguration": {
                            "provisionVMAgent": true,
                            "provisionVMConfigAgent": true
                        }
                    },
                    "hardwareProfile": {
                        "vmSize": "Default",
                        "processors": 4,
                        "memoryMB": 8192
                    },
                    "storageProfile": {
                        "imageReference": {
                            "id": "[parameters('imageReferenceId')]"
                        },
                        "dataDisks": [
                            {
                                "id": "[resourceid('Microsoft.AzureStackHCI/virtualHardDisks',parameters('diskName'))]"
                            }
                        ]
                    },
	                "httpProxyConfig": {
                        "httpProxy": "http://proxy.example.com:3128",
                        "httpsProxy": "http://proxy.example.com:3128"
	                },
                    "networkProfile": {
                        "networkInterfaces": [
                            {
                                "id": "[resourceId('Microsoft.AzureStackHCI/networkInterfaces', parameters('vNicName'))]"
                            }
                        ]
                    }
                },
                "scope": "[concat('Microsoft.HybridCompute/machines/', parameters('name'))]"
            },
            {
                "condition": "[parameters('enableDomainJoin')]",
                "type": "Microsoft.HybridCompute/machines/extensions",
                "apiVersion": "2023-03-15-preview",
                "name": "[variables('domainJoinExtensionName')]",
                "location": "[parameters('location')]",
                "dependsOn": [
                    "[concat(resourceId('Microsoft.HybridCompute/machines', parameters('name')), '/providers/Microsoft.AzureStackHCI/virtualmachineinstances/default')]"
                ],
                "properties": {
                    "publisher": "Microsoft.Compute",
                    "type": "JsonADDomainExtension",
                    "typeHandlerVersion": "1.3",
                    "autoUpgradeMinorVersion": true,
                    "settings": {
                        "Name": "[parameters('domainToJoin')]",
                        "OUPath": "[parameters('orgUnitPath')]",
                        "User": "[concat(parameters('domainToJoin'), '\\', parameters('domainUsername'))]",
                        "Restart": "true",
                        "Options": "3"
                    },
                    "protectedSettings": {
                        "Password": "[parameters('domainPassword')]"
                    }
                }
            }
        ]
    }
   ```

1. Select **Save**.

   :::image type="content" source="media/multi-rack-create-arc-virtual-machines/edit-template.png" alt-text="Screenshot of template being edited in Azure portal." lightbox="media/multi-rack-create-arc-virtual-machines/edit-template.png":::

1. You see the blade for providing deployment values. Again, select the resource group. You can use the other default values. When you're done providing values, select **Review + create**

   :::image type="content" source="media/multi-rack-create-arc-virtual-machines/filled-basics.png" alt-text="Screenshot of filled basics tab for template in Azure portal." lightbox="media/multi-rack-create-arc-virtual-machines/filled-basics.png":::

1. After the portal validates the template, select **Create**. A deployment job should start.

   :::image type="content" source="media/multi-rack-create-arc-virtual-machines/filled-review-create.png" alt-text="Screenshot of Review + Create tab for template in Azure portal." lightbox="media/multi-rack-create-arc-virtual-machines/filled-review-create.png":::

1. When the deployment completes, you see the status of the deployment as complete. After the deployment has successfully completed, a VM is created.
    
   <!--:::image type="content" source="./create-arc-virtual-machines/view-resource-group.png" alt-text="Screenshot of resource group with storage account and virtual network in Azure portal." lightbox="media/multi-rack-create-arc-virtual-machines/review-virtual-machine.png":::-->

<!--# [Bicep template](#tab/biceptemplate)

1. Download the sample Bicep template below from the [Azure QuickStarts Repo](https://aka.ms/hci-vmbiceptemplate).
1. Specify parameter values to match your environment. The Custom Location name, Logical Network name parameter values should reference resources you have already created for your Azure Local.
1. Deploy the Bicep template using [Azure CLI](/azure/azure-resource-manager/bicep/deploy-cli) or [Azure PowerShell](/azure/azure-resource-manager/bicep/deploy-powershell)

   :::code language="bicep" source="~/../quickstart-templates/quickstarts/microsoft.azurestackhci/vm-windows-disks-and-adjoin/main.bicep":::

# [Terraform template](#tab/terraformtemplate)

You can use the Azure Verified Module (AVM) that contains the Terraform template for creating Virtual Machines. This module ensures your Terraform templates meet Microsoft's rigorous standards for quality, security, and operational excellence, enabling you to seamlessly deploy and manage on Azure. With this template, you can create one or multiple Virtual Machines on your cluster.

### Steps to use the Terraform template

1. Download the Terraform template from [Azure verified module](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm/0.1.2).
2. Navigate to the **examples** folder in the repository, and look for the following subfolders:
    - **default**: Creates one virtual machine instance.
    - **multi**: Creates multiple virtual machine instances.
3. Choose the appropriate folder for your deployment.
4. To initialize Terraform in your folder from step 2, run the `terraform init` command.
5. To apply the configuration that deploys virtual machines, run the `terraform apply` command.
6. After the deployment is complete, verify your virtual machines via the Azure portal. Navigate to **Resources** > **Virtual machines**.

   :::image type="content" source="media/multi-rack-create-arc-virtual-machines/terraform-virtual-machines.png" alt-text="Screenshot of select Virtual Machine after deployment." lightbox="media/multi-rack-create-arc-virtual-machines/terraform-virtual-machines.png":::
-->
---

> [!NOTE]
> - Two DVD drives are created and used in Azure Local VMs during VM provisioning. The ISO files used during provisioning are removed after successfully creating the VM. However, you might see the empty drives visible for the VM. 
> - To delete these drives in a Windows VM, use Device Manager to uninstall the drives. Depending on the flavor of Linux you are using, you can also delete them for Linux VMs.

## Use managed identity to authenticate Azure Local VMs

When the VMs are created on your Azure Local via Azure CLI or Azure portal, a system-assigned managed identity is also created that lasts for the lifetime of the VMs.

The VMs on Azure Local are extended from Arc-enabled servers and can use system-assigned managed identity to access other Azure resources that support Microsoft Entra ID-based authentication. For example, the VMs can use a system-assigned managed identity to access the Azure Key Vault.

For  more information, see [system-assigned managed identities](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types) and [Authenticate against Azure resource with Azure Arc-enabled servers](/azure/azure-arc/servers/managed-identity-authentication).
