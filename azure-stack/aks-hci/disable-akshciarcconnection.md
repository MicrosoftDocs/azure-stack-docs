---
title: Disable-AksHciArcConnection
author: jessicaguan
description: The Disable-AksHciArcConnection PowerShell command disables the Arc connection on an AKS on Azure Stack HCI cluster.
ms.topic: reference
ms.date: 04/12/2021
ms.author: jeguan
---

# Disable-AksHciArcConnection

## Synopsis
Disables Arc connection on an AKS on Azure Stack HCI cluster.

## Syntax

```powershell
Disable-AksHciArcConnection -name <String> 
                           -tenantId <String>
                           -subscriptionId <String> 
                           -resourceGroup <String>
                           -credential <PSCredential>
                           -location <String>
```

## Description
Disables Arc connection an AKS on Azure Stack HCI cluster.

## Examples

### Disconnects an AKS cluster on Azure Stack HCI from Azure Arc enabled Kubernetes

```PowerShell
Disable-AksHciArcConnection -name "myCluster"
```

## Parameters

### -Name
The alphanumeric name of your AKS cluster.

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
The tenant ID of your Azure service principal. Default value is the Azure login context.

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

### -subscriptionId
Your Azure account's subscription ID. Default value is the subscription ID passed in `Set-AksHciRegistration`.

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

### -resourceGroup
The name of the Azure resource group. Default value is the resource group passed in `Set-AksHciRegistration`.

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
The credential for the Azure service principal.

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

### -location
The location or Azure region of your Azure resource. Default value is the location passed in `Set-AksHciRegistration`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Azure resource group's location
Accept pipeline input: False
Accept wildcard characters: False
```
