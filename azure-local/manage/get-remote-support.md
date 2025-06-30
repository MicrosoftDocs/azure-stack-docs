---
title: Get remote support for Azure Local
description: Learn how to get remote support for the Azure Stack HCI Operating System.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.custom: devx-track-azurepowershell
ms.date: 06/18/2025
---

# Get remote support for Azure Local

[!INCLUDE [hci-applies-to-23h2-22h2](../includes/hci-applies-to-23h2-22h2.md)]

This article explains how to get remote support for the Azure Stack HCI operating system for Azure Local.
It provides an overview of remote support, the terms and conditions, and the steps to enable remote support on your Azure Local. It also includes information about configuring proxy settings, submitting a support request, and other remote support operations.

## Overview

Remote support lets a Microsoft support professional resolve your support case faster by allowing access to your device for limited troubleshooting and repair. You can enable remote support by granting consent and choosing the access level and duration.

:::image type="content" source="media/get-remote-support/remote-support-workflow.png" alt-text="Process flow of authenticated access between customer and Microsoft support for diagnostics, troubleshooting, and remediation actions." lightbox="media/get-remote-support/remote-support-workflow.png" :::

After you enable remote support, Microsoft support gets just-in-time (JIT) limited time access to your device. Access is provided over a secure, audited, and compliant channel to ensure all activities are monitored. Microsoft support can only access your device after you submit a support request which ensures that your device remains secure and your privacy is maintained.

## Remote support terms and conditions

The following are the data handling terms and conditions for remote access. Carefully read them before granting access. Everything under this section should be remain as is without making any changes to the text.

> By approving this request, the Microsoft support organization or the Azure engineering team supporting this feature ("Microsoft Support Engineer") will be given direct access to your device for troubleshooting purposes and/or resolving the technical issue described in the Microsoft support case.
>
> During a remote support session, a Microsoft Support Engineer may need to collect logs. By enabling remote support, you have agreed to a diagnostics log collection by a Microsoft Support Engineer to address a support case. You also acknowledge and consent to the upload and retention of those logs in an Azure storage account managed and controlled by Microsoft. These logs may be accessed by Microsoft in the context of a support case and to improve the health of Azure Local.
>
> The data will be used only to troubleshoot failures that are subject to a support ticket, and will not be used for marketing, advertising, or any other commercial purposes without your consent. The data may be retained for up to ninety (90) days and will be handled following our standard privacy practices.
>
> Any data previously collected with your consent will not be affected by the revocation of your permission.

For more information about the personal data that Microsoft processes, how Microsoft processes it, and for what purposes, review [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement).

## Workflow

The high-level workflow to enable remote support is as follows:

