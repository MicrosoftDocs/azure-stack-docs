---
title: Reconnect Azure Arc on Cluster Machines After Disconnected Operations Restore
description: Learn how to reconnect Azure Arc on workload and management cluster machines after an Azure Local disconnected operations restore by reinstalling the Connected Machine agent and re-running Arc initialization.
author: anupam8995
ms.author: kumaranupam
ms.date: 07/29/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Reconnect Azure Arc on cluster machines after a disconnected operations restore

::: moniker range=">=azloc-2603"

This article describes how to reconnect Azure Arc on workload and management cluster machines after you complete a [restore for disconnected operations](disconnected-operations-restore.md). After a restore, the Azure Connected Machine agent on cluster machines might still hold state from the pre-restore environment and report as disconnected. To reestablish the Arc connection, reinstall the agent, import the trust and client certificates from the seed node, and re-run the Azure Local Arc initialization against the restored environment.

Run this procedure on every workload and management cluster machine that needs to be reconnected to the restored Azure Local disconnected operations environment.

> [!NOTE]
> Automation for the following steps is planned for a future release.

## Prerequisites

Before you start, complete these prerequisites:

- **Restore complete**: The [restore operation](disconnected-operations-restore.md) for your Azure Local disconnected environment finishes successfully.
- **Azure Connected Machine agent installer**: You have access to the `AzureConnectedMachineAgent.msi` installer on the target machine.
- **Certificates from the seed node**: You copied the ingress certificate authority (CA) certificate and the management client certificate from `C:\ProgramData\Microsoft\aldodependencies` on the seed node to the target machine (for example, to `C:\Temp\`). You also have the password for the `.pfx` file.
- **ARM access token**: You have a valid ARM access token for the Operator subscription that you can pass to `Invoke-AzStackHciArcInitialization`.
- **Operator access**: Your identity has the required OperatorRP RBAC role in the Operator subscription. For more information, see [Operator subscription and RBAC permissions](disconnected-operations-identity.md).
- **Environment values**: You have the following values for the restored environment:
  - Account ID
  - Tenant ID
  - Subscription ID
  - Resource group name
  - Region (for example, `autonomous`)
  - Cloud name (for example, `Azure.local`)
  - Cloud fully qualified domain name (FQDN), for example, `armmanagement.contoso.private`

## Overview of the Arc reconnection workflow

To reconnect Azure Arc on a cluster machine, complete these steps in order on the target machine:

1. Reinstall the Azure Connected Machine agent.
1. Import the ingress CA and management client certificates that you copied from the seed node.
1. Remove stale bootstrap state and disconnect the existing Arc agent.
1. Re-run Azure Local Arc initialization against the restored environment.
1. Restart the bootstrap service and re-run Arc initialization to finalize the connection.
1. Verify that the machine reports as connected.

## Step 1: Reinstall the Azure Connected Machine agent

On the target cluster machine, uninstall the existing Azure Connected Machine agent and reinstall it from the local `AzureConnectedMachineAgent.msi` package.

1. Open an administrator PowerShell session.

1. Uninstall the existing agent in `C:\ImageComposition\ArcAgent\content`:

    ```powershell
    msiexec /x "AzureConnectedMachineAgent.msi" /qn
    ```

1. Reinstall the agent and write a verbose log to the current directory:

    ```powershell
    msiexec /i "AzureConnectedMachineAgent.msi" /qn /l*v "./azcmagent_install.log"
    ```

## Step 2: Import certificates from the seed node

Copy the ingress CA certificate from `C:\ProgramData\Microsoft\aldodependencies` on the seed node to the target machine (for example, `C:\Temp\`). Then import it into the local machine certificate store.

```powershell
Import-Certificate -FilePath "C:\Temp\ingressCA.cer" -CertStoreLocation "Cert:\LocalMachine\Root"

Add-AzEnvironment -Name "Azure.Local" -ARMEndpoint "https://armmanagement.contoso.private"
```

The following example shows the expected output of the `Import-Certificate` command.

```powershell
   PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\Root

Thumbprint                                  Subject
----------                                  -------
1234567890ABCDEF1234567890ABCDEF12345678    CN=ContosoRootCert, DC=contoso, DC=local
```

The following example shows the expected output of the `Add-AzEnvironment` command.

```powershell
Name         Resource Manager Url                               ActiveDirectory Authority
----         --------------------                               -------------------------
Azure.Local  https://armmanagement.contoso.private              https://login.armmanagement.contoso.private/
```

## Step 3: Remove stale bootstrap state and disconnect the agent

Remove the existing bootstrap hive file and force the agent to disconnect locally so that it doesn't retain state from the pre-restore environment.

```powershell
Remove-Item -Path C:\windows\system32\bootstrap\bootstraphive.ds
azcmagent disconnect --force-local-only
azcmagent show
```

The `azcmagent show` output should reflect a disconnected state before you proceed, as in the following example.

```powershell
Resource Name                           :
Resource Group Name                     :
Resource Namespace                      :
Resource Id                             :
Subscription ID                         :
Tenant ID                               :
VM ID                                   :
Correlation ID                          :
VM UUID                                 :
Location                                :
Cloud                                   :
Identity Key Store                      :
Agent Version                           : 1.64.03414.2961
Agent Logfile                           : C:\ProgramData\AzureConnectedMachineAgent\Log\himds.log
Agent Status                            : Disconnected
Agent Last Heartbeat                    :
Agent Error Code                        :
Agent Error Details                     :
Agent Error Timestamp                   :
Using HTTPS Proxy                       :
Proxy Bypass List                       :
Upstream Proxy                          :
Gateway URL                             :
Cloud Provider                          : AzSHCI
Cloud Metadata
Manufacturer                            : Dell Inc.
Model                                   : AX-740xd
MSSQL Server Detected                   : false
MySQL Server Detected                   : false
PGSQL Server Detected                   : false
Dependent Service Status
  Agent Service (himds)                 : running
  Azure Arc Proxy (arcproxy)            : running
  Extension Service (extensionservice)  : running
  GC Service (gcarcservice)             : running
  SMS Agent Host (CcmExec)              : unknown
Portal Page                             :
Disabled Features                       : sslendpoint
Agent Auto Upgrade Task Status          : enabled, id: {00000000-0000-0000-0000-000000000000}
```

## Step 4: Run Azure Local Arc initialization

Build the parameter hash table for `Invoke-AzStackHciArcInitialization` with the values for your restored environment, and then run the initialization.

> [!NOTE]
> Replace the placeholder values with the values for your restored environment. The `$token` variable must contain a valid ARM access token for the Operator subscription.

```powershell
Connect-AzAccount -DeviceCode -Environment "Azure.Local"

$accessToken = (Get-AzAccessToken).Token
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($accessToken)
$accessTokenAsString = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)

