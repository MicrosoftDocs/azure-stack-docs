---
title: Register Windows Admin Center with Azure
description: How to register Windows Admin Center with Azure.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 07/21/2020
---

# Register Windows Admin Center with Azure

> Applies to Azure Stack HCI v20H2; Windows Server 2019

To use Azure services with Windows Admin Center, you must first install Windows Admin Center on a management PC and complete a one-time registration.

## Complete the registration process in Windows Admin Center

1. Launch Windows Admin Center and click the **Settings** gear icon in the upper right, which will take you to your Account page. Then, from the **Gateway** menu at the left, select **Azure**, and then click **Register**.
1. You'll be provided with a unique code. Click the **Copy** button to the right of the code.
1. Click **Enter the code**, which will open up another browser window into which you can paste the code displayed on your app or device.
1. After pasting in the code, you'll be notified that you're about to be signed in to Windows Admin Center on a remote device or service. 
1. Enter your email or phone number. If your device is managed, you will be taken to your organization's sign-in page for authentication. Follow the instructions and enter the appropriate credentials.
1. You should see the following message: "You have signed in to the Windows Admin Center application on your device." Close the browser window to return to the original registration page.
1. Connect to Azure Active Directory by supplying your Azure Active Directory (tenant) ID. If you followed the preceding steps, the ID field will be pre-populated. Leave **Azure Active Directory application** set to **Create New** if your organization didn't provide you with an existing ID. If you already have an ID, click **Use existing**, and an empty field will appear for you to enter the ID provided by your admin. After entering your ID, Windows Admin Center will confirm that an account with that ID is found. If you have an existing ID but don't know what it is, follow [these steps](/azure/active-directory/develop/howto-create-service-principal-portal#get-values-for-signing-in) to retrieve it.
1. Click the **Connect** button to connect to Azure. You should see a confirmation that you are now connected to Azure AD.
1. Grant permissions in Azure by going to **App permissions** in the Azure portal. Under **Grant consent**, select **Grant admin consent**.
1. Close the window and sign into Windows Admin Center with your Azure account.

## Next steps

You are now ready to:

- [Use Azure Stack HCI with Windows Admin Center](../get-started.md)
- [Connect to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/)