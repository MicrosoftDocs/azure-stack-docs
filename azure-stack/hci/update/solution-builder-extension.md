---
title: Solution Builder Extension updates on Azure Stack HCI, version 23H2.
description: This article describes the Solution Builder Extension updates and how to apply them on your Azure Stack HCI server machines.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: dandefolo
ms.date: 05/28/2024

#customer intent: As a Senior Content Developer, I want provide customers with the highest level of content for the Solution Builder Extension so that customers gain knowledge and keep their Azure Stack HCI systems up to date in the most efficient way.

---

# Solution Builder Extension updates for your Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article provides an overview of the Solution Builder Extension updates and explains how to identify and install them on your Azure Stack HCI, version 23H2 clusters. Additionally, it offers insights into the extension’s advanced capabilities.

## About the extension

The Solution Builder Extension (referred to as SBE in the Azure CLI) allows you to apply updates to your Azure Stack HCI, version 23H2 cluster from your hardware vendor. In addition to Microsoft Azure Stack HCI solution updates, many hardware vendors release regular updates for your Azure Stack HCI hardware. These updates may include driver and firmware updates, hardware monitoring enhancements, and diagnostic tools. Additionally, you can receive updates related to supplemental policies for Windows Defender Application Control (WDAC) and validation logic integrated into Azure Stack HCI pre-update health checks.

Starting with Azure Stack HCI, version 23H2, these types of updates are packaged into **Solution Builder Extension** or **Solution Builder Extension packages**.

## Solution Builder Extension package updates

