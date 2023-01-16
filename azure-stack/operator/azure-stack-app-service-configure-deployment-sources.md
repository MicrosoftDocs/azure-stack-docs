---
title: Configure App Services deployment sources - Azure Stack Hub 
description: Learn how to configure deployment sources (Git, GitHub, BitBucket, DropBox, and OneDrive) for App Services on Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 10/24/2022
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 10/15/2019
zone_pivot_groups: version-2022h1-previous

# Intent: As an Azure Stack Hub operator, I want to configure deployment sources for App Services on Azure Stack Hub so I can deploy directly from my source control repositories.
# Keyword: deployment sources app services azure stack hub

---

# Configure deployment sources for App Services on Azure Stack Hub

App Service on Azure Stack Hub supports on-demand deployment from multiple source control providers. This feature lets app developers deploy directly from their source control repositories. If users want to configure App Service to connect to their repositories, a cloud operator must first configure the integration between App Service on Azure Stack Hub and the source control provider.  

In addition to local Git, the following source control providers are supported:

* GitHub
* BitBucket
* OneDrive
* DropBox

## View deployment sources in App Service administration

1. Sign in to the Azure Stack Hub administrator portal as the service admin.
2. Browse to **All Services** and select the **App Service**.

    ![App Service resource provider admin][1]

3. Select **Source control configuration**. You can see the list of all configured deployment sources.

    ![App Service resource provider admin source control configuration][2]

<!--- Azure App Service on Azure Stack Hub 2022 H1 pivot --->
::: zone pivot="version-previous"

## Configure GitHub

You must have a GitHub account to complete this task. You might want to use an account for your organization rather than a personal account.

1. Sign in to GitHub, go to <https://www.github.com/settings/developers>, and then select **Register a new application**.

    ![GitHub - Register a new application][3]

