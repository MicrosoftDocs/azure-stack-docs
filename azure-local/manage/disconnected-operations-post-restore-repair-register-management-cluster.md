---
title: Re-register a Management or Data Cluster After a Disconnected Operations Restore
description: Learn how to re-register the management cluster or data cluster created post backup on a restored Azure Local disconnected operations node by re-running Arc initialization, assigning roles, creating the cluster resource, and repairing registration.
author: anupam8995
ms.author: kumaranupam
ms.date: 09/02/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Re-register a management or data cluster after a disconnected operations restore

::: moniker range=">=azloc-2603"

> [!IMPORTANT]
> For management cluster restore, this article applies only to re-registering the management cluster on an instance where you initiated restore after cloud deployment. If you initiated restore before cloud deployment, you can deploy the management cluster as in regular setup scenario.

> [!IMPORTANT]
> For data cluster created before backup was taken, follow [reconnect data cluster](disconnected-operations-post-restore-reconnect-cluster.md). For data cluster created post backup re-registration, check [datacluster post backup recovery](disconnected-operations-post-restore-recover-data-cluster-created-post-backup.md).

This article describes how to re-register

* Management cluster on a restored Azure Local disconnected operations node after a [restore **post cloud deployment** for disconnected operations](disconnected-operations-restore.md). During a restore on a setup where Azure Local instance is deployed, the management cluster of the newly setup restore node is deleted and replaced by the management cluster from the backup, which no longer exists. Use this procedure to recover the management cluster on the restored disconnected operations for Azure Local environment.

* Data cluster that you created and registered post backup, implying that the physical resources exist but the restored disconnected operations for Azure Local VM no longer has knowledge of its existence.

::: moniker-end

::: moniker range=">=azloc-2609"

## Automated recovery

Use the post-restore recovery module from the Operations module package to automate re-registration.

Open an administrator PowerShell session on any node of the cluster and import the module. The commands prompt before they configure CredSSP. The `management-cluster` command also discovers and prompts before it removes stray backup management-cluster resources.

### `Invoke-ApplianceManagementClusterReRegistration`

To re-register a management cluster, run the following command:

```powershell
$operationsModulePath = "C:\AzureLocal\OperationsModule"
Import-Module "$operationsModulePath\Azure.Local.DisconnectedOperations.PostRestoreRecovery.psm1" -Force

Invoke-ApplianceManagementClusterReRegistration `
    -SubscriptionId "00000000-0000-0000-0000-000000000000" `
    -ResourceGroup "example-resource-group" `
    -AccountId "admin@contoso.com" `
    -TenantId "00000000-0000-0000-0000-000000000000" `
    -PublicCertificatePath "C:\Temp\PublicCertificate.cer" `
    -CloudName "Azure.Local" `
    -Region "autonomous"
```

#### Parameters

The following table describes the parameters for `Invoke-ApplianceManagementClusterReRegistration`:

| Parameter | Description | Type | Required |
|---|---|---|---|
| **ClusterNodeName** | Name of the cluster node on which the command runs. The default is the current computer. | String | No |
| **ClusterName** | Name of the Azure Local cluster resource to recreate. When omitted, the command discovers the name from deployment data. | String | No |
| **NodeNames** | Cluster node names. When omitted, the command discovers the nodes from deployment data. | String array | No |
| **SubscriptionId** | Subscription ID of the restored environment. | String | Yes |
| **ResourceGroup** | Resource group name for the cluster. | String | Yes |
| **Region** | Region name of the disconnected environment. The default is `autonomous`. | String | No |
| **CloudName** | Name of the disconnected cloud. The default is `Azure.Local`. | String | No |
| **AccountId** | Account user principal name (UPN) used for registration. | String | Yes |
| **TenantId** | Tenant ID of the Operator subscription. | String | Yes |
| **PublicCertificatePath** | Full path to the backup public root certificate (`.cer`) used to recreate ARB. | String | Yes |
| **ControlPlaneGroupName** | Name of the control plane cluster group. When omitted, the command discovers the group whose name contains `control-plane`. | String | No |
| **AppliancePath** | Path to the Arc appliance working directory. The default is `C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\MocArb\WorkingDirectory\Appliance`. | String | No |
| **ArmAccessToken** | ARM access token. When omitted, the command acquires a token from the connected Az PowerShell context. | SecureString | No |
| **DomainFqdn** | Active Directory domain FQDN used to configure CredSSP. When omitted, the command discovers it from deployment data. | String | No |
| **Credential** | Credentials for remote sessions to cluster nodes. When omitted, the command uses the current session credentials. | PSCredential | No |
| **SkipStrayResourceDeletion** | Skips discovery and deletion of stray backup management-cluster resources. | Switch | No |
| **Force** | Skips the interactive prompts to configure CredSSP and delete stray backup management-cluster resources. | Switch | No |

The command discovers the cluster and node names from deployment data, ensures that required roles are assigned, repairs cluster registration, reconnects any cluster node whose Azure Connected Machine agent isn't connected, and recreates the Arc Resource Bridge (ARB) and associated resources.

### `Invoke-ApplianceDataClusterReRegistration`

For a data cluster that you created after the backup, first complete the reconnection procedure on the DVM, and then run the following command on any cluster node:

```powershell
$operationsModulePath = "C:\AzureLocal\OperationsModule"
Import-Module "$operationsModulePath\Azure.Local.DisconnectedOperations.PostRestoreRecovery.psm1" -Force

