--- 
title: Use Azure gateway without a proxy on Azure Local, version 2408 (preview)
description: Learn how to use Azure gateway without a proxy, on Azure Local instance running version 2408 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 11/18/2024
ms.author: alkohli
ms.service: azure-stack-hci
---

# Use Azure Arc gateway without a proxy on Azure Local (preview)

Applies to: Azure Local, version 23H2, release 2411.1 and later

After creating the Arc gateway resource in your Azure subscription, you can enable the new Arc gateway preview features on your Azure Local. This article details how to use Azure gateway for Azure Local instances without a proxy.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

Make sure the following prerequisites are met before proceeding:

- You’ve access to an Azure Local instance running version 23H2, release 2411.1. Prior versions do not support this scenario.

- An Arc gateway resource created in the same subscription as used to deploy Azure Local. For more information, see [Create the Arc gateway resource in Azure](deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

## Run the initialization script

To use the Arc gateway feature for Azure Local systems without a proxy, only use the `ArcGatewayID` parameter.

Run the initialization script as follows.

```azurecli

#Define the subscription where you want to register your server as Arc device.
$Subscription = "yoursubscription"

#Define the resource group where you want to register your server as Arc device.
$RG = "yourresourcegroupname"

#Define the tenant you will use to register your server as Arc device.
$Tenant = "yourtenant"
 
#Define the Arc gateway resource ID from Azure
$ArcgwId = "/subscriptions/yourarcgatewayid/resourceGroups/yourresourcegroupname/providers/Microsoft.HybridCompute/gateways/yourarcgatewayname"

#Connect to your Azure account and Subscription
Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode

#Get the Access Token and Account ID for the registration
$ARMtoken = (Get-AzAccessToken).Token

#Get the Account ID for the registration
$id = (Get-AzContext).Account.Id

#Invoke the registration script with Proxy and ArcgatewayID
Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region australiaeast -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -ArcGatewayID $ArcgwId
```

## Next steps

- [Get support for deployment issues](../manage/get-support-for-deployment-issues.md)
- [Get support for Azure Local](../manage/get-support.md)
