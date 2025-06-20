---
title: Entra ID Graph API retirement
description: Learn how to mitigate the retirement of the Entra ID Graph API.
author: sethmanheim
ms.author: sethm
ms.topic: article
ms.date: 04/15/2025
ms.reviewer: rtiberiu

---

# Microsoft Entra ID Graph API retirement

The Microsoft Entra ID (formerly Azure Active Directory or Azure AD) [Graph API service is being retired](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/important-update-azure-ad-graph-api-retirement/4090534). This retirement is part of a broader effort to streamline the Microsoft Entra ID platform and improve the Microsoft Entra ID developer experience.

## Mitigation steps

The Graph API retirement affects all Azure Stack Hub customers that use Entra ID as the identity provider, and requires you to run the script included in this article for all impacted applications. If you have applications that need continued access to the Graph APIs, the script sets a flag that configures these applications for an extension that allows these specific applications to continue calling the legacy Graph API.

The PowerShell script provided in this article sets a flag for each application to configure the Graph API extension for each Entra ID identity provider of Azure Stack Hub.

To ensure that your Azure Stack Hub environments that use Entra ID as an identity provider continue functioning, you should run this script by the end of February 2025.

> [!NOTE]  
> If you delay adding this flag beyond February 2025, authentication will fail. You can then run this script to ensure your Azure Stack Hub functions as needed.

## Run the script

Run the following PowerShell script in your Entra ID environment that's used by Azure Stack Hub as the *home directory* (the main identity provider of your Azure Stack Hub), as well as the Entra ID environment to which you registered your Azure Stack Hub system. This might be a different directory than your home directory. The script interacts with Azure, so you don't need to run it on a specific machine. However, you need at least **application administrator** privileges in the respective Entra ID tenant to run the script.

Make sure to run the following script with administrator privileges on the local machine:

```powershell
# Install the Graph modules if necessary
#Install-Module Microsoft.Graph.Authentication
#Install-Module Microsoft.Graph.Applications
 
$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Applications
 
# Target your Azure Cloud instance name; use Get-MgEnvironment to list available clouds and Add-MgEnvironment to add new ones as needed for custom private/secure clouds
$envName = 'Global'

# Repeat this flow for each of your target directory tenants
$tenantId = 'MyTenantId'

# Sign in with admin permissions to read and write all application objects
Connect-MgGraph -Environment $envName -TenantId $tenantId -Scopes Application.ReadWrite.All
 
# Retrieve all applications in the current directory
Write-Host "Looking-up all applications in directory '$tenantId'..."
$applications = Get-MgApplication -All -Property id, displayName, appId, identifierUris, requiredResourceAccess, authenticationBehaviors
Write-Host "Found '$($applications.Count)' total applications in directory '$tenantId'"
 
# Find all the unique deployment GUIDs, each one representing an Azure Stack deployment or registration in the current directory
$deploymentGuids = $applications.IdentifierUris |
    Where-Object { $_ -like 'https://management.*' -or $_ -like 'https://adminmanagement.*' -or $_ -like 'https://azurebridge*' } |
    ForEach-Object { "$_".Split('/')[3] } |
    Select-Object -Unique
Write-Host "Found '$($deploymentGuids.Count)' total Azure Stack deployments or registrations in directory '$tenantId'"
 
# Find all the Azure Stack application objects for each deployment or registration
$azureStackApplications = @()
foreach ($application in $applications)
{
    foreach ($deploymentGuid in $deploymentGuids)
    {
        if (($application.IdentifierUris -join '') -like "*$deploymentGuid*")
        {
            $azureStackApplications += $application
            break
        }
    }
}
 
# Find which Azure Stack applications require access to the legacy Graph Service
$azureStackLegacyGraphApplications = $azureStackApplications |
    Where-Object {
        ($_.RequiredResourceAccess.ResourceAppId -contains '00000002-0000-0000-c000-000000000000') -or
        ($_.IdentifierUris | Where-Object { $_ -like 'https://azurebridge*' }) }
 
# Find which of those applications need to have their authentication behaviors patched to allow access to legacy Graph
$azureStackLegacyGraphApplicationsToUpdate = $azureStackLegacyGraphApplications | Where-Object {
    $oldLocationSet = $false -eq $_.AdditionalProperties.authenticationBehaviors.blockAzureADGraphAccess
    $newLocationNotSet = $false -eq $_.AuthenticationBehaviors.BlockAzureAdGraphAccess
    return (-not $oldLocationSet -and -not $newLocationNotSet)
}
 
# Update the applications that require their authentication behaviors patched to allow access to legacy Graph
Write-Host "Found '$($azureStackLegacyGraphApplicationsToUpdate.Count)' total Azure Stack applications which need permission to continue calling Legacy Microsoft Graph Service"
$count = 0
foreach ($application in $azureStackLegacyGraphApplicationsToUpdate)
{
    $count++
    Write-Host "$count/$($azureStackLegacyGraphApplicationsToUpdate.Count) - Updating application '$($application.DisplayName)' (appId=$($application.AppId)) (id=$($application.Id))"
    Update-MgApplication -ApplicationId $application.Id -BodyParameter @{
        authenticationBehaviors = @{ blockAzureADGraphAccess = $false }
    }
}
```