Invoke-ApplianceDataClusterReRegistration `
    -SubscriptionId "00000000-0000-0000-0000-000000000000" `
    -ResourceGroup "example-resource-group" `
    -AccountId "admin@contoso.com" `
    -TenantId "00000000-0000-0000-0000-000000000000" `
    -PublicCertificatePath "C:\Temp\PublicCertificate.cer" `
    -CloudName "Azure.Local" `
    -Region "autonomous"
```

#### Parameters

The following table describes the parameters for `Invoke-ApplianceDataClusterReRegistration`:

| Parameter | Description | Type | Required |
|---|---|---|---|
| **ClusterNodeName** | Name of the cluster node on which the command runs. The default is the current computer. | String | No |
| **ClusterName** | Name of the Azure Local cluster resource to recreate. When omitted, the command discovers the name from deployment data. | String | No |
| **NodeNames** | Cluster node names. When omitted, the command discovers the nodes from deployment data. | String array | No |
| **SubscriptionId** | Subscription ID of the restored environment. | String | Yes |
| **ResourceGroup** | Resource group name for the cluster. | String | Yes |
| **Region** | Region name of the disconnected environment. The default is `autonomous`. | String | No |
| **CloudName** | Name of the disconnected cloud. The default is `Azure.Local`. | String | No |
| **AccountId** | Account user principal name (UPN) used for registration. | String | Yes |
| **TenantId** | Tenant ID of the Operator subscription. | String | Yes |
| **PublicCertificatePath** | Full path to the backup public root certificate (`.cer`) used to recreate ARB. | String | Yes |
| **ControlPlaneGroupName** | Name of the control plane cluster group. When omitted, the command discovers the group whose name contains `control-plane`. | String | No |
| **AppliancePath** | Path to the Arc appliance working directory. The default is `C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\MocArb\WorkingDirectory\Appliance`. | String | No |
| **ArmAccessToken** | ARM access token. When omitted, the command acquires a token from the connected Az PowerShell context. | SecureString | No |
| **DomainFqdn** | Active Directory domain FQDN used to configure CredSSP. When omitted, the command discovers it from deployment data. | String | No |
| **Credential** | Credentials for remote sessions to cluster nodes. When omitted, the command uses the current session credentials. | PSCredential | No |
| **Force** | Skips the interactive prompt to configure CredSSP. | Switch | No |

The command discovers the cluster and node names from deployment data, ensures that required roles are assigned, repairs cluster registration, and recreates the ARB and associated resources.

::: moniker-end

::: moniker range=">=azloc-2603 <azloc-2609"

> [!NOTE]
> Automated recovery is available in Azure Local 2609 and later. If your Azure Local disconnected operations version is earlier than 2609, follow the manual steps in this article.

