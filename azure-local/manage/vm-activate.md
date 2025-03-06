---
title: Activate Windows Server VMs on Azure Local
description: This article explains the benefits of using Automatic Virtual Machine Activation and provides instructions on setting up this optional feature on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 03/03/2025
ms.service: azure-local
---

# Activate Windows Server VMs on Azure Local

> Applies to: Azure Local 2311.1 and later; Windows Server 2025, Windows Server 2022, Windows Server 2019 Datacenter Edition and later

Windows Server virtual machines (VMs) must be activated before you can use them on Azure Local. You can use any existing Windows Server activation methods that you already have. Optionally, Azure Local offers an addon subscription and tools to help simplify this process. This article describes Windows Server VM activation concepts and the options that are available on Azure Local.

## Summary

First, choose one of the two options:

- **Windows Server subscription**: Activates all Windows Server VMs for the Azure Local. Available for Azure Local only as an add-on.
- [**Azure Hybrid Benefit (AHB)**](/windows-server/get-started/azure-hybrid-benefit): Exchange qualifying Windows Server Datacenter with Software Assurance licenses to activate your Windows Server VMs on Azure Local at a reduced cost.

For more information, see [Compare options](#compare-options).

Next, activate your Windows Server VMs:

- Azure Local supports Automatic VM Activation (AVMA), a method that binds VM activation to the Azure Local machine and activates the Windows Server VM when it starts up.
- If you're using Windows Server subscription, AVMA is automatically enabled on the Azure Local machines. You can immediately activate Windows Server VMs against the system using [generic AVMA client keys](/windows-server/get-started/automatic-vm-activation?tabs=server2025#avma-keys).
- If you're using Azure Hybrid Benefit, you must use the corresponding keys associated with your Windows Server license and apply them using your chosen activation method. One of the most convenient ways is to exchange them to use AVMA by enabling Windows Server subscription.
- To use other methods to activate Windows Server VMs, see [Key Management Services (KMS) activation planning](/windows-server/get-started/kms-activation-planning).

## Compare options

Choose the deployment option that best suits your needs:

| Question | Windows Server subscription | Azure Hybrid Benefit (AHB) |
|--|--|--|
| What versions of WS VMs do you want to use? | Evergreen – all versions up to the latest version. | All versions up to the latest version - includes versions of Windows Server that are supported by Azure Local. Specifically, the benefit is extended to Azure Local version 22H2 or later. |
| Does this option also allow me to use Windows Server: Azure edition? | Yes. | For more information, see [Windows Server versions](/windows-server/get-started/azure-edition). |
| How do I activate my WS VMs? | No host-side keys – AVMA is automatically enabled. After it's enabled, you can then apply the [generic AVMA client keys](/windows-server/get-started/automatic-vm-activation?tabs=server2025#avma-keys) on the client side. | To activate this benefit, you must exchange your 1-core license of Software Assurance-enabled Windows Server Datacenter for 1-physical core of Azure Local. For detailed licensing requirements, see [Azure Hybrid Benefit for Windows Server](/windows-server/get-started/azure-hybrid-benefit?tabs=azure#getting-azure-hybrid-benefit-for-azure-stack-hci). |
| What are the CAL requirements? | No CAL required – included in WS subscription. | No CAL required – included in SA/WS subscription. |
| What is the pricing model? | Per physical core/per month pricing, purchased and billed through Azure (free trial within the first 60 days of registering your Azure Local). For details, see [Pricing for Windows Server subscription](https://azure.microsoft.com/pricing/details/azure-local/). | This benefit waives the Azure Local host service fee and Windows Server subscription fee on your system. Other costs associated with Azure Local, such as Azure services, are billed as normal. For details about pricing with Azure Hybrid Benefit, see [Azure Local pricing](https://azure.microsoft.com/pricing/details/azure-local/). |

### Windows Server VM versions

The following table shows the supported Windows Server VM versions per their activation method.

| Windows Server VM Version | AHB Windows Server 2019 | AHB Windows Server 2022 | AHB Windows Server 2025 |Windows Server subscription |
|--|--|--|--| -- |
| Windows Server 2016 | Y | Y | Y | Y |
| Windows Server 2019 | Y | Y | Y | Y |
| Windows Server 2022 |  | Y | Y | Y |
| Windows Server 2025 |  | | Y | Y |
| Future Windows Server editions (Evergreen) |  |  | | X |

## Activate Windows Server subscription

Windows Server subscription enables you to activate all Windows Server VMs on Azure Local. For the Windows Server subscription fees, see the *Add-on workloads (optional)* section in the [Azure Local pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/) page.

### How does Windows Server subscription work?

When Windows Server subscription is purchased, your Azure Local machines automatically set up AVMA on the Azure Local instance. After setting up AVMA, you can then apply the generic AVMA keys on the client side to activate your Windows Server VMs on Azure Local.

:::image type="content" source="media/vm-activate/windows-server-subscription.png" alt-text="Windows Server subscription" lightbox="media/vm-activate/windows-server-subscription.png":::

### Windows Server subscription prerequisites

- An Azure Local instance
  - [Install updates](update-cluster.md): Version 22H2 or later.
  - [Register Azure Local](../deploy/register-with-azure.md?tab=windows-admin-center#register-a-cluster): All machines must be online and registered to Azure.


### Enable Windows Server subscription

You can enable Windows Server subscription through different methods. Select one of the following tabs based on your preferred method.

### [Azure portal](#tab/azure-portal)

1. In your Azure Local resource page, navigate to the **Configuration** screen.

1. Under the feature **Windows Server subscription add-on**, select **Purchase.** In the context pane, select **Purchase** again to confirm.

   :::image type="content" source="media/vm-activate/configuration-purchase.png" alt-text="Screenshot showing purchase confirmation." lightbox="media/vm-activate/configuration-purchase.png":::

1. For Azure Hybrid Benefit, you must [activate Azure Hybrid Benefit](../concepts/azure-hybrid-benefit.md?tabs=azure-portal) and then select **Activate benefit**.  

   :::image type="content" source="media/vm-activate/configuration-hybrid.png" alt-text="Screenshot showing Azure Hybrid Benefit." lightbox="media/vm-activate/configuration-hybrid.png":::

1. When the Windows Server subscription add-on has been successfully purchased, you can start using Windows Server VMs on your system using [generic AVMA client keys](/windows-server/get-started/automatic-vm-activation?tabs=server2025#avma-keys).


   :::image type="content" source="media/vm-activate/configuration-all-on.png" alt-text="Screenshot showing subscription activations on." lightbox="media/vm-activate/configuration-all-on.png":::

### [Azure CLI](#tab/azurecli)

Azure CLI is available to install in Windows, macOS, and Linux environments. It can also be run in [Azure Cloud Shell](https://shell.azure.com/). This document details how to use Bash in Azure Cloud Shell. For more information, refer [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Azure CLI to configure Windows Server Subscription following these steps:

1. Set up parameters from your subscription, resource group, and cluster name:

   ```azurecli
   subscription="00000000-0000-0000-0000-000000000000" # Replace with your subscription ID        
   resourceGroup="local-rg" # Replace with your resource group name
   clusterName="LocalCluster" # Replace with your cluster name

   az account set --subscription "${subscription}"
   ```

1. To view Windows Server Subscription status on a cluster, run the following command:

   ```azurecli    
   az stack-hci cluster list \
   --resource-group "${resourceGroup}" \
   --query "[?name=='${clusterName}'].{Name:name, DesiredWSSStatus:desiredProperties.windowsServerSubscription}" \
   -o table
   ```

1. To enable Windows Server Subscription on a cluster, run the following command:

   ```azurecli    
   az stack-hci cluster update \
   --cluster-name "${clusterName}" \
   --resource-group "${resourceGroup}" \
   --desired-properties windows-server-subscription="Enabled"
   ```

### [Windows Admin Center](#tab/windows-admin-center)

1. Select **Cluster Manager** from the top drop-down, navigate to the system that you want to activate, then under **Settings**, select **Activate Windows Server VMs**.
2. In the **Automatically activate VMs** pane, select **Set up**, and then select **Purchase Windows Server subscription.** Select **Next** and confirm details, then select **Purchase.**
3. When you complete the purchase successfully, the system retrieves licenses from the cloud, and sets up AVMA on your system.

   :::image type="content" source="media/vm-activate/confirm-purchase.gif" alt-text="Confirm purchase" lightbox="media/vm-activate/confirm-purchase.gif":::

### [PowerShell](#tab/powershell)

- **Purchase Windows Server subscription**: From your system, run the following command:

   ```powershell
   Set-AzStackHCI -EnableWSsubscription $true
   ```

- **Check status**: To check subscription status for each machine, run the following command on each machine:

   ```powershell
   Get-AzureStackHCISubscriptionStatus
   ```

- To check that AVMA is set up with a Windows Server subscription, run the following command on each machine:

  ```powershell
  Get-VMAutomaticActivation
  ```

---

### Troubleshoot subscription issues

**Error**: One or more machines in the system doesn't have the latest changes to this setting. We apply the changes as soon as the machines sync again.

**Remediation**: Your system doesn't have the latest status on Windows Server subscription - for example, you enrolled or canceled and therefore may not have retrieved the services to set up AVMA. In most cases, the next cloud sync will resolve this error. For faster resolution, you can sync manually. For more information, see [Syncing Azure Local](../faq.yml#how-often-does-azure-local-sync-with-the-cloud).


## Activate Azure Hybrid Benefit through AVMA

You can use any existing method to activate Windows Server VMs on Azure Local. Optionally, you can use AVMA, which enables activated Azure Local machines to automatically activate VMs running on them. For more information, see [AVMA in Windows Server](/windows-server/get-started/automatic-vm-activation).

:::image type="content" source="media/vm-activate/vm-activate.png" alt-text="Activate VMs" lightbox="media/vm-activate/vm-activate.png":::

### Benefits of AVMA

VM activation through Azure Local machines presents several benefits:

- Individual VMs don't have to be connected to the internet. Only licensed host machines with internet connectivity are required.
- VM activation management is simplified. Instead of having to true-up key usage counts for individual VMs, you can activate any number of VMs with an active Azure Local Windows Server subscription.
- AVMA acts as a proof-of-purchase mechanism. This capability helps to ensure that Windows products are used in accordance with product use rights and Microsoft software license terms.


### Set up AVMA

You can set up AVMA through different methods. Select one of the following tabs based on your preferred method.

### [Azure portal](#tab/azure-portal)

To set up AVMA, see [Activate Azure Hybrid Benefit](../concepts/azure-hybrid-benefit.md?tabs=azure-portal#activate-azure-hybrid-benefit).

### [Azure CLI](#tab/azurecli)

Use either Windows Admin Center or PowerShell to set up AVMA.

### [Windows Admin Center](#tab/windows-admin-center)

You can use Windows Admin Center to set up and manage product keys for your Azure Local.

Take a few minutes to watch the video on using Automatic Virtual Machine Activation in Windows Admin Center:

> [!VIDEO 65545cda-9e79-413b-9cd0-116a51de0c18]

#### Apply activation keys

To use AVMA in Windows Admin Center:

1. Select **Cluster Manager** from the top drop-down arrow, navigate to the system that you want to activate, then under **Settings**, select **Activate Windows Server VMs**.

   :::image type="content" source="media/vm-activate/apply-keys.gif" alt-text="Apply keys" lightbox="media/vm-activate/apply-keys.gif":::

1. In the **Automatically activate VMs** pane, select **Set up** and then select **Use existing Windows Server licenses**. In the **Apply activation keys to each server** pane, enter your Windows Server Datacenter keys.

   When you finish entering keys for each host machine in the system, select **Apply**. The process then takes a few minutes to complete.

   > [!NOTE]
   > Each machine requires a unique key, unless you have a valid volume license key.

1. Now that AVMA has been enabled, you can activate VMs against the host machine by following the steps in [Automatic Virtual Machine Activation](/windows-server/get-started/automatic-vm-activation).

#### Change or add keys later (optional)

You might want to either change or add keys later; for example, when you add a machine to the system, or use new Windows Server VM versions.

To change or add keys:

1. In the **Activate Windows Server VMs** pane, select the machines that you want to manage, and then select **Manage activation keys**.

   :::image type="content" source="./media/vm-activate/change.gif" alt-text="Short demonstration showing how to change or add keys in Windows Admin Center." lightbox="./media/vm-activate/change.gif":::

2. In the **Manage activation keys** pane, enter the new keys for the selected host machines, and then select **Apply**.

   > [!NOTE]
   > Overwriting keys does not reset the activation count for used keys. Ensure that you're using the right keys before applying them to the machines.

### [PowerShell](#tab/powershell)

You can also use PowerShell to set up and manage key-based AVMA for your Azure Local.

Open PowerShell as an administrator, and run the following commands:

1. Apply Windows Server Datacenter keys to each machine:

    ```powershell
     Set-VMAutomaticActivation <product key>
    ```

1. View and confirm Automatic Virtual Machine Activation status:

    ```powershell
     Get-VMAutomaticActivation
    ```

1. Repeat these steps on each of the other machines in your Azure Local.

Now that you have set up AVMA through AHB, you can activate VMs against the host machine by [following the steps here](/windows-server/get-started/automatic-vm-activation).

---

### Troubleshoot AVMA using Windows Admin Center

If you receive the following AVMA error messages, try using the verification steps in this section to resolve them.

#### Error 1: "The key you entered didn't work"

This error might be due to one of the following issues:

- A key submitted to activate a machine in the system was not accepted.
- A disruption of the activation process prevented a machine in the system from being activated.
- A valid key hasn't been applied to a machine that was added to the system.

To resolve such issues, in the **Activate Windows Server VMs** window, select the machine with the warning, and then select **Manage activation keys** to enter a new key.

#### Error 2: "Some servers use keys for an older version of Windows Server"

All machines must use the same version of keys. Update the keys to the same version to ensure that the VMs stay activated regardless of which machine they run on.

#### Error 3: "Server is down"

Your machine is offline and can't be reached. Bring all machines online and then refresh the page.

#### Error 4: "Couldn't check the status on this server" or "To use this feature, install the latest update"

One or more of your machines isn't updated and doesn't have the required packages to set up AVMA. Ensure that your system is updated, and then refresh the page. For more information, see [Update Azure Local instances](./update-cluster.md).

## FAQs

This section provides answers to some frequently asked questions (FAQs) about Windows Server VMs on Azure Local.

### Do I need to be connected to the internet?

You do need internet connectivity:

- To sync host machines to Azure at least once every 30 days, in order to maintain Azure Local 30-day connectivity requirements and to sync host licenses for AVMA.
- When purchasing or canceling Windows Server subscription.

You don't need internet connectivity:

- For VMs to activate via Windows Server subscription or AHB-based AVMA. For connectivity requirements for other forms of activation, see the [Windows Server documentation](/windows-server/get-started/kms-activation-planning).

### When does Windows Server subscription start/end billing?

Windows Server subscription starts billing and activating Windows Server VMs immediately upon purchase. If you enable Windows Server subscription within the first 60 days of activating Azure Local, you automatically have a free trial during that period.

You can sign up or cancel your Windows Server subscription at any time. Upon cancellation, billing and activation via Azure stops immediately. Make sure you have an alternate form of VM activation if you continue to run Windows Server VMs on your system.

### I have a license for Windows Server, can I run Windows Server 2016 VMs on Azure Local?

Yes. Although you can't use Windows Server 2016 keys to set up AVMA on Azure Local, they can still be applied using [other activation methods](/windows-server/get-started/kms-activation-planning). For example, you can enter a Windows Server 2016 key into your Windows Server 2016 VM directly.

### Where can I get AHB keys for AVMA?

To get a product key, choose from the following options:

- **OEM provider**: Find a Certificate of Authenticity (COA) key label on the outside of the OEM hardware. You can use this key once per machine in the system.
- **Volume Licensing Service Center (VLSC)**: From the VLSC, you can download a Multiple Activation Key (MAK) that you can reuse up to a predetermined number of allowed activations. For more information, see [MAK keys](/licensing/products-keys-faq#what-is-a-multiple-activation-key--mak-).
- **Retail channels**: You can also find a retail key on a retail box label. You can only use this key once per machine in the system. For more information, see [Packaged Software](https://www.microsoft.com/howtotell/software-packaged).

### I want to change an existing key. What happens to the previous key if the overwrite is successful/unsuccessful?

Once a product key is associated with a device, that association is permanent. Overwriting keys doesn't reduce the activation count for used keys. If you successfully apply another key, both keys would be considered to have been "used" once. If you unsuccessfully apply a key, your host machine activation state remains unchanged and defaults to the last successfully added key.

### I want to change to another key of a different version. Is it possible to switch keys between versions?

You can update to newer versions of keys, or replace existing keys with the same version, but you can't downgrade to a previous version.


## Next steps

- [Automatic virtual machine activation](/windows-server/get-started/automatic-vm-activation)
- [Key Management Services (KMS) activation planning for Windows Server](/windows-server/get-started/kms-activation-planning)
