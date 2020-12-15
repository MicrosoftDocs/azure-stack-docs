---
title: Use PowerShell to manage subscriptions, plans, and offers in Azure Stack Hub
description: How to manage subscriptions, plans, and offers with PowerShell in Azure Stack Hub.
author: PatAltimore
ms.topic: how-to
ms.date: 12/14/2020
ms.author: patricka
ms.lastreviewed: 12/14/2020
ms.reviewer: bganapa

# Intent: As an Azure Stack Hub operator, I want to use PowerShell so I can manage offers.
# Keyword: subscription plan offer powershell azure stack hub

---

# Use PowerShell to manage subscriptions, plans, and offers in Azure Stack Hub

You can use PowerShell to configure and deliver services by using offers, plans, and subscriptions. using PowerShell. For instructions on getting set up with PowerShell on Azure Stack Hub, see [Install PowerShell Az module for Azure Stack Hub](powershell-install-az-module.md).

## Create a plan

Quotas are required when creating a plan. You can use an existing quotas or create new quotas. For example, to create a storage, compute and network quota, you can use the [New-AzsStorageQuota](/powershell/module/azs.storage.admin/new-azsstoragequota), [New-AzsComputeQuota](/powershell/module/azs.compute.admin/new-azscomputequota), and [New-AzsNetworkQuota](/powershell/module/azs.network.admin/new-azsnetworkquota) cmdlets:

```powershell
$serviceQuotas  = @()
$serviceQuotas += (New-AzsStorageQuota -Name "Example storage quota with defaults").Id
$serviceQuotas += (New-AzsComputeQuota -Name "Example compute quota with defaults").Id
$serviceQuotas += (New-AzsNetworkQuota -Name "Example network quota with defaults").Id
```

To create or update a base or add-on plan, use [New-AzsPlan](/powershell/module/azs.subscriptions.admin/new-azsplan).

```powershell
$testPlan = New-AzsPlan -Name "testplan" -ResourceGroupName "testrg" -QuotaIds $serviceQuotas -Description "Test plan"
```

## Create an offer

To create an offer, use [New-AzsOffer](/powershell/module/azs.subscriptions.admin/new-azsoffer).

```powershell
New-AzsOffer -Name "testoffer" -ResourceGroupName "testrg" -BasePlanIds @($testPlan.Id)
```

Once you have an offer, you can add plans to the offer. Use [Add-AzsPlanToOffer](/powershell/module/azs.subscriptions.admin/add-azsplantooffer). The **-PlanLinkType** parameter distinguishes the plan type.

```powershell
Add-AzsPlanToOffer -PlanName "addonplan" -PlanLinkType Addon -OfferName "testoffer" -ResourceGroupName "testrg" -MaxAcquisitionCount 18
```

If you want to change the state of an offer, use the [Set-AzsOffer](/powershell/module/azs.subscriptions.admin/set-azsoffer) cmdlet.

```powershell
$offer = Get-AzsAdminManagedOffer -Name "testoffer" -ResourceGroupName "testrg"
$offer.state = "Public"
$offer | Set-AzsOffer -Confirm:$false
```

## Subscribe to an offer

To subscribe to an offer, use [New-AzsUserSubscription](/powershell/module/azs.subscriptions.admin/new-azsusersubscription).

```powershell
New-AzsUserSubscription -Owner "user@contoso.com" -DisplayName "User subscription" -OfferId "/subscriptions/<Subscription ID>/resourceGroups/testrg/providers/Microsoft.Subscriptions.Admin/offers/testoffer"
```

## Delete quotas, plans, offers, and subscriptions

There are companion PowerShell cmdlets to delete Azure Stack Hub quotas, plans, offers, and subscriptions. The following show examples for each.

Use [Remove-AzsUserSubscription](/powershell/module/azs.subscriptions.admin/remove-azsusersubscription) to remove a subscription from an offer.

```powershell
Remove-AzsUserSubscription -TargetSubscriptionId "c90173b1-de7a-4b1d-8600-b8325ca1eab1e"
```

To remove a plan from an offer, use [Remove-AzsPlanFromOffer](/powershell/module/azs.subscriptions.admin/remove-azsplanfromoffer).

```powershell
Remove-AzsPlanFromOffer -PlanName "addonplan" -PlanLinkType Addon -OfferName "testoffer" -ResourceGroupName "testrg"
Remove-AzsPlanFromOffer -PlanName "testplan" -PlanLinkType Base -OfferName "testoffer" -ResourceGroupName "testrg"
```

Use [Remove-AzsPlan](/powershell/module/azs.subscriptions.admin/remove-azsplan) to remove a plan.

```powershell
Remove-AzsPlan -Name "testplan" -ResourceGroupName "testrg"
```

Use [Remove-AzsOffer](/powershell/module/azs.subscriptions.admin/remove-azsoffer) to remove an offer.

```powershell
Remove-AzsOffer -Name "testoffer" -ResourceGroupName "testrg"
```

To remove quotas, use [Remove-AzsStorageQuota](/powershell/module/azs.storage.admin/remove-azsstoragequota), [Remove-AzsComputeQuota](/powershell/module/azs.compute.admin/remove-azscomputequota), [Remove-AzsNetworkQuota](/powershell/module/azs.network.admin/remove-azsnetworkquota) .

```powershell
Remove-AzsStorageQuota -Name "Example storage quota with defaults"
Remove-AzsComputeQuota -Name "Example compute quota with defaults"
Remove-AzsNetworkQuota -Name "Example network quota with defaults"
```

## Next steps

- [Managing updates in Azure Stack Hub](./azure-stack-updates.md)
