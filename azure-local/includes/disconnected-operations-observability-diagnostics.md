---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 10/07/2025
ms.reviewer: alkohli
ms.lastreviewed: 10/07/2025
---

## Set up observability for diagnostics and support

This setup allows Arc registration using a managed identity to upload logs, metrics, and telemetry from the appliance VM.

1. Sign in to Azure. Use Azure CLI or Azure Cloud Shell and run this command:

    ```PowerShell
    az login
    ```

2. Create a resource group using the same name you used in DeviceARMResourceURI. Run this command:

    ```powershell
    az group create -g <ResourceGroupName> -l <AzureRegion>
    ```

3. Identify Active Cloud. Run this command:

    ```PowerShell
    az cloud list -o table
    ```

4. Get subscription and tenant IDs. Run this command:

    ```PowerShell
    az account show
    ```

5. Create a Service Principal. Replace `<SubscriptionID>` with your subscription ID and run this command:

    ```PowerShell
    az ad sp create-for-rbac --name "<SPNName>" --role "Azure Connected Machine Onboarding" --scopes /subscriptions/<SubscriptionID>/resourceGroups/<ResourceGroupName>
    ```

    Example output:

    {
      "appId": "\<AppId>",
      "displayName": "azlocalobsapp",
      "password": "\<RETRACTED>",
      "tenant": "\<RETRACTED>"
    }
    \<SubscriptionID>

    > [!NOTE]
    > Use the appID as the Service Principal ID and password as the Service Principal Secret

6. Set the observability configuration. Modify to match your environment details:

    ```PowerShell
    $observabilityConfiguration = New-ApplianceObservabilityConfiguration -ResourceGroupName "azure-disconnectedoperations" -TenantId "<TenantID>" -Location "<Location>" -SubscriptionId "<SubscriptionId>" -ServicePrincipalId "<AppId>" -ServicePrincipalSecret ("<Password>"|ConvertTo-SecureString -AsPlainText -Force)
    
    Set-ApplianceObservabilityConfiguration -ObservabilityConfiguration $observabilityConfiguration
    ```

7. Verify that observability is configured:

    ```PowerShell
    Get-ApplianceObservabilityConfiguration
    ```
