---
title: Azure Hybrid Benefit for Azure Local
description: Learn about Azure Hybrid Benefit for Azure Local.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.service: azure-local
ms.custom: devx-track-azurepowershell
ms.date: 05/08/2025
---

# Azure Hybrid Benefit for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

This article describes Azure Hybrid Benefit and how to use it for Azure Local.

[Azure Hybrid Benefit](https://azure.microsoft.com/pricing/hybrid-benefit/) is a program that helps you reduce the costs of running workloads in the cloud. With Azure Hybrid Benefit for Azure Local, you can maximize the value of your on-premises licenses and modernize your existing infrastructure to Azure Local at no additional cost.

## What is Azure Hybrid Benefit for Azure Local?

If you have [Windows Server Datacenter licenses](https://www.microsoft.com/licensing/product-licensing/windows-server?rtc=2) with active [Software Assurance](https://www.microsoft.com/licensing/licensing-programs/software-assurance-default), you are eligible to activate Azure Hybrid Benefit for Azure Local. To activate this benefit, you'll need to exchange 1-core license of Software Assurance-enabled Windows Server Datacenter for 1-physical core of Azure Local. For detailed licensing requirements, see [Azure Hybrid Benefit for Windows Server](/windows-server/get-started/azure-hybrid-benefit#getting-azure-hybrid-benefit-for-azure-stack-hci).

This benefit waives the Azure Local host service fee and Windows Server guest subscription on your system. Other costs associated with Azure Local, such as Azure services, are billed as per normal. For details about pricing with Azure Hybrid Benefit, see [Azure Local pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/).

> [!TIP]
> You can maximize cost savings by also using Azure Hybrid Benefit for AKS. For more information, see [Azure Hybrid Benefits for AKS](/windows-server/get-started/azure-hybrid-benefit#getting-azure-hybrid-benefit-for-aks).

## Activate Azure Hybrid Benefit for Azure Local

You can activate Azure Hybrid Benefit for Azure Local using the Azure portal.

### Prerequisites

The following prerequisites are required to activate Azure Hybrid Benefit for your Azure Local instance:

- Make sure your Azure Local instance is installed with the following:

  - Version 22H2 or later; or
  - Version 21H2 with the September 13, 2022 security update [KB5017316](https://support.microsoft.com/topic/september-13-2022-security-update-kb5017316-0f0e00f9-a27c-496d-81b7-aa3b3bb010bc) or later.

- Make sure that all machines in your system are online and [registered](../deploy/register-with-azure.md?tab=windows-admin-center#register-a-cluster) with Azure.

- Make sure that your system has Windows Server Datacenter licenses with active Software Assurance. For other licensing prerequisites, see [Licensing prerequisites](/windows-server/get-started/azure-hybrid-benefit#licensing-prerequisites-1).

- Make sure you have permission to write to the Azure Local resource. This is included if you're assigned the [contributor or owner role](/azure/role-based-access-control/role-assignments-portal) on your subscription.

### Activate Azure Hybrid Benefit

# [Azure portal](#tab/azure-portal)

Follow these steps to activate Azure Hybrid Benefit for Azure Local via the Azure portal:

1. Use your Microsoft Azure credentials to sign in to the Azure portal at this URL: https://portal.azure.com.
1. Go to your Azure Local resource page.
1. Under **Settings**, select **Configuration**.
1. Under **Azure Hybrid Benefit**, select the **Activate** link.
1. In the **Activate Azure Hybrid Benefit** pane on the right-hand side, confirm the designated system and the number of core licenses you wish to allocate, and select **Activate** again to confirm.

    > [!NOTE]
    > You can't deactivate Azure Hybrid Benefit for your system after activation. Proceed after you have confirmed the changes.

    :::image type="content" source="media/azure-hybrid-benefit/activate-azure-hybrid-benefit.png" alt-text="Screenshot showing how to activate Azure Hybrid Benefit." lightbox="media/azure-hybrid-benefit/activate-azure-hybrid-benefit.png":::

1. When Azure Hybrid Benefit successfully activates for your system, the Azure Local host fee is waived for the system.

    > [!IMPORTANT]
    > [Windows Server subscription](../manage/vm-activate.md) is a way to get unlimited virtualization rights on your system through Azure. Now that you have Azure Hybrid Benefit enabled, you have the option of turning on Windows Server subscription at no additional cost.

1. To enable Windows Server subscription at no additional cost, under the Windows Server subscription add-on feature in the same **Configuration** pane, select **Activate benefit**.

1. In the **Activate Azure Hybrid Benefit** pane on the right-hand side, check the details and then select **Activate** to confirm. Upon activation, licenses take a few minutes to apply and set up automatic VM activation (AVMA) on the system.

    :::image type="content" source="media/azure-hybrid-benefit/activate-windows-server-subscription.png" alt-text="Screenshot showing how to activate Windows Server subscription." lightbox="media/azure-hybrid-benefit/activate-windows-server-subscription.png":::

# [Azure PowerShell](#tab/azure-powershell)

Azure PowerShell can be run in Azure Cloud Shell. This section describes how to use PowerShell in Azure Cloud Shell. For more information, see [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Azure PowerShell to perform the following steps:

1. Set up parameters from your subscription, resource group, and system name

   ```powershell
   $subscription = "00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
   $resourceGroup = "local-rg" # Replace with your resource group name
   $clusterName = "MyLocal" # Replace with your system name

   Set-AzContext -Subscription "${subscription}"
   ```

1. To view Azure Hybrid Benefit status on a system, run the following command:

   ```powershell
   Install-Module -Name Az.ResourceGraph
   Search-AzGraph -Query "resources | where type == 'microsoft.azurestackhci/clusters'| where name == '${clusterName}' | project id, properties['softwareAssuranceProperties']['softwareAssuranceStatus']"
   ```

1. To enable Azure Hybrid Benefit, run the following command and check if Azure Hybrid Benefit was enabled using the previous command:

   ```powershell
   Invoke-AzStackHciExtendClusterSoftwareAssuranceBenefit -ClusterName "${clusterName}" -ResourceGroupName "${resourceGroup}" -SoftwareAssuranceIntent "Enable"
   ```

# [Azure CLI](#tab/azure-cli)

Azure CLI is available to install in Windows, macOS and Linux environments. It can also be run in Azure Cloud Shell. This section describes how to use Bash in Azure Cloud Shell. For more information, see [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Azure CLI to configure Azure Hybrid Benefits following these steps:

1. Set up parameters for your subscription, resource group, and system name:

   ```azurecli
   subscription="00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
   resourceGroup="hcicluster-rg" # Replace with your resource group name
   clusterName="HCICluster" # Replace with your system name

   az account set --subscription "${subscription}"
   ```

1. To view Azure Hybrid Benefit status on a system, run the following command:

   ```azurecli
   az stack-hci cluster list \
   --resource-group "${resourceGroup}" \
   --query "[?name=='${clusterName}'].{Name:name, SoftwareAssurance:softwareAssuranceProperties.softwareAssuranceStatus}" \
   -o table
   ```

1. To enable Azure Hybrid Benefit, run the following command:

   ```azurecli
   az stack-hci cluster extend-software-assurance-benefit \
   --cluster-name "${clusterName}" \
   --resource-group "${resourceGroup}" \
   --software-assurance-intent enable
   ```

---

## Maintain compliance for Azure Hybrid Benefit

After you activate Azure Local with Azure Hybrid Benefit, you must regularly check status and maintain compliance for Azure Hybrid Benefit. An Azure Local instance using Azure Hybrid Benefit can run only during the Software Assurance term. When the Software Assurance term is nearing expiration, you must either renew your agreement with Software Assurance, disable the Azure Hybrid Benefit functionality, or de-provision the systems that are using Azure Hybrid Benefit.

You can perform an inventory of your systems through the Azure portal and [Azure Resource Graph](/azure/governance/resource-graph/first-query-azurecli) as described in the following section.

### Verify that your system is using Azure Hybrid Benefit

You can verify if your system is using Azure Hybrid Benefit via the Azure portal, PowerShell, or Azure CLI.

# [Azure portal](#tab/azure-portal)

1. In your Azure Local resource page, under **Settings**, select **Configuration**.
1. Under **Azure Hybrid Benefit**, the status shows as:
    - **Activated** - indicates Azure Hybrid Benefit is activated
    - **Not activated** - indicates Azure Hybrid Benefit isn't activated

You can also navigate to **Cost Analysis > Cost by Resource > Cost by Resource**. Expand your Azure Local resource to check that the meter is under **Software Assurance**.

# [Azure PowerShell](#tab/azure-powershell)

```powershell
Install-Module -Name Az.ResourceGraph
Search-AzGraph -Query "resources | where type == 'microsoft.azurestackhci/clusters'| where name == '${clusterName}' | project id, properties['softwareAssuranceProperties']['softwareAssuranceStatus']"
```

# [Azure CLI](#tab/azure-cli)

```azurecli
az extension add --name resource-graph
az graph query -q "resources | where type == 'microsoft.azurestackhci/clusters'| where name == '${clusterName}' | project id, properties['softwareAssuranceProperties']['softwareAssuranceStatus']"
```

---

### List all Azure Local instances with Azure Hybrid Benefit in a subscription

You can list all Azure Local instances with Azure Hybrid Benefit in a subscription using PowerShell and Azure CLI.

# [Azure portal](#tab/azure-portal)

Use PowerShell or Azure CLI to list all Azure Local instances with Azure Hybrid Benefit in a subscription.

# [Azure PowerShell](#tab/azure-powershell)

```powershell
Install-Module -Name Az.ResourceGraph
Connect-AzAccount -Environment $EnvironmentName -Subscription $subId
Search-AzGraph -Query "Resources | where type == 'microsoft.azurestackhci/clusters' | where properties['softwareAssuranceProperties']['softwareAssuranceStatus'] == 'Enabled' | project id, properties['softwareAssuranceProperties']['softwareAssuranceStatus']"
```

# [Azure CLI](#tab/azure-cli)

```azurecli
az extension add --name resource-graph
az graph query -q "Resources | where type == 'microsoft.azurestackhci/clusters' | where properties['softwareAssuranceProperties']['softwareAssuranceStatus'] == 'Enabled' | project id, properties['softwareAssuranceProperties']['softwareAssuranceStatus']"
```

---

## Troubleshoot Azure Hybrid Benefit for Azure Local

This section describes the errors that you might get when activating Azure Hybrid Benefit for Azure Local.

### Error

Failed to activate Azure Hybrid Benefit. We couldn't find your Software Assurance contract.

#### Suggested solution

This error can occur if you have a new Software Assurance contract or if you set up this Azure subscription recently, but your information isn't updated in the portal yet. If you get this error, reach out to us at [AHBonHCI@microsoft.com](mailto:AHBonHCI@microsoft.com) and share the following information:

- Customer/organization name - the name registered on your Software Assurance contract.
- Azure subscription ID – to which your Azure Local instance is registered.
- Agreement number for Software Assurance – this can be found on your purchase order, and is the number you use to install software from the Volume Licensing Service Center (VLSC).

## FAQs

This section answers questions you might have about Azure Hybrid Benefit for Azure Local.

### How does licensing work for Azure Hybrid Benefit?

For more information about licensing, see [Azure Hybrid Benefit for Windows Server](/windows-server/get-started/azure-hybrid-benefit).

### Can I opt in to Azure Hybrid Benefit for an existing system?

Yes.

### Is there any additional cost incurred by opting in to Azure Hybrid Benefit for Azure Local?

No additional costs are incurred, as Azure Hybrid Benefit is included as part of your Software Assurance benefit.

### How do I find out if my organization has Software Assurance?

Consult your Account Manager or licensing partner.

### When does the new pricing benefit for Azure Hybrid Benefit take effect?

The pricing benefit for Azure Local host fees takes effect immediately upon activation of Azure Hybrid Benefit for your system. The pricing benefit for Windows Server subscription takes effect immediately after you activate both Azure Hybrid Benefit and Windows Server subscription.

## Next steps

- [Azure Hybrid Benefit for Windows Server](/windows-server/get-started/azure-hybrid-benefit).
