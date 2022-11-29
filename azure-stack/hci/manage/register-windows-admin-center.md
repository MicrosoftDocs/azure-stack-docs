---
title: Register Windows Admin Center with Azure
description: How to register your Windows Admin Center gateway with Azure.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 02/24/2022
---

# Register Windows Admin Center with Azure

> Applies to: Azure Stack HCI, versions 22H2, 21H2, and 20H2; Windows Server 2022, Windows Server 2019

This article describes how to register Windows Admin Center with Azure.

To use Azure services with Windows Admin Center, you must register your Windows Admin Center gateway with Azure. This is a prerequisite if you use Windows Admin Center to [register a cluster](../deploy/register-with-azure.md) with Azure.

## Before you begin

There are several requirements and things to consider before you begin the registration process:

- You must [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management PC.

- If you don't already have an Azure account, first [create an account](https://azure.microsoft.com/free/) before starting the registration process.

- If you use Windows Admin Center to register the Azure Stack HCI cluster, make sure to register your Windows Admin Center gateway to an Azure Active Directory (Azure AD) application ID that is approved by your organization's Azure AD admin. Also make sure to register Windows Admin Center on the same management PC you plan to use to register Azure Stack HCI, using the same Azure Active Directory (tenant) ID.

- If your network is configured to use a proxy server for internet connection, make sure that you configure the proxy settings on the Windows Admin Center gateway settings. After the proxy settings are configured, to avoid registration failures restart the **ServerManagmentGateway** (Windows Admin Center) service on the server running Windows Admin Center before proceeding with Azure AD registration.

- If you are not an Azure AD admin and you don't have an existing Azure application ID, you will need to contact your Azure AD admin to either provide an existing Azure application ID or [grant consent to a new application ID](#grant-consent-to-a-new-azure-application-id) that you'll create as part of the registration process.

## How to register Windows Admin Center with Azure

Follow these steps to register Windows Admin Center with Azure:

1. Launch Windows Admin Center.

1. Select the **Settings** gear icon from the top right corner of the page.

1. From the **Settings** menu in the left pane, go to **Gateway** > **Register**.

1. Select the **Register** button on the center of the page. The registration pane appears on the right of the page.

   :::image type="content" source="media/register-wac/register-wac.png" alt-text="Select Settings > Gateway > Azure, then click Register" lightbox="media/register-wac/register-wac.png":::

1. Perform the following one-time registration steps in the registration pane.
   
   1. **Step 1. Select an Azure cloud.** Select an Azure cloud from the dropdown menu.

   1. **Step 2. Copy this code.** You are provided with a unique code. Click the **Copy** button to the right of the code. After you click the **Copy** button, the **Enter the code** link in the next step becomes active.
   
   1. **Step 3. Enter the code.** Click the **Enter the code** link. This opens the **Enter code** window in a new browser tab. In the **Enter code** field, paste the code you copied from **Step 2** and then select **Next**.

      :::image type="content" source="media/register-wac/enter-code.png" alt-text="Copy the unique code, click enter the code, and paste it into the dialog box" lightbox="media/register-wac/enter-code.png":::

      After pasting in the code, an interactive **Sign in** window appears. Enter the email address associated with the Azure account you want to use with Windows Admin Center. The exact prompts that you see will vary depending on your security settings (for example, two-factor authentication). Follow the prompts to sign in.

      :::image type="content" source="media/register-wac/sign-in.png" alt-text="Sign in to Windows Admin Center using your email or phone number" lightbox="media/register-wac/sign-in.png":::

      After signing in, a notification window appears with a message that you have signed in to the Windows Admin Center application on your device. Close the browser window to return to the original registration page.

   1. **Step 4. Connect to Azure Active Directory.** Connect to Azure Active Directory by supplying your Azure Active Directory (tenant) ID and application ID. If you already have an Azure tenant ID and you've completed the preceding steps, the tenant ID dropdown may be pre-populated and may contain multiple options. Select the correct tenant ID.

      - If your Azure AD administrator has provided you with an application ID, click **Use existing**. An empty **Azure application ID** field appears. Enter the application ID that your admin provided. After you enter the ID, Windows Admin Center confirms if an account with that ID exists.
      
      - If you have an existing ID but don't know what it is, follow the steps described in [Get tenant and app ID values for signing in](/azure/active-directory/develop/howto-create-service-principal-portal#get-tenant-and-app-id-values-for-signing-in) to retrieve it.
      
      - If your organization didn't provide you with an existing ID, leave **Azure Active Directory application** set to **Create new**.

         :::image type="content" source="media/register-wac/connect-to-aad.png" alt-text="Connect to Azure Active Directory by supplying your existing Azure Active Directory (tenant) ID and application ID, or creating a new application ID" lightbox="media/register-wac/connect-to-aad.png":::

   1. Select **Connect**.
   
      - If you're an Azure AD admin or if you used an existing application ID, you should see a confirmation that you are now connected to Azure AD. You may see a **Permissions requested** dialog box. Click **Accept**.
      
      - If you're not an Azure AD admin and you created a new application ID in the previous step by selecting **Create new**, ask your Azure AD admin to [grant consent to the new Azure application ID](#grant-consent-to-a-new-azure-application-id).

   1. **Step 5. Sign in to Azure.** Select **Sign in** to sign into your Azure account.
      > [!NOTE]
      > If you get a notice that you need admin approval, it might be because the Azure AD admin must grant permissions in the Azure portal, as described in [Grant consent to the new Azure application ID](#grant-consent-to-a-new-azure-application-id). If they've already done that and you're still getting the notice, try refreshing Windows Admin Center and signing in again by going to **Settings** > **Account**.

After Windows Admin Center is registered with Azure, you're ready to [register Azure Stack HCI with Azure](../deploy/register-with-azure.md).

## Grant consent to a new Azure application ID

> [!NOTE]
> This procedure applies only if you an Azure AD admin.

If you are an Azure AD admin, follow these steps to grant consent to a new Azure application ID:

1. Sign in to the [Azure portal](https://portal.azure.com).

1. Navigate to **Azure Active Directory**.

1. Select **App registrations**.

1. Select **All applications** and search for **WindowsAdminCenter**.

1. Select the display name that matches the address of the Windows Admin Center system you're registering. Take note of the **Application (client) ID** displayed near the top of the page. You may need to provide it to one or more users in your organization so they can register Windows Admin Center on their PCs.

1. Navigate to **API permissions** and select **Grant admin consent**. If you plan to use the same application ID for multiple users, proceed to the next step; otherwise, you're done.

1. For convenience and ease of management, it's possible to enable multiple users in an organization to register Windows Admin Center on their PCs using the same Azure app ID. To do this, all users must register Windows Admin Center to the same domain and port, usually *https://localhost:6516*. This also requires the Azure AD admin to add redirect URIs in the Azure portal.

   1. While still viewing the app registration in the Azure portal for the Windows Admin Center instance you're registering, select **Authentication** under **Manage** from the left pane.
   
   1. In the **Redirect URIs** box, you will see an existing URI representing the first Windows Admin Center system that registered to the app ID. Select **Add URI** and add two new redirect URIs: *http://localhost:6516* and *https://localhost:6516*. Select **Save.**

   :::image type="content" source="media/register-wac/add-redirect-uris.png" alt-text="To enable multiple users in an organization to register Windows Admin Center using the same Azure app ID, add redirect URIs" lightbox="media/register-wac/add-redirect-uris.png":::

   > [!IMPORTANT]
   > Make sure to provide your users with the correct Azure tenant ID and the application ID from step 5, and tell them to select **Use existing** application ID when registering Windows Admin Center. Note that if an Azure AD admin doesn't add redirect URIs and more than one user tries to register Windows Admin Center to the same app ID, they will get an error that the reply URL doesn't match.

## Unregister Windows Admin Center

When you unregister Windows Admin Center from Azure, it removes the association between Windows Admin Center and the Azure app ID that was provided by your Azure AD admin or created when you registered Windows Admin Center. It doesn't delete the Azure app nor affect any Azure services used by servers or clusters managed by Windows Admin Center.

Follow these steps to unregister Windows Admin Center from Azure:

1. Launch Windows Admin Center and select the **Settings** gear icon from the top right corner of the page.

1. From the **Gateway** menu in the left pane, select **Register**.

1. From the **Register with Azure** pane, select the **Unregister** button.

1. In the confirmation dialog, select **Confirm**.

## Next steps

You are now ready to:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Use Azure Stack HCI with Windows Admin Center](../get-started.md)
- [Connect to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/)