The script displays the following sample output:

```output
Looking-up all applications in directory '<ID>'... 
Found '###' total applications in directory '<ID>'
Found '1' total Azure Stack deployments in directory '<app ID>'
Found '16' total Azure Stack applications which need permission to continue calling Legacy Microsoft Graph Service
1/16 - Updating application 'Azure Stack - AKS' (appId=<app ID>) (id=<ID>)
2/16 - Updating application 'Azure Stack - Hubs' (appId=<app ID>) (id=<ID>)
3/16 - Updating application 'Azure Stack - Portal Administration' (appId=<app ID>) (id=<app>)
4/16 - Updating application 'Azure Stack - RBAC Administration' (appId=<app ID>) (id=ID)
5/16 - Updating application 'Azure Stack - Container Registry' (appId=<app ID>) (id=ID)
6/16 - Updating application 'Azure Stack - RBAC' (appId=<app ID>) (id=ID)
7/16 - Updating application 'Azure Stack - Hubs Administration' (appId=<app ID>) (id=ID)
8/16 - Updating application 'Azure Stack - Deployment Provider' (appId=<app ID>) (id=ID)
9/16 - Updating application 'Azure Stack - Deployment' (appId=<app ID>) (id=ID)
10/16 - Updating application 'Azure Stack - KeyVault' (appId=<app ID>) (id=ID)
11/16 - Updating application 'Azure Stack' (appId=<app ID>) (id=ID)
12/16 - Updating application 'Azure Stack - Administration' (appId=<app ID>) (id=ID)
13/16 - Updating application 'Azure Stack - Policy Administration' (appId=<app ID>) (id=ID)
14/16 - Updating application 'Azure Stack - Policy' (appId=<app ID>) (id=ID)
15/16 - Updating application 'Azure Stack - Portal' (appId=<app ID>) (id=ID)
16/16 - Updating application 'Azure Stack - KeyVault Administration ' (appId=<app ID>) (id=ID) 
```

Run the script a second time to verify that all applications were updated. The script should return the following output if all applications were successfully updated:

```output
Looking-up all applications in directory '<ID>'...
Found '####' total applications in directory '<ID>>'
Found '1' total Azure Stack deployments in directory '<ID>>'
Found '0' total Azure Stack applications which need permission to continue calling Legacy Microsoft Graph Service 
```

The following output from the `Get-MgEnvironment` command shows the default cloud instances that are included when you install the Graph module:

```output
C:\> Get-MgEnvironment

Name     AzureADEndpoint                   GraphEndpoint                           Type    
----     ---------------                   -------------                           ----    
USGovDoD https://login.microsoftonline.us  https://dod-graph.microsoft.us          Built-in
Germany  https://login.microsoftonline.de  https://graph.microsoft.de              Built-in
USGov    https://login.microsoftonline.us  https://graph.microsoft.us              Built-in
China    https://login.chinacloudapi.cn    https://microsoftgraph.chinacloudapi.cn Built-in
Global   https://login.microsoftonline.com https://graph.microsoft.com             Built-in
```

## Next steps

[Azure Stack Hub release notes](release-notes.md)
