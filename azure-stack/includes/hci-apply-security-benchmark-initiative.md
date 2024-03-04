---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 02/26/2024
ms.reviewer: alkohli
---

To view the security settings via the Azure portal, you must apply the MCSB initiative using one of the following methods:

- (Recommended) Turn on the Microsoft Defender for Cloud Foundational cloud security posture management (CSPM) plan, at no extra cost, and confirm that MCSB is applied, as described below.
- Manually apply the Azure compute security baseline in Azure policy to all cluster servers. See [Windows security baseline](/azure/governance/policy/samples/guest-configuration-baseline-windows).

Follow these steps to apply the MCSB initiative at the subscription level:

1. Sign into the Azure portal, and search for and select **Microsoft Defender for Cloud**.

   :::image type="content" source="./media/hci-apply-security-benchmark-initiative/access-defender-for-cloud.png" alt-text="Screenshot that shows how to search for Defender for Cloud in the Azure portal." lightbox="./media/hci-apply-security-benchmark-initiative/access-defender-for-cloud.png" :::

1. On the left pane, scroll down to the **Management** section and select **Environment settings**.

1. On the **Environment settings** page, select the subscription in use from the drop-down.

   :::image type="content" source="./media/hci-apply-security-benchmark-initiative/select-subscription.png" alt-text="Screenshot that shows how to select the Azure subscription." lightbox="./media/hci-apply-security-benchmark-initiative/select-subscription.png" :::

1. Select the **Security policies** blade.

1. For **Microsoft cloud security benchmark**, toggle the **Status** button to **On**.

   :::image type="content" source="./media/hci-apply-security-benchmark-initiative/toggle-on-status.png" alt-text="Screenshot that shows how to toggle on the Status button." lightbox="./media/hci-apply-security-benchmark-initiative/toggle-on-status.png" :::

1. Wait for at least one hour for the Azure policy initiative to evaluate the included resources.