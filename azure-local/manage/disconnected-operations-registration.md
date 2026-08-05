---
title: Register Disconnected Operations for Azure Local
description: Learn how to register disconnected operations for Azure Local to ensure compliance with deployment requirements.
ms.topic: how-to
author: haraldfianbakken
ms.author: hafianba
ms.date: 02/23/2026
ms.reviewer: robess
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Register disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article explains how to register disconnected operations for Azure Local after deploying your management cluster with the control plane. Learn how to ensure compliance with Azure Local requirements through proper registration.


## Registration using self-attestation flow

On a machine with internet access, ensure that Azure CLI and Azure PowerShell are installed. 

Copy the provided function from PowerShell.

```powershell
function New-AzureLocalDisconnectedOperationsSelfAttestation {
    <#
    .SYNOPSIS
    Registers your disconnected operations resource using a self-attestation flow.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('AzureCloud', 'AzureUSGovernment')]
        [string]$Cloud,

[Parameter(Mandatory)]
        [string]$SubscriptionId,

[Parameter(Mandatory)]
        [string]$ResourceGroup,

[Parameter(Mandatory)]
        [string]$ResourceName,

[Parameter(Mandatory)]
        [int]$TotalCores,

[Parameter(Mandatory)]
        [int]$DiskSpaceInGb,

[Parameter(Mandatory)]
        [int]$MemoryInGb,

[Parameter(Mandatory)]
        [string]$Oem,

[Parameter(Mandatory)]
        [string]$HardwareSku,

[Parameter(Mandatory)]
        [int]$Nodes,

[Parameter(Mandatory)]
        [string]$VersionAtRegistration,

[Parameter(Mandatory)]
        [string]$SolutionBuilderExtension,

[Parameter(Mandatory)]
        [string]$DeviceId,

[string]$ApiVersion = '2026-03-01-preview',

[switch]$SkipLogin
    )

if (-not $SkipLogin) {
                Connect-AzAccount -EnvironmentName $Cloud -ErrorAction Stop | Out-Null
}

Select-AzSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop | Out-Null

function Get-BearerToken {
                param(
                        [Parameter(Mandatory)]
                        [ValidateSet('AzureCloud', 'AzureUSGovernment')]
                        [string]$CloudEnvironment
                )

$resource = switch ($CloudEnvironment) {
                        'AzureCloud'        { 'https://management.azure.com/' }
                        'AzureUSGovernment' { 'https://management.usgovcloudapi.net/' }
                }

$tokenResponse = Get-AzAccessToken -ResourceUrl $resource -ErrorAction Stop
                $token = $tokenResponse.Token
                if ($token -is [System.Security.SecureString]) {
                        $plainTextToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($token))
                } else {
                        $plainTextToken = $token
                }
                return "Bearer $plainTextToken"
        }

$baseEndpoint = switch ($Cloud) {
        'AzureCloud'         { 'management.azure.com' }
        'AzureUSGovernment'  { 'management.usgovcloudapi.net' }
    }

$token = Get-BearerToken -CloudEnvironment $Cloud
Write-host "Obtained authorization token $token." -ForegroundColor Green
$uri = "https://$baseEndpoint/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.Edge/disconnectedOperations/$ResourceName/hardwareSettings/default?api-version=$ApiVersion"

$body = @{
        properties = @{
            totalCores               = $TotalCores
            diskSpaceInGb            = $DiskSpaceInGb
            memoryInGb               = $MemoryInGb
            oem                      = $Oem
            hardwareSku              = $HardwareSku
            nodes                    = $Nodes
            versionAtRegistration    = $VersionAtRegistration
            solutionBuilderExtension = $SolutionBuilderExtension
            deviceId                 = $DeviceId
        }
    } | ConvertTo-Json -Depth 5

Write-Host "Creating HardwareSetting for '$ResourceName'..." -ForegroundColor Cyan
    Write-Host "  PUT $uri" -ForegroundColor DarkGray

$response = Invoke-RestMethod -Method Put -Uri $uri -Headers @{
        'Authorization' = $token
        'Content-Type' = 'application/json'
    } -Body $body

Write-Host "HardwareSetting created successfully." -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
}
``` 

## Register your Azure Local disconnected operations 

```powershell
# Modify these to fit your disconnected operations resource. You can find the DeviceId by running the Get-ApplianceInstanceConfiguration on your deployed environment. This should be a guid.
$params = @{
    Cloud                      = 'AzureCloud'
    SubscriptionId             = ''
    ResourceGroup              = ''
    ResourceName               = ''
    TotalCores                 = 320  # Total cores managed by Azure Local disconnected operations
    Nodes                      = 10   # Total number of nodes managed
    DiskSpaceInGb              = 2000 # Management cluster total disk capacity
    MemoryInGb                 = 2000 # Total memory mangement cluster
    Oem                        = ''   # Management cluster OEM - E.g. Dell / Lenovo / HPE etc.
    HardwareSku                = ''   # Management cluster OEM - E.g. AX-760 / MX 655
    VersionAtRegistration      = '2602.2.32510'
    SolutionBuilderExtension   = 'x.y.z'
    DeviceId                   = ''   # Copy your device id from portal
    ApiVersion                 = '2026-03-01-preview'
}

New-AzureLocalDisconnectedOperationsSelfAttestation @params
```
After successful registration, the message 'Hardware setting created successfully' appears. The banner in the Azure portal also disappears, and the hardware properties for your Azure Local disconnected operations populate with the registered information.

## Related content

- [About updates for disconnected operations](./disconnected-operations-update.md).
- [Backup for disconnected operations for Azure Local](./disconnected-operations-back-up-restore.md).

::: moniker-end

::: moniker range="<=azloc-2601"

This feature is available only in Azure Local 2602 or later.

::: moniker-end
