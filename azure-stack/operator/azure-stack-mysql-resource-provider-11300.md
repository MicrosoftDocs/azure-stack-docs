---
title: Azure Stack Hub MySQL resource provider 1.1.30.0 release notes | Microsoft Docs
description: View the release notes to see what's new in the Azure Stack Hub MySQL resource provider 1.1.30.0 update.
author: mattbriggs

ms.topic: article
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: jiahan
ms.lastreviewed: 12/10/2018
---

# MySQL resource provider 1.1.30.0 release notes

These release notes describe the improvements and known issues in MySQL resource provider version 1.1.30.0.

## Build reference
Download the MySQL resource provider binary and then run the self-extractor to extract the contents to a temporary directory. The resource provider has a minimum corresponding Azure Stack Hub build. The minimum Azure Stack Hub release version required to install this version of the MySQL resource provider is listed below:

> |Minimum Azure Stack Hub version|MySQL resource provider version|
> |-----|-----|
> |Azure Stack Hub 1808 update (1.1808.0.97)|[1.1.30.0](https://aka.ms/azurestackmysqlrp11300)|
> |     |     |

> [!IMPORTANT]
> Apply the minimum supported Azure Stack Hub update to your Azure Stack Hub integrated system or deploy the latest Azure Stack Development Kit (ASDK) before deploying the latest version of the MySQL resource provider.

## New features and fixes
This version of the Azure Stack Hub MySQL resource provider includes the following improvements and fixes:

- **Telemetry enabled for MySQL resource provider deployments**. Telemetry collection has been enabled for MySQL resource provider deployments. Telemetry collected includes resource provider deployment, start and stop times, exit status, exit messages, and error details (if applicable).

- **TLS 1.2 encryption update**. Enabled TLS 1.2-only support for resource provider communication with internal Azure Stack Hub components. 

### Fixes

- **MySQL resource provider Azure Stack Hub PowerShell compatibility**. The MySQL resource provider has been updated to work with the Azure Stack Hub 2018-03-01-hybrid PowerShell profile and to provide compatibility with AzureRM 1.3.0 and later.

- **MySQL login change password blade**. Fixed an issue where the password can't be changed on the change password blade. Removed links from password change notifications.

## Known issues

- **MySQL SKUs can take up to an hour to be visible in the portal**. It can take up to an hour for newly created SKUs to be visible for use when creating new MySQL databases.

    **Workaround**: None.

- **Reused MySQL logins**. Attempting to create a new MySQL login with the same username as an existing login under the same subscription will result in reusing the same login and the existing password.

    **Workaround**: Use different usernames when creating new logins under the same subscription or create logins with the same username under different subscriptions.

- **TLS 1.2 support requirement**. If you try to deploy or update the MySQL resource provider from a computer where TLS 1.2 isn't enabled, the operation might fail. Run the following PowerShell command on the computer being used to deploy or update the resource provider to verify that TLS 1.2 is returned as supported:

  ```powershell
  [System.Net.ServicePointManager]::SecurityProtocol
  ```

  If **Tls12** isn't included in the output of the command, TLS 1.2 isn't enabled on the computer.

    **Workaround**: Run the following PowerShell command to enable TLS 1.2 and then start the resource provider deployment or update script from the same PowerShell session:

    ```powershell
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    ```
 
### Known issues for Cloud Admins operating Azure Stack Hub
Refer to the documentation in the [Azure Stack Hub Release Notes](azure-stack-servicing-policy.md).

## Next steps
[Learn more about the MySQL resource provider](azure-stack-mysql-resource-provider.md).

[Prepare to deploy the MySQL resource provider](azure-stack-mysql-resource-provider-deploy.md#prerequisites).

[Upgrade the MySQL resource provider from a previous version](azure-stack-mysql-resource-provider-update.md). 