- [Configure proxy settings](#configure-proxy-settings)
- [Enable remote support via PowerShell](#enable-remote-support-via-powershell)
- [Submit a support request](#submit-a-support-request)
- [Other remote support operations](#other-remote-support-operations)

## Configure proxy settings

If you use a proxy with Azure Local, add the following endpoints to your allowlist:

- \*.servicebus.windows.net
- \*.core.windows.net
- login.microsoftonline.com
- https\://asztrsprod.westus2.cloudapp.azure.com
- https\://asztrsprod.westeurope.cloudapp.azure.com
- https\://asztrsprod.eastus.cloudapp.azure.com
- https\://asztrsprod.westcentralus.cloudapp.azure.com
- https\://asztrsprod.southeastasia.cloudapp.azure.com
- https\://edgesupprd.trafficmanager.net

## Enable remote support via PowerShell

The Remote Support Arc extension, listed as **AzureEdgeRemoteSupport** in the Azure portal, makes setup easier and boosts support efficiency. It comes preinstalled on all system nodes, so there's no action for you to take. For more information about the Remote Support Arc extension, see [Azure Local remote support Arc extension](./remote-support-arc-extension.md).

To enable remote support on your Azure Local, follow these steps:

1. On the client you use to connect to your system, run PowerShell as an admin.

2. Open a remote PowerShell session to a node on your Azure Local. Run the following command and enter your node credentials when prompted:

    ```powershell
    $cred = Get-credential
    Enter-PsSession -ComputerName <NodeName> -Credential $cred
    ```

    Here's a sample output:

    ```console
    PS C:\Users\Administrator> etsn -ComputerName v-host1 -Credential $cred
    ```

3. To enable remote support, run this command:

    ```powershell
    Enable-RemoteSupport -AccessLevel <Diagnostics Or DiagnosticsRepair> -ExpireInMinutes <1440>
    ```

    Here's sample output:

    ```console
    PS C:\Users\Administrator> etsn -ComputerName v-host1 -Credential $cred

    PS C:\Users\HciDeploymentUser\Documents> Enable-RemoteSupport -AccessLevel Diagnostics -ExpireInMinutes 1440

    By approving this request, the Microsoft support organization or the Azure engineering team supporting this feature ('Microsoft Support Engineer') will be given direct access to your device for troubleshooting purposes and/or resolving the technical issue described in the Microsoft support case.

    During a remote support session, a Microsoft Support Engineer may need to collect logs. By enabling remote support, you have agreed to a diagnostic logs collection by Microsoft Support Engineer to address a support case You also acknowledge and consent to the upload and retention of those logs in an Azure storage account managed and controlled by Microsoft. These logs may be accessed by Microsoft in the context of a support case and to improve the health of Azure Local.

    The data will be used only to troubleshoot failures that are subject to a support ticket, and will not be used for marketing, advertising, or any other commercial purposes without your consent. The data may be retained for up to ninety (90) days and will be handled following our standard privacy practices (https://privacy.microsoft.com/en-US/). Any data previously collected with your consent will not be affected by the revocation of your permission.

    Proceed with enabling remote support?
    [Y] Yes  [N] No  [?] Help (default is "Y"): Y
         
    Enabling Remote Support for 'Diagnostics' expiring in '1440' minutes.
    Remote Support successfully Enabled.
     
    State                  : Active
    CreatedAt              : 9/6/2023 10:05:52 PM +00:00
    UpdatedAt              : 9/6/2023 10:05:52 PM +00:00
    ConnectionStatus       : Connecting
    ConnectionErrorMessage :
    TargetService          : PowerShell
    AccessLevel            : Diagnostics
    ExpiresAt              : 9/7/2023 10:05:50 PM +00:00
    SasCredential          :
    ```

> [!NOTE]
    > First time users, if you enable Remote Support through a remote PowerShell session, you might receive the following error:
    >
    > `Processing data from remote server NodeName failed with the following error message: The I/O operation has been aborted because of either a thread exit or an application request.`
    >
    > For more information, see [Error handling](#error-handling).

There are various operations that you can perform to grant remote access for Microsoft support, after you enable remote support. The next sections detail some examples of those operations.

## Enable remote support diagnostics

### Enable remote support for diagnostics

In this example, you grant remote support access for diagnostic-related operations only. The consent expires in 1,440 minutes (one day) after which remote access can't be established.

```powershell
Enable-RemoteSupport -AccessLevel Diagnostics -ExpireInMinutes 1440
```

Use the `ExpireInMinutes` parameter to set the duration of the session. In the example, consent expires in 1,440 minutes (one day). After one day, remote access can't be established.

You can set `ExpireInMinutes` a minimum duration of 60 minutes (one hour) and a maximum of 20,160 minutes (14 days).

If duration isn't defined, the remote session expires in 480 (8 hours) by default.

### Enable remote support for diagnostics and repair

In this example, you grant remote support access for diagnostic and repair related operations only. Since an expiration isn't explicitly provided, access expires in eight hours by default.

```powershell
Enable-RemoteSupport -AccessLevel DiagnosticsRepair
```

For information on access levels, see [List of Microsoft support operations](./remote-support-arc-extension.md#list-of-microsoft-support-operations).

For information on other available operations you can use, see [Other remote support operations](#other-remote-support-operations).

## Submit a support request

Microsoft support can access your device only after a support request is submitted. For information about how to create and manage support requests, see [Create an Azure support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).

## Other remote support operations

There are other operations you can perform to get information about access or a remote session. The next sections detail some examples of those operations.

### Retrieve existing consent grants

In this example, you retrieve any previously granted consent. The result includes expired consent in the last 30 days.

```powershell
Get-RemoteSupportAccess -IncludeExpired
```

### Revoke remote access consent

In this example, you revoke remote access consent. Any existing sessions are terminated and new sessions can no longer be established.

```powershell
Disable-RemoteSupport
```

### List existing remote sessions

In this example, you list all the remote sessions that were made to the device since FromDate.

```powershell
Get-RemoteSupportSessionHistory -FromDate <Date>
```

### Get details on a specific remote session

In this example, you get the details for remote session with the ID SessionID.

```powershell
Get-RemoteSupportSessionHistory -IncludeSessionTranscript -SessionId <SessionId>
```

> [!NOTE]
> Session transcript details are retained for 90 days. You can retrieve details for a remote session within 90 days after the session.

## Error handling

When you enable remote support on Azure Local, you may encounter an error. The following section describes the error message, its cause, and suggested resolutions.

When you run the enable remote support command for the first time, you may see the following error message:

```console
PS C:\Users\Administrator> etsn -ComputerName v-host1 -Credential $cred

PS C:\Users\HciDeploymentUser\Documents> Enable-RemoteSupport -AccessLevel Diagnostics -ExpireMinutes 1440

Proceed with enabling remote support?
[Y] Yes  [N] No  [?] Help (default is "Y"): Y

Type            Keys                                Name
----            ----                                ----
Container       {Name=SupportDiagnosticEndpoint}    SupportDiagnosticEndpoint

Processing data from remote server NodeName failed with the following error message: The I/O operation has been aborted because of either a thread exit or an application request.
```

**Error Message**: Processing data from remote server `NodeName` failed with the following error message: The I/O operation has been aborted because of either a thread exit or an application request.

**Cause**: When you enable remote support, a Windows Remote Management (WinRM) service restart is required to active Just Enough Administration (JEA). During the remote support JEA configuration, the WinRM restarts twice, which might disrupt the PowerShell session to the node.

**Suggested resolutions**: You can choose one of the following options to resolve this error and enable remote support:

- Wait for a few minutes. Repeat step #2 and #3 for each JEA endpoint to reconnect to your machine and enable remote support.
    - After the third run of the enable remote support command, you shouldn’t see any other error. Refer to the output at step #3 for a successful example of the remote support installation.
- Instead of using the remote PowerShell session, you can enable remote support by connecting to each node using [Remote Desktop Protocol](https://support.microsoft.com/en-us/windows/how-to-use-remote-desktop-5fe128d5-8fb1-7a23-3b8a-41e636865e8c) and enabling it.

## Next steps

- Learn about [Azure Arc extension management](../manage/arc-extension-management.md).
- Learn about the [Azure Local remote support Arc extension](../manage/remote-support-arc-extension.md).
