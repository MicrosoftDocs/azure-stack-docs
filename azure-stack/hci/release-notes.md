---
title: Azure Stack HCI release notes
description: Release notes for Azure Stack HCI, version 20H2.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/13/2020
---

# Release notes for Azure Stack HCI Public Preview

> Applies to: Azure Stack HCI, version 20H2

This article describes the contents of Azure Stack HCI Public Preview update packages.

## October 13, 2020 Security Update (KB4580363)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This update contains miscellaneous security improvements to internal OS functionality. No additional issues were documented for this release.

For more information about the resolved security vulnerabilities, please refer to the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance).

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The October 13, 2020 security update (KB4580363) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1288), download the [file information for cumulative update 4580363](https://download.microsoft.com/download/f/7/8/f78801f0-e7e5-4a3d-a971-f642ccd24ee4/4580363.csv).

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## October 13, 2020 Servicing Stack Update (KB4583287)

This update includes quality improvements for the latest release of Azure Stack HCI.

### Improvements and fixes
This update makes quality improvements to the servicing stack, which is the component that installs updates. Servicing stack updates (SSU) makes sure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.

### How to get this update
The October 13, 2020 servicing stack update (KB4583287) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### Restart information
You don't have to restart your computer after you apply this update.

### Removal information
Servicing stack updates (SSUs) make changes to how updates are installed and cannot be uninstalled from the device.

### File information
For a list of the files that are provided in this update (OS Build 17784.1287), download the [file information for cumulative update 4583287](https://download.microsoft.com/download/b/8/5/b85160fb-85d9-49f9-b9d5-7dbc0158a944/4583287.csv).

### References

For information on SSUs, see the following articles:

- [Servicing stack updates](/windows/deployment/update/servicing-stack-updates)
- [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/help/4535697)

Learn about the [terminology](https://support.microsoft.com/help/824684) that Microsoft uses to describe software updates.

## September 17, 2020 Preview Update (KB4577629)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This nonsecurity update includes quality improvements. Key changes include:
- Addressed an issue where Software Load Balancer (SLB) traffic going through the Multiplexer might be redirected to a different host that can cause an application connection failure.

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The September 17, 2020 security update (KB4577629) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1259), download the [file information for cumulative update 4577629](https://download.microsoft.com/download/9/1/a/91addcbb-2b36-408c-ab88-736de42edb98/4577629.csv)

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## September 8, 2020 Security Update (KB4577470)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This update contains miscellaneous security improvements to internal OS functionality. No additional issues were documented for this release.

For more information about the resolved security vulnerabilities, please refer to the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance).

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The September 8, 2020 security update (KB4577470) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1226), download the [file information for cumulative update 4577470](https://download.microsoft.com/download/3/c/4/3c468525-5867-4cc3-8d34-dba88989adab/4577470.csv).

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## September 8, 2020 Servicing Stack Update (KB4577558)

This update includes quality improvements for the latest release of Azure Stack HCI.

### Improvements and fixes
This update makes quality improvements to the servicing stack, which is the component that installs updates. Servicing stack updates (SSU) makes sure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.

### How to get this update
The September 8, 2020 servicing stack update (KB4577558) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### Restart information 
You don't have to restart your computer after you apply this update.

### Removal information
Servicing stack updates (SSUs) make changes to how updates are installed and cannot be uninstalled from the device.

### File information
For a list of the files that are provided in this update (OS Build 17784.1220), download the [file information for cumulative update 4577558](https://download.microsoft.com/download/8/f/6/8f612a9b-cb4e-4832-9397-156760848592/4577558.csv).

### References

For information on SSUs, see the following articles:

- [Servicing stack updates](/windows/deployment/update/servicing-stack-updates)
- [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/help/4535697)

Learn about the [terminology](https://support.microsoft.com/help/824684) that Microsoft uses to describe software updates.

## August 11, 2020 Security Update (KB4574585)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This update contains miscellaneous security improvements to internal OS functionality. No additional issues were documented for this release.

For more information about the resolved security vulnerabilities, please refer to the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance).

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The August 11, 2020 security update (KB4574585) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1162), download the [file information for cumulative update 4574585](https://download.microsoft.com/download/7/f/4/7f451def-76c5-4cc0-9929-0c5efeb27d2f/4574585.csv).

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.