---
title: Register Windows Admin Center with Azure
description: How to register your Windows Admin Center gateway with Azure.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 02/24/2022
---

# Register Windows Admin Center with Azure

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019

To use Azure services with Windows Admin Center, you must first [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management PC and register your Windows Admin Center gateway. This is a prerequisite for [registering a cluster](../deploy/register-with-azure.md) with Azure.

   > [!IMPORTANT]
   > In order to use Windows Admin Center to register Azure Stack HCI clusters, your Windows Admin Center gateway must be registered to an Azure Active Directory (Azure AD) application ID that is approved by your organization's Azure AD admin. Register Windows Admin Center on the same management PC you plan to use to register your cluster(s), using the same Azure Active Directory (tenant) ID.

   > [!NOTE]
   > If your network is configured to use a proxy server for internet connection, it is required that you configure the proxy settings on the Windows Admin Center gateway settings. After the proxy settings are configured, to avoid registration failures restart the **ServerManagmentGateway** (Windows Admin Center) service on the server running Windows Admin Center before proceeding with Azure AD registration.

## Complete the registration process

Launch Windows Admin Center and select the **Settings** gear icon in the upper right, which will take you to the **Settings** view. Then select **Register** under the **Gateway** settings on the left. Then select the **Register** button in the center of the page.

   :::image type="content" source="media/register-wac/register-wac.png" alt-text="Select Settings > Gateway > Azure, then click Register" lightbox="media/register-wac/register-wac.png":::

To register Windows Admin Center, follow these steps:

1. Select an Azure cloud from the dropdown menu.

2. You'll be provided with a unique code. Click the **Copy** button to the right of the code. Click **Enter the code**, which will open up another browser window into which you can paste the code displayed on your app or device.

   :::image type="content" source="media/register-wac/enter-code.png" alt-text="Copy the unique code, click enter the code, and paste it into the dialog box" lightbox="media/register-wac/enter-code.png":::

3. After pasting in the code, you'll be notified that you're about to be signed in to Windows Admin Center on a remote device or service. Enter your email or phone number. If your device is managed, you will be taken to your organization's sign-in page for authentication. Follow the instructions and enter the appropriate credentials. You may be asked to confirm that you're trying to sign into Windows Admin Center. Select **continue**.

   :::image type="content" source="media/register-wac/sign-in.png" alt-text="Sign in to Windows Admin Center using your email or phone number" lightbox="media/register-wac/sign-in.png":::

   You should see the following message: "You have signed in to the Windows Admin Center application on your device." Close the browser window to return to the original registration page.

4. Connect to Azure Active Directory by supplying your Azure Active Directory (tenant) ID and application ID. If you already have an Azure tenant ID and you've followed the preceding steps, the tenant ID field may be pre-populated and may contain multiple options. Select the correct tenant ID. 

   If your Azure AD administrator has provided you with an application ID, click **Use existing**, and an empty field will appear for you to enter the ID provided by your admin. After entering your ID, Windows Admin Center will confirm that an account with that ID is found. If you have an existing ID but don't know what it is, follow [these steps](/azure/active-directory/develop/howto-create-service-principal-portal#get-values-for-signing-in) to retrieve it. If your organization didn't provide you with an existing ID, leave **Azure Active Directory application** set to **Create New**.

   :::image type="content" source="media/register-wac/connect-to-aad.png" alt-text="Connect to Azure Active Directory by supplying your existing Azure Active Directory (tenant) ID and application ID, or creating a new application ID" lightbox="media/register-wac/connect-to-aad.png":::

5. Click **Connect**. If you're an Azure AD admin or if you used an existing application ID, you should see a confirmation that you are now connected to Azure AD. You may see a **Permissions requested** dialog box; click **Accept**. Select **Sign in** to sign into Windows Admin Center with your Azure account. If you're not an Azure AD admin and you created a new application ID upon registration, you'll need to ask your Azure AD admin to grant consent to the new application ID by following the instructions in step 6 below.

6. If you are an Azure AD admin, grant permissions in the Azure portal by navigating to **Azure Active Directory**, then **App registrations**. Select **All applications** and search for **WindowsAdminCenter**. Select the display name that matches the address of the Windows Admin Center system you're registering. Take note of the **Application (client) ID** displayed near the top of the page, as you may need to provide it to one or more users in your organization so they can register Windows Admin Center on their PCs. Next, navigate to **API permissions** and select **Grant admin consent**. If you plan to use the same application ID for multiple users, proceed to step 7; otherwise, you're done.

7. For convenience and ease of management, it's possible to enable multiple users in an organization to register Windows Admin Center on their PCs using the same Azure app ID. To do this, all users must register Windows Admin Center to the same domain and port, usually *https://localhost:6516*. This also requires the Azure AD admin to take an extra step and add redirect URIs in the Azure portal.

   In the Azure portal, select **Authentication** under **Manage** from the toolbar on the left. In the **Redirect URIs** box, you will see an existing URI representing the first Windows Admin Center system that registered to the app ID. Select **Add URI** and add two new redirect URIs: *http://localhost:6516* and *https://localhost:6516*. Select **Save.**

   :::image type="content" source="media/register-wac/add-redirect-uris.png" alt-text="To enable multiple users in an organization to register Windows Admin Center using the same Azure app ID, add redirect URIs" lightbox="media/register-wac/add-redirect-uris.png":::

   > [!IMPORTANT]
   > Make sure to provide your users with the correct Azure tenant ID and the application ID from step 6, and tell them to select **Use existing** application ID when registering Windows Admin Center. Note that if an Azure AD admin doesn't add redirect URIs and more than one user tries to register Windows Admin Center to the same app ID, the user(s) will get an error that the reply URL doesn't match.

8. Once Windows Admin Center is registered with Azure, you're ready to [register your Azure Stack HCI cluster with Azure](../deploy/register-with-azure.md).

## Unregister Windows Admin Center

To unregister Windows Admin Center, select the **Settings** gear icon in the upper right. Then, from the **Gateway** menu at the left, select **Azure**, then **Unregister**, then **Confirm**. 

This will remove the association between Windows Admin Center and the Azure AD app ID that was provided by your Azure AD admin or created when you registered Windows Admin Center. It will not delete the Azure AD app nor affect any Azure services used by servers or clusters managed by Windows Admin Center.

## Next steps

You are now ready to:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Use Azure Stack HCI with Windows Admin Center](../get-started.md)
- [Connect to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/)