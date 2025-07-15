---
title: Install solution upgrade on Azure Local via Azure Resource Manager template
description: Learn how to install the solution upgrade on your Azure Local instance via Azure Resource Manager template.
author: alkohli
ms.topic: how-to
ms.date: 07/14/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---


# Install solution upgrade on Azure Local via Azure Resource Manager template

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

This article describes how to install the solution upgrade on your Azure Local instance using Azure Resource Manager (ARM) template after upgrading the operating system (OS).

> [!IMPORTANT]
> While the OS upgrade is generally available, the solution upgrade is rolled out in phases. Additionally, the solution upgrade isn't available to customers in Azure China.

## Prerequisites

Before you install the solution upgrade, make sure that you:

- Validate the system using the Environment Checker as per the instructions in [Assess solution upgrade readiness](./validate-solution-upgrade-readiness.md#run-the-validation).
- Have failover cluster name between 3 to 15 characters.
- Create an Active Directory Lifecycle Manager (LCM) user account that's a member of the local Administrator group. For instructions, see [Prepare Active Directory for Azure Local deployment](../deploy/deployment-prep-active-directory.md).
- Have IPv4 network range that matches your host IP address subnet with six, contiguous IP addresses available for new Azure Arc services. Work with your network administrator to ensure that the IP addresses aren't in use and meet the outbound connectivity requirement.
- Have Azure subscription permissions for [Azure Stack HCI Administrator and Reader](../manage/assign-vm-rbac-roles.md#about-built-in-rbac-roles).  

    :::image type="content" source="media/install-solution-upgrade/verify-subscription-permissions-roles.png" alt-text="Screenshot of subscription with permissions assigned to required roles for upgrade." lightbox="./media/install-solution-upgrade/verify-subscription-permissions-roles.png":::

## Before you begin

There are a few things to consider before you begin the solution upgrade process:

- The solution upgrade isn't yet supported on OS version 26100.xxxx.
- Microsoft only supports upgrade applied from Azure Local resource page. Use of third party tools to install upgrades isn't supported.
- We recommend you perform the solution upgrade during a maintenance window. After the upgrade, host machine might reboot and the workloads will be live migrated, causing brief disconnections.
- If you have Azure Kubernetes Service (AKS) workloads on Azure Local, wait for the solution upgrade banner to appear on the Azure Local resource page. Then, remove AKS and all AKS hybrid settings before you apply the solution upgrade.
- By installing the solution upgrade, existing Hyper-V VMs won't automatically become Azure Arc VMs.

## Upgrade using Azure Resource Manager template

1. In the Azure portal, go to **Home** and select **+ Create a resource**.

2. Select **Create** under **Template deployment (deploy using custom templates)**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-1.png" alt-text="Screenshot showing the template deployment (deploy using custom template)." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-1.png":::

3. From the **Start with a quickstart template or template spec** section, select **Quickstart template** option.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-2.png" alt-text="Screenshot showing the quickstart template selected." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-2.png":::

4. From the **Quickstart template (disclaimer)** dropdown list, select the **azurestackhci/upgrade-cluster** template.

5. When finished, select the **Select template** button.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-arm-template.png" alt-text="Screenshot showing template selected for the solution upgrade." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-arm-template.png":::

6. On the **Basics** tab, you see the **Custom deployment** page. You can select the various parameters through the dropdown list or select **Edit parameters**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-template-parameters.png" alt-text="Screenshot showing Custom deployment page on the Basics tab." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-template-parameters.png":::

    <!-->> [!NOTE]
    > For an example parameter file that shows the format of various inputs, such as `ArcNodeResourceId`, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-2411.3/azuredeploy.parameters.json).-->

7. Edit parameters such as network intent or storage network intent. Once the parameters are all filled out, **Save** the parameters file.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-5.png" alt-text="Screenshot showing parameters filled out for the template." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-5.png":::

8. Select the appropriate resource group for your environment.

9. Scroll to the bottom, and confirm that **Deployment Mode = Validate**.

10. Select **Review + create**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-6.png" alt-text="Screenshot showing Review + Create selected on Basics tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-6.png":::

11. On the **Review + Create** tab, select **Create**. This creates the remaining prerequisite resources and validates the deployment. Validation takes about 10 minutes to complete.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7.png" alt-text="Screenshot showing Create selected on Review + Create tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7.png":::

12. Once validation is complete, select **Redeploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png" alt-text="Screenshot showing Redeploy selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png":::

13. On the **Custom deployment** screen, select **Edit parameters**. Load up the previously saved parameters and select **Save**.

14. At the bottom of the workspace, change the final value in the JSON from **Validate** to **Deploy**, where **Deployment Mode = Deploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png" alt-text="Screenshot showing deploy selected for deployment mode." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png":::

15. Verify that all the fields for the Resource Manager deployment template are filled in by the Parameters JSON.

16. Select the appropriate resource group for your environment.

17. Scroll to the bottom, and confirm that **Deployment Mode = Deploy**.

18. Select **Review + create**.

19. Select **Create**. The deployment begins, using the existing prerequisite resources that were created during the **Validate** step.

    The Deployment screen cycles on the cluster resource during deployment.

    Once deployment initiates, there's a limited Environment Checker run, a full Environment Checker run, and cloud deployment starts. After a few minutes, you can monitor deployment in the portal.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png" alt-text="Screenshot showing the status of environment checker validation." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png":::

20. In a new browser window, navigate to the resource group for your environment. Select the cluster resource.

21. Select **Deployments**.

22. Refresh and watch the deployment progress from the first machine (also known as the seed machine and is the first machine where you deployed the cluster). Deployment takes between 2.5 and 3 hours. Several steps take 40-50 minutes or more.

## Next steps

If you run into issues during the upgrade process, see [Troubleshoot solution upgrade on Azure Local](./troubleshoot-upgrade-to-23h2.md).
