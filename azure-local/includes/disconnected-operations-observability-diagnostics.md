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

Set up observability for diagnostics and support to let Arc registration use a managed identity to upload logs, metrics, and telemetry from the appliance VM.

Here's a list of parameters needed:

- **Azure resource group**: Create a resource group in Azure for the appliance, such as azure-disconnectedoperations.
- **Service Principal Name (SPN)**: Create an SPN that has contributor rights to the resource group.
- **Service Principal credentials**: Get the service principal ID (appId) and secret (password).
- **Subscription**: Identify your Azure subscription.
- **Tenant ID**: Identify your tenant ID.
- **Azure region**: Specify the Azure region (location) for deployment.
- **Required resource providers**: Register these resource providers in your subscription:
  - *Microsoft.Compute* (for Update Manager and extension upgrades)
  - *Microsoft.AzureArcData* (if you use Arc-enabled SQL)
  - *Microsoft.HybridConnectivity*
  - *Microsoft.GuestConfiguration*
  - *Microsoft.HybridCompute*
- **Connectivity**: Make sure your appliance can connect to Azure for telemetry and diagnostics (this isn't required for air-gapped deployments).

Follow these steps to set up observability for diagnostics and support:

1. Sign in to Azure. Use Azure CLI or Azure Cloud Shell, and run this command:

    ```PowerShell
    az login
    ```

1. Create a resource group using the same name you used in DeviceARMResourceURI. Run this command:

    ```powershell
    az group create -g <ResourceGroupName> -l <AzureRegion>
    ```

1. Identify the active cloud. Run this command:

    ```PowerShell
    az cloud list -o table
    ```

1. Get the subscription and tenant IDs. Run this command:

    ```PowerShell
    az account show
    ```

1. Create a service principal. Replace \<SubscriptionID> with your subscription ID, and run this command:

    ```PowerShell
    az ad sp create-for-rbac --name "<SPNName>" --role "Azure Connected Machine Resource Administrator" --scopes /subscriptions/<SubscriptionID>/resourceGroups/<ResourceGroupName>
    ```

    Example output:

    ```json  
    {
      "appId": "<AppId>",
      "displayName": "azlocalobsapp",
      "password": "<RETRACTED>",
      "tenant": "<RETRACTED>"
    }
    <SubscriptionID>
    ```

    > [!NOTE]
    > Use the appID as the Service Principal ID and password as the Service Principal Secret

1. Set the observability configuration. Change the values to match your environment details.

    ```PowerShell
    $observabilityConfiguration = New-ApplianceObservabilityConfiguration -ResourceGroupName "azure-disconnectedoperations" -TenantId "<TenantID>" -Location "<Location>" -SubscriptionId "<SubscriptionId>" -ServicePrincipalId "<AppId>" -ServicePrincipalSecret ("<Password>"|ConvertTo-SecureString -AsPlainText -Force)
    
    Set-ApplianceObservabilityConfiguration -ObservabilityConfiguration $observabilityConfiguration
    ```

1. Check that observability is configured.

    ```PowerShell
    Get-ApplianceObservabilityConfiguration
    ```
