---
title: Create logical networks for Kubernetes clusters on Azure Stack HCI 23H2
description: Learn how to create Arc-enabled logical networks for AKS.
ms.topic: how-to
author: sethmanheim
ms.date: 04/02/2024
ms.author: sethm 
ms.lastreviewed: 04/01/2024
ms.reviewer: abha
---

# Create logical networks for Kubernetes clusters on Azure Stack HCI 23H2

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

After you install and configure Azure Stack HCI 23H2, you must create Arc VM logical networks. AKS on Azure Stack HCI uses static logical networks to provide IP addresses to the underlying VMs of the AKS clusters.

## Before you begin

Before you begin, make sure you have the following prerequisites:

- Install and configure Azure Stack HCI 23H2. Make sure you have the custom location Azure Resource Manager ID, as this ID is a required parameter for creating a logical network.
- Make sure that the logical network you create contains enough usable IP addresses to avoid IP address exhaustion. IP address exhaustion can lead to Kubernetes cluster deployment failures. For more information, see [Networking concepts in AKS on Azure Stack HCI 23H2](aks-hci-network-system-requirements.md).
- Make sure you have an external VM switch that can be accessed by all the servers in your Azure Stack HCI cluster. By default, an external switch is created during the deployment of your Azure Stack HCI cluster that you can use to associate with the logical network you will create.

Run the following command to get the name of the external VM switch on your Azure Stack HCI cluster:

```powershell
Get-VmSwitch -SwitchType External
```

Make a note of the name of the switch. You use this information when you create a logical network. For example:

```powershell
Get-VmSwitch -SwitchType External
```

```output
Name                               SwitchType       NetAdapterInterfaceDescription
----                               ----------       ----------------------------
ConvergedSwitch(management_compute_storage) External        Teamed-Interface
```

## Create the logical network

You can create a logical network using either the Azure Command-Line Interface (CLI) or by using the Azure portal.

# [Azure CLI](#tab/azurecli)

You can use the [`az stack-hci-vm network lnet create`](/cli/azure/stack-hci-vm/network/lnet#az-stack-hci-vm-network-lnet-create) cmdlet to create a logical network on the VM switch in Static IP configuration.

For static IP, the required parameters are as follows:

| Required parameters | Description |
|------------|-------------|
| `--name`  | Name for the logical network that you create for your Azure Stack HCI cluster. Make sure to provide a name that follows the [rules for Azure resources](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking). You can't rename a logical network after it's created. |
| `--resource-group` | Name of the resource group where you create the logical network. |
| `--subscription` | Name or ID of the subscription where your Azure Stack HCI is deployed. |
| `--custom-location` | Provide the custom location associated with your Azure Stack HCI cluster where you're creating the logical network. |
| `--vm-switch-name`     | The name of the VM switch. Usage: `--vm-switch-name "vm-switch-01"`. | 
| `--address-prefixes` | AddressPrefix for the network. Currently only 1 address prefix is supported. Usage: `--address-prefixes "10.220.32.16/24"`. |
| `--dns-servers`      | Space-separated list of DNS server IP addresses. Usage: `--dns-servers 10.220.32.16 10.220.32.17`. | 
| `--gateway`         | Gateway. The gateway IP address must be within the scope of the address prefix. Usage: `--gateway 10.220.32.16`. |
| `--ip-allocation-method`   | The IP address allocation method. Supported values are "Static". Usage: `--ip-allocation-method "Static"`. |
| `--ip-pool-start`     | The start IP address of your IP pool. The address must be in range of the address prefix. Usage: `--ip-pool-start "10.220.32.18"`.  | 
| `--ip-pool-end`       | The end IP address of your IP pool. The address must be in range of the address prefix. Usage: `--ip-pool-end "10.220.32.38"`.  |
```azurecli
az stack-hci-vm network lnet create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --name $lnetName --vm-switch-name $vmSwitchName --ip-allocation-method "Static" --address-prefixes $addressPrefixes --gateway $gateway --dns-servers $dnsServers --ip-pool-start $ipPoolStart --ip-pool-end $ipPoolEnd
```

# [Azure portal](#tab/azureportal)

Complete the following steps to create a logical network using the Azure portal:

1. In the left pane, under **Resources**, select **Logical networks**.

   :::image type="content" source="./media/aks-networks/select-logical-network.png" alt-text="Screenshot showing Resources pane in Azure portal." lightbox="./media/aks-networks/select-logical-network.png":::

2. In the right pane, select **Create logical network**.

   :::image type="content" source="./media/aks-networks/create-logical-network.png" alt-text="Screenshot showing logical network creation link." lightbox="./media/aks-networks/create-logical-network.png":::

3. On the **Create logical network** page, on the **Basics** tab:

    - Select the Azure subscription name.
    - Select the associated resource group name.
    - Provide a logical network name. Make sure to provide a name that follows the [Rules for Azure resources.](/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-networking) You can't rename a logical network after it's created.
    - Enter the virtual switch name that you saved earlier.
    - The geographic region is automatically set to the region where you registered your cluster.
    - The custom location is automatically populated from the cluster.

    When complete, select **Next: Network Configuration**.

   :::image type="content" source="./media/aks-networks/enter-network-name.png" alt-text="Screenshot showing Basics tab." lightbox="./media/aks-networks/enter-network-name.png":::

4. On the **Network configuration** tab, select **Static** and then enter the following:
    - IPv4 address space (previously reserved).
    - IP pools.
    - Default gateway address.
    - DNS server address.
    - VLAN ID (if used).

    When complete, select **Review + Create**.

   :::image type="content" source="./media/aks-networks/enter-ip-addresses.png" alt-text="Screenshot showing Network configuration tab." lightbox="./media/aks-networks/enter-ip-addresses.png":::

5. On the **Review + Create** tab, review network settings and then select **Create**:

   :::image type="content" source="./media/aks-networks/review-and-create-static.png" alt-text="Screenshot showing static network properties page." lightbox="./media/aks-networks/review-and-create-static.png":::

---

## Next steps

[Create and manage Kubernetes clusters on-premises using Azure CLI](aks-create-clusters-cli.md)
