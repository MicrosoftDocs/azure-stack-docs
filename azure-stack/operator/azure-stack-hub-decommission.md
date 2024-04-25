---
title: Decommission an Azure Stack Hub system
description: Learn how to properly decommission an Azure Stack Hub system. 
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 03/23/2023
ms.custom: template-how-to
---

# Decommission an Azure Stack Hub system

This article describes how to properly decommission an Azure Stack Hub system. Prior to reclaiming the system hardware, follow this procedure to ensure tenant workloads are secured, sensitive information is removed, and the system is unregistered with Azure.

## Prerequisites

Before you begin, ensure that the following prerequisites are met:

- Ensure that all workloads have been removed from the system with appropriate backups.
- It's not necessary that you fully stop or remove all resources (VMs, web apps, etc.) from the system. However, you can stop or remove these resources to manage usage and costs during the decommission process.
- Once the system is permanently shut down, no further usage information is reported.

<a name='connected-azure-ad-scenarios'></a>

## Connected (Microsoft Entra ID) scenarios

Follow these steps in a connected (Microsoft Entra ID) environment:

1. Disable multi-tenancy by removing secondary directories: [Unregister a guest directory](enable-multitenancy.md#unregister-a-guest-directory).
1. Verify any additional guest directories have been removed: [Retrieve identity health report](enable-multitenancy.md#retrieve-azure-stack-hub-identity-health-report).
1. Remove any tenant registrations for usage billing: [Remove a tenant mapping](azure-stack-csp-ref-operations.md#remove-a-tenant-mapping).
1. Remove Azure Stack Hub registration and prevent usage data being pushed to Azure billing.

   1. Follow the steps from [Register Azure Stack Hub](azure-stack-registration.md?pivots=state-connected#renew-or-change-registration) to import the **RegisterWithAzure.psm1** module.
   1. Use the following script to remove the registration resource.

   ```powershell
   # Select the subscription used during the registration (shown in portal) 
   Select-AzSubscription -Subscription '<Registration subscription ID from portal>' 
   
   # Unregister using the parameter values from portal 
   Remove-AzsRegistration -PrivilegedEndpointCredential $YourCloudAdminCredential -PrivilegedEndpoint $YourPrivilegedEndpoint -RegistrationName '<Registration name from portal>' -ResourceGroupName '<Registration resource group from portal>'
   ```

1. Remove Microsoft Entra app registrations for Azure Stack Hub:
   1. [Connect to your Azure Stack environment with Azure PowerShell](azure-stack-powershell-configure-admin.md#connect-with-azure-ad).
   1. In the same PowerShell instance as the previous step, run the following script to export a list of all app registration IDs.

       ```powershell
       $context = Get-AzContext
       if (!$context.Subscription){
       @"
       # Connect To Azure Stack Admin Azure Resource Manager endpoint first https://learn.microsoft.com/azure-stack/operator/azure-stack-powershell-configure-admin#connect-with-azure-ad
       "@ | Write-Host -ForegroundColor:Red
       }
    
       "Getting access token for tenant {0}" -f $context.Subscription.TenantID | Write-Host -ForegroundColor Green
    
       $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
       $profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azureRmProfile)
       $newtoken = $profileClient.AcquireAccessToken($context.Subscription.TenantID)
    
       $armEndpoint = $context.Environment.ResourceManagerUrl
       $applicationRegistrationParams = @{
           Method  = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
           Headers = @{ Authorization = "Bearer " + $newtoken.AccessToken }
           Uri = "$($armEndpoint.ToString().TrimEnd('/'))/applicationRegistrations?api-version=2014-04-01-preview"
       }
    
       $applicationRegistrations = Invoke-RestMethod @applicationRegistrationParams | Select-Object -ExpandProperty value
       "[{0}] App Registrations were found for {1}" -f $applicationRegistrations.appId.Count, $context.Environment.Name | Write-Host -ForegroundColor Green
       $applicationRegistrations.appId | Write-Host
       ```

   1. Work with your Microsoft Entra administrator to remove the app registrations in the previously generated list.

      > [!NOTE]
      > Proceed with app registration cleanup with caution. Outside of the Privileged Endpoint (PEP), your Azure Stack Hub system becomes unusable once these are removed. The app registrations cannot be restored, and your system will not function without being redeployed.

## Disconnected scenarios

For disconnected environments, follow the [Remove the activation resource from Azure Stack Hub](/azure-stack/operator/azure-stack-registration?pivots=state-disconnected&tabs=az1%2Caz2%2Caz3%2Caz4#remove-the-activation-resource-from-azure-stack-hub) procedure.

## Shut down Azure Stack Hub

There are two options to shut down your Azure Stack Hub system. Both commands require the cloud administrator to connect to the [Privileged Endpoint](azure-stack-privileged-endpoint.md):

1. Shut down Azure Stack Hub (recoverable): run the [Stop-AzureStack](../reference/pep/Stop-AzureStack.md) PowerShell cmdlet from the Privileged Endpoint.
1. Shut down Azure Stack Hub (non-recoverable, data is wiped): run the [Start-AzsCryptoWipe](../reference/pep/start-azscryptowipe.md) cmdlet from the Privileged Endpoint.

   > [!IMPORTANT]
   > After this command is executed, the stamp is not recoverable.

## Next steps

- Learn about [Azure Stack Hub diagnostic tools](diagnostic-log-collection.md)
- [Stop-AzureStack](../reference/pep/Stop-AzureStack.md)
- [Start-AzsCryptoWipe](../reference/pep/start-azscryptowipe.md)