$hash = @{
    AccountID        = "<AccountID>"
    ArmAccessToken   = $accessTokenAsString
    Cloud            = "<CloudName>"          # for example, "Azure.local"
    ErrorAction      = 'Stop'
    Region           = "<Region>"             # for example, "autonomous"
    ResourceGroup    = "<ResourceGroupName>"
    SubscriptionID   = "<SubscriptionID>"
    TenantID         = "<TenantID>"
    CloudFqdn        = "<CloudFqdn>"          # for example, "armmanagement.contoso.private"
}

Invoke-AzStackHciArcInitialization @hash
azcmagent show
```

The following example shows the expected output.

```powershell
Microsoft image detected.
No target solution version provided. Skipping update.

Starting Arc registration process...
Configuration saved to: C:\Users\username\AppData\Local\Temp\bootstrap.json
Checking for any in progress bootstrap workflow
Triggering bootstrap on the device...
Waiting for bootstrap to complete... Current Status: InProgress

NetworkConfig : NotStarted
RemoteConfig  : NotStarted
WebProxy      : NotStarted
TimeServer    : NotStarted
HostName      : NotStarted

ArcConfiguration : NotStarted
    ArtifactsUpload      : NotStarted
    ConnectivityValidation : NotStarted
    ArcRegistration      : NotStarted
    ArcExtensionInstall  : NotStarted

Waiting for bootstrap to complete... Current Status: InProgress

NetworkConfig : NotStarted
RemoteConfig  : NotStarted
WebProxy      : NotStarted
ArcConfiguration : InProgress
    ArtifactsUpload      : NotApplicable
    ConnectivityValidation : Succeeded
    ArcRegistration      : InProgress
    ArcExtensionInstall  : NotStarted

