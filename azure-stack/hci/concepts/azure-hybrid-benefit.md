---
title: Azure Hybrid Benefit for Azure Stack HCI
description: Learn about Azure Hybrid Benefit for Azure Stack HCI.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/10/2022
---

# Azure Hybrid Benefit for Azure Stack HCI

> Applies to: Azure Stack HCI, versions 22H2 (preview), 21H2, and 20H2

This article describes what is Azure Hybrid Benefit and how to use it for Azure Stack HCI.

Azure Hybrid Benefit is a program that enables you to significantly reduce the costs of running workloads in the cloud. With Azure Hybrid Benefit for Azure Stack HCI, you can maximize the value of your on-premise licenses and modernize your existing infrastructure to Azure Stack HCI at no additional cost.

## What is Azure Hybrid Benefit for Azure Stack HCI?

If you have Windows Server Datacenter licenses with active Software Assurance, you are eligible to activate Azure Hybrid Benefit for your Azure Stack HCI cluster. This benefit waives the Azure Stack HCI host service fee and Windows Server guest subscription on your cluster. You still pay other costs associated with Azure Stack HCI, such as customer-managed hardware, Azure services, and workloads. To see pricing with Azure Hybrid Benefit, see [Azure Stack HCI pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/).

To activate this benefit, you'll need to exchange 1-core license of Software Assurance-enabled Windows Server Datacenter for 1-physical core of Azure Stack HCI. To see detailed licensing requirements, see [Azure Hybrid Benefit for Windows Server](/windows-server/get-started/azure-hybrid-benefit#getting-ahb-for-azure-stack-hci).

