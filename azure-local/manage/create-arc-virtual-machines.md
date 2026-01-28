---
title: Create Azure Local Virtual Machines Enabled by Azure Arc 
description: Learn how to view your Azure Local instance in the Azure portal and create Azure Local VMs enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 12/30/2025
ms.custom:
  - devx-track-azurecli
  - sfi-image-nochange
ms.subservice: hyperconverged
---

# Create Azure Local virtual machines enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create Azure Local virtual machines (VMs) enabled by Azure Arc, starting with the VM images that you created on your Azure Local instance. You can create Azure Local VMs by using the Azure CLI, the Azure portal, or an Azure Resource Manager template (ARM template).

## About Azure Local resources

Use the [Azure Local resource page](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.AzureStackHCI%2Fclusters) for the following operations:

- Create and manage Azure Local VM resources such as VM images, disks, and network interfaces.
- View and access the Azure Arc resource bridge and custom location associated with the Azure Local instance.
- Provision and manage VMs.

The procedure to create VMs is described in the next section.

## Prerequisites

Before you create an Azure Local VM, make sure that you meet the following prerequisites.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

- See [Connect to Azure Local via the Azure CLI client](./azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements) if you use a client to connect to your Azure Local instance.
- Have access to a network interface that you created on a logical network associated with your Azure Local instance. You can choose a network interface with a static IP or one with a dynamic IP allocation. For more information, see how to [create network interfaces](./create-network-interfaces.md).

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

# [Azure Resource Manager template](#tab/armtemplate)

