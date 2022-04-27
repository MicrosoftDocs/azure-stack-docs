---
title: Set-AksHciRegistration for AKS on Azure Stack HCI and Windows Server
author: mattbriggs
description: The Set-AksHciRegistration PowerShell command registers Azure Kubernetes Service on Azure Stack HCI with Azure.
ms.topic: reference
ms.date: 04/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Set-AksHciRegistration

## Synopsis
Register Azure Kubernetes Service on Azure Stack HCI with Azure.

## Syntax


```powershell
Set-AksHciRegistration -subscriptionId<String>
                       -resourceGroupName <String>
                      [-tenantId <String>]
                      [-armAccessToken <String>]
                      [-graphAccessToken <String>]
                      [-accountId <String>]
                      [-environmentName <String>]
                      [-credential <PSCredential>]
                      [-region <String>]
                      [-useDeviceAuthentication]
                      [-skipLogin]
```

## Description
Register Azure Kubernetes Service on Azure Stack HCI with Azure.

## Examples

### Register AKS on Azure Stack HCI and Windows Server using a subscription ID and resource group name

```powershell
Set-AksHciRegistration -subscriptionId 57ac26cf-a9f0-4908-b300-9a4e9a0fb205 -resourceGroupName myresourcegroup
```

### Register with a device login or while running in a headless shell
```powershell
Set-AksHciRegistration -subscriptionId myazuresubscription -resourceGroupName myresourcegroup -UseDeviceAuthentication
```

### Register AKS on Azure Stack HCI and Windows Server using a service principal

If you do not have access to a subscription on which you're an "Owner", you can register your AKS host to Azure for billing using a service principal.

Log in to Azure using the [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount) PowerShell command:

```powershell
Connect-AzAccount
```

Set the subscription you want to use to register your AKS host for billing as the default subscription by running the [Set-AzContext](/powershell/module/az.accounts/set-azcontext) command.
```powershell
Set-AzContext -Subscription myAzureSubscription
```

Verify that your login context is correct by running the [Get-AzContext](/powershell/module/az.accounts/get-azcontext) PowerShell command. Verify that the subscription, tenant, and account are what you want to use to register your AKS host for billing.

```powershell
Get-AzContext
```

```output
Name                                     Account                      SubscriptionName             Environment                  TenantId
----                                     -------                      ----------------             -----------                  --------
myAzureSubscription (92391anf-...        user@contoso.com             myAzureSubscription          AzureCloud                   xxxxxx-xxxx-xxxx-xxxxxx
```

Retreive your tenant ID.

```powershell
$tenant = (Get-AzContext).Tenant.Id
```

Create a service principal by running the [New-AzADServicePrincipal](/powershell/module/az.resources/new-azadserviceprincipal) PowerShell command. This command creates a service principal with the "Microsoft.Kubernetes connected cluster" role and sets the scope at a subscription level. For more information on creating service principals, visit [create an Azure service principal with Azure PowerShell](/powershell/azure/azurerm/create-azure-service-principal-azureps).

```powershell
$sp = New-AzADServicePrincipal -Role "Microsoft.Kubernetes connected cluster role" -Scope "/subscriptions/myazuresubscription"
```

Retrieve the password for the service principal by running the following command:

```powershell
$secret = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret))
Write-Host "Application ID: $($sp.ApplicationId)"
Write-Host "App Secret: $secret"
```   
From the output above, you now have the **application ID** and the **secret** available when deploying AKS on Azure Stack HCI and Windows Server. You should take a note of these items and store them safely.
Now that you have the application ID and secret available, in the **Azure portal**, under **Subscriptions**, **Access Control**, and then **Role Assignments**, you should see your new service principal.

Store your service principal credentials (the application ID and secret) with [Get-Credential](/powershell/module/microsoft.powershell.security/get-credential), then set the registration.
```powershell
$credential = Get-Credential
Set-AksHciRegistration -SubscriptionId myazuresubscription -ResourceGroupName myresourcegroup -TenantId $tenant -Credential $credential
```

## Parameters

### -subscriptionId
The ID of the Azure subscription to be used.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceGroupName
Name of the resource group to place Arc resources.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tenantId
The tenant Id of your Azure service principal.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -armAccessToken
The token for accessing Azure Resource Manager.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -graphAccessToken
The token for accessing the graph.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -accountId
ID of the Azure account.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -environmentName
The name of the intended public cloud.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -credential
A PSCredential that holds the user's service principal.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -region
The Azure location.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -useDeviceAuthentication
Outputs a code to be used in the browser.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -skipLogin
Skips the Connect-AzAccount call. This flag is useful in automation or when running from a connected shell.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
## Next steps

[AksHci PowerShell Reference](index.md)
