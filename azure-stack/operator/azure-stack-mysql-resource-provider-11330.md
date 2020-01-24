---
title: Azure Stack Hub MySQL resource provider 1.1.33.0 release notes | Microsoft Docs
description: View the release notes to see what's new in the Azure Stack Hub MySQL resource provider 1.1.33.0 update.
author: mattbriggs

ms.service: azure-stack
ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: jiahan
ms.lastreviewed: 01/09/2019
---

# MySQL resource provider 1.1.33.0  release notes

These release notes describe the improvements and known issues in MySQL resource provider version 1.1.33.0.

## Build reference
Download the MySQL resource provider binary and then run the self-extractor to extract the contents to a temporary directory. The resource provider has a minimum corresponding Azure Stack Hub build. The minimum Azure Stack Hub release version required to install this version of the MySQL resource provider is listed below:

> |Minimum Azure Stack Hub version|MySQL resource provider version|
> |-----|-----|
> |Version 1808 (1.1808.0.97)|[MySQL RP version 1.1.33.0](https://aka.ms/azurestackmysqlrp11330)|  
> |     |     |

> [!IMPORTANT]
> Apply the minimum supported Azure Stack Hub update to your Azure Stack Hub integrated system or deploy the latest Azure Stack Development Kit (ASDK) before deploying the latest version of the MySQL resource provider.

## New features and fixes
This version of the Azure Stack Hub MySQL resource provider includes the following improvements and fixes:

### Fixes

- **MySQL resource provider portal extension might choose the wrong subscription**. The MySQL resource provider uses Azure Resource Manager calls to determine the first service admin subscription to use, which might not be the *Default Provider Subscription*. If that happens, the MySQL resource provider doesn't work normally.

- **MySQL hosting server doesn't list hosted databases.** User-created databases might not be listed when viewing tenant resources for MySQL hosting servers.

- **Previous MySQL resource provider (1.1.30.0) deployment could fail if TLS 1.2 isn't enabled**. Updated the MySQL resource provider 1.1.33.0 to enable TLS 1.2 when deploying the resource provider, updating the resource provider, or rotating secrets.

- **MySQL resource provider secret rotation fails**. Fixed an issue resulting in the following error code when rotating secrets:
`New-AzureRmResourceGroupDeployment - Error: Code=InvalidDeploymentParameterValue; Message=The value of deployment parameter 'StorageAccountBlobUri' is null.`

## Known issues

- **MySQL SKUs can take up to an hour to be visible in the portal**. It can take up to an hour for newly created SKUs to be visible for use when creating new MySQL databases. 

    **Workaround**: None.

- **Reused MySQL logins**. Attempting to create a new MySQL login with the same username as an existing login under the same subscription will result in reusing the same login and the existing password.

    **Workaround**: Use different usernames when creating new logins under the same subscription or create logins with the same username under different subscriptions.

- **Shared MySQL logins cause data inconsistency**. If a MySQL login is shared for multiple MySQL databases under the same subscription, changing the login password will cause data inconsistency.

    **Workaround**: Always use different logins for different databases under the same subscription.


### Known issues for Cloud Admins operating Azure Stack Hub
Refer to the documentation in the [Azure Stack Hub Release Notes](azure-stack-servicing-policy.md).

## Next steps
[Learn more about the MySQL resource provider](azure-stack-mysql-resource-provider.md).

[Prepare to deploy the MySQL resource provider](azure-stack-mysql-resource-provider-deploy.md#prerequisites).

[Upgrade the MySQL resource provider from a previous version](azure-stack-mysql-resource-provider-update.md). 