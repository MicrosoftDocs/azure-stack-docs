---
title: Set-AksHciRegistration
author: jessicaguan
description: The Set-AksHciRegistration PowerShell command registers Azure Kubernetes Service on Azure Stack HCI with Azure.
ms.topic: reference
ms.date: 04/12/2021
ms.author: jeguan
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

## Example

```powershell
Set-AksHciRegistration -subscriptionId 57ac26cf-a9f0-4908-b300-9a4e9a0fb205 -resourceGroupName myresourcegroup
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
The token for accessing ARM.

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
The name of the intented public cloud.

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
