---
title: Security Monitoring for Small Form Factor Deployments of Azure Local (preview)
description: Learn how to set up an Azure Policy audit assignment and view security baseline settings for small form factor deployments of Azure Local (preview).
author: Sars47
ms.topic: how-to
ms.date: 11/03/2026
ms.author: adamsarsony
ms.service: azure-local
ms.subservice: small-form-factor
---

# Security monitoring

This article explains how to set up an Azure Policy audit assignment and view the security baseline settings on your Azure Local Small Form Factor (SFF) device.

## View security baseline settings for Azure Local Small Form Factor

Set up a machine configuration policy assignment in Azure Policy to view the security baseline setting status on your Azure Local Small Form Factor (SFF) device.

> [!IMPORTANT]
> You only need to set up the audit policy assignment once per subscription. The assignment applies to all Azure Local SFF devices in that subscription, so you can view the enabled security baseline settings on each device’s SFF portal page.

> [!NOTE]
> This functionality isn't currently available for the NVIDIA Jetson Thor Devkit in SFF release 2610.

## Set up the policy assignment

1. In the Azure portal, go to **Policy**.
2. Under **Authoring**, select **Machine configuration**.
3. Select the **Definitions** tab.
4. Find and select **Azure Security Baseline for Linux**.
5. Select **Modify settings**.
6. Select **Azure Security Baseline for Linux on Azure Local Small Form Factor (SFF)**.
7. Select **Set up audit policy assignment**.
8. On the **Scope** tab:
   1. Select the subscription that contains your Azure Local SFF resource.
   2. Enter a name for the policy assignment.
9. On the **Parameters** tab, set **Include Arc-connected servers** to **True**.
10. Select **Review + create**, and then select **Create**.

## View the status of security settings

After you create the audit policy assignment, wait up to one hour for the machine configuration data to appear. To view the settings enabled on a specific SFF device, open the device’s SFF portal page. The page displays the security baseline settings that are enabled on that device.
