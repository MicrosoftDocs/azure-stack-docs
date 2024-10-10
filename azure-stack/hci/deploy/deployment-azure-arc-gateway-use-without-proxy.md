--- 
title: Use Azure gateway without a proxy, version 2408 (preview)
description: Learn how to use Azure gateway without a proxy, version 2408 (preview). 
author: alkohli
ms.topic: how-to
ms.date: 10/07/2024
ms.author: alkohli
---

# Use Azure gateway without a proxy (preview)

Applies to: Azure Stack HCI, version 23H2, releases 2408 and 2408.1

After creating the Arc gateway resource in your Azure subscription, you can enable the new Arc gateway preview features. This article details how to use Azure gateway for Azure Stack HCI systems without a proxy.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Make sure the following prerequisites are met before proceeding:

- You’ve access to an Azure Stack HCI, version 23H2 system.

- An Arc gateway resource created in the same subscription as used to deploy Azure Stack HCI. For more information, see [Create the Arc gateway resource in Azure](deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure).

> [!Warning]
> Only the standard ISO OS image available at https://aka.ms/PVenEREWEEW should be used to test the Arc gateway public preview on Azure Stack HCI, version 2408. Do not use the ISO image available in Azure portal.

## Run the initialization script

To use the Arc gateway feature for Azure Stack HCI systems without a proxy, use the `ProxyBypassList` parameter to specify traffic that shouldn't route through the Arc gateway. Create the bypass list according to this article.

Run the initialization script as follows. All other instructions remain the same as listed in [Configure the proxy using the Arc registration script](deployment-azure-arc-gateway-configure-via-script.md).

```azurecli
#Install required PowerShell modules in your node for registration

Install-Module Az.Accounts -RequiredVersion 2.13.2

Install-Module Az.Resources -RequiredVersion 6.12.0

Install-Module Az.ConnectedMachine -RequiredVersion 0.5.2

#Install Arc registration script from PSGallery

Install-Module AzsHCI.ARCinstaller

#Define the subscription where you want to register your server as Arc device

$Subscription = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx"

#Define the resource group where you want to register your server as Arc device

$RG = "yourresourcegroupname"

#Define the tenant you will use to register your server as Arc device

$Tenant = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
 
#Define the Arc gateway resource ID from Azure

$ArcgwId = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxx /resourceGroups/ yourresourcegroupname /providers/Microsoft.HybridCompute/gateways/yourarcgatewayname"

#Define the bypass list for the proxy. Use semicolon to separate each item from the list.

# Use “localhost” instead of <local>

# Use specific IPs such as 127.0.0.1 without mask

# Use * for subnets allowlisting. 192.168.1.* for /24 exclusions. Use 192.168.*.
* for /16 exclusions.

# Append * for domain names exclusions like *.contoso.com

# DO NOT INCLUDE .svc on the list. The registration script takes care of Environment Variables configuration.

$ProxyBypassList = "localhost;127.0.0.1;*.contoso.com;Node1;Node2;node3;node4;node5;192.168.*.*;HCI-cluster1”

#Connect to your Azure account and Subscription

Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode

#Get the Access Token and Account ID for the registration

$ARMtoken = (Get-AzAccessToken).Token

#Get the Account ID for the registration

$id = (Get-AzContext).Account.Id

#Invoke the registration script with Proxy and ArcgatewayID

Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup
$RG -TenantID $Tenant -Region australiaeast -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -ArcGatewayID $ArcgwId -ProxyBypass
$ProxyBypassList
```

## Next steps

- [Get support for deployment issues](../manage/get-support-for-deployment-issues.md)
- [Get support for Azure Stack HCI](../manage/get-support.md)

