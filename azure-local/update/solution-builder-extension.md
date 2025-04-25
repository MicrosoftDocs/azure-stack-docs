---
title: Solution Builder Extension updates on Azure Local, version 23H2
description: This article describes the Solution Builder Extension updates and how to apply them on your Azure Local machines.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: dandefolo
ms.date: 02/25/2025

#customer intent: As a Senior Content Developer, I want provide customers with the highest level of content for the Solution Builder Extension so that customers gain knowledge and keep their Azure Local up to date in the most efficient way.

---

# Solution Builder Extension updates for your Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article provides an overview of the Solution Builder Extension updates and explains how to identify and install them on your Azure Local systems. Additionally, it offers insights into the extension’s advanced capabilities.

## About the extension

The Solution Builder Extension (referred to as SBE in the Azure CLI) allows you to apply updates from your hardware vendor to your Azure Local system. In addition to Microsoft Azure Local solution updates, many hardware vendors release regular updates for your Azure Local hardware. These updates may include driver and firmware updates, hardware monitoring enhancements, and diagnostic tools. Additionally, you can receive updates related to supplemental policies for Windows Defender Application Control (WDAC) and validation logic integrated into Azure Local pre-update health checks.

Starting with Azure Local 2311.2, all these updates are packaged into Solution Builder Extension or Solution Builder Extension packages.

## Solution Builder Extension package updates

Solution Builder Extension package updates are integrated into the solution update process for Azure Local. You can install these updates as part of a combined (full solution) update with other Azure Local updates using orchestration within Azure Local. For example, if a Solution Builder Extension update that matches your system's hardware becomes available, it appears as an update option in the Azure portal or can be retrieved using the `Get-SolutionUpdate` PowerShell cmdlet. For more information, see [About updates for Azure Local](../update/about-updates-23h2.md#user-interfaces-for-updates).

By installing such combined updates, you can keep your entire solution up to date with less impact and minimal effect on running workloads.

## Advanced Solution Builder Extension capabilities

In addition to installing hardware updates, Solution Builder Extension may also provide optional advanced capabilities, as described in the following table. To determine if advanced Solution Builder Extension capabilities are implemented, refer to your hardware vendor’s Azure Local documentation.

