---
title: Create Azure Local virtual machines enabled by Azure Arc 
description: Learn how to view your Azure Local instance in the Azure portal and create Azure Local VMs enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/26/2025
ms.custom:
  - devx-track-azurecli
  - sfi-image-nochange
---

# Create Azure Local virtual machines enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create Azure Local virtual machines (VMs) enabled by Azure Arc, starting with the VM images that you created on your Azure Local instance. You can create Azure Local VMs using the Azure CLI, Azure portal, or Azure Resource Manager template.

## About Azure Local resource

Use the [Azure Local resource page](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.AzureStackHCI%2Fclusters) for the following operations:

- Create and manage Azure Local VM resources such as VM images, disks, network interfaces.
- View and access Azure Arc resource bridge and custom location associated with the Azure Local instance.
- Provision and manage VMs.

The procedure to create VMs is described in the next section.

## Prerequisites

Before you create an Azure Local VM, make sure that the following prerequisites are complete:

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

- If using a client to connect to your Azure Local, see [Connect to Azure Local via Azure CLI client](./azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).

- Access to a network interface that you created on a logical network associated with your Azure Local. You can choose a network interface with static IP or one with a dynamic IP allocation. For more information, see how to [Create network interfaces](./create-network-interfaces.md).

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

# [Azure Resource Manager template](#tab/armtemplate)