Waiting for bootstrap to complete... Current Status: InProgress

NetworkConfig : NotApplicable
RemoteConfig  : NotApplicable
WebProxy      : NotApplicable
TimeServer    : NotApplicable
HostName      : NotApplicable

ArcConfiguration : InProgress
    ArtifactsUpload      : NotApplicable
    ConnectivityValidation : Succeeded
    ArcRegistration      : Succeeded
    ArcExtensionInstall  : NotApplicable

Waiting for bootstrap to complete... Current Status: Succeeded

NetworkConfig : NotApplicable
RemoteConfig  : NotApplicable
WebProxy      : NotApplicable
TimeServer    : NotApplicable
HostName      : NotApplicable

ArcConfiguration : Succeeded
    ArtifactsUpload      : NotApplicable
    ConnectivityValidation : Succeeded
    ArcRegistration      : Succeeded
    ArcExtensionInstall  : NotApplicable

Bootstrap succeeded.

Version Response
----------------

V1     Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response
```

## Step 5: Restart the bootstrap service and re-run initialization

Restart the bootstrap service and re-run `Invoke-AzStackHciArcInitialization` to finalize the connection to the restored environment.

```powershell
Stop-Service *bootstrap*
Start-Service *bootstrap*
Invoke-AzStackHciArcInitialization @hash
```

## Step 6: Verify the connection

Confirm that the machine reports as connected:

```powershell
azcmagent show
```

The `Agent Status` field should report `Connected`. The machine should also appear as connected in the portal under the restored environment. The following example shows the expected state.

```powershell
Resource Name                           : example-resource
Resource Group Name                     : example-resource-group
Resource Namespace                      : Microsoft.HybridCompute
Resource Id                             : /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.HybridCompute/machines/example-resource
Subscription ID                         : 00000000-0000-0000-0000-000000000000
Tenant ID                               : 00000000-0000-0000-0000-000000000000
VM ID                                   : 00000000-0000-0000-0000-000000000000
Correlation ID                          : 00000000-0000-0000-0000-000000000000
VM UUID                                 : 00000000-0000-0000-0000-000000000000
Location                                : autonomous
Cloud                                   : AzureStackCloud
Identity Key Store                      : Default
Agent Version                           : 1.64.03414.2961
Agent Logfile                           : C:\ProgramData\AzureConnectedMachineAgent\Log\himds.log
Agent Status                            : Connected
Agent Last Heartbeat                    : 2026-07-24T08:24:15Z
Agent Error Code                        :
Agent Error Details                     :
Agent Error Timestamp                   :
Using HTTPS Proxy                       :
Proxy Bypass List                       :
Upstream Proxy                          :
Gateway URL                             :
Cloud Provider                          : AzSHCI
Cloud Metadata
Manufacturer                            : Dell Inc.
Model                                   : AX-740xd
MSSQL Server Detected                   : false
MySQL Server Detected                   : false
PGSQL Server Detected                   : false
Dependent Service Status
  Agent Service (himds)                 : running
  Azure Arc Proxy (arcproxy)            : running
  Extension Service (extensionservice)  : running
  GC Service (gcarcservice)             : running
  SMS Agent Host (CcmExec)              : unknown
Portal Page                             : https://portal.armmanagement.contoso.private/#@00000000-0000-0000-0000-000000000000/resource/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.HybridCompute/machines/example-resource/overview
Disabled Features                       :
Agent Auto Upgrade Task Status          : enabled, id: {00000000-0000-0000-0000-000000000000}
```

Repeat this procedure on every workload and management cluster machine that needs to be reconnected.

## Next step

After you reconnect Azure Arc on cluster machines, re-register the management cluster on the restored node:

> [!div class="nextstepaction"]
> [Re-register the management cluster on a restored disconnected operations node](disconnected-operations-post-restore-repair-register-management-cluster.md)

## Related content

- [Restore for disconnected operations for Azure Local](disconnected-operations-restore.md)
- [Reconnect a data cluster after a disconnected operations restore](disconnected-operations-post-restore-reconnect-cluster.md)
- [Back up disconnected operations](disconnected-operations-back-up-restore.md)
- [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2602&preserve-view=true)

::: moniker-end

::: moniker range="<=azloc-2602"

This feature is available only in Azure Local 2603 or later.

::: moniker-end
