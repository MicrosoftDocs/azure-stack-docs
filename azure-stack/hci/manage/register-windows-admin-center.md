---
title: Register Windows Admin Center with Azure
description: How to register your Windows Admin Center gateway with Azure.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 01/28/2021
---

# Register Windows Admin Center with Azure

> Applies to Azure Stack HCI v20H2; Windows Server 2019

To use Azure services with Windows Admin Center, you must first install Windows Admin Center on a management PC and complete a one-time registration of your Windows Admin Center gateway. This is a prerequisite for registering your cluster with Azure, and should be done on the same management PC you plan to use to complete the [cluster registration](../deploy/register-with-azure.md) process, using the same Azure subscription ID and tenant ID.

## Complete the registration process

1. Launch Windows Admin Center and click the **Settings** gear icon in the upper right, which will take you to your Account page. Then, from the **Gateway** menu at the left, select **Azure**, and then click **Register**.

   :::image type="content" source="media/register-wac/register-wac.png" alt-text="Select Settings > Gateway > Azure, then click Register" lightbox="media/register-wac/register-wac.png":::

2. You'll be provided with a unique code. Click the **Copy** button to the right of the code. Click **Enter the code**, which will open up another browser window into which you can paste the code displayed on your app or device.

   :::image type="content" source="media/register-wac/enter-code.png" alt-text="Copy the unique code, click enter the code, and paste it into the dialog box" lightbox="media/register-wac/enter-code.png":::

3. After pasting in the code, you'll be notified that you're about to be signed in to Windows Admin Center on a remote device or service. Enter your email or phone number. If your device is managed, you will be taken to your organization's sign-in page for authentication. Follow the instructions and enter the appropriate credentials.

   :::image type="content" source="media/register-wac/sign-in.png" alt-text="Sign in to Windows Admin Center using your email or phone number" lightbox="media/register-wac/sign-in.png":::

   You should see the following message: "You have signed in to the Windows Admin Center application on your device." Close the browser window to return to the original registration page.

4. Connect to Azure Active Directory by supplying your Azure Active Directory (tenant) ID. If you already have an Azure tenant ID and you've followed the preceding steps, the ID field may be pre-populated. Leave **Azure Active Directory application** set to **Create New** if your organization didn't provide you with an existing ID. If you already have an ID, click **Use existing**, and an empty field will appear for you to enter the ID provided by your admin. After entering your ID, Windows Admin Center will confirm that an account with that ID is found. If you have an existing ID but don't know what it is, follow [these steps](/azure/active-directory/develop/howto-create-service-principal-portal#get-values-for-signing-in) to retrieve it.

   :::image type="content" source="media/register-wac/connect-to-aad.png" alt-text="Connect to Azure Active Directory by supplying your existing Azure Active Directory (tenant) ID or creating a new one" lightbox="media/register-wac/connect-to-aad.png":::

5. Click the **Connect** button to connect to Azure. You should see a confirmation that you are now connected to Azure AD.

6. Grant permissions in Azure by going to **App permissions** in the Azure portal. Under **Grant consent**, select **Grant admin consent**.

7. Close the window and sign into Windows Admin Center with your Azure account.

## Next steps

You are now ready to:

- [Connect Azure Stack HCI to Azure](../deploy/register-with-azure.md)
- [Use Azure Stack HCI with Windows Admin Center](../get-started.md)
- [Connect to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/)