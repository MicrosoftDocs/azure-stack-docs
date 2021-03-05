---
title: Register Windows Admin Center with Azure
description: How to register your Windows Admin Center gateway with Azure.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 03/05/2021
---

# Register Windows Admin Center with Azure

> Applies to Azure Stack HCI version 20H2; Windows Server 2019

To use Azure services with Windows Admin Center, you must first [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) on a management PC and register your Windows Admin Center gateway. This is a prerequisite for [registering a cluster](../deploy/register-with-azure.md) with Azure.

   > [!IMPORTANT]
   > In order to use Windows Admin Center to register Azure Stack HCI clusters, your Windows Admin Center gateway must be registered to an Azure AD application ID that is approved by your organization's Azure AD admin. Register Windows Admin Center on the same management PC you plan to use to register your cluster(s), using the same Azure Active Directory (tenant) ID and application ID.

## Complete the registration process

1. Launch Windows Admin Center and select the **Settings** gear icon in the upper right, which will take you to your Account page. Then, from the **Gateway** menu at the left, select **Azure**, and then click **Register**.

   :::image type="content" source="media/register-wac/register-wac.png" alt-text="Select Settings > Gateway > Azure, then click Register" lightbox="media/register-wac/register-wac.png":::

2. You'll be provided with a unique code. Click the **Copy** button to the right of the code. Click **Enter the code**, which will open up another browser window into which you can paste the code displayed on your app or device.

   :::image type="content" source="media/register-wac/enter-code.png" alt-text="Copy the unique code, click enter the code, and paste it into the dialog box" lightbox="media/register-wac/enter-code.png":::

3. After pasting in the code, you'll be notified that you're about to be signed in to Windows Admin Center on a remote device or service. Enter your email or phone number. If your device is managed, you will be taken to your organization's sign-in page for authentication. Follow the instructions and enter the appropriate credentials.

   :::image type="content" source="media/register-wac/sign-in.png" alt-text="Sign in to Windows Admin Center using your email or phone number" lightbox="media/register-wac/sign-in.png":::

   You should see the following message: "You have signed in to the Windows Admin Center application on your device." Close the browser window to return to the original registration page.

4. Connect to Azure Active Directory by supplying your Azure Active Directory (tenant) ID and application ID. If you already have an Azure tenant ID and you've followed the preceding steps, the tenant ID field may be pre-populated and may contain multiple options. Select the correct tenant ID. 

   If your Azure AD administrator has provided you with an application ID, click **Use existing**, and an empty field will appear for you to enter the ID provided by your admin. After entering your ID, Windows Admin Center will confirm that an account with that ID is found. If you have an existing ID but don't know what it is, follow [these steps](/azure/active-directory/develop/howto-create-service-principal-portal#get-values-for-signing-in) to retrieve it. If your organization didn't provide you with an existing ID, leave **Azure Active Directory application** set to **Create New**.

   :::image type="content" source="media/register-wac/connect-to-aad.png" alt-text="Connect to Azure Active Directory by supplying your existing Azure Active Directory (tenant) ID and application ID, or creating a new application ID" lightbox="media/register-wac/connect-to-aad.png":::

5. Click the **Connect** button to connect to Azure. If you are an Azure AD admin or if you used an existing application ID, you should see a confirmation that you are now connected to Azure AD, indicating that the process is complete. If not, you may see a message that you need admin approval. If this is the case, select **Return to the application without granting consent**, and contact your Azure AD admin to grant permissions to the new application ID that was created upon registration by following the instructions in step 6.

6. If you are an Azure AD admin, grant permissions in Azure by navigating to **Azure Active Directory**, then **App registrations**. Select **All applications** and search for **WindowsAdminCenter**. Select the display name of the gateway you're registering. Take note of the **Application (client) ID** displayed near the top of the page, as you'll need to provide it to the user. Next, navigate to **API permissions**. Under **Grant consent**, select **Grant admin consent**. Then, give the application ID to the user. If you plan to use the same application ID for multiple users, proceed to step 7; otherwise, skip ahead to step 8.

7. For convenience and ease of management, it's possible to enable multiple users in an organization to register Windows Admin Center using the same Azure app ID. To do this, all users must register their gateways to the same domain and port, such as *https://localhost:6516* for example. This also requires the Azure AD admin to take an extra step and add redirect URIs in the Azure portal.

   In Windows Admin Center, select the **Settings** gear icon in the upper right. Then, from the **Gateway** menu at the left, select **Azure**, and then click **View in Azure**, which will display Azure AD details. In the Azure portal, select **Manage > Authentication** from the menu on the left. In the **Redirect URIs** box, you will see an existing URI representing the first gateway that registered to the app ID. Select **Add URI** and add two new redirect URIs, such as *http://localhost:6516* and *https://localhost:6516*.

   :::image type="content" source="media/register-wac/add-redirect-uris.png" alt-text="To enable multiple users in an organization to register Windows Admin Center using the same Azure app ID, add redirect URIs by selecting Authentication in the Azure portal" lightbox="media/register-wac/add-redirect-uris.png":::

   > [!IMPORTANT]
   > If the Azure AD admin doesn't add redirect URIs and more than one user tries to register Windows Admin Center to the same app ID, the user will get an error that the reply URL doesn't match.

7. At this point, the user must repeat the registration process, this time selecting **Use existing** application ID and specifying the application ID provided by the Azure AD admin.

8. Select **Sign in** to sign into Windows Admin Center with your Azure account.

## Next steps

You are now ready to:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Use Azure Stack HCI with Windows Admin Center](../get-started.md)
- [Connect to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/)