---
title: Create Arc virtual machines on Azure Stack HCI 
description: Learn how to view your cluster in the Azure portal and create Arc virtual machines on your Azure Stack HCI.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurecli
ms.date: 01/24/2024
---

# Create Arc virtual machines on Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to create an Arc VM starting with the VM images that you've created on your Azure Stack HCI cluster. You can create Arc VMs using the Azure portal.

## About Azure Stack HCI cluster resource

Use the [Azure Stack HCI cluster resource page](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.AzureStackHCI%2Fclusters) for the following operations:

- Create and manage Arc VM resources such as VM images, disks, network interfaces.
- View and access Azure Arc Resource Bridge and Custom Location associated with the Azure Stack HCI cluster.
- Provision and manage Arc VMs.

The procedure to create Arc VMs is described in the next section.

## Prerequisites

Before you create an Azure Arc-enabled VM, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

- If using a client to connect to your Azure Stack HCI cluster, see [Connect to Azure Stack HCI via Azure CLI client](./azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).

- Access to a network interface that you have created on a logical network associated with your Azure Stack HCI cluster. You can choose a network interface with static IP or one with a dynamic IP allocation. For more information, see how to [Create network interfaces](./create-network-interfaces.md).


# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

---

## Create Arc VMs

Follow these steps to create an Arc VM on your Azure Stack HCI cluster.

# [Azure CLI](#tab/azurecli)

Follow these steps on the client running az CLI that is connected to your Azure Stack HCI cluster. 

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../../includes/hci-vm-sign-in-set-subscription.md)]

### Create a VM from network interface

Depending on the type of the network interface that you created, you can create a VM that has network interface with static IP or one with a dynamic IP allocation. Here we will create a VM that uses specific memory and processor counts on a specified storage path.

