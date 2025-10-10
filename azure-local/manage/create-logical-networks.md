---
title: Create logical networks for Azure Local virtual machines enabled by Azure Arc
description: Learn how to create logical networks on Azure Local. The Azure Local VMs enabled by Azure Arc running on your system use this logical network.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 04/09/2025
ms.custom: sfi-image-nochange
---

# Create logical networks for Azure Local VMs enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create or add logical networks for your Azure Local instance. Any Azure Local virtual machines (VMs) that you create use these logical networks.

> [!NOTE]
> Azure Local VMs only support IPv4 addresses. IPv6 addresses aren't supported.

## Prerequisites

Before you begin, make sure to complete the following prerequisites:


# [Azure CLI](#tab/azurecli)

- Make sure to review and [complete the prerequisites](./azure-arc-vm-management-prerequisites.md). If using a client to connect to your Azure Local, see [Connect to the system remotely](./azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).

- Make sure that all the machines in your Azure Local can access and external virtual machine (VM) switch. By default, an external switch is created during the deployment of your Azure Local that you can use to associate with the logical network you create.

  Run the following command to get the name of the external VM switch on your system.

  ```powershell
  Get-VmSwitch -SwitchType External
  ```

  Make a note of the name of the switch. You use this information when you create a logical network. Here's a sample output:

  ```output
  PS C:\Users\hcideployuser> Get-VmSwitch -SwitchType External
  Name                               SwitchType       NetAdapterInterfaceDescription
  ----                               ----------       ----------------------------
  ConvergedSwitch(management_compute_storage) External        Teamed-Interface
  PS C:\Users\hcideployuser>
  ```

- To create VMs with static IP addresses in your address space, add a logical network with static IP allocation. Reserve an IP range with your network admin and make sure to get the address prefix for this IP range.

# [Azure portal](#tab/azureportal)