> [!NOTE]
> For the manual procedure, complete [Reconnect Azure Arc on cluster machines after a disconnected operations restore](disconnected-operations-post-restore-reconnect-arc.md) on each cluster machine. That article covers the prerequisite work that this procedure builds on, including copying and importing the management certificates from the seed node, reinstalling the Azure Connected Machine agent, and running Azure Local Arc initialization against the restored environment.

## Prerequisites

Before you start, complete these prerequisites:

- **Restore complete**: The [restore operation](disconnected-operations-restore.md) for your Azure Local disconnected environment finishes successfully.
- **Delete backup management cluster resources in portal (not applicable for data cluster re-registration)** - Delete ARC machines, cluster, lnet, custom location, and Azure Arc resource bridge (ARB) for the backup management cluster. These resources are phantom resources as no on-prem connection exists for these resources with backup machine being considered unavailable in this scenario.
- **Azure Arc reconnected on cluster machines**: You complete [Reconnect Azure Arc on cluster machines after a disconnected operations restore](disconnected-operations-post-restore-reconnect-arc.md) for each cluster machine.
- **Operator access**: Your identity has the required OperatorRP RBAC role in the Operator subscription. For more information, see [Operator subscription and RBAC permissions](disconnected-operations-identity.md).
- **Seed node access**: You have administrative access to the seed node. The certificates and dependencies are located under `C:\ProgramData\Microsoft\aldodependencies` on the seed node, and you can reach them through the administrative share, for example, `\\$seedNode\c$\ProgramData\Microsoft\aldodependencies`.
- **Environment values**: You have the following values for the restored environment:

  | Placeholder | Description | Example |
  |---|---|---|
  | `$seedNode` | Computer name of the seed node | `<seed-node-name>` |
  | `$node` | Computer name of the cluster node you're operating on | `<cluster-node-name>` |
  | `$cluster` | Name of the Azure Local cluster resource | `<cluster-resource-name>` |
  | `<DomainFqdn>` | Active Directory domain FQDN of the cluster | `<domain>.example.com` |
  | `<CloudFqdn>` | Cloud FQDN of the disconnected environment | `autonomous.contoso.private` |
  | `<AccountID>` | Account UPN to use for sign-in | `admin@contoso.com` |
  | `<TenantID>` | Tenant ID of the Operator subscription | |
  | `<SubscriptionID>` | Subscription ID of the Starter subscription | |
  | `<ResourceGroup>` | Resource group name for the cluster | `example-resource-group` |
  | `<Region>` | Region name of the disconnected environment | `autonomous` |
  | `<CloudName>` | Cloud name registered in Azure PowerShell and CLI | `Azure.Local` |
  | `<PfxPassword>` | Password for `ManagementEndpointClientAuth.pfx` | |

## Overview of the re-registration workflow

After you complete the [Arc reconnection prerequisite](disconnected-operations-post-restore-reconnect-arc.md) on each cluster machine, follow these steps to re-register the management cluster and data cluster that you created after backup on the restored node:

> [!IMPORTANT]
> Run all the following steps on the seed node.

1. Define PowerShell variables, enable CredSSP, and open a CredSSP session to the seed node.
1. Configure the Azure CLI to trust the disconnected environment and sign in.
1. Assign required roles to each node's managed identity.
1. Create the Azure Local cluster resource through the ARM REST API.
1. Run `Register-AzStackHCI` with `-RepairRegistration` in the CredSSP session.

## Step 1: Define variables, enable CredSSP, and open a CredSSP session

Define PowerShell variables for the seed node, the target node, and the cluster. The remaining steps reference these variables. Then enable CredSSP on the seed node and on the management machine, and open a CredSSP session to the seed node that you use for the subsequent steps.

1. From a remote PowerShell session into the seed node, enable CredSSP as the server role:

    ```powershell
    Enable-WSManCredSSP -Role Server -Force
    ```

1. On the management machine, enable client-side CredSSP and configure credential delegation through Group Policy registry keys:

    ```powershell
    # Enable client-side CredSSP
    Enable-WSManCredSSP -Role Client -DelegateComputer "$seedNode.<DomainFqdn>" -Force

    # Set GPO registry keys for credential delegation
    $key = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation"
    New-Item -Path "$key\AllowFreshCredentials" -Force | Out-Null
    New-ItemProperty -Path $key -Name "AllowFreshCredentials" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path "$key\AllowFreshCredentials" -Name "1" -Value "WSMAN/*.<DomainFqdn>" -PropertyType String -Force
    New-ItemProperty -Path "$key\AllowFreshCredentials" -Name "2" -Value "WSMAN/$seedNode" -PropertyType String -Force

    # Refresh Group Policy
    gpupdate /force
    ```

