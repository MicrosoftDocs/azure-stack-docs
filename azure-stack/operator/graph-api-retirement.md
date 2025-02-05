---
title: Entra ID Graph API retirement
description: Learn how to mitigate the retirement of the Entra ID Graph API.
author: sethmanheim
ms.author: sethm
ms.topic: conceptual
ms.date: 02/05/2025
ms.reviewer: rtiberiu

---

# Microsoft Entra ID Graph API retirement

The Microsoft Entra ID (formerly Azure Active Directory or Azure AD) [Graph API service is being retired](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/important-update-azure-ad-graph-api-retirement/4090534). This retirement is part of a broader effort to streamline the Microsoft Entra ID platform and improve the Microsoft Entra ID developer experience.

## Mitigation steps

The Graph API retirement affects all Azure Stack Hub customers, and requires you to run the script included in this article for all impacted applications. If you have applications that need continued access to the Graph APIs, the script sets a flag that configures these applications for an extension that allows these specific applications to continue calling the legacy Graph API until June 2025.

The PowerShell script provided in this article sets a flag for each application to configure the Graph API extension for your connected Azure Stack environments.

To ensure that your connected Azure Stack environments continue functioning through the June cutoff date and beyond, you should run this script by the end of February 2025.

## Run the script

Run the following PowerShell script in your Azure Stack Hub environment to configure the Graph API extension. You can run the script after your environment is deployed. The script interacts with Azure, so you don't need to run it on a specific machine. However, you need administrator privileges to run the script, and you must run it in each of your directory tenants.

Make sure to run the following script with administrator privileges:

```powershell
# Install the graph modules if necessary
#Install-Module Microsoft.Graph.Authentication
#Install-Module Microsoft.Graph.Applications
 
$ErrorActionPreference='Stop'
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Applications
 
# Repeat this flow for each of your target directory tenants
$tenantId = 'MyTenantId'
 
# Sign-in with admin permissions to read and write all application objects
Connect-MgGraph -TenantId $tenantId -Scopes Application.ReadWrite.All
 
# Retrieve all applications in the current directory
Write-Host "Looking-up all applications in directory '$tenantId'..."
$applications = Get-MgApplication -All -Property id, displayName, appId, identifierUris, requiredResourceAccess, authenticationBehaviors
Write-Host "Found '$($applications.Count)' total applications in directory '$tenantId'"
 
# Find all the unique deployment guids, each one representing an Azure Stack deployment in the current directory
$deploymentGuids = $applications.IdentifierUris |
    Where-Object { $_ -like 'https://management.*' -or $_ -like 'https://adminmanagement.*' } |
    ForEach-Object { "$_".Split('/')[3] } |
    Select-Object -Unique
Write-Host "Found '$($deploymentGuids.Count)' total Azure Stack deployments in directory '$tenantId'"
 
# Find all the Azure Stack application objects for each deployment
$azureStackApplications = @()
foreach ($application in $applications)
{
    foreach ($deploymentGuid in $deploymentGuids)
    {
        if (($application.IdentifierUris -join '') -like "*$deploymentGuid*")
        {
            $azureStackApplications += $application
        }
    }
}
 
# Find which Azure Stack applications require access to Legacy Graph Service
$azureStackLegacyGraphApplications = $azureStackApplications |
    Where-Object { $_.RequiredResourceAccess.ResourceAppId -contains '00000002-0000-0000-c000-000000000000' }
 
# Find which of those applications need to have their authentication behaviors patched to allow access to Legacy Graph
$azureStackLegacyGraphApplicationsToUpdate = $azureStackLegacyGraphApplications |
    Where-Object { -not ($ab = $_.AdditionalProperties.authenticationBehaviors) -or -not $ab.ContainsKey(($key='blockAzureADGraphAccess')) -or $ab[$key] }
 
# Update the applications which require their authentication behaviors patched to allow access to Legacy Graph
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
Found '3164' total applications in directory '<ID>'
Found '102' total Azure Stack deployments in directory '<app ID>'
Found '14' total Azure Stack applications which need permission to continue calling Legacy Microsoft Graph Service
1/14 - Updating application 'Azure Stack - AKS' (appId=<app ID>) (id=<ID>)
2/14 - Updating application 'Azure Stack - Hubs' (appId=<app ID>) (id=<ID>)
3/14 - Updating application 'Azure Stack - Portal Administration' (appId=<app ID>) (id=<app>)
4/14 - Updating application 'Azure Stack - RBAC Administration' (appId=<app ID>) (id=ID)
5/14 - Updating application 'Azure Stack - Container Registry' (appId=<app ID>) (id=ID)
6/14 - Updating application 'Azure Stack - RBAC' (appId=<app ID>) (id=ID)
7/14 - Updating application 'Azure Stack - Hubs Administration' (appId=<app ID>) (id=ID)
8/14 - Updating application 'Azure Stack - Deployment Provider' (appId=<app ID>) (id=ID)
9/14 - Updating application 'Azure Stack - Deployment' (appId=<app ID>) (id=ID)
10/14 - Updating application 'Azure Stack - KeyVault' (appId=<app ID>) (id=ID)
11/14 - Updating application 'Azure Stack' (appId=<app ID>) (id=ID)
12/14 - Updating application 'Azure Stack - Administration' (appId=<app ID>) (id=ID)
13/14 - Updating application 'Azure Stack - Policy Administration' (appId=<app ID>) (id=ID)
14/14 - Updating application 'Azure Stack - Policy' (appId=<app ID>) (id=ID) 
```

Run the script a second time to verify that all applications were updated. The script should return the following output if all applications were successfully updated:

```output
Looking-up all applications in directory '<ID>'...
Found '3164' total applications in directory '<ID>>'
Found '102' total Azure Stack deployments in directory '<ID>>'
Found '0' total Azure Stack applications which need permission to continue calling Legacy Microsoft Graph Service 
```

## Next steps

[Azure Stack Hub release notes](release-notes.md)
