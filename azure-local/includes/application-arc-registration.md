---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 09/04/2026
---

### Configure Azure Arc registration

1. On the **Arc agent setup** page, select **Log in to Azure**.

   :::image type="content" source="./media/application-arc-registration/app-arc-registration.png" alt-text="Screenshot of the Azure Arc registration page in the Configurator app." lightbox="./media/application-arc-registration/app-arc-registration.png":::

1. Sign in with an Azure account that has permissions to register Azure Local with Azure Arc.

1. Enter the following information:

   - **Cloud type**. This field is populated automatically as **Azure**.
   - **Tenant ID**. If you register by using an Arc gateway, enter the directory ID of your Microsoft Entra tenant. If you register without an Arc gateway, skip this field. To get the tenant ID, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id).
   - **Subscription**. Enter a subscription ID to register the machine.
   - **Resource group**. The resource group for Azure Local resources. This resource group contains the machine and system resources that you create.
   - **Region**. The Azure region where you want to create resources. The region should be the same as the region where you want to deploy the Azure Local instance. Specify the region with spaces removed. For example, specify the East US region as `EastUS`.
   - **Azure Arc gateway**. This is the resource ID of the Arc gateway that you set up. If you register by using an Arc gateway, select the Arc gateway resource that you created earlier. If you register without an Arc gateway, skip this field. For more information, see [About Azure Arc gateways](../deploy/deployment-azure-arc-gateway-overview.md).

1. Verify the information, and then select **Next**.

### Review and apply configuration

1. On the **Review and apply** page, review the configuration.

   :::image type="content" source="./media/application-arc-registration/app-review-apply.png" alt-text="Screenshot of the Review and apply page showing Azure Arc registration settings." lightbox="./media/application-arc-registration/app-review-apply.png":::

1. Select **Done** to start the configuration and registration process.

1. Monitor the registration progress on the **Configuration status** page. The app might display the following states:

   - Registration not started.

     :::image type="content" source="./media/application-arc-registration/app-not-started.png" alt-text="Screenshot showing that Azure Arc registration hasn't started." lightbox="./media/application-arc-registration/app-not-started.png":::

   - Update available.

     :::image type="content" source="./media/application-arc-registration/app-update-available.png" alt-text="Screenshot showing an available Azure Arc update." lightbox="./media/application-arc-registration/app-update-available.png":::

   - Configuration in progress.

     :::image type="content" source="./media/application-arc-registration/app-update-progress.png" alt-text="Screenshot showing Azure Arc configuration in progress." lightbox="./media/application-arc-registration/app-update-progress.png":::

   - Registration completed successfully.

     :::image type="content" source="./media/application-arc-registration/app-registration-successful.png" alt-text="Screenshot showing that Azure Arc registration completed successfully." lightbox="./media/application-arc-registration/app-registration-successful.png":::

### Verify machines are connected to Azure Arc

1. In the Azure portal, go to the resource group that you used for bootstrapping.

1. On the resource group used to bootstrap, you should see your Azure Arc-enabled machines. In this example, you see a single machine.

### Troubleshoot and collect support logs

Use the support and troubleshooting tools in the Configurator app to collect logs and diagnose issues.

1. Select the **Support** icon in the upper-right corner of the Configurator app.

1. Use the available options to:

   - Create a support log package.
   - Download a support log package.
   - Upload a support package to Microsoft.
   - Run diagnostic tests.

   The following example shows a support log package being created:

   :::image type="content" source="./media/application-arc-registration/app-support-log-progress.png" alt-text="Screenshot showing support log package generation in progress." lightbox="./media/application-arc-registration/app-support-log-progress.png":::

   The following example shows a completed support log package that is ready for download or upload:

   :::image type="content" source="./media/application-arc-registration/app-support-log-created.png" alt-text="Screenshot showing a support log package ready for download or upload." lightbox="./media/application-arc-registration/app-support-log-created.png":::

> [!NOTE]
> Use the generated support package when you work with Microsoft Support to troubleshoot Azure Arc registration or connectivity issues.