1. Open a new CredSSP session to the seed node. Run all subsequent steps in this session.

    ```powershell
    Enter-PSSession -ComputerName $seedNode -Authentication CredSSP -Credential (Get-Credential)
    ```

1. In the CredSSP session, redefine the variables from substep 1 so that they're available for the remaining steps:

    ```powershell
    $seedNode = "<SeedNodeName>"
    $node     = "<NodeName>"
    $cluster  = "<ClusterName>"
    ```

## Step 2: Configure the Azure CLI to trust the disconnected environment

Append the public root certificate to the Python certificate store that the Azure CLI uses, and then register the cloud and sign in.

```powershell
$cerFile = "C:\PublicRootCertificate.cer"
$pythonCertStore = "\\$seedNode\c`$\Program Files (x86)\Microsoft SDKs\Azure\CLI2\Lib\site-packages\certify\cacert.pem"

$root = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new()
$root.Import($cerFile)

$md5Hash    = (Get-FileHash -Path $cerFile -Algorithm MD5).Hash.ToLower()
$sha1Hash   = (Get-FileHash -Path $cerFile -Algorithm SHA1).Hash.ToLower()
$sha256Hash = (Get-FileHash -Path $cerFile -Algorithm SHA256).Hash.ToLower()

$issuerEntry  = [string]::Format("# Issuer: {0}", $root.Issuer)
$subjectEntry = [string]::Format("# Subject: {0}", $root.Subject)
$labelEntry   = [string]::Format("# Label: {0}", $root.Subject.Split('=')[-1])
$serialEntry  = [string]::Format("# Serial: {0}", $root.GetSerialNumberString().ToLower())
$md5Entry     = [string]::Format("# MD5 Fingerprint: {0}", $md5Hash)
$sha1Entry    = [string]::Format("# SHA1 Fingerprint: {0}", $sha1Hash)
$sha256Entry  = [string]::Format("# SHA256 Fingerprint: {0}", $sha256Hash)

$certText = (Get-Content -Path $cerFile -Raw).ToString().Replace("`r`n","`n")

$rootCertEntry = "`n" + $issuerEntry + "`n" + $subjectEntry + "`n" + $labelEntry + "`n" + $serialEntry + "`n" + $md5Entry + "`n" + $sha1Entry + "`n" + $sha256Entry + "`n" + $certText

Add-Content $pythonCertStore $rootCertEntry
```

Register and configure the cloud, and then sign in:

```powershell
az cloud register --name <CloudName> --endpoint-resource-manager https://armmanagement.<CloudFqdn>
az cloud update --name <CloudName> --endpoint-active-directory "https://login.<CloudFqdn>/adfs"

az login --use-device-code
```

## Step 3: Assign required roles to each node's managed identity

For each cluster node, retrieve the Connected Machine principal ID and assign the required roles on the resource group.

1. Get the principal ID for each node:

    ```powershell
    az connectedmachine show `
        --name $node `
        --resource-group <ResourceGroup> `
        --query "identity.principalId" -o tsv
    ```

1. For every node, assign the following roles. Replace `<PrincipalId>` with the principal ID from the previous command:

    ```powershell
    az role assignment create `
        --assignee-object-id <PrincipalId> `
        --assignee-principal-type ServicePrincipal `
        --role "Azure Stack HCI Connected InfraVMs" `
        --scope /subscriptions/<SubscriptionID>/resourceGroups/<ResourceGroup>

    az role assignment create `
        --assignee-object-id <PrincipalId> `
        --assignee-principal-type ServicePrincipal `
        --role "Azure Stack HCI Device Management Role" `
        --scope /subscriptions/<SubscriptionID>/resourceGroups/<ResourceGroup>

    az role assignment create `
        --assignee-object-id <PrincipalId> `
        --assignee-principal-type ServicePrincipal `
        --role "Azure Connected Machine Resource Manager" `
        --scope /subscriptions/<SubscriptionID>/resourceGroups/<ResourceGroup>
    ```

