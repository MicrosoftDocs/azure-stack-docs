---
title: Manage system security with Microsoft Defender for Cloud (preview)
description: This article describes how to use Microsoft Defender for Cloud to secure your Azure Stack HCI system (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 01/23/2024
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Manage system security with Microsoft Defender for Cloud (preview)

[!INCLUDE [hci-applies-to-23h2-22h2](../../includes/hci-applies-to-23h2-22h2.md)]

This article discusses how to use Microsoft Defender for Cloud to protect your Azure Stack HCI from various cyber threats and vulnerabilities. For more information about Microsoft Defender for Cloud, see [Microsoft Defender for Cloud documentation](/azure/defender-for-cloud/).

[!INCLUDE [important](../../includes/hci-preview.md)]

## About using Defender for Cloud for Azure Stack HCI

Microsoft Defender for Cloud is a security posture management solution with advanced threat protection capabilities. It provides you with tools to assess the security status of your infrastructure, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. It performs all these services at high speed in the cloud with no deployment overhead through auto-provisioning and protection with Azure services.

You can use Defender for Cloud to assess both the individual and overall security posture of all the resources in your Azure Stack HCI environment. Defender for Cloud helps improve the security posture of your environment, and can protect against existing and evolving threats.

## Benefits

- **No additional cost.** With the basic Defender for Cloud plan, you get advanced security features for your Azure Stack HCI system at no additional cost.

- **Seamless integration with Azure Stack HCI-certified hardware.** Defender for Cloud is designed to work seamlessly with Azure Stack HCI-certified hardware to provide consistent Secure Boot, United Extensible Firmware Interface (UEFI), and Trusted Platform Module (TPM) settings out of the box.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

- You have access to an Azure Stack HCI, version 23H2 or Azure Stack HCI, version 22H2 system that is deployed, registered, and connected to Azure.
- You have at least Owner or Contributor roles in your Azure subscription to turn on Foundational CSPM.

## Enable Defender for Cloud for Azure Stack HCI

After you complete the prerequisites, follow these steps to enable Defender for Cloud for Azure Stack HCI.

- Step 1: Turn on Foundational cloud security posture management (CSPM)
- Step 2: Turn on Defender for Servers for Arc-enabled hosts and Arc VMs

### Step 1: Turn on Foundational CSPM

This step turns on the basic Defender for Cloud plan—at no additional cost. This plan lets you monitor and identify the steps that you can take to secure your Azure Stack HCI system. For instructions, see [Enable Defender for Cloud on your Azure subscription](/azure/defender-for-cloud/connect-azure-subscription#enable-defender-for-cloud-on-your-azure-subscription).

### Step 2: Turn on Defender for Servers for Arc-enabled hosts and Arc VMs

This step gets you enhanced security features including security alerts on individual servers and Arc-enabled VMs.

To do so, follow all instructions in the [Enable the Defender for Servers plan](/azure/defender-for-cloud/tutorial-enable-servers-plan#enable-the-defender-for-servers-plan) section, which includes:

- Selecting a plan
- Configuring monitoring coverage for:
   - Log Analytics agent
   - Vulnerability assessment
   - Endpoint protection

## View security recommendations

Security recommendations are created when potential security vulnerabilities are identified. These recommendations guide you through the process of configuring the needed control.

After you've [enabled Defender for Cloud for Azure Stack HCI](#enable-defender-for-cloud-for-azure-stack-hci), follow these steps to view security recommendations for your Azure Stack HCI system:

1. In the Azure portal, go to your Azure Stack HCI cluster resource page and select your cluster.

1. On the left pane, go to **Security (preview)** > **Microsoft Defender for Cloud**.

1. View the security recommendations on this Azure Stack HCI system.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/microsoft-defender-for-cloud-page.png" alt-text="Screenshot of the Microsoft Defender for Cloud page showing the security recommendations for your Azure Stack HCI system." lightbox="./media/manage-security-with-defender-for-cloud/microsoft-defender-for-cloud-page.png" :::

   > [!NOTE]
   > Azure Stack HCI-exclusive recommendations are available only on Azure Stack HCI, version 23H2. Azure Stack HCI, version 22H2 shows recommendations that are also available on Windows Server.

   To learn more about the security recommendations specific to Azure Stack HCI, refer to the [Compute recommendations](/azure/defender-for-cloud/recommendations-reference#compute-recommendations).

   To see security recommendations across multiple systems or for individual servers or VMs on your Azure Stack HCI, see [Monitor servers and VMs](#monitor-servers-and-vms).

## Monitor servers and VMs

The **Defender for Cloud Overview page** shows the overall security posture of your environment broken down by Compute, Networking, Storage & data, and Applications. Each resource type has an indicator showing identified security vulnerabilities. Selecting each tile displays a list of security issues identified by Defender for Cloud, along with an inventory of the resources in your subscription.

:::image type="content" source="./media/manage-security-with-defender-for-cloud/defender-for-cloud-overview.png" alt-text="Screenshot of the Defender for Cloud Overview page." lightbox="./media/manage-security-with-defender-for-cloud/defender-for-cloud-overview.png" :::

Go to the **Defender for Cloud Overview** page to monitor alerts on individual servers and VMs running on the Azure Stack HCI system. You can also check regulatory compliance, and attack path analysis. Access the **Defender for Cloud Overview page** using any of the following methods:

- In the Azure portal, search for and select **Microsoft Defender for Cloud**.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/access-defender-for-cloud.png" alt-text="Screenshot that shows how to search for Defender for Cloud in the Azure portal." lightbox="./media/manage-security-with-defender-for-cloud/access-defender-for-cloud.png" :::

- In the Azure portal, go to the **Microsoft Defender for Cloud** blade of your Azure Stack HCI system resource, and then select the **View in Defender for Cloud** link.

   :::image type="content" source="./media/manage-security-with-defender-for-cloud/view-in-defender-for-cloud-link.png" alt-text="Screenshot of the Microsoft Defender for Cloud page showing the security recommendations for your Azure Stack HCI system." lightbox="./media/manage-security-with-defender-for-cloud/view-in-defender-for-cloud-link.png" :::

## Next steps

- [Review the deployment checklist and install Azure Stack HCI, version 23H2](../deploy/deployment-checklist.md).