| Advanced Solution Builder Extension Capability   |Description    |
|---------------------------|---------------|
| Health service integration | The Solution Builder Extension package can extend **Health Check** validation performed by Azure Local before various lifecycle actions (deployment, update, add node, repair node, and others) occur. The validation checks help to ensure issues are resolved before performing any specific lifecycle actions.<br/><br/> Hardware vendors typically use this integration to evaluate if there's a hardware issue that needs immediate attention. For example, it might identify problems with hardware vendor management software, a non-redundant power supply, or higher than expected temperatures. It could also identify SSD drive wear approaching a critical state. Be sure to review your hardware vendor's Solution Builder Extension documentation for details on hardware health checks supported by their extension. |
| Solution builder extension download | The Solution Builder Extension package can implement **download connector** interfaces that allow Azure Local to download future SBE updates on behalf of the user. This feature enables new updates from your hardware vendor to show a **Ready** state instead of the [AdditionalContentRequired](solution-builder-extension.md#the-additionalcontentrequired-update-state) state mentioned later in this guide. Because these updates are ready to install without needing any files to be [imported](update-via-powershell-23h2.md#step-3-import-and-rediscover-updates) per an Azure Local instance, it makes it easy to install updates across multiple Azure Local instances simultaneously. <br><br> Hardware vendors often require customized SBE credentials for authentication to download their SBE extension files. Refer to your hardware vendor documentation for instructions on providing these credentials during [deployment on the Configuration](../deploy/deploy-via-portal.md#specify-the-deployment-settings) page or starting with Azure Local, version 2411, you can use the `Set-SolutionExtensionSecretLocation` cmdlet to update or add SBE credentials in Key Vault after deployment. |
| Customized deployment | The Solution Builder Extension package can implement customized steps that are executed automatically as part of the system deployment process. <br/><br/> Hardware vendors typically use this capability to configure or install any value-add software via their Solution Builder Extension for the solution.  |
| Customized solution update | The Solution Builder Extension package can implement customized steps that are performed both before and after the main portion of the solution update process. Even when it isn't performing a Solution Builder Extension update, Solution Builder Extension packages that implement this capability always run these extra steps. For example, the execution of hardware vendor specific steps before or after Azure Stack HCI Operating System updates, when no updates to the Solution Builder Extension are needed. <br/><br/> Hardware vendors typically use this capability to prepare nodes for any update related tasks that may involve rebooting machines. |

## Identify a Solution Builder Extension update for your hardware

Starting with Azure Local 2311.2, any new Integrated Systems or Premier Solution hardware added to the Azure Local catalog must implement a Solution Builder Extension that supports firmware and driver updates. Microsoft recommends purchasing newer Integrated Systems and Premier Solutions to fully utilize the update-at-scale capabilities enabled by the Solution Builder Extension.

> [!NOTE]
> A Solution Builder Extension might not be implemented for your hardware if:
>
> - It was added to the Azure Local catalog before Azure Local 2311.2.
>
> - Your hardware was purchased as a Validated Node.
>
> Consult with your hardware vendor’s Azure Local documentation to determine if your machine model supports a Solution Builder Extension.

If your hardware doesn't support a Solution Builder Extension update experience, the process for updating your hardware is like that of Azure Local, version 22H2. This means that your hardware updates may be available using Windows Admin Center. For more information, see  [Update Azure Local, version 22H2](../manage/update-cluster.md#install-operating-system-and-hardware-updates-using-windows-admin-center).

Here's an example of the Windows Admin Center updates tool for systems running Azure Local.

[![Screenshot to install hardware updates in Windows Admin Center.](./media/solution-builder-extension/updates-os-windows-admin-center-23h2.png)](media/solution-builder-extension/updates-os-windows-admin-center-23h2.png#lightbox)

Your firmware and driver updates may need to be performed separately, if your hardware doesn't support hardware updates using Solution Builder Extension packages or Windows Admin Center. Follow the recommendations of your hardware vendor.

The following table provides the hardware update method for different hardware vendors along with their respective platform series and generations.

| Solution Builder (machine hardware vendor) | Platform series/generation | Hardware Update Method  | For more information  |
|-----------------|------------------|---------------|-------------------|
| DataON   | Models starting with S2D6, S2D7, AZS6, AZS7   | Solution Builder Extension | [Must Stay Up to Date - DataON](https://www.dataonstorage.com/dataon-must/must-stay-up-to-date/) |
| DataON  | Other Integrated Systems and Validated Nodes (not previously listed)    | [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/DataON.MUSTPro/overview/3.2.6) | [Enhancing the Windows Admin Center Experience with DataON MUST](https://www.dataonstorage.com/must/windows-admin-center/)                   |
| Dell Technologies  | Premier Solutions: </br><br> MC-660, MC-760 | APEX Cloud Platform Hardware Updates (Solution Builder Extension) | [Support Matrix of Dell APEX Cloud Platform for Microsoft Azure](https://dl.dell.com/content/manual34666301-dell-apex-cloud-platform-for-microsoft-azure-support-matrix.pdf) |
| Dell Technologies | **15G and 16G Integrated Systems - Instances running Azure Stack HCI OS, version 23H2**:</br><br> AX-650, AX-750, AX-6515, AX-7525, AX-4510c, AX-4520c, AX-660, AX-760 | Solution Builder Extension (once available)  | [Dell Solution Builder Extensions for Azure Local Integrated System AX Server Release Notes](https://www.dell.com/support/kbdoc/en-us/000224407) |
| Dell Technologies | **15G Integrated Systems - Instances running Azure Stack HCI OS, version 22H2**:</br><br> AX-650, AX-750, AX-6515, AX-7525, AX-4150c, AX-4520c | [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/dell-emc.openmanage-integration/overview/3.2.0)  | [E2E Deployment and Operations Guide - Cluster Creation Using Windows Admin Center (WAC) \| Dell Technologies Info Hub](https://infohub.delltechnologies.com/en-us/t/e2e-deployment-and-operations-guide-cluster-creation-using-windows-admin-center-wac-1/) |
| Dell Technologies | 14G Integrated Systems - Instances running Azure Stack HCI OS, version 22H2:</br><br> AX-740xd, AX-640 | [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/dell-emc.openmanage-integration/overview/3.2.0) | [E2E Deployment and Operations Guide - Cluster Creation Using Windows Admin Center (WAC) \| Dell Technologies Info Hub](https://infohub.delltechnologies.com/en-us/t/e2e-deployment-and-operations-guide-cluster-creation-using-windows-admin-center-wac-1/) |
| Hewlett Packard Enterprise | Newer integrated systems:</br><br> DL380 Gen11 (only SKU P65984-B21)</br>DL145 Gen11 (only SKU P78955-B21)  | Solution Builder Extension | 1. Install [Standard Solution Builder Extension](https://myenterpriselicense.hpe.com/cwp-ui/product-details/SBE_UPDATES/-/sw_free) |
| Hewlett Packard Enterprise | Other models | Solution Builder Extension and [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/hpe.hci.snap-in/overview/1.3.0) | 1. Install [Minimal Solution Builder Extension](https://myenterpriselicense.hpe.com/cwp-ui/product-details/SBE_UPDATES/-/sw_free) </br><br> 2. Install hardware updates via [Windows Admin Center](https://www.hpe.com/us/en/alliance/microsoft/ws-admin-center.html) |
| Lenovo | ThinkAgileMXPremier family servers:</br><br> ThinkAgile MX455 V3 Edge PR </br> ThinkAgile MX650 V3 PR | Solution Builder Extension | [ThinkAgileMXPremier Family SBE](https://pubs.lenovo.com/thinkagile-mx/mx_sbe) |
| Lenovo | ThinkAgileMXStandard family servers:</br><br> ThinkAgile MX 455 V3 Edge IS </br> ThinkAgile MX 650 V3 IS </br> ThinkAgile MX 650 V3 CN </br> ThinkAgile MX 450 Edge IS </br> ThinkAgile MX 630 V3 IS </br> ThinkAgile MX 630 V3 CN  | Solution Builder Extension | [ThinkAgileMXStandard Family SBE](https://pubs.lenovo.com/thinkagile-mx/mx_sbe) |
| Lenovo | Other Integrated Systems and Validated Nodes (not previously listed)  | [Windows Admin Center Extension](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/lnvgy_sw_xclarity_integrator_for_wac/overview/4.5.1) | [Lenovo XClarity Integrator for Microsoft Windows Admin Center](https://dev.azure.com/WindowsAdminCenter/Windows%20Admin%20Center%20Feed/_artifacts/feed/WAC/NuGet/lnvgy_sw_xclarity_integrator_for_wac/overview/4.5.1) |

## Check for SBE installation

To see if you have SBE installed on your registered Azure Local system, run the following command:

```powershell
$Update = Get-SolutionUpdateEnvironment
$Update | ft SbeFamily, HardwareModel, CurrentSbeVersion, State
```

Here's a sample output

```console
PS C:\Users\lcmuser> $Update = Get-SolutionUpdateEnvironment
PS C:\Users\lcmuser> $Update | ft SbeFamily, HardwareModel, CurrentSbeVersion, State

SbeFamily             HardwareModel       CurrentSbeVersion        State
---------             -------------       -----------------        -----
Gen A                 Contoso680          4.0.0.0                  UpdateAvailable
```

> [!NOTE]
> If you don't have an SBE installed the CurrentSbeVersion default is shown as 2.1.0.0.

The following table describes the possible states of the SBE on your Azure Local system. For states requiring action, follow the provided guidance.

| State    | Description     | Action    |
|-----------|----------------|-----------|
| AppliedSuccessfully | The SBE is installed and up to date.| No action required.|
| NeedsAttention | The SBE or Azure Local update requires attention.| [Troubleshoot solution updates for Azure Local](update-troubleshooting-23h2.md).|
| PreparationFailed | The system failed to prepare for the SBE or Azure Local update.| [Troubleshoot solution updates for Azure Local](update-troubleshooting-23h2.md).|
| PreparationInProgress | The system is preparing for an SBE or Azure Local update.| [Track system update progress and history](azure-update-manager-23h2.md#track-system-update-progress-and-history).|
| UpdateAvailable | A new SBE or Azure Local update is available.| [Discover Solution Builder Extension updates](#discover-solution-builder-extension-updates).|
| UpdateFailed | The SBE or Azure Local update failed.| [Troubleshoot solution updates for Azure Local](update-troubleshooting-23h2.md).|
| UpdateInProgress | An SBE or Azure Local update is in progress.| [Track system update progress and history](azure-update-manager-23h2.md#track-system-update-progress-and-history).|

## Discover Solution Builder Extension Updates

The Azure Local Lifecycle Management orchestration queries an established online SBE manifest endpoint for each hardware vendor to determine if there are any new SBE updates for your Azure Local instance. The process of checking for new updates and determining if they're applicable to your Azure Local instance is called **discovering** updates.

Microsoft and your hardware vendor work together to ensure only valid and supported update options are discovered. To determine if the extension updates match, the discovery process checks the current versions of your Azure Local instance against the validated versions recorded in the SBE manifest. If you see an SBE discovered as an option to install, it means your hardware vendor has validated and supports the new combination of SBE and Azure Local versions.

To discover and install SBE or your SBE updates, use one of the methods in the next sections.

### Discover Solution Builder Extension updates via the Azure portal

To discover and select updates via the Azure portal, see [Use Azure Update Manager to update Azure Local](../update/azure-update-manager-23h2.md#browse-for-system-updates).

### Discover Solution Builder Extension updates via PowerShell

Before you can install your SBE updates, sign in to the client with the domain user credentials that you provided during the deployment of the system.

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
Azure Local 2311 bundle      Solution    10.2311.0.26 4.1.2312.5     Ready 
```

In the sample output, you can see that two updates are ready to be installed: the standalone **SBE_Contoso_Gen3_4.1.2312.5** update and the combined **Azure Local 2311 bundle** update, which includes the same Solution Builder Extension as identified by the SbeVersion number 4.1.2312.5.

> [!NOTE]
> Microsoft recommends installing the combined "Solution" update in most cases, to reduce the number of update operations needed to keep your system up to date. You can refer to the `SBEReleaseLink` and `SBENotifyMessage` properties, provided by your hardware vendor in the `AdditionalProperties` of the update, to determine if there's an urgent reason to install a Solution Builder Extension update before the combined solution update.

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

While Azure Local can automatically discover Solution Builder Extension updates, in many cases, Solution Builder Extension packages must be downloaded from the hardware vendor’s support site and then imported into the system.

The **AdditionalContentRequired** state is used to identify files that must be imported before the update can be installed.

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
Azure Local 2311 bundle          Solution    10.2311.0.26 4.1.2312.5     AdditionalContentRequired
```

To view information on the Solution Builder Extension update such as its release notes (via the `SBEReleaseLink`) and determine how to download the Solution Builder Extension files from your hardware vendor, use the updates `AdditionalProperties` property of the updates.

For more information, see [Discover Solution Builder Extension updates](#discover-solution-builder-extension-updates). You should download the Solution Builder Extension files following the hardware vendor's recommendations and license agreements.

## Next steps

- [Import and discover solution updates](../update/update-via-powershell-23h2.md#step-3-import-and-rediscover-updates).
- [Understand update phases of Azure Local](../update/update-phases-23h2.md).