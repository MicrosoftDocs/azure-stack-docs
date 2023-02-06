---
title: Known issues in Azure Stack HCI (preview)
description: Read about the known issues in Azure Stack HCI (preview).
author: alkohli
ms.topic: conceptual
ms.date: 1/12/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI, 2210 Supplemental Package release (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-supplemental-package.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

This article applies to Azure Stack HCI, Supplemental Package, for 2210 public preview release. This release maps to software version number **10.2210.0.32**. This release supports brand new software installation using a deployment tool. For more information, see [What's new in 22H2](whats-new.md#azure-stack-hci-supplemental-package-preview) and [What's in preview](./manage/whats-new-preview.md#azure-stack-hci-supplemental-package-preview).

[!INCLUDE [important](../includes/hci-preview.md)]

## Known issues

Here are the known issues in Azure Stack HCI supplemental package:

|#|Feature|Issue|Workaround|
|-|------|------|----------|
|1|Deployment |Failure in ECE – *Set-RoleDefinition: Can't find the element 'NodeDefinition' for the role NC*|Make sure that a DVD isn't inserted in the physical machine or mounted via the Baseboard Management Controller (BMC).|
|2|Deployment |Only the first host can be the staging server.|There's no workaround for this issue in this preview release.|
|3|Deployment |During deployment, an error is seen in Windows Admin Center: Remote Exception "GetCredential" with "1".|Reboot the staging server and run the bootstrap script again. Make sure that the Azure credentials for the subscription haven't expired and are correct.|
|4|Deployment |Renaming the network adapter in the deployment tool and using the **Back** and **Next** buttons causes it to hang.|There's no workaround for this is in the preview release.|
|5|Arc VM and AKS Hybrid workload deployment |In this release, Windows Defender App Control (WDAC) is enabled by default on Azure Stack HCI servers. If you are deploying Arc VM or AKS Hybrid workloads, you would see an error while importing the Arc Resource Bridge PowerShell module. |The workaround is to switch WDAC policy mode to `Audit` instead of `Enforced`. For more information, see [Enable WDAC policy modes](./concepts/security-windows-defender-application-control.md#enable-wdac-policy-modes). <br> After the workload deployment is complete, you can run the cmdlet to switch WDAC policy mode back to the default enforced mode.|
|6|Deployment |If you have an Azure policy assigned to the Azure subscription that enforces tags, the deployment fails.||
|7|OS update|After deployment, scanning for OS updates using *SConfig* or Cluster-Aware Updating may fail to scan Windows Update.|Manually enable and start the *wuauserv* service. Run the following PowerShell commands: <br>`Set-Service -Name WUAUServ -StartupType Auto -Verbose`<br/>`Start-Service -Name WUAUServ`|
|8|Deployment|Cluster creation will fail with the error "Microsoft-Windows-Kerberos-Key-Distribution-Center Event ID 14 error event" in the System section of Event Log on your domain controller.|Search for and install the following cumulative updates:<br>Windows Server 2022: [KB5021656](https://support.microsoft.com/help/5021656)<br>Windows Server 2019: [KB5021655](https://support.microsoft.com/help/5021655)<br>Windows Server 2016: [KB5021654](https://support.microsoft.com/help/5021654)<br>To get the standalone package for these out-of-band updates, search for the KB number in the Microsoft Update Catalog. You can manually import these updates into Windows Server Update Services (WSUS) and Microsoft Endpoint Configuration Manager. For WSUS instructions, see [WSUS and the Catalog Site](/windows-server/administration/windows-server-update-services/manage/wsus-and-the-catalog-site#the-microsoft-update-catalog-site). For Configuration Manger instructions, see [Import updates from the Microsoft Update Catalog](/mem/configmgr/sum/get-started/synchronize-software-updates#import-updates-from-the-microsoft-update-catalog). |
|9|Deployment|Rebooting a cluster node can result in a prompt for the BitLocker recovery key.|First, always ensure that BitLocker recovery keys are securely stored outside the cluster after deployment.<br/><br/>Enter the BitLocker recovery key and once the machine is booted, run the following two commands to mitigate the issue:<br/><br/>`Suspend-AzsOSVolumeEncryption`<br/>`Resume-AzsOSVolumeEncryption`|
|10|Environment Checker| If SSL inspection is turned on in your Azure Stack HCI system, the connectivity validator fails with the certificate validation error message.  | For information about the error and how to troubleshoot it, see [Potential failure scenario for connectivity validator](./manage/use-environment-checker.md#potential-failure-scenario-for-connectivity-validator).|
|11|Deployment| AzureStackHCI module may cause the deployment to fail with the following exception: "HCI Registration failed. Error: Could not load file or assembly 'Newtonsoft.Json, Version=10.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed' or one of its dependencies. The system cannot find the file specified." | Use the following workaround and resume the deployment: <br>`Uninstall-Module Az.Stackhci -Force`<br>`Uninstall-Module Az.Accounts -Force`<br>`Install-Module Az.Accounts -RequiredVersion 2.10.4`<br>`Install-Module Az.StackHci -RequiredVersion 1.4.1`.|


## Next steps

- Read the [Deployment overview](./deploy/deployment-tool-introduction.md).