[!INCLUDE [hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

- Have access to a logical network that you associate with the VM on your Azure Local instance. For more information, see how to [create a logical network](./create-logical-networks.md).
- [Download the sample ARM template](https://aka.ms/hci-vmarmtemp) in the GitHub Azure quickstarts repo. Use this template to create a VM.

# [Bicep template](#tab/biceptemplate)

[!INCLUDE [hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

- Have access to a logical network that you associate with the VM on your Azure Local instance. For more information, see how to [create a logical network](./create-logical-networks.md).
- [Download the sample Bicep template](https://aka.ms/hci-vmbiceptemplate).

# [Terraform template](#tab/terraformtemplate)

[!INCLUDE[hci-vm-prerequisites](../includes/hci-vm-prerequisites.md)]

- Have access to a logical network that you associate with the VM of your Azure Local instance. For more information, see [create a logical network](../manage/create-logical-networks.md).
- Make sure that Terraform is installed and up to date on your machine. To verify your Terraform version, run the `terraform -v` command.

        Sample output:
    
        ```output
        PS C:\Users\username\terraform-azurenn-avm-res-azurestackhci-virtualmachineinstance> terraform -v 
        Terraform vi.9.8 on windows_amd64
        + provider registry.terraform.io/azure/azapi vl.15.0 
        + provider registry.terraform.io/azure/modtm V0.3.2 
        + provider registry.terraform.io/hashicorp/azurerm v3.116.0 
        + provider registry.terraform.io/hashicorp/random V3.6.3
        ```
    
- Make sure that Git is installed and up to date on your machine. To verify your version of Git, run the `git --version` command.

---

## Create Azure Local VMs

To create a VM on your Azure Local instance, follow these steps.

> [!NOTE]
> - Two DVD drives are created and used in Azure Local VMs during VM provisioning. The ISO files used during provisioning are removed after you successfully create the VM. However, you might see the empty drives visible for the VM.
> - To delete these drives in a Windows VM, use Device Manager to uninstall the drives. Depending on the flavor of Linux that you use, you can also delete them for Linux VMs.

# [Azure CLI](#tab/azurecli)

Follow these steps on the client by running the `az cli` command that's connected to your Azure Local instance.

## Sign in and set the subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

### Create a Windows VM

Depending on the type of network interface that you created, you can create a VM that has a network interface with a static IP or one with a dynamic IP allocation.

If you need more than one network interface with a static IP for your VM, create one or more interfaces now before you create the VM. Adding a network interface with a static IP after the VM is provisioned isn't supported.

Now create a VM that uses specific memory and processor counts on a specified storage path.

1. Set some parameters:

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

    The parameters for VM creation are listed in the following table.

    | Parameters | Description |
    |------------|-------------|
    | `name`  |Name for the VM that you create for your Azure Local instance. Make sure to provide a name that follows the [rules for Azure resources](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking).|
    | `admin-username` |Username for the user on the VM that you're deploying on your Azure Local instance. |
    | `admin-password` |Password for the user on the VM that you're deploying on your Azure Local instance. |
    | `image-name` |Name of the VM image used to provision the VM. |
    | `location` |Azure regions as specified by the `az locations` parameter. For example, they could be `eastus` or `westeurope`. |
    | `resource-group` |Name of the resource group where you create the VM. For ease of management, we recommend that you use the same resource group as your Azure Local instance. |
    | `subscription` |Name or ID of the subscription where your Azure Local instance is deployed. This name or ID could be another subscription that you use for the VM on your Azure Local instance. |
    | `custom-location` |Use this parameter to provide the custom location associated with your Azure Local instance where you create this VM. |
    | `authentication-type` |Type of authentication to use with the VM. The accepted values are `all`, `password`, and `ssh`. The default is the password for Windows and the Secure Shell (SSH) public key for Linux. Use `all` to enable both `ssh` and `password` authentication.     |
    | `nics` |Names or the IDs of the network interfaces associated with your VM. You must have at least one network interface when you create a VM to enable guest management.|
    | `memory-mb` |Memory in megabytes allocated to your VM. If not specified, defaults are used.|
    | `processors` |The number of processors allocated to your VM. If not specified, defaults are used.|
    | `storage-path-id` |The associated storage path where the VM configuration and the data are saved.  |
    | `proxy-configuration` |Use this optional parameter to configure a proxy server for your VM. For more information, see [Create a VM with proxy configured](#create-a-vm-with-proxy-configured).  |

1. Run the following commands to create the applicable VM:
    
    - To create a `Trusted launch` Azure Local VM:
    
        1. Specify more flags to enable secure boot, enable virtual Trusted Platform Module (vTPM), and choose the security type. When you specify that security type as `TrustedLaunch`, you must enable secure boot and vTPM. Otherwise, `TrustedLaunch` VM creation fails.
    
            ```azurecli
            az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --enable-secure-boot true --enable-vtpm true --security-type "TrustedLaunch"
            ```
    
        1. After the VM is created, verify that the security type of the VM is `TrustedLaunch`.
    
        1. Run the following cmdlet (on one of the cluster nodes) to find the owner node of the VM:
    
            ```azurecli
            Get-ClusterGroup $vmName
            ```
    
        1. Run the following cmdlet on the owner node of the VM:
    
            ```azurecli
            (Get-VM $vmName).GuestStateIsolationType
            ```
    
        1. Ensure that a value of `TrustedLaunch` is returned.
    
    - To create a standard Azure Local VM:

       ```azurecli
        az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId 
       ```

    - To create a VM with dynamic memory:

        1. Specify more flags to create a VM with dynamic memory:
    
            `--hardware-profile vm-size="Custom" processors=1 memory-mb=1024 maximum-memory-mb=2048 minimum-memory-mb=1024 target-memory-buffer=20`
        
        1. Note that `minimum-memory-mb` is less than or equal to `memory-mb`, and `maximum-memory-mb` is greater than or equal to `memory-mb`.
    
        Sample script:
    
        ```azurecli
        az stack-hci-vm create --name "my_dynmemory" -g "my_registration" --admin-username "admin" --admin-password "" --custom-location "/subscriptions/my_subscription/resourceGroups/my_registration/providers/Microsoft.ExtendedLocation/customLocations/my_customlocation" --location "eastus2euap" --image "/subscriptions/my_subscription/resourceGroups/my_registration/microsoft.azurestackhci/marketplacegalleryimages/2022-datacenter-azure-edition-core-01" --hardware-profile vm-size="Custom" processors=1 memory-mb=1024 maximum-memory-mb=2048 minimum-memory-mb=1024 target-memory-buffer=20 --enable-agent true --nics "dynnic"
        ```

The VM is successfully created when the `provisioningState` parameter appears as `succeeded` in the output.

> [!NOTE]
> The VM created has guest management enabled by default. If for any reason guest management fails during VM creation, follow the steps in [Enable guest management on the Azure Local VM](./manage-arc-virtual-machines.md#enable-guest-management) to enable it after the VM creation.

In this example, the storage path was specified by using the `--storage-path-id` flag. That flag ensures that the workload data (including the VM, VM image, and non-OS data disk) is placed in the specified storage path.

If the flag isn't specified, the workload (VM, VM image, and non-OS data disk) is automatically placed in a high-availability storage path.

### More parameters for Windows Server 2012 and Windows Server 2012 R2 images

When you create a VM by using Windows Server 2012 and Windows Server 2012 R2 images, specify the following parameters to create the VM:

- `--enable-agent`: Set this parameter to `true` to onboard the Azure Connected Machine Agent on VMs.
- `--enable-vm-config-agent`: Set this parameter to `false` to prevent the onboarding of the VM agent on the VM from the host via the Hyper-V sockets channel. Windows Server 2012 and Windows Server 2012 R2 don't support Hyper-V sockets. In the newer image versions that support Hyper-V sockets, the VM agent is used to onboard the Azure Connected Machine Agent on VMs. For more information on Hyper-V sockets, see [Make your own integration services](/virtualization/hyper-v-on-windows/user-guide/make-integration-service).

### Create a Linux VM

To create a Linux VM, use the same command that you used to create the Windows VM:

- The gallery image you specify must be a Linux image.
- The username and password you use must work with the `authentication-type-all` parameter.
- For SSH keys, you must pass the `ssh-key-values` parameters along with the `authentication-type-all`.

> [!IMPORTANT]
> Setting the proxy server during VM creation is supported for Ubuntu Server VMs.

## Create a VM with a proxy configured

Use the optional parameter `proxy-configuration` to configure a proxy server for your VM.

Proxy configuration for VMs is applied only to the onboarding of the Azure Connected Machine Agent and set as environment variables within the guest VM operating system. Browsers and applications on the VM referencing `WinInet` and `netsh` aren't necessarily all enabled with this proxy configuration. The `WinInet` and `netsh` parameters should be configured with the proxy settings separately.

You might need to specifically set the proxy configuration for your applications if they don't reference the environment variables set within the VM.

If you create a VM behind a proxy server, run the following command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --proxy-configuration http_proxy="<Http URL of proxy server>" https_proxy="<Https URL of proxy server>" no_proxy="<URLs which bypass proxy>" cert_file_path="<Certificate file path for your machine>"
```

Input the following parameters for `proxy-server-configuration`.

| Parameters | Description |
|------------|-------------|
| `http_proxy`  |HTTP URLs for the proxy server. An example URL is `http://proxy.example.com:3128`.  |
| `https_proxy`  |HTTPS URLs for the proxy server. The server might still use an HTTP address, as shown in this example: `http://proxy.example.com:3128`. |
| `no_proxy`  |URLs, which can bypass that proxy. Typical examples are `localhost`, `127.0.0.1`, `.svc`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, and `100.0.0.0/8`.|
| `cert_file_path`  |Select the certificate file used to establish trust with your proxy server. An example is `C:\Users\Palomino\proxycert.crt`. |
<!--| **proxyServerUsername**  |Username for proxy authentication. The username and password are combined in this URL format: `http://username:password@proxyserver.contoso.com:3128`. An example is: `GusPinto`|
| **proxyServerPassword**  |Password for proxy authentication. The username and password are combined in a URL format similar to the following: `http://username:password@proxyserver.contoso.com:3128`. An example is: `UseAStrongerPassword!` |-->

Sample command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --proxy-configuration http_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" https_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" no_proxy="localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8,s-cluster.test.contoso.com" cert_file_path="C:\ClusterStorage\UserStorage_1\server.crt"
```

For proxy authentication, you can pass the username and password combined in a URL, as shown in this example: `"http://username:password@proxyserver.contoso.com:3128"`.

## Create a VM with the Azure Arc gateway configured

Configure the Azure Arc gateway to reduce the number of required endpoints that are needed to provision and manage Azure Local VMs with the Azure Connected Machine Agent. Certain VM extensions can use the Azure Arc gateway to route all Azure Arc traffic from your VM through a single gateway.

For the most up-to-date list of VM extensions that are enabled through the Azure Arc gateway, see [Simplify network configuration requirements with Azure Arc gateway](/azure/azure-arc/servers/arc-gateway?tabs=portal#more-scenarios).

To configure an Azure Arc gateway for your Azure Local VM, create a VM with guest management enabled and pass the optional `--gateway-id` parameter. You can use the Azure Arc gateway with or without proxy configuration. By default, only the Azure Arc traffic is redirected through the Azure Arc proxy.

If your VM applications or services are reaching the Azure endpoint, configure the proxy inside the VM to use the Azure Arc proxy. For applications that don't reference the environment variables set within the VMs, specify a proxy as needed.

> [!IMPORTANT]
> Traffic intended for endpoints not managed by the Azure Arc gateway is routed through the enterprise proxy or firewall.
>
> For Windows VMs, allow the following endpoints: `https://agentserviceapi.guestconfiguration.azure.com` and `https://<azurelocalregion>-gas.guestconfiguration.azure.com`.
>
> For Linux VMs, allow the following endpoints: `https://agentserviceapi.guestconfiguration.azure.com`, `https://<azurelocalregion>-gas.guestconfiguration.azure.com`, and `https://packages.microsoft.com`.

### Create a VM with the Azure Arc gateway enabled behind a proxy server

Run the following command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gateway-id $gw --proxy-configuration http_proxy="<Http URL of proxy server>" https_proxy="<Https URL of proxy server>" no_proxy="<URLs which bypass proxy>" cert_file_path="<Certificate file path for your machine>"
```

You can input the following parameters for `proxy-server-configuration` with `Arc gateway`.

| Parameters | Description |
|------------|-------------|
| `gateway-id` | Resource ID of your Azure Arc gateway. A gateway resource ID example is `/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.HybridCompute/gateways/$gwid`. |
| `http_proxy`  |HTTP URLs for the proxy server. An example URL is `http://proxy.example.com:3128`.  |
| `https_proxy`  |HTTPS URLs for the proxy server. The server might still use an HTTP address, as shown in this example: `http://proxy.example.com:3128`. |
| `no_proxy`  |URLs, which can bypass the proxy. Typical examples are `localhost`, `127.0.0.1`, `.svc`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, and `100.0.0.0/8`.|

Sample command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gateway-id $gw --proxy-configuration http_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" https_proxy="http://ubuntu:ubuntu@192.168.200.200:3128" no_proxy="localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8,s-cluster.test.contoso.com" 
```

### Create a VM with the Azure Arc gateway enabled without the proxy server

Run the following command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gateway-id $gw
```

You can input the following parameters for the Azure Arc gateway.

| Parameters | Description |
|------------|-------------|
| `gateway-id` | Resource ID of your Azure Arc gateway. A gateway resource ID example is `/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.HybridCompute/gateways/$gwid`. |

Sample command:

```azurecli
az stack-hci-vm create --name $vmName --resource-group $resource_group --admin-username $userName --admin-password $password --computer-name $computerName --image $imageName --location $location --authentication-type all --nics $nicName --custom-location $customLocationID --hardware-profile memory-mb="8192" processors="4" --storage-path-id $storagePathId --gateway-id $gw 
```

# [Azure portal](#tab/azureportal)

Follow these steps in the Azure portal for your Azure Local instance.

> [!IMPORTANT]
> Setting the proxy server during VM creation is supported for Ubuntu Server VMs.

1. Go to **Azure Arc cluster view** > **Virtual machines**.
1. From the top command bar, select **+ Create VM**.

   :::image type="content" source="./media/create-arc-virtual-machines/select-create-vm.png" alt-text="Screenshot that shows selecting + Create VM." lightbox="./media/create-arc-virtual-machines/select-create-vm.png":::

1. On the **Basics** tab, input the following parameters in the **Project details** section:

   :::image type="content" source="./media/create-arc-virtual-machines/create-virtual-machines-project-details.png" alt-text="Screenshot that shows Project details on the Basics tab." lightbox="./media/create-arc-virtual-machines/create-virtual-machines-project-details.png":::

    - **Subscription**: The subscription is tied to the billing. Choose the subscription that you want to use to deploy this VM.
    - **Resource group**: Create a new resource group or choose an existing resource group where you deploy all the resources associated with your VM.

1. In the **Instance details** section, input the following parameters:

    :::image type="content" source="./media/create-arc-virtual-machines/create-virtual-machines-instance-details.png" alt-text="Screenshot that shows Instance details on the Basics tab." lightbox="./media/create-arc-virtual-machines/create-virtual-machines-instance-details.png":::

    1. **Virtual machine name**: Enter a name for your VM. The name should follow all the naming conventions for Azure VMs.  
    
        VM names should be in lowercase letters and can include hyphens and numbers.

    1. **Custom location**: Select the custom location for your VM. The custom locations are filtered to show only those locations that are enabled for your Azure Local instance. The VM kind is automatically set to **Azure Local**.

    1. **Security type**: For the security of your VM, select **Standard** or **Trusted launch virtual machines**. For more information about Trusted launch Azure Local VMs, see [What is Trusted launch for Azure Local virtual machines?](./trusted-launch-vm-overview.md).

   1. **Storage path**: Select the storage path for your VM image:

      - **Choose automatically**: Select this option to have a storage path with high availability automatically selected.
      - **Choose manually**: Select this option to specify a storage path to store VM images and configuration files on your Azure Local instance. Ensure that the selected storage path has sufficient storage space.

   1. **Image**: Select Azure Marketplace or a customer-managed image to create the VM image:
    
        - If you selected a Windows image, provide a username and password for the administrator account, and then confirm the password.
        <!--:::image type="content" source="./media/create-arc-virtual-machines/create-arc-vm-windows-image.png" alt-text="Screenshot that shows how to create a VM by using Windows VM image." lightbox="./media/create-arc-virtual-machines/create-arc-vm-windows-image.png":::-->

        - If you selected a Linux image, along with a username and password, you also need SSH keys.

           <!--:::image type="content" source="./media/create-arc-virtual-machines/create-arc-vm-linux-vm-image.png" alt-text="Screenshot that shows how to create a VM by using a Linux VM image." lightbox="./media/create-arc-virtual-machines/create-arc-vm-linux-vm-image.png":::-->

    1. **Virtual processor count**: Specify the number of vCPUs you want to use to create the VM.

    1. **Memory**: Specify the memory in MB for the VM that you intend to create.

    1. **Memory type**: Specify the memory type as **Static** or **Dynamic**.

1. In the **VM extensions** section, select **Enable guest management**. You can install extensions on VMs where the guest management is enabled.

    :::image type="content" source="./media/create-arc-virtual-machines/arc-vm-guest-management.png" alt-text="Screenshot that shows the VM extensions section with the Enable guest management checkbox selected." lightbox="./media/create-arc-virtual-machines/arc-vm-guest-management.png":::

    Add at least one network interface by using the **Networking** tab to finish the guest management setup.
    
    The network interface that you enable must have a valid IP address and internet access. For more information, see [Azure Local VM management networking](../manage/azure-arc-vm-management-networking.md#arc-vm-virtual-network).

1. In the **VM proxy configuration** section, select a connectivity method. This method is used to onboard the Azure Connected Machine Agent on your VM. You have two options:
    - **Public endpoint**: For direct connection to the internet without a proxy.
    - **Proxy server**: To connect to the internet through a proxy for your VM. You can choose to have the same proxy server as your Azure Local instance or configure a different proxy server for your VM.

        Proxy configuration for VMs is applied only to the onboarding of the Azure Connected Machine Agent and set as environment variables within the guest VM operating system. Browsers and applications on the VM referencing `WinInet` and `netsh` aren't necessarily all enabled with this proxy configuration. `WinInet` and `netsh` should be configured with the proxy settings separately.

        You might need to specifically set the proxy configuration for your applications if they don't reference the environment variables set within the VM.

        :::image type="content" source="./media/create-arc-virtual-machines/arc-vm-proxy-configuration.png" alt-text="Screenshot that shows the local VM administrator on the Basics tab." lightbox="./media/create-arc-virtual-machines/arc-vm-proxy-configuration.png":::

1. If you selected **Proxy server**, provide the following proxy information:

    - **Http proxy**: Enter an HTTP URL for the proxy server. An example URL is `http://proxy.example.com:3128`.
    - **Https proxy**: Enter an HTTPS URL for the proxy server. The server might still use an HTTP address as shown in this example: `http://proxy.example.com:3128`.
    - **No proxy**: Specify URLs to bypass the proxy. Typical examples are `localhost,127.0.0.1`,`.svc,10.0.0.0/8`,`172.16.0.0/12`,`192.168.0.0/16`, and`100.0.0.0/8`.
    - **Certificate file**: Select **Browse** and choose the certificate file used to establish trust with your proxy server.

        > [!NOTE]
        > For proxy authentication, you can pass the username and password combined in a URL as shown in this example: `http://username:password@proxyserver.contoso.com:3128`.

1. Configure the Azure Arc gateway to reduce the number of required endpoints that are needed to provision and manage Azure Local VMs with the Azure Connected Machine Agent. Certain VM extensions can use the Azure Arc gateway to route all Azure Arc traffic from your VM through a single gateway. For the most up-to-date list of VM extensions enabled through Azure Arc gateway, see [Simplify network configuration requirements with Azure Arc gateway](/azure/azure-arc/servers/arc-gateway?tabs=portal#more-scenarios).

    1. From the **Arc gateway** dropdown, select an existing gateway or select **Create new** to set up a gateway.
    1. If you create a new gateway, fill in the **Create an Arc gateway resource** pane with information on the subscription, resource group, name, location, and tags.

    :::image type="content" source="./media/create-arc-virtual-machines/arc-vm-arc-gateway.png" alt-text="Screenshot that shows VM proxy configuration settings on the left and a pane to create an Azure Arc gateway resource on the right." lightbox="./media/create-arc-virtual-machines/arc-vm-arc-gateway.png":::

1. Set the local VM administrator account credentials used when you connect to your VM via the Remote Desktop Protocol. In the **Administrator account** section, input the following parameters:

    :::image type="content" source="./media/create-arc-virtual-machines/create-virtual-machines-administrator-account-domain-join.png" alt-text="Screenshot that shows guest management enabled in VM extensions on the Basics tab." lightbox="./media/create-arc-virtual-machines/create-virtual-machines-administrator-account-domain-join.png":::

    1. Specify the local VM administrator account username.
    1. Specify the password and then confirm the password.

1. If you selected a Windows VM image, you can domain join your Windows VM. In the **Domain join** section, input the following parameters:

    1. Select **Enable domain join**.

    1. Only the Active Directory domain join is supported and selected by default.

    1. Enter the user principal name (UPN) of an Active Directory user who has privileges to join the VM to your domain.

       > [!IMPORTANT]
       > For your Active Directory instance, if your security account manager (SAM) account name and UPN are different, enter the SAM account name in the UPN field as `SAMAccountName@domain`.

    1. Enter the password of the user account that you entered in the previous step. If you use the SAM account name in the UPN field, enter the corresponding password.

    1. Specify the domain or organizational unit (OU). You can join VMs to a specific domain or to an OU and then provide the domain to join and the OU path.
    
        If the domain isn't specified, the suffix of the Active Directory domain join UPN is used by default. For example, the user `guspinto@contoso.com` gets the default domain name `contoso.com`.

1. **(Optional)**: Create new disks or add more disks to the VM.

   :::image type="content" source="./media/create-arc-virtual-machines/create-new-disk.png" alt-text="Screenshot that shows a new disk added during Create a VM." lightbox="./media/create-arc-virtual-machines/create-new-disk.png":::

    1. Select **+ Add new disk**.
    1. Provide a name and size.
    1. For **Provisioning type**, select **Static** or **Dynamic**.
    1. **Storage path**: Select the storage path for your VM image. Select **Choose automatically** to have a storage path with high availability automatically selected. Select **Choose manually** to specify a storage path to store VM images and configuration files on the Azure Local instance. Ensure that the selected storage path has sufficient storage space. If you select the manual option, previous storage options autopopulate the dropdown by default.
    1. Select **Add**. The new disk appears in the list view.
    
       :::image type="content" source="./media/create-arc-virtual-machines/create-new-disk.png" alt-text="Screenshot that shows a new disk added during Create a VM." lightbox="./media/create-arc-virtual-machines/create-new-disk.png":::

1. **(Optional)**: Create or add a network interface for the VM.

    - If you enabled guest management, you must add at least one network interface.
    - If you need more than one network interface with static IPs for your VM, create one or more interfaces now before you create the VM. Adding a network interface with static IP after the VM is provisioned isn't supported.

    :::image type="content" source="./media/create-arc-virtual-machines/add-new-network-interface.png" alt-text="Screenshot that shows the network interface added during creation of a VM." lightbox="./media/create-arc-virtual-machines/add-new-network-interface.png":::

    1. Enter a name for the network interface.
    1. From the dropdown list, select the network. Based on the network that you select, you see the IPv4 type automatically populate as **Static** or **DHCP**.
    1. For a static IP, for **Allocation Method**, select **Automatic** or **Manual**. For a manual IP, provide an IP address.
    1. Select **Add**.

1. **(Optional)**: Add tags to the VM resource if necessary.

1. Review all the properties of the VM.

    :::image type="content" source="./media/create-arc-virtual-machines/review-virtual-machine.png" alt-text="Screenshot that shows the review page during creation of a VM." lightbox="./media/create-arc-virtual-machines/review-virtual-machine.png":::

1. Select **Create**. The process to provision the VM takes a few minutes.

# [Azure Resource Manager template](#tab/armtemplate)

To deploy the ARM template, Follow these steps.

1. In the Azure portal, from the top search bar, search for **deploy a custom template**. Select **Deploy a custom template** from the available options.

1. On the **Select a template** tab, select **Build your own template in the editor**.

   :::image type="content" source="./media/create-arc-virtual-machines/build-own-template.png" alt-text="Screenshot that shows the Build your own template option in the Azure portal." lightbox="./media/create-arc-virtual-machines/build-own-template.png":::

   A blank template appears.

   :::image type="content" source="./media/create-arc-virtual-machines/blank-template.png" alt-text="Screenshot that shows a blank ARM template in the Azure portal." lightbox="./media/create-arc-virtual-machines/blank-template.png":::

1. Replace the blank template with the template that you downloaded during the prerequisites step.

    This template creates an Azure Local VM. First, a virtual network interface is created. You can optionally enable domain join and attach a virtual disk to the VM that you create. Finally, the VM is created with guest management enabled.

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

   :::image type="content" source="./media/create-arc-virtual-machines/edit-template.png" alt-text="Screenshot that shows the template being edited in the Azure portal." lightbox="./media/create-arc-virtual-machines/edit-template.png":::

1. The pane where you enter deployment values opens. Again, select the resource group. You can use the other default values. After you finish entering values, select **Review + create**

   :::image type="content" source="./media/create-arc-virtual-machines/filled-basics.png" alt-text="Screenshot that shows the filled Basics tab for a template in the Azure portal." lightbox="./media/create-arc-virtual-machines/filled-basics.png":::

1. After the portal validates the template, select **Create**. A deployment job starts.

   :::image type="content" source="./media/create-arc-virtual-machines/filled-review-create.png" alt-text="Screenshot that shows the Review + create tab for a template in the Azure portal." lightbox="./media/create-arc-virtual-machines/filled-review-create.png":::

1. After the deployment finishes, you see the status of the deployment as complete and a VM is created on your Azure Local instance.
    
   <!--:::image type="content" source="./create-arc-virtual-machines/view-resource-group.png" alt-text="Screenshot of resource group with storage account and virtual network in Azure portal." lightbox="./media/create-arc-virtual-machines/review-virtual-machine.png":::-->

# [Bicep template](#tab/biceptemplate)

1. Download the sample Bicep template from the [Azure quickstarts repo](https://aka.ms/hci-vmbiceptemplate).
1. Specify parameter values to match your environment. The custom location name and logical network name parameter values should reference resources that you already created for your Azure Local instance.
1. Deploy the Bicep template by using the [Azure CLI](/azure/azure-resource-manager/bicep/deploy-cli) or [Azure PowerShell](/azure/azure-resource-manager/bicep/deploy-powershell).

   :::code language="bicep" source="~/../quickstart-templates/quickstarts/microsoft.azurestackhci/vm-windows-disks-and-adjoin/main.bicep":::

# [Terraform template](#tab/terraformtemplate)

You can use the Azure Verified Module (AVM) that contains the Terraform template to create VMs. This module ensures that your Terraform templates meet Microsoft standards for quality, security, and operational excellence to help you seamlessly deploy and manage your VMs on Azure. With this template, you can create one or multiple VMs on your cluster.

### Steps to use the Terraform template

1. Download the Terraform template from the [Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-virtualmachineinstance/azurerm/).
1. Go to the **examples** folder in the repository, and look for the following subfolders:
    - **default**: Creates one VM instance.
    - **multi**: Creates multiple VM instances.
1. Choose the appropriate folder for your deployment.
1. To initialize Terraform in your folder from step 2, run the `terraform init` command.
1. To apply the configuration that deploys VMs, run the `terraform apply` command.
1. After the deployment is finished, verify your VMs via the Azure portal. Go to **Resources** > **Virtual machines**.

   :::image type="content" source="./media/create-arc-virtual-machines/terraform-virtual-machines.png" alt-text="Screenshot that shows a select VM after deployment." lightbox="./media/create-arc-virtual-machines/terraform-virtual-machines.png":::

---

## Use managed identity to authenticate Azure Local VMs

When the VMs are created on your Azure Local instance via the Azure CLI or the Azure portal, a system-assigned managed identity is also created that lasts for the lifetime of the VMs.

The VMs on your Azure Local instance are extended from Azure Arc-enabled servers and can use system-assigned managed identity to access other Azure resources that support authentication based on Microsoft Entra ID. For example, the VMs can use a system-assigned managed identity to access Azure Key Vault.

For more information, see [System-assigned managed identities](/entra/identity/managed-identities-azure-resources/overview#managed-identity-types) and [Authenticate against Azure resources with Azure Arc-enabled servers](/azure/azure-arc/servers/managed-identity-authentication).

## Related content

- [Delete Azure Local VMs](./manage-arc-virtual-machines.md#delete-a-vm)
- [Install and manage VM extensions](./virtual-machine-manage-extension.md)
- [Troubleshoot Azure Local VMs](troubleshoot-arc-enabled-vms.md)
- [Frequently asked questions for Azure Local VM management](./azure-arc-vms-faq.yml)