## Step 4: Create the Azure Local cluster resource

Acquire an access token for the management ARM endpoint and create the cluster resource by using the ARM REST API.

```powershell
$token = (Get-AzAccessToken -ResourceUrl "https://armmanagement.<CloudFqdn>").Token
$ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
$accessTokenAsString = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)

$clusterPayload = @{
    "Location" = "<Region>"
}

$jsonPayload = $clusterPayload | ConvertTo-Json

Invoke-AzRestMethod -Method PUT `
    -Path "/subscriptions/<SubscriptionID>/resourceGroups/<ResourceGroup>/providers/Microsoft.AzureStackHCI/clusters/$cluster`?api-version=2026-02-15-preview" `
    -Payload $jsonPayload
```

The following example shows the expected output.

```powershell
[ASRR1N22R15U27]: PS C:\ImageComposition\ArcAgent\content> Invoke-AzRestMethod -Method PUT -Path "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.AzureStackHCI/clusters/example-cluster?api-version=2026-02-15-preview" -Payload $jsonPayload

StatusCode : 200
Content    : {
               "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resource-group/providers/Microsoft.AzureStackHCI/clusters/example-cluster",
               "name": "example-resource-name",
               "type": "microsoft.azurestackhci/clusters",
               "location": "autonomous",
               "systemData": {
                   "createdBy": "user@contoso.com",
                   "createdByType": "User",
                   "createdAt": "2026-05-22T04:38:58.7369739Z",
                   "lastModifiedBy": "user@contoso.com",
                   "lastModifiedByType": "User",
                   "lastModifiedAt": "2026-05-22T04:38:58.7369739Z"
               },
               "properties": {
                   "provisioningState": "Succeeded",
                   "status": "NotYetRegistered",
                   "connectivityStatus": "NotYetRegistered",
                   "cloudId": "00000000-0000-0000-0000-000000000000",
                   "softwareAssuranceProperties": {
                       "softwareAssuranceStatus": "Disabled",
                       "softwareAssuranceIntent": "Disable"
                   },
                   "remoteSupportProperties": {
                       "accessLevel": "None",
                       "remoteSupportType": "Revoke",
                       "remoteSupportProvisioningState": "None",
                       "remoteSupportNodeSettings": [
                           {
                               "state": "Expired",
                               "createdAt": "0001-01-01T00:00:00",
                               "updatedAt": "0001-01-01T00:00:00",
                               "provisionStatus": "Disconnected"
...
```

## Step 5: Repair the cluster registration over CredSSP

