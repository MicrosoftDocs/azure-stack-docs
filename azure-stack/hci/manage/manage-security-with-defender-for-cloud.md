---
title: Manage system security with Microsoft Defender for Cloud (preview)
description: This article describes how to use Microsoft Defender for Cloud to secure your Azure Stack HCI system (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 08/02/2024
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Manage system security with Microsoft Defender for Cloud (preview)

[!INCLUDE [hci-applies-to-23h2-22h2](../../includes/hci-applies-to-23h2-22h2.md)]

This article discusses how to use Microsoft Defender for Cloud to protect your Azure Stack HCI system from various cyber threats and vulnerabilities.

Defender for Cloud helps improve the security posture of your Azure Stack HCI environment, and can protect against existing and evolving threats.

For more information about Microsoft Defender for Cloud, see [Microsoft Defender for Cloud documentation](/azure/defender-for-cloud/).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- You have access to an Azure Stack HCI, version 23H2 or Azure Stack HCI, version 22H2 system that is deployed, registered, and connected to Azure.
- You have at least **Owner** or **Contributor** roles in your Azure subscription to turn on Foundational cloud security posture management (CSPM).

## Enable Defender for Cloud for Azure Stack HCI

Follow these steps to enable Defender for Cloud for Azure Stack HCI.

- Step 1: Turn on Foundational CSPM.
- Step 2: Turn on Defender for Servers for individual servers and Arc VMs.

### Step 1: Turn on Foundational CSPM

This step turns on the basic Defender for Cloud plan—at no extra cost. This plan lets you monitor and identify the steps that you can take to secure your Azure Stack HCI system, along with other Azure and Arc resources. For instructions, see [Enable Defender for Cloud on your Azure subscription](/azure/defender-for-cloud/connect-azure-subscription#enable-defender-for-cloud-on-your-azure-subscription).

### Step 2: Turn on Defender for Servers for individual servers and Arc VMs

This step gets you enhanced security features including security alerts for individual servers and Arc VMs.

To do so, follow all the instructions in the [Enable the Defender for Servers plan](/azure/defender-for-cloud/tutorial-enable-servers-plan#enable-the-defender-for-servers-plan) section, which includes:

- Selecting a plan
- Configuring monitoring coverage for:
   - Log Analytics agent
   - Vulnerability assessment
   - Endpoint protection

## Apply Microsoft Cloud Security Benchmark initiative

After you turn on the Microsoft Defender for Cloud Foundational CSPM plan, you must apply the Microsoft Cloud Security Benchmark (MCSB) initiative. You can view the security settings via the Azure portal only when the MCSB is applied. Use one of the following methods to apply the MCSB initiative:

- Apply the MCSB via the portal as described below.
- Manually apply the Azure compute security baseline in Azure policy to all cluster servers. See [Windows security baseline](/azure/governance/policy/samples/guest-configuration-baseline-windows).

Follow these steps to apply the MCSB initiative at the subscription level:

1. Sign into the Azure portal, and search for and select **Microsoft Defender for Cloud**.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/access-defender-for-cloud.png" alt-text="Screenshot that shows how to search for Defender for Cloud in the Azure portal." lightbox="./media/manage-security-with-defender-for-cloud/access-defender-for-cloud.png" :::

1. On the left pane, scroll down to the **Management** section and select **Environment settings**.

1. On the **Environment settings** page, select the subscription in use from the drop-down.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/select-subscription.png" alt-text="Screenshot that shows how to select the Azure subscription." lightbox="./media/manage-security-with-defender-for-cloud/select-subscription.png" :::

1. Select the **Security policies** blade.

1. For **Microsoft cloud security benchmark**, toggle the **Status** button to **On**.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/toggle-on-status.png" alt-text="Screenshot that shows how to toggle on the Status button." lightbox="./media/manage-security-with-defender-for-cloud/toggle-on-status.png" :::

1. Wait for at least one hour for the Azure policy initiative to evaluate the included resources.

## View security recommendations

Security recommendations are created when potential security vulnerabilities are identified. These recommendations guide you through the process of configuring the needed control.

After you've [enabled Defender for Cloud for Azure Stack HCI](#enable-defender-for-cloud-for-azure-stack-hci), follow these steps to view security recommendations for your Azure Stack HCI system:

1. In the Azure portal, go to your Azure Stack HCI cluster resource page and select your cluster.

1. On the left pane, scroll down to the **Security (preview)** section and select **Microsoft Defender for Cloud**.

1. On the **Microsoft Defender for Cloud** page, under **Recommendations**, you can view the current security recommendations for the selected Azure Stack HCI system and its workloads. By default, the recommendations are grouped by resource type.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/security-recommendations.png" alt-text="Screenshot of the Microsoft Defender for Cloud page showing the security recommendations on your Azure Stack HCI system." lightbox="./media/manage-security-with-defender-for-cloud/security-recommendations.png" :::

1. (Optional) To view the security recommendations for multiple Azure Stack HCI systems, select the **View in Defender for Cloud** link. This opens the **Recommendations** page in the Microsoft Defender for Cloud portal. This page provides security recommendations across all your Azure resources, including Azure Stack HCI systems.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/recommendations-defender-for-cloud.png" alt-text="Screenshot of the Recommendations page in the Defender for Cloud portal." lightbox="./media/manage-security-with-defender-for-cloud/recommendations-defender-for-cloud.png" :::

   > [!NOTE]
   > Azure Stack HCI-exclusive recommendations are available only on Azure Stack HCI, version 23H2. Azure Stack HCI, version 22H2 shows recommendations that are also available on Windows Server.

   To learn more about the security recommendations specific to Azure Stack HCI, refer to the [Azure compute recommendations](/azure/defender-for-cloud/recommendations-reference-compute#azure-compute-recommendations) section in the [Compute security recommendations](/azure/defender-for-cloud/recommendations-reference-compute) article.

## Monitor servers and Arc VMs

Go to the Microsoft Defender for Cloud portal to monitor alerts for individual servers and Arc VMs running on the Azure Stack HCI system. You can utilize the regulatory compliance and attack path analysis features, among other enhanced security features.

Follow these steps to access the Microsoft Defender for Cloud portal's pages to monitor individual servers and Arc VMs:

1. Sign into the Azure portal, and search for and select **Microsoft Defender for Cloud**.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/access-defender-for-cloud.png" alt-text="Screenshot that shows how to search for Defender for Cloud in the Azure portal." lightbox="./media/manage-security-with-defender-for-cloud/access-defender-for-cloud.png" :::

1. The **Overview** page of the Microsoft Defender for Cloud portal shows the overall security posture of your environment. From the left navigation pane, navigate to various portal pages, such as **Recommendations** to view security recommendations for individual servers and Arc VMs running on the Azure Stack HCI system, or **Security alerts** to monitor alerts for them.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/defender-for-cloud-overview.png" alt-text="Screenshot of the Defender for Cloud Overview page." lightbox="./media/manage-security-with-defender-for-cloud/defender-for-cloud-overview.png" :::

## Next steps

- [Review the deployment checklist and install Azure Stack HCI, version 23H2](../deploy/deployment-checklist.md).