[!INCLUDE [hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

- Access to a logical network that you associate with the VM on your Azure Local. For more information, see how to [Create logical network](./create-logical-networks.md).
- [Download the sample Azure Resource Manager template](https://aka.ms/hci-vmarmtemp) in the GitHub Azure QuickStarts repo. You use this template to create a VM.

# [Bicep template](#tab/biceptemplate)

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

---

## Create Azure Local VMs

Follow these steps to create a VM on your Azure Local.

# [Azure CLI](#tab/azurecli)

Follow these steps on the client running az CLI that is connected to your Azure Local.

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

### Create a Windows VM

Depending on the type of the network interface that you created, you can create a VM that has network interface with static IP or one with a dynamic IP allocation.

> [!NOTE]
> If you need more than one network interface with static IPs for your VM, create one or more interfaces now before you create the VM. Adding a network interface with static IP, after the VM is provisioned, isn't supported.

Here we create a VM that uses specific memory and processor counts on a specified storage path.

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
    $imageName ="ws22server"
    $nicName ="local-vnic" 
    $storagePathName = "local-sp" 
    $storagePathId = "/subscriptions/<Subscription ID>/resourceGroups/local-rg/providers/Microsoft.AzureStackHCI/storagecontainers/local-sp" 
    ```

    The parameters for VM creation are tabulated as follows:

    | Parameters | Description |
    |------------|-------------|
    | **name**  |Name for the VM that you create for your Azure Local. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking)|
    | **admin-username** |Username for the user on the VM you're deploying on your Azure Local. |
    | **admin-password** |Password for the user on the VM you're deploying on your Azure Local. |
    | **image-name** |Name of the VM image used to provision the VM. |
    | **location** |Azure regions as specified by `az locations`. For example, this could be `eastus`, `westeurope`. |
    | **resource-group** |Name of the resource group where you create the VM. For ease of management, we recommend that you use the same resource group as your Azure Local. |
    | **subscription** |Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for VM on your Azure Local. |
    | **custom-location** |Use this to provide the custom location associated with your Azure Local where you're creating this VM. |
    | **authentication-type** |Type of authentication to use with the VM. The accepted values are `all`, `password`, and `ssh`. Default is password for Windows and SSH public key for Linux. Use `all` to enable both `ssh` and `password` authentication.     |
    | **nics** |Names or the IDs of the network interfaces associated with your VM. You must have atleast one network interface when you create a VM, to enable guest management.|
    | **memory-mb** |Memory in Megabytes allocated to your VM. If not specified, defaults are used.|
    | **processors** |The number of processors allocated to your VM. If not specified, defaults are used.|
    | **storage-path-id** |The associated storage path where the VM configuration and the data are saved.  |
    | **proxy-configuration** |Use this optional parameter to configure a proxy server for your VM. For more information, see [Create a VM with proxy configured](#create-a-vm-with-proxy-configured).  |

1. Run the following commands to create the applicable VM.

    **To create a Trusted launch Azure Local VM:**

    1. Specify additional flags to enable secure boot, enable virtual TPM, and choose security type. Note, when you specify security type as Trusted launch, you must enable secure boot and vTPM, otherwise Trusted launch VM creation will fail.

        ```azurecli
        az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --enable-secure-boot true --enable-vtpm true --security-type "TrustedLaunch"
        ```

    1. Once the VM is created, to verify the security type of the VM is `Trusted launch`, do the following.

    1. Run the following cmdlet (on one of the cluster nodes) to find the owner node of the VM:

        ```azurecli
        Get-ClusterGroup $vmName
        ```

    1. Run the following cmdlet on the owner node of the VM:

        ```azurecli
        (Get-VM $vmName).GuestStateIsolationType
        ```

    1. Ensure a value of `TrustedLaunch` is returned.

    **To create a standard Azure Local VM:**

   ```azurecli
    az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId 
   ```

The VM is successfully created when the `provisioningState` shows as `succeeded`in the output.

> [!NOTE]
> The VM created has guest management enabled by default. If for any reason guest management fails during VM creation, you can follow the steps in [Enable guest management on Azure Local VM](./manage-arc-virtual-machines.md#enable-guest-management) to enable it after the VM creation.

In this example, the storage path was specified using the `--storage-path-id` flag and that ensured that the workload data (including the VM, VM image, non-OS data disk) is placed in the specified storage path.

If the flag isn't specified, the workload (VM, VM image, non-OS data disk) is automatically placed in a high availability storage path.

### Additional parameters for Windows Server 2012 and Windows Server 2012 R2 images

When creating a VM using Windows Server 2012 and Windows Server 2012 R2 images, specify the following additional parameters to create the VM:

- `--enable-agent`: Set this parameter to `true` to onboard the Azure Connected Machine agent on VMs.
- `--enable-vm-config-agent`: Set this parameter to `false` to prevent the onboarding of the VM agent on the VM from the host via Hyper-V sockets channel. Windows Server 2012 and Windows Server 2012 R2 don't support Hyper-V sockets. In the newer image versions that support Hyper-V sockets, the VM agent is used to onboard the Azure Connected Machine agent on VMs. For more information on Hyper-V sockets, see [Make your own integration services](/virtualization/hyper-v-on-windows/user-guide/make-integration-service).

### Create a Linux VM

To create a Linux VM, use the same command that you used to create the Windows VM.

- The gallery image specified should be a Linux image.
- The username and password works with the `authentication-type-all` parameter.
- For SSH keys, you need to pass the `ssh-key-values` parameters along with the `authentication-type-all`.

> [!IMPORTANT]
> Setting the proxy server during VM creation is supported for Ubuntu Server VMs.

### Create a VM with proxy configured

Use this optional parameter **proxy-configuration** to configure a proxy server for your VM.

Proxy configuration for VMs is applied only to the onboarding of the Azure connected machine agent and set as environment variables within the guest VM operating system. Browsers and applications on the VM aren't necessarily all enabled with this proxy configuration.

As such, you may need to specifically set the proxy configuration for your applications if they don't reference the environment variables set within the VM.

If creating a VM behind a proxy server, run the following command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --proxy-configuration http_proxy="<Http URL of proxy server>" https_proxy="<Https URL of proxy server>" no_proxy="<URLs which bypass proxy>" cert_file_path="<Certificate file path for your machine>"
```

You can input the following parameters for `proxy-server-configuration`:

| Parameters | Description |
|------------|-------------|
| **http_proxy**  |HTTP URLs for proxy server. An example URL is:`http://proxy.example.com:3128`.  |
| **https_proxy**  |HTTPS URLs for proxy server. The server may still use an HTTP address as shown in this example: `http://proxy.example.com:3128`. |
| **no_proxy**  |URLs, which can bypass proxy. Typical examples would be `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8`.|
| **cert_file_path**  |Select the certificate file used to establish trust with your proxy server. An example is: `C:\Users\Palomino\proxycert.crt`. |
<!--| **proxyServerUsername**  |Username for proxy authentication. The username and password are combined in this URL format: `http://username:password@proxyserver.contoso.com:3128`. An example is: `GusPinto`|
| **proxyServerPassword**  |Password for proxy authentication. The username and password are combined in a URL format similar to the following: `http://username:password@proxyserver.contoso.com:3128`. An example is: `UseAStrongerPassword!` |-->

Here's a sample command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --proxy-configuration http_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" https_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" no_proxy="localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8,s-cluster.test.contoso.com" cert_file_path="C:\ClusterStorage\UserStorage_1\server.crt"
```

For proxy authentication, you can pass the username and password combined in a URL as follows:`"http://username:password@proxyserver.contoso.com:3128"`.

### Create a VM with Arc gateway configured

Use this optional parameter **gateway-id** to configure a Arc gateway for your VM.

Arc gateway for VMs is configured during the onboarding of the Azure connected machine agent and be used with or without proxy configuration. When enabling the Arc gateway on Azure connected machines, only the Arc traffic will be redirected through the Arc proxy by default. If you want all the OS applications or services to also use the Arc gateway inside the VM, you will need to configure the proxy inside the VM to use the Arc proxy. Only the allowed endpoints by Arc gateway will be sent over the Arc gateway tunnel. The rest of the traffic will be sent to the endpoint directly or over your enterprise proxy, depending on the VM configuration.

As such, you may need to specifically set the proxy configuration for your applications if they don't reference the environment variables set within the VM.

> [!IMPORTANT]
> Traffic intended for endpoints not managed by the Arc gateway is routed through the enterprise proxy or firewall.
> 
> For Windows VMs, allow the following endpoints: `https://agentserviceapi.guestconfiguration.azure.com` and `https://<azurelocalregion>-gas.guestconfiguration.azure.com`.
> 
> For Linux VMs, allow the following endpoints: `https://agentserviceapi.guestconfiguration.azure.com`, `https://<azurelocalregion>-gas.guestconfiguration.azure.com`, and `https://packages.microsoft.com`.

#### To create a VM with Arc gateway enabled behind a proxy server, run the following command

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gateway-id $gw --proxy-configuration http_proxy="<Http URL of proxy server>" https_proxy="<Https URL of proxy server>" no_proxy="<URLs which bypass proxy>" cert_file_path="<Certificate file path for your machine>"
```

You can input the following parameters for `proxy-server-configuration` with `Arc gateway`:

| Parameters | Description |
|------------|-------------|
| **gateway-id** | Resource Id of your Arc gateway. A Gateway resource Id example is: `/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.HybridCompute/gateways/$gwid` |
| **http_proxy**  |HTTP URLs for proxy server. An example URL is:`http://proxy.example.com:3128`.  |
| **https_proxy**  |HTTPS URLs for proxy server. The server may still use an HTTP address as shown in this example: `http://proxy.example.com:3128`. |
| **no_proxy**  |URLs, which can bypass proxy. Typical examples would be `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8`.|

Here's a sample command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gateway-id $gw --proxy-configuration http_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" https_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" no_proxy="localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8,s-cluster.test.contoso.com" 
```

#### To create a VM with Arc gateway enabled without proxy server, run the following command

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gateway-id $gw
```

You can input the following parameters for `Arc gateway`:

| Parameters | Description |
|------------|-------------|
| **gateway-id** | Resource Id of your Arc gateway. A Gateway resource Id example is: `/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.HybridCompute/gateways/$gwid` |

Here's a sample command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gateway-id $gw 
```

# [Azure portal](#tab/azureportal)

Follow these steps in Azure portal for your Azure Local.

> [!IMPORTANT]
> Setting the proxy server during VM creation is supported for Ubuntu Server VMs.

1. Go to **Azure Arc cluster view** > **Virtual machines**.
1. From the top command bar, select **+ Create VM**.

   :::image type="content" source="./media/create-arc-virtual-machines/select-create-vm.png" alt-text="Screenshot of select + Add/Create VM." lightbox="./media/create-arc-virtual-machines/select-create-vm.png":::

1. On the **Basics** tab, input the following parameters in the **Project details** section:

   :::image type="content" source="./media/create-arc-virtual-machines/create-virtual-machines-project-details.png" alt-text="Screenshot of Project details on Basics tab." lightbox="./media/create-arc-virtual-machines/create-virtual-machines-project-details.png":::

    1. **Subscription** – The subscription is tied to the billing. Choose the subscription that you want to use to deploy this VM.

    1. **Resource group** – Create new or choose an existing resource group where you deploy all the resources associated with your VM.

1. In the **System details** section, input the following parameters:

    :::image type="content" source="./media/create-arc-virtual-machines/create-virtual-machines-instance-details.png" alt-text="Screenshot of system details on Basics tab." lightbox="./media/create-arc-virtual-machines/create-virtual-machines-instance-details.png":::

    1. **Virtual machine name** – Enter a name for your VM. The name should follow all the naming conventions for Azure virtual machines.  
    
        > [!IMPORTANT]
        > VM names should be in lowercase letters and can include hyphens and numbers.

    1. **custom-location** – Select the custom location for your VM. The custom locations are filtered to only show those locations that are enabled for your Azure Local.
    
        **The Virtual machine kind** is automatically set to **Azure Local**.

    1. **Security type** - For the security of your VM, select **Standard** or **Trusted launch virtual machines**. For more information about Trusted launch Azure Local VMs, see [What is Trusted launch for Azure Local Virtual Machines?](./trusted-launch-vm-overview.md).

   1. **Storage path** - Select the storage path for your VM image. Select **Choose automatically** to have a storage path with high availability automatically selected. Select **Choose manually** to specify a storage path to store VM images and configuration files on your Azure Local. In this case, ensure that the selected storage path has sufficient storage space.

   1. **Image** – Select the Marketplace or customer managed image to create the VM image.
    
        1. If you selected a Windows image, provide a username and password for the administrator account, and then confirm the password.
 
        <!--:::image type="content" source="./media/create-arc-virtual-machines/create-arc-vm-windows-image.png" alt-text="Screenshot showing how to Create a VM using Windows VM image." lightbox="./media/create-arc-virtual-machines/create-arc-vm-windows-image.png":::-->

        1. If you selected a Linux image, in addition to providing username and password, you'll also need SSH keys.

           <!--:::image type="content" source="./media/create-arc-virtual-machines/create-arc-vm-linux-vm-image.png" alt-text="Screenshot showing how to Create a VM using a Linux VM image." lightbox="./media/create-arc-virtual-machines/create-arc-vm-linux-vm-image.png":::-->

    1. **Virtual processor count** – Specify the number of vCPUs you would like to use to create the VM.

    1. **Memory** – Specify the memory in MB for the VM you intend to create.

    1. **Memory type** – Specify the memory type as static or dynamic.

1. In the **VM extensions** section, select the checkbox to enable guest management and input the following parameters. You can install extensions on VMs where the guest management is enabled.

    > [!NOTE]
    > - Add at least one network interface through the **Networking** tab to complete guest management setup.
    > - The network interface that you enable, must have a valid IP address and internet access. For more information, see [Azure Local VM management networking](../manage/azure-arc-vm-management-networking.md#arc-vm-virtual-network).

1. In the VM proxy configuration section, to configure a proxy for your VM, input the following parameters:

    > [!NOTE]
    > Proxy configuration for VMs is applied only to the onboarding of the Azure connected machine agent and set as environment variables within the guest VM operating system. Browsers and applications on the VM aren't necessarily all enabled with this proxy configuration. As such, you may need to specifically set the proxy configuration for your applications if they don't reference the environment variables set within the VM.

    :::image type="content" source="./media/create-arc-virtual-machines/arc-vm-proxy-configuration.png" alt-text="Screenshot of local VM administrator on Basics tab." lightbox="./media/create-arc-virtual-machines/arc-vm-proxy-configuration.png":::

    - **Http proxy** - Provide an HTTP URL for the proxy server. An example URL is: `http://proxy.example.com:3128`.
    - **Https proxy** - Provide an HTTPS URL for the proxy server. The server may still use an HTTP address as shown in this example: `http://proxy.example.com:3128`.
    - **No proxy** - Specify URLs to bypass the proxy. Typical examples would be: `localhost,127.0.0.1`,`.svc,10.0.0.0/8`,`172.16.0.0/12`,`192.168.0.0/16`,`100.0.0.0/8`.
    - **Certificate file** - Select the certificate file used to establish trust with your proxy server.

    > [!NOTE]
    > For proxy authentication, you can pass the username and password combined in a URL as follows: `http://username:password@proxyserver.contoso.com:3128`.

1. Set the local VM administrator account credentials used when connecting to your VM via RDP. In the **Administrator account** section, input the following parameters:

    :::image type="content" source="./media/create-arc-virtual-machines/create-virtual-machines-administrator-account-domain-join.png" alt-text="Screenshot of guest management enabled inVM extensions on Basics tab." lightbox="./media/create-arc-virtual-machines/create-virtual-machines-administrator-account-domain-join.png":::

    1. Specify the local VM administrator account username.
    1. Specify the password and then **Confirm password**.

1. If you selected a Windows VM image, you can domain join your Windows VM. In the **Domain join** section, input the following parameters:
   
    1. Select **Enable domain join**.

    1. Only the Active Directory domain join is supported and selected by default.  
    
    1. Provide the UPN of an Active Directory user who has privileges to join the virtual machine to your domain.
       
       > [!IMPORTANT]
       > For your Active Directory, if your SAM Account Name and UPN are different, enter the SAM Account Name in the UPN field as: `SAMAccountName@domain`.
    
    1. Provide the password of the user account you entered in the previous step. If using SAM Account Name in the UPN field, enter the corresponding password.

    1. Specify domain or organizational unit. You can join virtual machines to a specific domain or to an organizational unit (OU) and then provide the domain to join and the OU path.
    
        If the domain isn't specified, the suffix of the Active Directory domain join UPN is used by default. For example, the user *guspinto@contoso.com* would get the default domain name *contoso.com*.

1. **(Optional)** Create new or add more disks to the VM.

   :::image type="content" source="./media/create-arc-virtual-machines/create-new-disk.png" alt-text="Screenshot of new disk added during Create a VM." lightbox="./media/create-arc-virtual-machines/create-new-disk.png":::

    1. Select **+ Add new disk**.
    1. Provide a **Name** and **Size**.
    1. Choose the disk **Provisioning type** to be **Static** or **Dynamic**.
    1. **Storage path** - Select the storage path for your VM image. Select **Choose automatically** to have a storage path with high availability automatically selected.  Select **Choose manually** to specify a storage path to store VM images and configuration files on the Azure Local instance. In this case, ensure that the selected storage path has sufficient storage space. If you select the manual option, previous storage options autopopulate the dropdown by default.
    1. Select **Add**. After it's created, you can see the new disk in the list view.
    
       :::image type="content" source="./media/create-arc-virtual-machines/create-new-disk.png" alt-text="Screenshot of new disk added during Create a VM." lightbox="./media/create-arc-virtual-machines/create-new-disk.png":::

1. **(Optional)** Create or add a network interface for the VM.

    > [!NOTE]
    > - If you enabled guest management, you must add at least one network interface.
    > - If you need more than one network interface with static IPs for your VM, create one or more interfaces now before you create the VM. Adding a network interface with static IP, after the VM is provisioned, isn't supported.

    :::image type="content" source="./media/create-arc-virtual-machines/add-new-network-interface.png" alt-text="Screenshot of network interface added during Create a VM." lightbox="./media/create-arc-virtual-machines/add-new-network-interface.png":::

    1. Provide a **Name** for the network interface.
    1. From the drop-down list, select the **Network**. Based on the network selected, you see the IPv4 type automatically populate as **Static** or **DHCP**.
    1. For **Static** IP, choose the **Allocation method** as **Automatic** or **Manual**. For **Manual** IP, provide an IP address.

    1. Select **Add**.

1. **(Optional)** Add tags to the VM resource if necessary.

1. Review all the properties of the VM.

    :::image type="content" source="./media/create-arc-virtual-machines/review-virtual-machine.png" alt-text="Screenshot of review page during Create a VM." lightbox="./media/create-arc-virtual-machines/review-virtual-machine.png":::

1. Select **Create**. It should take a few minutes to provision the VM.

# [Azure Resource Manager template](#tab/armtemplate)

Follow these steps to deploy the Resource Manager template:

1. In the Azure portal, from the top search bar, search for *deploy a custom template*. Select **Deploy a custom template** from the available options.

1. On the **Select a template** tab, select **Build your own template in the editor**.

   :::image type="content" source="./media/create-arc-virtual-machines/build-own-template.png" alt-text="Screenshot of build your own template option in Azure portal." lightbox="./media/create-arc-virtual-machines/build-own-template.png":::

1. You see a blank template.

   :::image type="content" source="./media/create-arc-virtual-machines/blank-template.png" alt-text="Screenshot of blank Resource Manager template in Azure portal." lightbox="./media/create-arc-virtual-machines/blank-template.png":::

1. Replace the blank template with the template that you downloaded during the prerequisites step.

    This template creates an Azure Local VM. First, a virtual network interface is created. You can optionally enable domain-join and attach a virtual disk to the VM you create. Finally, the VM is created with the guest management enabled.

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
                    "description": "The Azure Resource Manager ID of the subnet for the network interface."
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
                "apiVersion": "2023-09-01-preview",
                "name": "[variables('virtualDiskName')]",
                "location": "[parameters('location')]",
                "extendedLocation": {
                    "type": "CustomLocation",
                    "name": "[parameters('customLocationId')]"
                },
                "properties": {
                    "diskSizeGB": "[parameters('diskSize')]",
                    "dynamic": true
                }
            },
            {
                "type": "Microsoft.AzureStackHCI/networkInterfaces",
                "apiVersion": "2023-09-01-preview",
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

   :::image type="content" source="./media/create-arc-virtual-machines/edit-template.png" alt-text="Screenshot of template being edited in Azure portal." lightbox="./media/create-arc-virtual-machines/edit-template.png":::

1. You see the blade for providing deployment values. Again, select the resource group. You can use the other default values. When you're done providing values, select **Review + create**

   :::image type="content" source="./media/create-arc-virtual-machines/filled-basics.png" alt-text="Screenshot of filled basics tab for template in Azure portal." lightbox="./media/create-arc-virtual-machines/filled-basics.png":::

1. After the portal validates the template, select **Create**. A deployment job should start.

   :::image type="content" source="./media/create-arc-virtual-machines/filled-review-create.png" alt-text="Screenshot of Review + Create tab for template in Azure portal." lightbox="./media/create-arc-virtual-machines/filled-review-create.png":::

1. When the deployment completes, you see the status of the deployment as complete. After the deployment has successfully completed, a VM is created on your Azure Local.
    
   <!--:::image type="content" source="./create-arc-virtual-machines/view-resource-group.png" alt-text="Screenshot of resource group with storage account and virtual network in Azure portal." lightbox="./media/create-arc-virtual-machines/review-virtual-machine.png":::-->

# [Bicep template](#tab/biceptemplate)

1. Download the sample Bicep template below from the [Azure QuickStarts Repo](https://aka.ms/hci-vmbiceptemplate).
1. Specify parameter values to match your environment. The Custom Location name, Logical Network name parameter values should reference resources you have already created for your Azure Local.
1. Deploy the Bicep template using [Azure CLI](/azure/azure-resource-manager/bicep/deploy-cli) or [Azure PowerShell](/azure/azure-resource-manager/bicep/deploy-powershell)

   :::code language="bicep" source="~/../quickstart-templates/quickstarts/microsoft.azurestackhci/vm-windows-disks-and-adjoin/main.bicep":::

# [Terraform template](#tab/terraformtemplate)

You can use the Azure Verified Module (AVM) that contains the Terraform template for creating Virtual Machines. This module ensures your Terraform templates meet Microsoft's rigorous standards for quality, security, and operational excellence, enabling you to seamlessly deploy and manage on Azure. With this template, you can create one or multiple Virtual Machines on your cluster.

### Steps to use the Terraform template

1. Download the Terraform template from [Azure verified module](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm/).
2. Navigate to the **examples** folder in the repository, and look for the following subfolders:
    - **default**: Creates one virtual machine instance.
    - **multi**: Creates multiple virtual machine instances.
3. Choose the appropriate folder for your deployment.
4. To initialize Terraform in your folder from step 2, run the `terraform init` command.
5. To apply the configuration that deploys virtual machines, run the `terraform apply` command.
6. After the deployment is complete, verify your virtual machines via the Azure portal. Navigate to **Resources** > **Virtual machines**.

   :::image type="content" source="./media/create-arc-virtual-machines/terraform-virtual-machines.png" alt-text="Screenshot of select Virtual Machine after deployment." lightbox="./media/create-arc-virtual-machines/terraform-virtual-machines.png":::

---

> [!NOTE]
> - Two DVD drives are created and used in Azure Local VMs during VM provisioning. The ISO files used during provisioning are removed after successfully creating the VM. However, you might see the empty drives visible for the VM. 
> - To delete these drives in a Windows VM, use Device Manager to uninstall the drives. Depending on the flavor of Linux you are using, you can also delete them for Linux VMs.

## Use managed identity to authenticate Azure Local VMs

When the VMs are created on your Azure Local via Azure CLI or Azure portal, a system-assigned managed identity is also created that lasts for the lifetime of the VMs.

The VMs on Azure Local are extended from Arc-enabled servers and can use system-assigned managed identity to access other Azure resources that support Microsoft Entra ID-based authentication. For example, the VMs can use a system-assigned managed identity to access the Azure Key Vault.

For  more information, see [system-assigned managed identities](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types) and [Authenticate against Azure resource with Azure Arc-enabled servers](/azure/azure-arc/servers/managed-identity-authentication).

## Next steps

- [Delete Azure Local VMs](./manage-arc-virtual-machines.md#delete-a-vm).
- [Install and manage VM extensions](./virtual-machine-manage-extension.md).
- [Troubleshoot Azure Local VMs](troubleshoot-arc-enabled-vms.md).
- [Frequently Asked Questions for Azure Local VM management](./azure-arc-vms-faq.yml).