The prerequisites for the Azure portal are the same as those for the Azure CLI. See [Azure CLI](./create-logical-networks.md?tabs=azurecli#tabpanel_1_azurecli).

# [Terraform template](#tab/terraformtemplate)

- Make sure Terraform is installed and up to date on your machine.
  - To verify your version of Terraform, run the `terraform -v` command.

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
  - To verify your version of Git, run the `git --version` command.
  
---


## Create the logical network

You can create a logical network using either the Azure Command-Line Interface (CLI) or by using the Azure portal.

> [!NOTE]
> Once a logical network is created, you can't update the following:
>
> - Default gateway
> - IP pools
> - IP address space
> - VLAN ID
> - Virtual switch name

# [Azure CLI](#tab/azurecli)

Complete the following steps to create a logical network using Azure CLI.

### Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

### Create logical network via CLI

You can use the `az stack-hci-vm network lnet create` cmdlet to create a logical network on the VM switch for a DHCP or a static IP configuration. The parameters used to create a DHCP and a static logical network are different.

> [!NOTE]
> For both dynamic and static logical networks, the following apply:
> - Creating logical networks with overlapping IP pools on the same VLAN isn't permitted.
> - If a VLAN ID isn't specified, the value defaults to 0.

#### Create a static logical network via CLI

In this release, you can create Azure Local VMs enabled by Azure Arc using a static IP only via the Azure CLI.

Create a static logical network when you want to create Azure Local VMs with network interfaces on these logical networks. Follow these steps in Azure CLI to configure a static logical network:

1. Set the parameters. Here's an example:

    ```azurecli
    $lnetName = "mylocal-lnet-static"
    $vmSwitchName = '"ConvergedSwitch(management_compute_storage)"'
    $subscription = "<Subscription ID>"
    $resource_group = "mylocal-rg"
    $customLocationName = "mylocal-cl"
    $customLocationID ="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    $addressPrefixes = "100.68.180.0/28"
    $gateway = "192.168.200.1"
    $dnsServers = "192.168.200.222"
    $vlan = "201"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(management_compute_storage) is passed as '"ConvergedSwitch(management_compute_storage)"'.

    For static IP, the *required* parameters are tabulated as follows:

    | Parameters | Description |
    |------------|-------------|
    | **name**  |Name for the logical network that you create for your Azure Local. Make sure to provide a name that follows the [Naming rules for Azure network resources.](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork) You can't rename a logical network after it's created. |
    | **vm-switch-name** |Name of the external virtual switch on your Azure Local where you deploy the logical network. |
    | **resource-group** |Name of the resource group where you create the logical network. For ease of management, we recommend that you use the same resource group as your Azure Local. |
    | **subscription** |Name or ID of the subscription where your Azure Local is deployed. This could be another subscription you use for logical network on your Azure Local. |
    | **custom-location** | Use this to provide the custom location associated with your Azure Local where you're creating this logical network. |
    | **location** | Azure regions as specified by `az locations`. |
    | **vlan** | VLAN identifier for Azure Local VMs. Contact your network admin to get this value. If no VLAN ID is specified, the logical network (LNET) is created with a default VLAN ID of 0. In this configuration, the Azure Local VM sends untagged network traffic, which the physical switch maps to its default VLAN.<br>**Note**: Outbound traffic from the VM, such as internet-bound packets, may be dropped if a default VLAN isn’t configured on the physical switch to handle untagged traffic. |
    | **ip-allocation-method** | IP address allocation method and could be `Dynamic` or `Static`. If this parameter isn't specified, by default the logical network is created with a dynamic configuration. |
    | **address-prefixes** | Subnet address in CIDR notation. For example: "192.168.0.0/16". |
    | **dns-servers** | List of IPv4 addresses of DNS servers. Specify multiple DNS servers in a space separated format. For example: "10.0.0.5" "10.0.0.10" |
    | **gateway** | Ipv4 address of the default gateway. |

    > [!NOTE]
    > DNS server, gateway, and VLAN ID must be specified if you're creating a static logical network.
 

1. Create a static logical network. Run the following cmdlet:

    ```azurecli
    az stack-hci-vm network lnet create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $lnetName --vm-switch-name $vmSwitchName --ip-allocation-method "Static" --address-prefixes $addressPrefixes --gateway $gateway --dns-servers $dnsServers --vlan $vlan
    ```

    Here's a sample output:

    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<Subscription ID>resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<Subscription ID>resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/logicalnetworks/mylocal-lnet-static",
      "location": "eastus",
      "name": "mylocal-lnet-static",
      "properties": {
        "dhcpOptions": {
          "dnsServers": [
            "192.168.200.222"
          ]
        },
        "provisioningState": "Succeeded",
        "status": {},
        "subnets": [
          {
            "name": "mylocal-lnet-static",
            "properties": {
              "addressPrefix": "192.168.201.0/24",
              "addressPrefixes": null,
              "ipAllocationMethod": "Static",
              "ipConfigurationReferences": null,
              "ipPools": null,
              "routeTable": {
                "etag": null,
                "name": null,
                "properties": {
                  "routes": [
                    {
                      "name": "mylocal-lnet-static-default-route",
                      "properties": {
                        "addressPrefix": "0.0.0.0/0",
                        "nextHopIpAddress": "192.168.200.1"
                      }
                    }
                  ]
                },
                "type": null
              },
              "vlan": null
            }
          }
        ],
        "vmSwitchName": "ConvergedSwitch(management_compute_storage)"
      },
      "resourceGroup": "mylocal-rg",
      "systemData": {
        "createdAt": "2023-11-02T16:38:18.460150+00:00",
        "createdBy": "guspinto@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-11-02T16:40:22.996281+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/logicalnetworks"
    }
    ```

  Once the logical network creation is complete, you're ready to create virtual machines with network interfaces on these logical networks.


#### Create a DHCP logical network via CLI

Create a DHCP logical network when the underlying network to which you want to connect your virtual machines has DHCP. 

Follow these steps to configure a DHCP logical network:

1. Set the parameters. Here's an example using the default external switch:

    ```azurecli
    $lnetName = "mylocal-lnet-dhcp"
    $vSwitchName = "ConvergedSwitch(management_compute_storage)"
    $subscription = "<subscription-id>"
    $resourceGroup = "mylocal-rg"
    $customLocationName = "mylocal-cl"
    $customLocationID = "/subscriptions/$subscription/resourceGroups/$resourceGroup/providers/Microsoft.ExtendedLocation/customLocations/$customLocationName"
    $location = "eastus"
    ```

    > [!NOTE]
    > For the default VM switch created at the deployment, pass the name string encased in double quotes followed by single quotes. For example, a default VM switch ConvergedSwitch(management_compute_storage) is passed as '"ConvergedSwitch(management_compute_storage)"'.
    
    Here are the parameters that are *required* to create a DHCP logical network:

    | Parameters | Description |
    |--|--|
    | **name** | Name for the logical network that you create for your Azure Local. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a logical network after it's created. |
    | **vm-switch-name** | Name of the external virtual switch on your Azure Local where you deploy the logical network. |
    | **resource-group** | Name of the resource group where you create the logical network. For ease of management, we recommend that you use the same resource group as your Azure Local. |
    | **subscription** | Name or ID of the subscription where Azure Local is deployed. This could be another subscription you use for logical network on your Azure Local. |
    | **custom-location** | Use this to provide the custom location associated with your Azure Local where you're creating this logical network. |
    | **location** | Azure regions as specified by `az locations`. |
    | **vlan** | VLAN identifier for Azure Local VMs. Contact your network admin to get this value. A value of 0 implies that there's no VLAN ID. |


1. Run the following cmdlet to create a DHCP logical network:

    ```azurecli
    az stack-hci-vm network lnet create --subscription $subscription --resource-group $resourceGroup --custom-location $customLocationID --location $location --name $lnetName --vm-switch-name $vSwitchName --ip-allocation-method "Dynamic"
    ```

    Here's a sample output:
    
    ```output
    {
      "extendedLocation": {
        "name": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/logicalnetworks/mylocal-lnet-dhcp",
      "location": "eastus",
      "name": "mylocal-lnet-dhcp",
      "properties": {
        "dhcpOptions": null,
        "provisioningState": "Succeeded",
        "status": {},
        "subnets": [
          {
            "name": "mylocal-lnet-dhcp",
            "properties": {
              "addressPrefix": null,
              "addressPrefixes": null,
              "ipAllocationMethod": "Dynamic",
              "ipConfigurationReferences": null,
              "ipPools": null,
              "routeTable": null,
              "vlan": 0
            }
          }
        ],
        "vmSwitchName": "ConvergedSwitch(management_compute_storage)"
      },
      "resourceGroup": "mylocal-rg",
      "systemData": {
        "createdAt": "2023-11-02T16:32:51.531198+00:00",
        "createdBy": "guspinto@contoso.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-11-02T23:08:08.462686+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/logicalnetworks"
    }
    ```

# [Azure portal](#tab/azureportal)

Complete the following steps to create a logical network using Azure portal.

1. In the left pane, under **Resources**, select **Logical networks**.

   :::image type="content" source="./media/create-logical-networks/select-logical-network.png" alt-text="Screenshot showing Resources pane in Azure portal." lightbox="./media/create-logical-networks/select-logical-network.png":::

1. In the right pane, select **Create logical network**.

   :::image type="content" source="./media/create-logical-networks/create-logical-network.png" alt-text="Screenshot showing logical network creation link." lightbox="./media/create-logical-networks/create-logical-network.png":::

1. On the **Create logical network** page, on the **Basics** tab:

    - Select the Azure subscription name.
    - Select the associated resource group name.
    - Provide a logical network name. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/azure-resource-manager/management/resource-name-rules#microsoftnetwork) You can't rename a logical network after it's created.
    - Enter the virtual switch name that you saved earlier.
    - The geographic region is automatically set to the region where you registered your system.
    - The custom location is automatically populated from the system.

    When complete, select **Next: Network Configuration**.

   :::image type="content" source="./media/create-logical-networks/enter-network-name.png" alt-text="Screenshot showing Basics tab." lightbox="./media/create-logical-networks/enter-network-name.png":::

### Create a static logical network via portal

1. On the **Network configuration** tab, select **Static** and then enter the following:
    - IPv4 address space (previously reserved).
    - IP pools (if used).
    - Default gateway address.
    - DNS server address.
    - VLAN ID (if used).

    When complete, select **Review + Create**.

   :::image type="content" source="./media/create-logical-networks/enter-ip-addresses.png" alt-text="Screenshot showing Network configuration tab." lightbox="./media/create-logical-networks/enter-ip-addresses.png":::

1. On the **Review + Create** tab, review network settings and then select **Create**:

   :::image type="content" source="./media/create-logical-networks/review-and-create-static.png" alt-text="Screenshot showing static network properties page." lightbox="./media/create-logical-networks/review-and-create-static.png":::

### Create a DHCP logical network via portal

1. On the **Network Configuration** tab, select **DHCP**, and then select **Review + Create**.

1. Enter VLAN ID if used.

   :::image type="content" source="./media/create-logical-networks/configure-dhcp.png" alt-text="Screenshot of DHCP configuration for logical network." lightbox="./media/create-logical-networks/configure-dhcp.png":::

1. On the **Review + Create** tab, review settings and then select **Create**:

   :::image type="content" source="./media/create-logical-networks/review-and-create.png" alt-text="Screenshot of Review + Create for the DHCP logical network." lightbox="./media/create-logical-networks/review-and-create.png":::

### Deploy the logical network via portal

These steps are the same for both static and DHCP network deployments.

1. Verify the network deployment job was submitted:

   :::image type="content" source="./media/create-logical-networks/submitting-deployment.png" alt-text="Screenshot of the submitted deployment job." lightbox="./media/create-logical-networks/submitting-deployment.png":::

1. Verify that the deployment is in progress:

   :::image type="content" source="./media/create-logical-networks/deployment-in-progress.png" alt-text="Screenshot indicating that the deployment job is in progress." lightbox="./media/create-logical-networks/deployment-in-progress.png":::

1. Verify the deployment job completed successfully and then select either **Pin to dashboard** or **Go to resource group**:

   :::image type="content" source="./media/create-logical-networks/deployment-succeeded.png" alt-text="Screenshot of successful completion of the deployment job." lightbox="./media/create-logical-networks/deployment-succeeded.png":::

1. In the resource group, select **Overview** and then verify the logical network is created and listed on the **Resources** tab:

   :::image type="content" source="./media/create-logical-networks/verify-network-created.png" alt-text="Screenshot of the newly created logical network." lightbox="./media/create-logical-networks/verify-network-created.png":::

# [Terraform template](#tab/terraformtemplate)

You can use the Azure Verified Module (AVM) that contains the Terraform template for creating Logical Networks. This module ensures your Terraform templates meet Microsoft's rigorous standards for quality, security, and operational excellence, enabling you to seamlessly deploy and manage on Azure. With this template, you can create one or multiple Logical Networks on your cluster.

### Steps to use the Terraform template

1. Download the Terraform template from [Azure verified module](https://registry.terraform.io/modules/Azure/avm-res-azurestackhci-logicalnetwork/azurerm/0.4.0).
2. Navigate to the **examples** folder in the repository, and look for the following subfolders:
    - **default**: Creates one logical network with a static IP configuration.
    - **static**: Creates one logical network with a static IP configuration.
    - **dhcp**: Creates one logical network with a dynamic IP configuration.
    - **multi**: Creates multiple logical network instances.
3. Choose the appropriate folder for your deployment.
4. To initialize Terraform in your folder from step 2, run the `terraform init` command.
5. To apply the configuration that deploys logical networks, run the `terraform apply` command.
6. After the deployment is complete, verify your logical networks via the Azure portal. Navigate to **Resources** > **Logical networks**.

    :::image type="content" source="./media/create-logical-networks/terraform-logical-networks.png" alt-text="Screenshot of select Logical networks after deployment." lightbox="./media/create-logical-networks/terraform-logical-networks.png":::

---

## Next steps

- [Create Azure Local VMs enabled by Azure Arc](create-arc-virtual-machines.md)