> [!TIP]
> You can maximize cost savings by also using Azure Hybrid Benefit for AKS on Azure Stack HCI. For more information, see [Azure Hybrid Benefits for AKS on Azure Stack HCI](/windows-server/get-started/azure-hybrid-benefit#getting-ahb-for-aks).

## Activate Azure Hybrid Benefit for Azure Stack HCI

You can activate Azure Hybrid Benefit for your Azure Stack HCI cluster using the Azure portal.

### Prerequisites

Following are the prerequisites for activating Azure Hybrid Benefit for your Azure Stack HCI cluster:

- Make sure your Azure Stack HCI cluster is installed with the following:

    - Version 22H2 (preview) or later; or
    - Version 21H2 with at least the September 13, 2022 security update KB5017316 or later
    
- Make sure that all servers in your cluster must be online and registered with Azure.
- Make sure that your cluster meets these licensing prerequisites:
    - Windows Server Datacenter licenses with active Software Assurance. For other licensing prerequisites, see [Licensing prerequisites](/windows-server/get-started/azure-hybrid-benefit#licensing-prerequisites-1).
- Make sure you have permission to write to the Azure Stack HCI resource. This is included if you're assigned the [contributor or owner role](/azure/role-based-access-control/role-assignments-portal) on your subscription.


### Activate Azure Hybrid Benefit

Follow these steps to activate Azure Hybrid Benefit for your Azure Stack HCI cluster via the Azure portal:

1. Use your Microsoft Azure credentials to sign in to the Azure portal at this URL: https://portal.azure.com.
1. Go to your Azure Stack HCI cluster resource page.
1. Under **Settings**, select **Configuration**.
1. Under **Azure Hybrid Benefit**, select the **Activate** link.
1. In the **Activate Azure Hybrid Benefit** pane on right, confirm the designated cluster and the number of core licenses you wish to allocate, and select **Activate** again to confirm.

    > [!NOTE]
    > You can't deactivate Azure Hybrid Benefit for your cluster after activation. Proceed after you have confirmed the changes.

    :::image type="content" source="media/azure-hybrid-benefit/activate-azure-hybrid-benefit.png" alt-text="Screenshot showing how to activate Azure Hybrid Benefit." lightbox="media/azure-hybrid-benefit/activate-azure-hybrid-benefit.png":::

1. When Azure Hybrid Benefit successfully activates for your cluster, the Azure Stack HCI host fee is waived for the cluster.

    > [!IMPORTANT]
    > Windows Server subscription is a way to get unlimited virtualization rights on your cluster through Azure. Now that you have Azure Hybrid Benefit enabled, you have the option of turning on Windows Server subscription at no additional cost.

1. To enable Windows Server subscription at no additional cost, under the Windows Server subscription add-on feature in the same **Configuration** pane, select **Activate benefit**.

1. In the **Activate Azure Hybrid Benefit** pane on right, check details and select **Activate** to confirm. Upon activation, licenses take a few minutes to apply and set up automatic VM activation (AVMA) on the cluster.

    :::image type="content" source="media/azure-hybrid-benefit/activate-windows-server-subscription.png" alt-text="Screenshot showing how to activate Windows Server subscription." lightbox="media/azure-hybrid-benefit/activate-windows-server-subscription.png":::

## Maintain compliance for Azure Hybrid Benefit

After you activate your Azure Stack HCI cluster with Azure Hybrid Benefit, check status and maintain compliance for Azure Hybrid Benefit. An Azure Stack HCI cluster using Azure Hybrid Benefit can run only during the Software Assurance term. When the Software Assurance term is nearing expiry, you need to either renew your agreement with Software Assurance, disable the Azure Hybrid Benefit functionality, or de-provision the clusters that are using Azure Hybrid Benefit.

You can perform an inventory of your clusters through the Azure portal and [Azure Resource Graph](/azure/governance/resource-graph/first-query-azurecli) as described in the following section.

### Verify that your cluster is using Azure Hybrid Benefit

You can verify if your cluster is using Azure Hybrid Benefit via Azure portal, PowerShell, or Azure CLI.

# [Azure portal](#tab/azureportal)

1. In your Azure Stack HCI cluster resource page, under **Settings**, select **Configuration**. 
1. Under **Azure Hybrid Benefit**, the status shows as:
    - Activated - indicates Azure Hybrid Benefit is activated
    - Not activated - indicates Azure Hybrid Benefit isn't activated

You can navigate to **Cost Analysis** > **Cost by Resource** > **Cost by Resource**. Expand your Azure Stack HCI resource to check that the meter is under **Software Assurance**.

# [PowerShell](#tab/powershell)

```powershell
Install-Module -Name Az.ResourceGraph
Connect-AzAccount -Environment $EnvironmentName -Subscription $subId
Search-AzGraph -Query "resources | where type == 'microsoft.azurestackhci/clusters'| where name == 'clustername' | project id, properties['softwareAssuranceProperties']['softwareAssuranceStatus']"
```

# [Azure CLI](#tab/azurecli)

```azurecli
az login
az extension add --name resource-graph
az graph query -q "resources | where type == 'microsoft.azurestackhci/clusters'| where name == ' clustername' | project id, properties['softwareAssuranceProperties']['softwareAssuranceStatus']"
```

---

## List all Azure Stack HCI clusters with Azure Hybrid Benefit in a subscription

You can list all Azure Stack HCI clusters with Azure Hybrid Benefit in a subscription using PowerShell and Azure CLI.

# [Azure portal](#tab/azureportal)

Use PowerShell or Azure CLI to list all Azure Stack HCI clusters with Azure Hybrid Benefit in a subscription.

# [PowerShell](#tab/powershell)

```powershell
Install-Module -Name Az.ResourceGraph
Connect-AzAccount -Environment $EnvironmentName -Subscription $subId
Search-AzGraph -Query "Resources | where type == 'microsoft.azurestackhci/clusters' | where properties['softwareAssuranceProperties']['softwareAssuranceStatus'] == 'Enabled'"
```

# [Azure CLI](#tab/azurecli)

```azurecli
az login
az extension add --name resource-graph
az graph query -q "Resources | where type == 'microsoft.azurestackhci/clusters' | where properties['softwareAssuranceProperties']['softwareAssuranceStatus'] == 'Enabled'"
```

---

## Troubleshoot Azure Hybrid Benefit for Azure Stack HCI

This section describes the errors that you may get when activating Azure Hybrid Benefit for Azure Stack HCI.

**Error**

*Failed to activate Azure Hybrid Benefit. We couldn’t find your Software Assurance contract.*

**Suggested solution**

This error can occur if you've a new Software Assurance contract or if you've set up this Azure subscription recently, but your information isn't updated in the portal yet. If you get this error, reach out to us at AHBonHCI@microsoft.com and share the following information:

- Customer/organization name - the name of your Software Assurance contract.
- Azure subscription ID – to which your Azure Stack HCI cluster is registered.
- Agreement number for Software Assurance – this can be found on your purchase order, and used to install software from the Volume Licensing Service Center (VLSC). 

## FAQs

This section answers questions you may have about Azure Hybrid Benefit for Azure Stack HCI.

### How do I find out if my organization has Software Assurance?

Consult your Account Manager or licensing partner.

## Next steps

For related information, see also:

- [Azure Hybrid Benefit for Windows Server](/windows-server/get-started/azure-hybrid-benefit)
