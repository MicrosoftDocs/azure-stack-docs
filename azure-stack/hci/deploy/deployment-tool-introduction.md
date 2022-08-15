---
title: Deploy Azure Stack HCI version 22H2 (preview)
description: Learn to deploy Azure Stack HCI version 22H2
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Deploy Azure Stack HCI version 22H2

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article describes how to deploy Azure Stack HCI, version 22H2 Preview using a new deployment method and tools. You should already be familiar with the existing Azure Stack HCI solution.

Azure Stack HCI, version 22H2 Preview must be installed using the local boot from VHDX method described in this article set.

> [!IMPORTANT]
 > Please review the [Terms of Use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for this preview and sign up before you deploy this solution.

## New features

Azure Stack HCI, version 22H2 Preview contains the following new features:

|Feature|Description|
|--|--|
|Release notes|Read the release notes for more information about validating the following features and for known issues.|
|New OS installation and deployment method|Azure Stack HCI, version 22H2 Preview includes a new deployment tool with better automation in Windows Admin Center.|
|[Azure Connectivity Checker](https://partner.microsoft.com/dashbaord/collaborate/packages/13235)|Ascertain how ready your network is to deploy the Azure Stack HCI, version 22H2 solution.|
|Azure registration|Registration of your cluster to Azure requires fewer permissions.|
|Default security improvements|Recommended security settings are turned on by default.|
|Remote support|Use this feature to allow Microsoft Support to access your device remotely and perform limited troubleshooting and repair. Enabling this feature requires your consent.|
|Windows Admin Center in Azure portal|Use Windows Admin Center natively in the Azure portal to centrally manage Azure Stack HCI clusters in your on-premises environment. For details, see [Use the Azure portal with Azure Stack HCI](https://docs.microsoft.com/azure-stack/hci/manage/azure-portal).|
|Network ATC improvements|Includes new features and enhancements for Network ATC|
|Builds|**Windows build**: 20348.30193.220714-1750<br>**Assembly build**: ASZ-Assembly-PKG_10.2207.0.118_20220725-2137|

## Tested configurations

The following three configurations were validated for this preview:

> [!IMPORTANT]
> We recommend that you use one of the validated configurations for optimum results in testing.

- A single physical server connected to a network switch.

- Two physical servers with direct (switchless) network connections to each other for storage traffic.

- Two or four physical servers deployed using a fully converged network configuration connected to redundant network switches.

The following diagram shows two physical servers with a directly connected (switchless) storage network and a single L2 switch for management and cluster traffic.

:::image type="content" source="media/deployment-tool/scenario1.png" alt-text=" Two servers with switchless storage network scenario" lightbox="media/deployment-tool/deployment-wizard-1.png":::

The following diagram shows two physical servers with a directly connected (switchless) storage network and redundant L3 switches for management and cluster traffic.

:::image type="content" source="media/deployment-tool/scenario2.png" alt-text="Two physical servers with switchless storage network and redundant L3 switches scenario" lightbox="media/deployment-tool/deployment-wizard-1.png":::

The following diagram shows two physical servers with all network traffic traveling over a converged set of network interfaces connected to redundant L3 switches.

:::image type="content" source="media/deployment-tool/scenario3.png" alt-text="Converged network scenario 3" lightbox="media/deployment-tool/deployment-wizard-1.png":::

## Deployment process

Follow this process to deploy Azure Stack HCI version 22H2 Preview in your environment:

- Read the [prerequisites for Azure Stack HCI version 22H2](deployment-tool-prerequisites.md).
- From a VHDX file, [install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.
- Deploy using either a [new configuration file](deployment-tool-new-file.md) or using an [existing configuration file](deployment-tool-existing-file.md) in Windows Admin Center.
- If applicable, [deploy using PowerShell](deployment-tool-powershell.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).
- Also see [Known issues for Azure Stack HCI version 22H2](deployment-tool-known-issues.md).