1. Set some parameters.

    ```azurecli
    $vmName ="myhci-vm"
    $subscription =  "<Subscription ID>"
    $resource_group = "myhci-rg"
    $customLocationName = "myhci-cl"
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    $computerName = "mycomputer"
    $userName = "myhci-user"
    $password = "<Password for the VM>"
    $imageName ="ws22server"
    $nicName ="myhci-vnic" 
    $storagePathName = "myhci-sp" 
    $storagePathId = "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/storagecontainers/myhci-sp" 
    ```

    The parameters for VM creation are tabulated as follows:

    | Parameters | Description |
    |------------|-------------|
    | **name**  |Name for the VM that you'll create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking)|
    | **admin-username** |Username for the user on the VM you are deploying on your Azure Stack HCI cluster. |
    | **admin-password** |Password for the user on the VM you are deploying on your Azure Stack HCI cluster. |
    | **image-name** |Name of the VM image used to provision the VM. |
    | **location** |Azure regions as specified by `az locations`. For example, this could be `eastus`, `westeurope`. |
    | **resource-group** |Name of the resource group where you create the VM. For ease of management, we recommend that you use the same resource group as your Azure Stack HCI cluster. |
    | **subscription** |Name or ID of the subscription where your Azure Stack HCI is deployed. This could be another subscription you use for VM on your Azure Stack HCI cluster. |
    | **custom-location** |Use this to provide the custom location associated with your Azure Stack HCI cluster where you're creating this VM. |
    | **authentication-type** |Type of authentication to use with the VM. The accepted values are `all`, `password`, and `ssh`. Default is password for Windows and SSH public key for Linux. Use `all` to enable both `ssh` and `password` authentication.     |
    | **nics** |Names or the IDs of the network interfaces associated with your VM. You must have atleast one network interface when you create a VM, to enable guest management.|
    | **memory-mb** |Memory in megabtyes allocated to your VM. If not specified, defaults are used.|
    | **processors** |The number of processors allocated to your VM. If not specified, defaults are used.|
    | **storage-path-id** |The associated storage path where the VM configuration and the data is saved.  |

    If configuring a proxy server for your VM, the following *optional* parameters can be specified:

    | Parameters | Description |
    |------------|-------------|
    | **proxyServerHTTP**  |HTTP URLs for proxy server. An example URL is:[`http://proxy.example.com:3128`](http://proxy.example.com:3128).  |
    | **proxyServerHTTPS**  |HTTPS URLs for proxy server. The server may still use an HTTP address as shown in this example: [http://proxy.example.com:3128`](http://proxy.example.com:3128). |
    | **proxyServerNoproxy**  |URLs which can bypass proxy. Typical examples would be `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8`.|
    | **proxyServerUsername**  |Username for proxy authentication. The username and password are combined in this URL format: [http://username:password@proxyserver.contoso.com:3128](http://username:password@proxyserver.contoso.com:3128). An example is: GusPinto|
    | **proxyServerPassword**  |Password for proxy authentication. The username and password are combined in a URL format similar to the following: [`http://username:password@proxyserver.contoso.com:3128`](http://username:password@proxyserver.contoso.com:3128). An example is: `PleaseUseAStrongerPassword!` |
    | **certificateFilePath**  |Name of the certificate file path for your proxy server. An example is: `C:\Users\Palomino\proxycert.crt`. |
  

1. Run the following command to create a VM.

   ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId 
   ``` 

The VM is successfully created when the `provisioningState` shows as `succeeded`in the output.

> [!NOTE]
> The VM created has guest management enabled by default. If for any reason guest management fails during VM creation, you can follow the steps in [Enable guest management on Arc VM](./manage-arc-virtual-machines.md#enable-guest-management) to enable it after the VM creation.

In this example, the storage path was specified using the `--storage-path-id` flag and that ensured that the workload data (including the VM, VM image, non-OS data disk) is placed in the specified storage path.

If the flag is not specified, the workload (VM, VM image, non-OS data disk) is automatically placed in a high availability storage path.


### Create a Linux VM from network interface

To create a Linux VM, use the same command that you used to create the Windows VM.

- The gallery image specified should be a Linux image.
- The username and password works with the `authentication-type-all` parameter.
- For SSH keys, you need to pass the `ssh-key-values` parameters along with the `authentication-type-all`.

> [!IMPORTANT]
> Proxy servers are not supported for Linux VMs.

# [Azure portal](#tab/azureportal)

Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to **Azure Arc > Virtual machines**.
1. From the top command bar, select **+ Add/Create**. From the dropdown list, select **Create a machine in a connected host environment**.

   :::image type="content" source="./media/manage-vm-resources/select-create-vm.png" alt-text="Screenshot of select + Add/Create VM." lightbox="./media/manage-vm-resources/select-create-vm.png":::

1. In the **Create an Azure Arc virtual machine** wizard, on the **Basics** tab, input the following parameters in the **Project details** section:

   :::image type="content" source="./media/manage-vm-resources/create-virtual-machines-project-details.png" alt-text="Screenshot of Project details on  Basics tab." lightbox="./media/manage-vm-resources/create-virtual-machines-project-details.png":::

    1. **Subscription** – The subscription is tied to the billing. Choose the subscription that you want to use to deploy this VM.

    1. **Resource group** – Create new or choose an existing resource group where you'll deploy all the resources associated with your VM.

1. In the **Instance details** section, input the following parameters:

    :::image type="content" source="./media/manage-vm-resources/create-virtual-machines-instance-details.png" alt-text="Screenshot of Instance details on  Basics tab." lightbox="./media/manage-vm-resources/create-virtual-machines-instance-details.png":::

    1. **Virtual machine name** – Enter a name for your VM. The name should follow all the naming conventions for Azure virtual machines.  
    
        > [!IMPORTANT]
        > VM names should be in lowercase letters and may use hyphens and numbers.

    1. **custom-location** – Select the custom location for your VM. The custom locations are filtered to only show those locations that are enabled for your Azure Stack HCI.
    
        **The Virtual machine kind** is automatically set to **Azure Stack HCI**.

    1. **Security type**: For the security of your VM, select **Standard** or **Trusted Launch virtual machines**. For more information on what are Trusted Launch Arc virtual machines, see [What is Trusted Launch for Azure Arc Virtual Machines?](./trusted-launch-vm-overview.md)
    
    1. **Image** – Select the Marketplace or customer managed image to create the VM image.
    
        1. If you selected a Windows image, provide a username and password for the administrator account. You'll also need to confirm the password.
 
          <!--:::image type="content" source="./media/manage-vm-resources/create-arc-vm-windows-image.png" alt-text="Screenshot showing how to Create a VM using Windows VM image." lightbox="./media/manage-vm-resources/create-arc-vm-windows-image.png":::-->       

        1. If you selected a Linux image, in addition to providing username and password, you'll also need SSH keys.

           <!--:::image type="content" source="./media/manage-vm-resources/create-arc-vm-linux-vm-image.png" alt-text="Screenshot showing how to Create a VM using a Linux VM image." lightbox="./media/manage-vm-resources/create-arc-vm-linux-vm-image.png":::-->

    1. **Virtual processor count** – Specify the number of vCPUs you would like to use to create the VM.

    1. **Memory** – Specify the memory in MB for the VM you intend to create.

    1. **Memory type** – Specify the memory type as static or dynamic.


1. In the **VM extensions** section, select the checkbox to enable guest management. You can install extensions on VMs where the guest management is enabled.

    :::image type="content" source="./media/manage-vm-resources/create-virtual-machines-vmext-adminacct-domainjoin.png" alt-text="Screenshot of guest management enabled inVM extensions on  Basics tab." lightbox="./media/manage-vm-resources/create-virtual-machines-vmext-adminacct-domainjoin.png":::   
   
    > [!NOTE]
    > - You can't enable guest management via Azure portal if the Arc VM is already created.
    > - Add at least one network interface through the **Networking** tab to complete guest management setup.
    > - The network interface that you enable, must have a valid IP address and internet access. For more information, see [Arc VM management networking](../manage/azure-arc-vm-management-networking.md#arc-vm-virtual-network).

1. Set the local VM administrator account credentials used when connecting to your VM via RDP. In the **Administrator account** section, input the following parameters: 

    1. Specify the local VM administrator account username.
    1. Specify the password and then **Confirm password**.

1. If you selected a Windows VM image, you can domain join your Windows VM. In the **Domain join** section, input the following parameters: 
   
    1. Select **Enable domain join**.

    1. Only the Active Directory domain join is supported and selected by default.  
    
    1. Provide the UPN of an Active Directory user who has privileges to join the virtual machine to your domain.
    
    1. Provide the domain administrator password.

    1. Specify domain or organizational unit. You can join virtual machines to a specific domain or to an organizational unit (OU) and then provide the domain to join and the OU path.
    
        If the domain is not specified, the suffix of the Active Directory domain join UPN is used by default. For example, the user *guspinto@contoso.com* would get the default domain name *contoso.com*.

1. **(Optional)** Create new or add more disks to the VM. 

   :::image type="content" source="./media/manage-vm-resources/create-new-disk.png" alt-text="Screenshot of new disk added during Create a VM." lightbox="./media/manage-vm-resources/create-new-disk.png":::

    1. Select **+ Add new disk**. 
    1. Provide a **Name** and **Size**. 
    1. You can also choose the disk **Provisioning type** to be **Static** or **Dynamic**.
    1. Select **Add**.

1. **(Optional)** Create or add a network interface for the VM.

    > [!NOTE]
    > If you enabled guest management, you must add at least one network interface.

    :::image type="content" source="./media/manage-vm-resources/create-virtual-network-interface.png" alt-text="Screenshot of network interface added during Create a VM." lightbox="./media/manage-vm-resources/create-virtual-network-interface.png":::

    1. Provide a **Name** for the network interface. 
    1. Select the **Network** and choose static or dynamic IP addresses.
    1. Select IPv4 type as **Static** or **DHCP**. 
        
        For **Static** IP, choose the **Allocation method** as **Automatic** or **Manual**. For **Manual** IP, provide an IP address.

    1. Select **Add**.


1. **(Optional)** Add tags to the VM resource if necessary.

1. Review all the properties of the VM.

    :::image type="content" source="./media/manage-vm-resources/review-virtual-machine.png" alt-text="Screenshot of review page during Create a VM." lightbox="./media/manage-vm-resources/review-virtual-machine.png":::

1. Select **Create**. It should take a few minutes to provision the VM.

---


## Use managed identity to authenticate Arc VMs

When the Arc VMs are created on your Azure Stack HCI system via Azure CLI or Azure portal, a system-assigned managed identity is also created that lasts for the lifetime of the Arc VMs. 

The Arc VMs on Azure Stack HCI are extended from Arc-enabled servers and can use system-assigned managed identity to access other Azure resources that support Microsoft Entra ID-based authentication. For example, the Arc VMs can use a system-assigned managed identity to access the Azure Key Vault.

For  more information, see [System-assigned managed identities](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types) and [Authenticate against Azure resource with Azure Arc-enabled servers](/azure/azure-arc/servers/managed-identity-authentication).


## Next steps

- [Install and manage VM extensions](./virtual-machine-manage-extension.md).
- [Troubleshoot Arc VMs](troubleshoot-arc-enabled-vms.md).
- [Frequently Asked Questions for Arc VM management](./azure-arc-vms-faq.yml).
