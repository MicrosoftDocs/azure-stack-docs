---
title: New-AksHciLoadBalancerSetting for AKS on Azure Stack HCI
author: mattbriggs
description: Use the New-AksHciLoadBalancerSetting command to create a load balancer in AKS on Azure Stack HCI.
ms.topic: reference
ms.date: 11/18/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# New-AksHciLoadBalancerSetting

## Synopsis
Create a load balancer object for the workload clusters.

## Syntax
```powershell
New-AksHciLoadBalancerSetting -name <String>
                              -loadBalancerSku {HAProxy, none}
```

## Description
Create a load balancer object for the workload clusters.

> [!NOTE]
> When you deploy an AKS cluster with no load balancer, you need to make sure that the Kubernetes API server is reachable. `kube-vip` is automatically deployed to handle requests to the API server, which allows you to continue to perform cluster operations. **If you choose `none` as the load balancer SKU, then your applications will be unreachable until you configure your own load balancer.**

## Examples

### Create a load balancer object

```powershell
$loadbalancer = New-AksHciLoadBalancerObject -name mylb -loadBalancerSku none
```

## Parameters

### -name
The name of the load balancer object.

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

### -loadBalancerSku
The load balancer SKU that is to be deployed. The value must be `HAProxy` or `none`.

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

## Next steps

[AksHci PowerShell Reference](index.md)