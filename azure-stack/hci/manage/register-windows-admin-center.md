---
title: Register Windows Admin Center with Azure
description: How to register Windows Admin Center with Azure.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 04/19/2023
---

# Register Windows Admin Center with Azure

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019

This article describes how to register Windows Admin Center with Azure.

To use Azure services with Windows Admin Center, you must register your Windows Admin Center instance with Azure. This is a prerequisite if you use Windows Admin Center to [register Azure Stack HCI with Azure](../deploy/register-with-azure.md).

## Before you begin

There are several requirements and things to consider before you begin the registration process:

- You must [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management computer.

- If you don't already have an Azure account, first [create an account](https://azure.microsoft.com/free/) before starting the registration process.

- If you use Windows Admin Center to register Azure Stack HCI with Azure, make sure to register Windows Admin Center on the same management computer you plan to use to register Azure Stack HCI, using the same Microsoft Entra ID (tenant) ID.

- If your network is configured to use a proxy server for internet connection, make sure that you configure the proxy settings on the Windows Admin Center settings. After the proxy settings are configured, to avoid registration failures restart the **ServerManagmentGateway** (Windows Admin Center) service on the server running Windows Admin Center before proceeding with Microsoft Entra registration.

- Unless you're a Microsoft Entra admin or you have an existing Azure application ID, you need to contact your Microsoft Entra admin to either provide an existing Azure application ID or [grant consent to a new application ID](#grant-consent-to-a-new-azure-application-id) that you'll create as part of the registration process.

## How to register Windows Admin Center with Azure

Follow these steps to open the registration pane:

1. In Windows Admin Center, select the **Settings** gear icon from the top right corner of the page.

1. From the **Settings** menu in the left pane, go to **Gateway** > **Register**.

1. Select the **Register** button on the center of the page. The registration pane appears on the right of the page.

   :::image type="content" source="media/register-wac/register-wac.png" alt-text="Screenshot of the registration pane." lightbox="media/register-wac/register-wac.png":::

Follow these one-time registration steps in the registration pane to register Windows Admin Center with Azure:

1. Select an Azure cloud from the **Select an Azure cloud** dropdown menu.

1. Select the **Copy** button.
   
1. Select the **Enter the code** link. This opens the **Enter code** window in a new browser tab. Paste the code you copied from **Step 2** and then select **Next**.

   :::image type="content" source="media/register-wac/enter-code.png" alt-text="Screenshot of the Enter code window." lightbox="media/register-wac/enter-code.png":::

   After pasting in the code, an interactive **Sign in** window appears. Enter the email address associated with the Azure account you want to use with Windows Admin Center. The exact prompts that you see varies depending on your security settings (for example, two-factor authentication). Follow the prompts to sign in.

   :::image type="content" source="media/register-wac/sign-in.png" alt-text="Screenshot of the sign in dialog box." lightbox="media/register-wac/sign-in.png":::

   After signing in, you get a confirmation that you're signed into the Windows Admin Center application on your device. Close the confirmation window and return to the original registration page.

1. Connect to Microsoft Entra ID by supplying your Microsoft Entra ID (tenant) ID and application ID. If you already have an Azure tenant ID and you've completed the preceding steps, the tenant ID dropdown may be pre-populated and may contain multiple options. Select the correct tenant ID.

   - If your Microsoft Entra administrator has provided you with an application ID, select **Use existing** and enter the application ID.
      
   - If you have an existing ID but don't know what it is, follow the steps described in [Get tenant and app ID values for signing in](/azure/active-directory/develop/howto-create-service-principal-portal#get-tenant-and-app-id-values-for-signing-in) to retrieve it.
      
   - If you don't have an existing ID, select **Create new**.

      :::image type="content" source="media/register-wac/connect-to-aad.png" alt-text="Connect to Microsoft Entra ID by supplying your existing Microsoft Entra ID (tenant) ID and application ID, or creating a new application ID." lightbox="media/register-wac/connect-to-aad.png":::

1. Select **Connect**.
   
   - If you're a Microsoft Entra admin or if you used an existing application ID, you should see a confirmation that you're now connected to Microsoft Entra ID. You may see a **Permissions requested** dialog box. Select **Accept**.
      
   - If you're not a Microsoft Entra admin and you created a new application ID in the previous step by selecting **Create new**, ask your Microsoft Entra admin to [grant consent to the new Azure application ID](#grant-consent-to-a-new-azure-application-id).

1. Select **Sign in** to sign into your Azure account.
   > [!NOTE]
   > If you get a notice that you need admin approval, it might be because the Microsoft Entra admin must grant permissions in the Azure portal, as described in [Grant consent to the new Azure application ID](#grant-consent-to-a-new-azure-application-id). If they've already done that and you're still getting the notice, try refreshing Windows Admin Center and signing in again by going to **Settings** > **Account**.

After Windows Admin Center is registered with Azure, you're ready to [register Azure Stack HCI with Azure](../deploy/register-with-azure.md).

## Grant consent to a new Azure application ID

> [!NOTE]
> This procedure applies only if you a Microsoft Entra admin.

If you're a Microsoft Entra admin, follow these steps to grant consent to a new Azure application ID:

1. Sign in to the [Azure portal](https://portal.azure.com).

1. Navigate to **Microsoft Entra ID**.

1. Select **App registrations**.

1. Select **All applications** and search for **WindowsAdminCenter**.

1. Select the display name that matches the address of the Windows Admin Center system you're registering. Take note of the **Application (client) ID** displayed near the top of the page. You may need to provide it to one or more users in your organization so they can register Windows Admin Center on their PCs.

1. Navigate to **API permissions** and select **Grant admin consent**. If you plan to use the same application ID for multiple users, proceed to the next step; otherwise, you're done.

1. For convenience and ease of management, it's possible to enable multiple users in an organization to register Windows Admin Center on their PCs using the same Azure app ID. To do this, all users must register Windows Admin Center to the same domain and port, usually *https://localhost:6516*. This also requires the Microsoft Entra admin to add redirect URIs in the Azure portal.

   1. While still viewing the app registration in the Azure portal for the Windows Admin Center instance you're registering, select **Authentication** under **Manage** from the left pane.
   
   1. In the **Redirect URIs** box, you will see an existing URI representing the first Windows Admin Center system that registered to the app ID. Select **Add URI** and add two new redirect URIs: *http://localhost:6516* and *https://localhost:6516*. Select **Save.**

      :::image type="content" source="media/register-wac/add-redirect-uris.png" alt-text="To enable multiple users in an organization to register Windows Admin Center using the same Azure app ID, add redirect URIs" lightbox="media/register-wac/add-redirect-uris.png":::

   > [!IMPORTANT]
   > Make sure to provide your users with the correct Azure tenant ID and the application ID from step 5, and tell them to select **Use existing** application ID when registering Windows Admin Center. Note that if a Microsoft Entra admin doesn't add redirect URIs and more than one user tries to register Windows Admin Center to the same app ID, they will get an error that the reply URL doesn't match.

## Unregister Windows Admin Center

When you unregister Windows Admin Center from Azure, it removes the association between Windows Admin Center and the Azure app ID that was provided by your Microsoft Entra admin or created when you registered Windows Admin Center. It doesn't delete the Azure app or affect any Azure services used by servers or clusters managed by Windows Admin Center.

Follow these steps to unregister Windows Admin Center from Azure:

1. Launch Windows Admin Center and select the **Settings** gear icon from the top right corner of the page.

1. From the **Gateway** menu in the left pane, select **Register**.

1. From the **Register with Azure** pane, select the **Unregister** button.

1. In the confirmation dialog, select **Confirm**.

## Next steps

You're now ready to:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Monitor Azure Stack HCI clusters from Windows Admin Center](../manage/monitor-cluster.md)
- [Connect to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/)