Solution Builder Extension package updates are integrated into the solution update process for Azure Stack HCI, version 23H2. You can install these updates as part of a combined (full solution) update with other Azure Stack HCI updates using orchestration within Azure Stack HCI. For example, if a Solution Builder Extension update that matches your cluster’s hardware becomes available, it appears as an update option in the Azure portal or can be retrieved using the `Get-SolutionUpdate` PowerShell cmdlet. For more information, see [About updates for Azure Stack HCI, version 23H2](../update/about-updates-23h2.md#user-interfaces-for-updates).

By installing such combined updates, you can keep your entire solution up to date with less impact and minimal effect on running workloads.

## Advanced Solution Builder Extension capabilities

In addition to installing hardware updates, Solution Builder Extension may also provide optional advanced capabilities, as described in the following table. Refer to your hardware vendor’s Azure Stack HCI documentation to determine if advanced Solution Builder Extension capabilities are implemented.

| Advanced Solution Builder Extension Capability   |Description    |
|---------------------------|---------------|
| Health service integration | The Solution Builder Extension package can extend **Health Check** validation performed by Azure Stack HCI before various lifecycle actions (deployment, update, add node, repair node, and others) occur. The validation checks help to ensure issues are resolved before performing any specific lifecycle actions.<br/><br/> Hardware vendors typically use this integration to evaluate if there's a hardware issue that needs immediate attention. For example, it might identify problems with hardware vendor management software, a non-redundant power supply, or higher than expected temperatures. It could also identify SSD drive wear approaching a critical state. Be sure to review your hardware vendor's Solution Builder Extension documentation for details on hardware health checks supported by their extension. |
| Customized deployment | The Solution Builder Extension package can implement customized steps that are executed automatically as part of the cluster deployment process. <br/><br/> Hardware vendors typically use this capability to configure or install any value-add software via their Solution Builder Extension for the solution.  |
| Customized solution update | The Solution Builder Extension package can implement customized steps that are performed both before and after the main portion of the solution update process. Even when it isn't performing a Solution Builder Extension update, Solution Builder Extension packages that implement this capability always run these extra steps. For example, the execution of hardware vendor specific steps before or after Azure Stack HCI Operating System updates, when no updates to the Solution Builder Extension are needed. <br/><br/> Hardware vendors typically use this capability to prepare nodes for any update related tasks that may involve rebooting servers. |

## Identify a Solution Builder Extension update for your hardware

Starting with Azure Stack HCI, version 23H2, any hardware added to the Azure Stack HCI catalog as an Integrated System or Premier Solution must implement a Solution Builder Extension that supports firmware and driver update. Microsoft recommends purchasing newer Integrated Systems and Premier Solutions to take advantage of the full solution, update at-scale, capabilities that are enabled through the Solution Builder Extension.

> [!NOTE]
> A solution builder extension might not be implemented for your hardware if:
>
> - It was added to the Azure Stack HCI catalog before Azure Stack HCI, version 23H2.
>
> - Your hardware was purchased as a Validated Node.
>
> Consult with your hardware vendor’s Azure Stack HCI documentation to determine if your server model supports a Solution Builder Extension.

If your hardware doesn't support a Solution Builder Extension update experience, the process for updating your hardware is like that of Azure Stack HCI, version 22H2. This means that your hardware updates may be available using Windows Admin Center. For more information, see  [Update Azure Stack HCI clusters, version 22H2](../manage/update-cluster.md#install-operating-system-and-hardware-updates-using-windows-admin-center).

Your firmware and driver updates may need to be performed separately, if your hardware doesn't support hardware updates using Solution Builder Extension packages or Windows Admin Center. Follow the recommendations of your hardware vendor.

The following table provides the hardware update method for different hardware vendors along with their respective platform series and generations.

| Solution Builder (server hardware vendor) | Platform series/generation | Hardware Update Method  | For more information  |
|-----------------|------------------|---------------|-------------------|
| DataON   | Models starting with S2D7 and AZS7   | Solution Builder Extension | [Must Stay Up to Date - DataON](https://www.dataonstorage.com/dataon-must/must-stay-up-to-date/) |
| DataON  | Other Integrated Systems and Validated Nodes (not previously listed)    | [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/DataON.MUSTPro/overview/3.2.6) | [Enhancing the Windows Admin Center Experience with DataON MUST](https://www.dataonstorage.com/must/windows-admin-center/)                   |
| Dell Technologies  | Premier Solutions: </br><br> MC-660, MC-760 | APEX Cloud Platform Hardware Updates (Solution Builder Extension) | [Support Matrix of Dell APEX Cloud Platform for Microsoft Azure](https://dl.dell.com/content/manual34666301-dell-apex-cloud-platform-for-microsoft-azure-support-matrix.pdf) |
| Dell Technologies | 15G Integrated Systems - Clusters running Azure Stack OS 23H2:</br><br> AX-650, AX-750, AX-6515, AX-7525 | Solution Builder Extension (once available)  | [Dell Solution Builder Extensions for Azure Stack HCI Integrated System AX Server Release Notes](https://www.dell.com/support/kbdoc/en-us/000224407) |
| Dell Technologies | 15G Integrated Systems - Clusters running Azure Stack OS 23H2:</br><br> AX-650, AX-750, AX-6515, AX-7525 | [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/dell-emc.openmanage-integration/overview/3.2.0)  | [Full Stack Cluster-Aware Updating for Azure Stack HCI clusters using the OpenManage Integration snap-in](https://infohub.delltechnologies.com/l/e2e-deployment-and-operations-guide-cluster-creation-using-windows-admin-center-wac-1/full-stack-cluster-aware-updating-for-azure-stack-hci-clusters-45/) |
| Dell Technologies | 14G Integrated Systems Clusters running Azure Stack OS 22H2:</br><br> AX-740xd, AX-640 | [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/dell-emc.openmanage-integration/overview/3.2.0) | [Full Stack Cluster-Aware Updating for Azure Stack HCI clusters using the OpenManage Integration snap-in](https://infohub.delltechnologies.com/l/e2e-deployment-and-operations-guide-cluster-creation-using-windows-admin-center-wac-1/full-stack-cluster-aware-updating-for-azure-stack-hci-clusters-45/) |
| Hewlett Packard Enterprise | All | Solution Builder Extension and [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/hpe.hci.snap-in/overview/1.3.0) | 1. Install [Solution Builder Extension](https://www.hpe.com/info/ASHCI-SBE) </br><br> 2. Install hardware updates via [Windows Admin Center](https://www.hpe.com/us/en/alliance/microsoft/ws-admin-center.html) |
| Lenovo | Premier Solutions and specific Integrated Systems:</br><br> MX455 V3, MX450 | Solution Builder Extension | [Azure Stack HCI Solution Builder Extension Update - Lenovo](https://thinkagile.lenovo.com/MX/) |
| Lenovo | Other Integrated Systems and Validated Nodes (not previously listed)  | [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/lnvgy_sw_xclarity_integrator_for_wac/overview/4.5.1) | [Lenovo XClarity Integrator for Microsoft Windows Admin Center](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/lnvgy_sw_xclarity_integrator_for_wac/overview/4.5.1) |

## Discover Solution Builder Extension Updates

The Azure Stack HCI Lifecycle Management orchestration integrates Solution Builder Extension updates, which include both Solution Builder Extension (hardware-only) updates and full solution updates for Azure Stack HCI and Solution Builder Extension. These updates can be managed using the same update management tools for the Azure portal and PowerShell. This means that you can install an urgent Solution Builder Extension update by itself or a combined "Solution" update using the same process.

### Discover Solution Builder Extension updates via the Azure portal

To discover and select updates via the Azure portal, see [Browse for cluster updates](../update/azure-update-manager-23h2.md#browse-for-cluster-updates).

### Discover Solution Builder Extension updates via PowerShell

To understand if an update is a standalone Solution Builder Extension or combined "Solution" update, use the properties `PackageType` and `SbeVersion`.

```powershell
$Update = Get-SolutionUpdate
$Update | ft DisplayName, PackageType, Version, SbeVersion, State
```

Here's a sample output:

```console
PS C:\Users\lcmuser> $Update = Get-SolutionUpdate 
PS C:\Users\lcmuser> $Update | ft DisplayName, PackageType, Version, SbeVersion, State

DisplayName                      PackageType Version      SbeVersion     State
-----------                      ----------- -------      ----------     -----
SBE_Contoso_Gen3_4.1.2312.5      SBE                      4.1.2312.5     Ready
Azure Stack HCI 2311 bundle      Solution    10.2311.0.26 4.1.2312.5     Ready 
```

In the sample output, you can see that two updates are ready to be installed: the standalone **SBE_Contoso_Gen3_4.1.2312.5** update and the combined **Azure Stack HCI 2311 bundle** update, which includes the same Solution Builder Extension as identified by the SbeVersion number 4.1.2312.5.

> [!NOTE]
> Microsoft recommends installing the combined “Solution” update in most cases, to reduce the number of update operations needed to keep your cluster up to date. You can refer to the `SBEReleaseLink` and `SBENotifyMessage` properties, provided by your hardware vendor in the `AdditionalProperties` of the update, to determine if there's an urgent reason to install a Solution Builder Extension update before the combined solution update.

To determine which update to install, use the **ComponentVersions** and **AdditionalProperties** values from `Get-SolutionUpdate`.

```powershell
$Update = Get-SolutionUpdate
$Update | select -ExpandProperty ComponentVersions
```

Here's a sample output:

```console
PS C:\Users\lcmuser> $Update = Get-SolutionUpdate 
PS C:\Users\lcmuser> $Update | select -ExpandProperty ComponentVersions

PackageType Version      LastUpdated
----------- -------      -----------
Services    10.2311.0.26
Platform    10.2311.0.26
SBE         4.1.2312.5
```

```powershell
$Update | Where-Object {$_.PackageType -eq "Solution" } | select -ExpandProperty AdditionalProperties
```

Here's a sample output:

```console
PS C:\Users\lcmuser> $Update | Where-Object {$_.PackageType -eq "Solution" } | select -ExpandProperty AdditionalProperties

Key                Value
---                -----
SBEReleaseLink     https://contoso.com/SBE/4.1.2312.5/ReleaseNotes.pdf
SBENotifyMessage   URGENT! Includes firmware updates that impact system reliability. See release notes!
SBEFamily          Gen3
SBEPublisher       Contoso
SupportedModels    Contoso550G3,Contoso320G3
SBEPackageSizeInMb 4
SBECopyright       Copyright (C) Contoso. All rights reserved.
SBELicenseUri      https://contoso.com/SBE/EULA.pdf 
```

As provided in the example, **SBEReleaseLink** and **SBENotifyMessage** may contain important information about the urgency of installing the Solution Builder Extension update, as opposed to deferring the update for a later update maintenance window.

#### The AdditionalContentRequired update state

While Azure Stack HCI can automatically discover Solution Builder Extension updates, in many cases, Solution Builder Extension packages must be downloaded from the hardware vendor’s support site and then sideloaded into the cluster.

The **AdditionalContentRequired** state is used to identify files that must be sideloaded before the update can be installed.

```powershell
$Update = Get-SolutionUpdate 
$Update | ft DisplayName, PackageType, Version, SbeVersion, State
```

Here's a sample output:

```console
PS C:\Users\lcmuser> $Update = Get-SolutionUpdate 
PS C:\Users\lcmuser> $Update | ft DisplayName, PackageType, Version, SbeVersion, State

DisplayName                      PackageType Version      SbeVersion     State
-----------                      ----------- -------      ----------     -----
SBE_Contoso_Gen3_4.1.2312.5      SBE                      4.1.2312.5     AdditionalContentRequired
Azure Stack HCI 2311 bundle      Solution    10.2311.0.26 4.1.2312.5     AdditionalContentRequired
```

To view information on the Solution Builder Extension update such as its release notes (via the `SBEReleaseLink`) and determine how to download the Solution Builder Extension files from your hardware vendor, use the updates `AdditionalProperties` property of the updates.

For more information, see [Discover Solution Builder Extension updates](./solution-builder-extension.md#discover-solution-builder-extension-updates). You should download the Solution Builder Extension files following the hardware vendor's recommendations and license agreements.

## Next steps

- [Sideload and discover solution updates](../update/update-via-powershell-23h2.md#sideload-and-discover-solution-updates).
- [Understand update phases of Azure Stack HCI, version 23H2](../update/update-phases-23h2.md).