In the CredSSP session that you opened in [Step 1](#step-1-define-variables-enable-credssp-and-open-a-credssp-session), add the Azure environment, sign in, and run `Register-AzStackHCI` with `-RepairRegistration`.

1. Add the Azure environment, sign in, and capture the access token:

    ```powershell
    Add-AzEnvironment -Name "<CloudName>" -ARMEndpoint "https://armmanagement.<CloudFqdn>"
    Connect-AzAccount -DeviceCode -Environment "<CloudName>"

    $token = (Get-AzAccessToken -ResourceUrl "https://armmanagement.<CloudFqdn>").Token
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
    $accessTokenAsString = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr)
    ```

1. Run `Register-AzStackHCI` with `-RepairRegistration`:

    ```powershell
    Register-AzStackHCI `
        -SubscriptionId "<SubscriptionID>" `
        -ResourceGroupName "<ResourceGroup>" `
        -EnvironmentName "<CloudName>" `
        -TenantId "<TenantID>" `
        -Region "<Region>" `
        -RepairRegistration `
        -AccountId "<AccountID>" `
        -ArmAccessToken $accessTokenAsString `
        -ComputerName $seedNode `
        -Verbose
    ```

The following example shows the expected output.

```powershell
VERBOSE: Checking solution deployment status.
VERBOSE: Populating RepositorySourceLocation property for module PackageManagement.
VERBOSE: Loading module from path
'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.4.8.1\PackageManagement.psm1'.

VERBOSE: Loading module from path
'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.4.8.1\PackageManagement.psd1'.

VERBOSE: Loading 'FormatsToProcess' from path
'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.4.8.1\PackageManagement.format.ps1xml'.

VERBOSE: Populating RepositorySourceLocation property for module PackageManagement.

VERBOSE: Loading module from path
'C:\Program Files\WindowsPowerShell\Modules\PackageManagement\1.4.8.1\PackageManagement.psm1'.

VERBOSE: Exporting cmdlet 'Find-Package'.
VERBOSE: Exporting cmdlet 'Find-PackageProvider'.
VERBOSE: Exporting cmdlet 'Get-Package'.
VERBOSE: Exporting cmdlet 'Get-PackageProvider'.
VERBOSE: Exporting cmdlet 'Get-PackageSource'.
VERBOSE: Exporting cmdlet 'Import-PackageProvider'.
VERBOSE: Exporting cmdlet 'Install-Package'.
VERBOSE: Exporting cmdlet 'Install-PackageProvider'.
VERBOSE: Exporting cmdlet 'Register-PackageSource'.
VERBOSE: Exporting cmdlet 'Save-Package'.
VERBOSE: Exporting cmdlet 'Set-PackageSource'.
VERBOSE: Exporting cmdlet 'Uninstall-Package'.
VERBOSE: Exporting cmdlet 'Unregister-PackageSource'.

VERBOSE: Importing cmdlet 'Find-Package'.
VERBOSE: Importing cmdlet 'Find-PackageProvider'.
...
```

After `Register-AzStackHCI` completes successfully, the management cluster is re-registered on the restored disconnected operations for Azure Local environment.

```powershell
VERBOSE: Cloud Deployment detected via registry key
VERBOSE: Attempting version check on localhost
VERBOSE: Checking version on localhost
VERBOSE: Negotiated version : Version5_0

VERBOSE: LocalHost call detected. Negotiated version Version5_0 overridden
to Version3_0 to use direct endpoint and avoid bridge.

VERBOSE: Successfully scheduled a sync with Azure.

VERBOSE: The nodes are already arc enabled for cloud deployment,
so skipping arc for server registration.

VERBOSE: Verifying Arc node linkage to cluster...
VERBOSE: Node01 is correctly attached to cluster (attempt 1).
VERBOSE: Node02 is correctly attached to cluster (attempt 1).

All nodes successfully verified as linked to the cluster.
VERBOSE: All nodes verified as linked to the cluster.

ClusterAgentStatus   : Success
Result               : Success

AzurePortalResourceURL :
https://portal.contoso.private#@00000000-0000-0000-0000-000000000000/...
.../subscriptions/00000000-0000-0000-0000-000000000000/
resourceGroups/example-resource-group/
providers/Microsoft.AzureStackHCI/clusters/example-cluster/overview

AzureResourceId :
/subscriptions/00000000-0000-0000-0000-000000000000/
resourceGroups/example-resource-group/
providers/Microsoft.AzureStackHCI/clusters/example-cluster

Details :
Azure Stack HCI is successfully registered.
An Azure resource representing Azure Stack HCI has been created in your
Azure subscription to enable an Azure-consistent monitoring, billing,
and support experience.

VERBOSE: Connecting from management
```

## Next step

After the management cluster (or data cluster created post backup) is re-registered, recreate the Azure Arc resource bridge (ARB), custom location, logical network, and storage resources for the cluster.

> [!div class="nextstepaction"]
> [Recover Azure Arc resource bridge and associated resources after a restore and cluster re-registration](disconnected-operations-post-restore-recover-azure-resource-bridge-resources.md)

## Related content

* [Restore for disconnected operations for Azure Local](disconnected-operations-restore.md)
* [Reconnect a data cluster after a disconnected operations restore](disconnected-operations-post-restore-reconnect-cluster.md)
* [Reconnect Azure Arc on cluster machines after a disconnected operations restore](disconnected-operations-post-restore-reconnect-arc.md)
* [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2602&preserve-view=true)

::: moniker-end

::: moniker range="<=azloc-2602"

This feature is available only in Azure Local 2603 or later.

::: moniker-end
