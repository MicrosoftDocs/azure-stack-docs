---
title: Activate Windows Server VMs on Azure Local
description: This article explains the benefits of using Automatic Virtual Machine Activation and provides instructions on setting up this optional feature on Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.date: 06/29/2026
ms.service: azure-local
ms.subservice: hyperconverged
---

# Activate Windows Server VMs on Azure Local

> Applies to: Azure Local; Windows Server 2025, Windows Server 2022, Windows Server 2019 Datacenter Edition and later

You must activate Windows Server virtual machines (VMs) before you can use them on Azure Local. You can use any existing Windows Server activation methods that you already have. Optionally, Azure Local offers an add-on subscription and tools to help simplify this process. This article describes Windows Server VM activation concepts and the options that are available on Azure Local.

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
| What versions of WS VMs do you want to use? | Evergreen – all versions up to the latest version. | All versions up to the latest version - includes versions of Windows Server that are supported by Azure Local. |
| Does this option also allow me to use Windows Server: Azure edition? | Yes. | For more information, see [Windows Server versions](/windows-server/get-started/azure-edition). |
| How do I activate my WS VMs? | No host-side keys – AVMA is automatically enabled. After it's enabled, you can then apply the [generic AVMA client keys](/windows-server/get-started/automatic-vm-activation?tabs=server2025#avma-keys) on the client side. | To activate this benefit, you must exchange your 1-core license of Software Assurance-enabled Windows Server Datacenter for 1-physical core of Azure Local. For detailed licensing requirements, see [Azure Hybrid Benefit for Windows Server](/windows-server/get-started/azure-hybrid-benefit?tabs=azure#getting-azure-hybrid-benefit-for-azure-stack-hci). |
| What are the CAL requirements? | No CAL required – included in WS subscription. | No CAL required – included in SA/WS subscription. |
| What is the pricing model? | Per physical core/per month pricing, purchased and billed through Azure (free trial within the first 60 days of registering your Azure Local). For details, see [Pricing for Windows Server subscription](https://azure.microsoft.com/pricing/details/azure-local/). | This benefit waives the Azure Local host service fee and Windows Server subscription fee on your system. Other costs associated with Azure Local, such as Azure services, are billed as normal. For details about pricing with Azure Hybrid Benefit, see [Azure Local pricing](https://azure.microsoft.com/pricing/details/azure-local/). |

### Windows Server VM versions

The following table shows the supported Windows Server VM versions per their activation method.

| Windows Server VM Version | AHB Windows Server 2019 | AHB Windows Server 2022 | AHB Windows Server 2025 |Windows Server subscription |
|--|--|--|--|--|
| Windows Server 2016 | Y | Y | Y | Y |
| Windows Server 2019 | Y | Y | Y | Y |
| Windows Server 2022 |  | Y | Y | Y |
| Windows Server 2025 |  | | Y | Y |
| Future Windows Server editions (Evergreen) |  |  | | X |

## Activate Windows Server subscription

Windows Server subscription enables you to activate all Windows Server VMs on Azure Local. For the Windows Server subscription fees, see the *Add-on workloads (optional)* section in the [Azure Local pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/) page.

### How does Windows Server subscription work?

When you purchase a Windows Server subscription, your Azure Local machines automatically set up AVMA on the Azure Local instance. After setting up AVMA, you can apply the generic AVMA keys on the client side to activate your Windows Server VMs on Azure Local.

:::image type="content" source="media/vm-activate/windows-server-subscription.png" alt-text="Windows Server subscription" lightbox="media/vm-activate/windows-server-subscription.png":::

### Windows Server subscription prerequisites

- An Azure Local instance
  - [Install updates](../update/about-updates-23h2.md).
  - [Register Azure Local](../deploy/register-with-azure.md?tab=windows-admin-center#register-a-cluster): All machines must be online and registered to Azure.

### Enable Windows Server subscription

You can enable Windows Server subscription through different methods. Select one of the following tabs based on your preferred method.

### [Azure portal](#tab/azure-portal)

1. In your Azure Local resource page, go to the **Configuration** screen.

1. Under the feature **Windows Server subscription add-on**, select **Purchase**. In the context pane, select **Purchase** again to confirm.

   :::image type="content" source="media/vm-activate/configuration-purchase.png" alt-text="Screenshot showing purchase confirmation." lightbox="media/vm-activate/configuration-purchase.png":::

1. For Azure Hybrid Benefit, [activate Azure Hybrid Benefit](../concepts/azure-hybrid-benefit.md?tabs=azure-portal) and then select **Activate benefit**.  

   :::image type="content" source="media/vm-activate/configuration-hybrid.png" alt-text="Screenshot showing Azure Hybrid Benefit." lightbox="media/vm-activate/configuration-hybrid.png":::

1. After you purchase the Windows Server subscription add-on, you can start using Windows Server VMs on your system by using [generic AVMA client keys](/windows-server/get-started/automatic-vm-activation?tabs=server2025#avma-keys).


   :::image type="content" source="media/vm-activate/configuration-all-on.png" alt-text="Screenshot showing subscription activations on." lightbox="media/vm-activate/configuration-all-on.png":::

### [Azure CLI](#tab/azurecli)

You can install Azure CLI on Windows, macOS, and Linux environments. You can also run it in [Azure Cloud Shell](https://shell.azure.com/). This article explains how to use Bash in Azure Cloud Shell. For more information, see [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Azure CLI to configure Windows Server Subscription by following these steps:

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

1. Select **Cluster Manager** from the top drop-down, go to the system that you want to activate, and then under **Settings**, select **Activate Windows Server VMs**.
1. In the **Automatically activate VMs** pane, select **Set up**, and then select **Purchase Windows Server subscription.** Select **Next** and confirm details, and then select **Purchase.**
1. When you complete the purchase successfully, the system retrieves licenses from the cloud, and sets up AVMA on your system.

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

**Error**: One or more machines in the system don't have the latest changes to this setting. The system applies the changes as soon as the machines sync again.

**Remediation**: Your system doesn't have the latest status on Windows Server subscription - for example, you enrolled or canceled and therefore might not have retrieved the services to set up AVMA. In most cases, the next cloud sync resolves this error. For faster resolution, you can sync manually. For more information, see [Syncing Azure Local](../faq.yml).


## Activate Azure Hybrid Benefit through AVMA

You can use any existing method to activate Windows Server VMs on Azure Local. Optionally, you can use AVMA, which enables activated Azure Local machines to automatically activate VMs running on them. For more information, see [AVMA in Windows Server](/windows-server/get-started/automatic-vm-activation).

:::image type="content" source="media/vm-activate/vm-activate.png" alt-text="Activate VMs" lightbox="media/vm-activate/vm-activate.png":::

### Benefits of AVMA

VM activation through Azure Local machines offers several benefits:

- Individual VMs don't need internet connectivity. Only licensed host machines require internet access.
- Simplified VM activation management. Instead of managing key usage counts for individual VMs, you can activate any number of VMs with an active Azure Local Windows Server subscription.
- AVMA serves as a proof-of-purchase mechanism. This capability helps ensure that Windows products are used in accordance with product use rights and Microsoft software license terms.


### Set up AVMA

Set up AVMA through different methods. Select one of the following tabs based on your preferred method.

### [Azure portal](#tab/azure-portal)

To set up AVMA, see [Activate Azure Hybrid Benefit](../concepts/azure-hybrid-benefit.md?tabs=azure-portal#activate-azure-hybrid-benefit).

### [Azure CLI](#tab/azurecli)

Use either Windows Admin Center or PowerShell to set up AVMA.

### [Windows Admin Center](#tab/windows-admin-center)

Use Windows Admin Center to set up and manage product keys for your Azure Local.

Take a few minutes to watch the following video on using Automatic Virtual Machine Activation in Windows Admin Center:

> [!VIDEO 65545cda-9e79-413b-9cd0-116a51de0c18]

#### Apply activation keys

To use AVMA in Windows Admin Center:

1. Select **Cluster Manager** from the top drop-down arrow. Go to the system that you want to activate. Under **Settings**, select **Activate Windows Server VMs**.

   :::image type="content" source="media/vm-activate/apply-keys.gif" alt-text="Apply keys" lightbox="media/vm-activate/apply-keys.gif":::

1. In **Automatically activate VMs**, select **Set up** and then select **Use existing Windows Server licenses**. In **Apply activation keys to each server**, enter your Windows Server Datacenter keys.

   When you finish entering keys for each host machine in the system, select **Apply**. The process then takes a few minutes to complete.

   > [!NOTE]
   > Each machine requires a unique key, unless you have a valid volume license key.

1. After you enable AVMA, activate VMs against the host machine by following the steps in [Automatic Virtual Machine Activation](/windows-server/get-started/automatic-vm-activation).

#### Change or add keys later (optional)

You might want to change or add keys later, such as when you add a machine to the system or use new Windows Server VM versions.

To change or add keys:

1. In **Activate Windows Server VMs**, select the machines that you want to manage, and then select **Manage activation keys**.

   :::image type="content" source="./media/vm-activate/change.gif" alt-text="Short demonstration showing how to change or add keys in Windows Admin Center." lightbox="./media/vm-activate/change.gif":::

1. In **Manage activation keys**, enter the new keys for the selected host machines, and then select **Apply**.

   > [!NOTE]
   > Overwriting keys doesn't reset the activation count for used keys. Ensure that you're using the right keys before applying them to the machines.

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

Now that you set up AVMA through AHB, you can activate VMs against the host machine by [following the steps here](/windows-server/get-started/automatic-vm-activation).

---

### Troubleshoot AVMA using Windows Admin Center

If you receive the following AVMA error messages, try using the verification steps in this section to resolve them.

#### Error 1: "The key you entered didn't work"

This error might be due to one of the following issues:

- You submitted a key to activate a machine in the system but the key isn't accepted.
- A disruption of the activation process prevented a machine in the system from being activated.
- You didn't apply a valid key to a machine that you added to the system.

To resolve these issues, in the **Activate Windows Server VMs** window, select the machine with the warning, and then select **Manage activation keys** to enter a new key.

#### Error 2: "Some servers use keys for an older version of Windows Server"

All machines must use the same version of keys. Update the keys to the same version to ensure that the VMs stay activated regardless of which machine they run on.

#### Error 3: "Server is down"

Your machine is offline and can't be reached. Bring all machines online and then refresh the page.

#### Error 4: "Couldn't check the status on this server" or "To use this feature, install the latest update"

One or more of your machines isn't updated and doesn't have the required packages to set up AVMA. Ensure that your system is updated, and then refresh the page. For more information, see [Update Azure Local instances](./update-cluster.md).

## FAQs

This section provides answers to some frequently asked questions (FAQs) about Windows Server VMs on Azure Local.

### Do I need to be connected to the internet?

You need internet connectivity:

- To sync host machines to Azure at least once every 30 days, in order to maintain Azure Local 30-day connectivity requirements and to sync host licenses for AVMA.
- When purchasing or canceling Windows Server subscription.

You don't need internet connectivity:

- For VMs to activate via Windows Server subscription or AHB-based AVMA. For connectivity requirements for other forms of activation, see the [Windows Server documentation](/windows-server/get-started/kms-activation-planning).

### When does Windows Server subscription start and end billing?

Windows Server subscription starts billing and activating Windows Server VMs immediately upon purchase. If you enable Windows Server subscription within the first 60 days of activating Azure Local, you automatically have a free trial during that period.

You can sign up for or cancel your Windows Server subscription at any time. Upon cancellation, billing and activation via Azure stops immediately. Make sure you have an alternate form of VM activation if you continue to run Windows Server VMs on your system.

### I have a license for Windows Server, can I run Windows Server 2016 VMs on Azure Local?

Yes. Although you can't use Windows Server 2016 keys to set up AVMA on Azure Local, you can still apply them by using [other activation methods](/windows-server/get-started/kms-activation-planning). For example, you can enter a Windows Server 2016 key into your Windows Server 2016 VM directly.

### Where can I get AHB keys for AVMA?

To get a product key, choose from the following options:

- **OEM provider**: Find a Certificate of Authenticity (COA) key label on the outside of the OEM hardware. You can use this key once per machine in the system.
- **Volume Licensing Service Center (VLSC)**: From the VLSC, you can download a Multiple Activation Key (MAK) that you can reuse up to a predetermined number of allowed activations. For more information, see [MAK keys](/licensing/products-keys-faq#what-is-a-multiple-activation-key--mak-).
- **Retail channels**: You can also find a retail key on a retail box label. You can only use this key once per machine in the system. For more information, see [Packaged Software](https://www.microsoft.com/howtotell/software-packaged).

### I want to change an existing key. What happens to the previous key if the overwrite is successful or unsuccessful?

When you associate a product key with a device, you create a permanent association. Overwriting keys doesn't reduce the activation count for used keys. If you successfully apply another key, both keys count as used. If you unsuccessfully apply a key, your host machine activation state stays the same and defaults to the last successfully added key.

### I want to change to another key of a different version. Can I switch keys between versions?

You can update to newer versions of keys or replace existing keys with the same version, but you can't downgrade to a previous version.


## Next steps

- [Automatic virtual machine activation](/windows-server/get-started/automatic-vm-activation)
- [Key Management Services (KMS) activation planning for Windows Server](/windows-server/get-started/kms-activation-planning)