2. Enter an **Application name**. For example, **App Service on Azure Stack Hub**.
3. Enter the **Homepage URL**. The Homepage URL must be the Azure Stack Hub portal address. For example, `https://portal.<region>.<FQDN>`. For more information on the Azure Stack Hub fully qualified domain name (FQDN), see [Azure Stack Hub DNS namespace](azure-stack-integrate-dns.md#azure-stack-hub-dns-namespace).
4. Enter an **Application Description**.
5. Enter the **Authorization callback URL**. In a default Azure Stack Hub deployment, the URL is in the form `https://portal.<region>.<FQDN>/TokenAuthorize`. 
6. Select **Register application**. A page is displayed listing the **Client ID** and **Client Secret** for the app.

    ![GitHub - Completed application registration][5]

7. In a new browser tab or window, sign in to the Azure Stack Hub administrator portal as the service admin.
8. Go to **Resource Providers** and select the **App Service Resource Provider Admin**.
9. Select **Source control configuration**.
10. Copy and paste the **Client ID** and **Client Secret** into the corresponding input boxes for GitHub.
11. Select **Save**.

## Configure BitBucket

You must have a BitBucket account to complete this task. You might want to use an account for your organization rather than a personal account.

1. Sign in to BitBucket and go to **Integrations** under your account.

    ![BitBucket Dashboard - Integrations][7]

2. Select **OAuth** under Access Management and **Add consumer**.

    ![BitBucket Add OAuth Consumer][8]

3. Enter a **Name** for the consumer. For example, **App Service on Azure Stack Hub**.
4. Enter a **Description** for the app.
5. Enter the **Callback URL**. In a default Azure Stack Hub deployment, the callback URL is in the form `https://portal.<region>.<FQDN>/TokenAuthorize`. For BitBucket integration to succeed, the URL must follow the capitalization listed here.
6. Enter the **URL**. This URL should be the Azure Stack Hub portal URL. For example, `https://portal.<region>.<FQDN>`.
7. Select the **Permissions** required:

    - **Repositories**: *Read*
    - **Webhooks**: *Read and write*

8. Select **Save**. You now see this new app, along with the **Key** and **Secret**, under **OAuth consumers**.

    ![BitBucket Application Listing][9]

9. In a new browser tab or window, sign in to the Azure Stack Hub administrator portal as the service admin.
10. Go to **Resource Providers** and select the **App Service Resource Provider Admin**.
11. Select **Source control configuration**.
12. Copy and paste the **Key** into the **Client ID** input box and **Secret** into the **Client Secret** input box for BitBucket.
13. Select **Save**.

## Configure OneDrive

You must have a **Microsoft** account linked to a OneDrive account to complete this task. You might want to use an account for your organization rather than a personal account.

> [!NOTE]
> OneDrive for business accounts are currently not supported.

1. Go to <https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade> and sign in using your Microsoft account.
1. Under **App registrations**, select **New registration**.
1. Enter a **Name** for the new app registration: for example, enter **App Service on Azure Stack Hub**.
1. Under **Supported account types**, select **Personal Microsoft accounts only**.
1. Enter the **Redirect URI**.  Choose platform - Web and in a default Azure Stack Hub deployment, the redirect URI is in the form - `https://portal.<region>.<FQDN>/TokenAuthorize`.
1. Select **Register**.
1. The next screen lists the properties of your new app. Save the **Application (client) ID** to a temporary location.
1. Under **Certificates & secrets**, choose **Client Secrets** and select **New client secret**.  Provide a description and choose the expiration length for the new secret and select **Add**.
1. Make a note of the value of the new secret.
1. Under **API Permissions**, select **Add a permission**.
1. Add the **Microsoft Graph Permissions** - **Delegated Permissions**.

    - **Files.ReadWrite.AppFolder**
    - **User. Read**
1. In a new browser tab or window, sign in to the Azure Stack Hub administrator portal as the service admin.
1. Go to **Resource Providers** and select the **App Service Resource Provider Admin**.
1. Select **Source control configuration**.
1. Copy and paste the **Application (client) ID** into the **Client ID** input box and **Secret** into the **Client Secret** input box for OneDrive.
1. Select **Save**.

## Configure DropBox

> [!NOTE]
> You must have a DropBox account to complete this task. You might want to use an account for your organization rather than a personal account.

1. Go to <https://www.dropbox.com/developers/apps> and sign in using your DropBox account credentials.
2. Select **Create app**.

    ![Dropbox apps][14]

3. Select **DropBox API**.
4. Set the access level to **App Folder**.
5. Enter a **Name** for your app.

    ![Dropbox application registration][15]

6. Select **Create App**. You're presented with a page listing the settings for the app, including **App key** and **App secret**.
7. Make sure that the **App folder name** is set to **App Service on Azure Stack Hub**.
8. Set the **OAuth 2 Redirect URI** and then select **Add**. In a default Azure Stack Hub deployment, the redirect URI is in the form `https://portal.<region>.<FQDN>/TokenAuthorize`.

    ![Dropbox application configuration][16]

9. In a new browser tab or window, sign in to the Azure Stack Hub administrator portal as the service admin.
10. Go to **Resource Providers** and select the **App Service Resource Provider Admin**.
11. Select **Source control configuration**.
12. Copy and paste the **Application Key** into the **Client ID** input box and **App secret** into the **Client Secret** input box for DropBox.
13. Select **Save**.

::: zone-end

<!--- Azure App Service on Azure Stack Hub 2022 H1 pivot --->
::: zone pivot="version-2022h1"

> [!IMPORTANT]
> If you are reconfiguring existing applications after upgrading to Azure App Service on Azure Stack Hub 2022 H1 
> you must revoke all tokens and your end users will need to reauthorize with the providers on their applications to enable synchronisation from source control providers
>

## Configure GitHub

You must have a GitHub account to complete this task. You might want to use an account for your organization rather than a personal account.

1. Sign in to GitHub, go to <https://www.github.com/settings/developers>, and then select **Register a new application**.

    ![GitHub - Register a new application][3]

2. Enter an **Application name**. For example, **App Service on Azure Stack Hub**.
3. Enter the **Homepage URL**. The Homepage URL must be the Azure Stack Hub portal address. For example, `https://portal.<region>.<FQDN>`. For more information on the Azure Stack Hub fully qualified domain name (FQDN), see [Azure Stack Hub DNS namespace](azure-stack-integrate-dns.md#azure-stack-hub-dns-namespace).
4. Enter an **Application Description**.
5. Enter the **Authorization callback URL**. In a default Azure Stack Hub deployment, the URL is in the form `https://api.appservice.<region>.<FQDN>:44300/auth/github/callback`. 
6. Select **Register application**. A page is displayed listing the **Client ID** and **Client Secret** for the app.

    ![GitHub - Completed application registration][5]

7. In a new browser tab or window, sign in to the Azure Stack Hub administrator portal as the service admin.
8. Go to **Resource Providers** and select the **App Service Resource Provider Admin**.
9. Select **Source control configuration**.
10. Copy and paste the **Client ID** and **Client Secret** into the corresponding input boxes for GitHub.
11. Select **Save**.

## Configure BitBucket

You must have a BitBucket account to complete this task. You might want to use an account for your organization rather than a personal account.

1. Sign in to BitBucket and go to **Integrations** under your account.

    ![BitBucket Dashboard - Integrations][7]

2. Select **OAuth** under Access Management and **Add consumer**.

    ![BitBucket Add OAuth Consumer][8]

3. Enter a **Name** for the consumer. For example, **App Service on Azure Stack Hub**.
4. Enter a **Description** for the app.
5. Enter the **Callback URL**. In a default Azure Stack Hub deployment, the callback URL is in the form `https://api.appservice.<region>.<FQDN>:44300/auth/bitbucket/callback`. For BitBucket integration to succeed, the URL must follow the capitalization listed here.
6. Enter the **URL**. This URL should be the Azure Stack Hub portal URL. For example, `https://portal.<region>.<FQDN>`.
7. Select the **Permissions** required:

    - **Repositories**: *Read*
    - **Webhooks**: *Read and write*

8. Select **Save**. You now see this new app, along with the **Key** and **Secret**, under **OAuth consumers**.

    ![BitBucket Application Listing][9]

9. In a new browser tab or window, sign in to the Azure Stack Hub administrator portal as the service admin.
10. Go to **Resource Providers** and select the **App Service Resource Provider Admin**.
11. Select **Source control configuration**.
12. Copy and paste the **Key** into the **Client ID** input box and **Secret** into the **Client Secret** input box for BitBucket.
13. Select **Save**.

## Configure OneDrive

You must have a **Microsoft** account linked to a OneDrive account to complete this task. You might want to use an account for your organization rather than a personal account.

> [!NOTE]
> OneDrive for business accounts are currently not supported.

1. Go to <https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade> and sign in using your Microsoft account.
1. Under **App registrations**, select **New registration**.
1. Enter a **Name** for the new app registration: for example, enter **App Service on Azure Stack Hub**.
1. Under **Supported account types**, select **Personal Microsoft accounts only**
1. Enter the **Redirect URI**.  Choose platform - Web and in a default Azure Stack Hub deployment, the redirect URI is in the form - `https://api.appservice.<region>.<FQDN>:44300/auth/onedrive/callback`.
1. Select **Register**
1. The next screen lists the properties of your new app. Save the **Application (client) ID** to a temporary location.
1. Under **Certificates & secrets**, choose **Client Secrets** and select **New client secret**.  Provide a description and choose the expiration length for the new secret and select **Add**.
1. Make a note of the value of the new secret.
1. Under **API Permissions**, select **Add a permission**
1. Add the **Microsoft Graph Permissions** - **Delegated Permissions**.

    - **Files.ReadWrite.AppFolder**
    - **User. Read**
1. In a new browser tab or window, sign in to the Azure Stack Hub administrator portal as the service admin.
1. Go to **Resource Providers** and select the **App Service Resource Provider Admin**.
1. Select **Source control configuration**.
1. Copy and paste the **Application (client) ID** into the **Client ID** input box and **Secret** into the **Client Secret** input box for OneDrive.
1. Select **Save**.

## Configure DropBox

> [!NOTE]
> You must have a DropBox account to complete this task. You might want to use an account for your organization rather than a personal account.

1. Go to <https://www.dropbox.com/developers/apps> and sign in using your DropBox account credentials.
2. Select **Create app**.

    ![Dropbox apps][14]

3. Select **DropBox API**.
4. Set the access level to **App Folder**.
5. Enter a **Name** for your app.

    ![Dropbox application registration][15]

6. Select **Create App**. You're presented with a page listing the settings for the app, including **App key** and **App secret**.
7. Make sure that the **App folder name** is set to **App Service on Azure Stack Hub**.
8. Set the **OAuth 2 Redirect URI** and then select **Add**. In a default Azure Stack Hub deployment, the redirect URI is in the form `https://api.appservice.<region>.<FQDN>:44300/auth/dropbox/callback`.

    ![Dropbox application configuration][16]

9. In a new browser tab or window, sign in to the Azure Stack Hub administrator portal as the service admin.
10. Go to **Resource Providers** and select the **App Service Resource Provider Admin**.
11. Select **Source control configuration**.
12. Copy and paste the **Application Key** into the **Client ID** input box and **App secret** into the **Client Secret** input box for DropBox.
13. Select **Save**.

::: zone-end

## Next steps

Users can now use the deployment sources for things like [continuous deployment](/azure/app-service/deploy-continuous-deployment), [local Git deployment](/azure/app-service/deploy-local-git), and [cloud folder synchronization](/azure/app-service/deploy-content-sync).

<!--Image references-->
[1]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin.png
[2]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-source-control-configuration.png
[3]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-github-developer-applications.png
[4]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-github-register-a-new-oauth-application-populated.png
[5]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-github-register-a-new-oauth-application-complete.png
[6]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-roles-management-server-repair-all.png
[7]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-bitbucket-dashboard.png
[8]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-bitbucket-access-management-add-oauth-consumer.png
[9]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-bitbucket-access-management-add-oauth-consumer-complete.png
[10]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-Onedrive-applications.png
[11]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-Onedrive-application-registration.png
[12]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-Onedrive-application-platform.png
[13]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-Onedrive-application-graph-permissions.png
[14]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-Dropbox-applications.png
[15]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-Dropbox-application-registration.png
[16]: ./media/azure-stack-app-service-configure-deployment-sources/App-service-provider-admin-Dropbox-application-configuration.png
