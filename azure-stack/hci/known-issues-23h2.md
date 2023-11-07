---
title: Release notes with known issues in Azure Stack HCI 23H2 2310 release (preview)
description: Read about the known issues in Azure Stack HCI 2310 public preview release (preview).
author: alkohli
ms.topic: conceptual
ms.date: 11/06/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# View known issues in Azure Stack HCI, version 23H2 release (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article identifies the critical known issues and their workarounds in Azure Stack HCI.

The release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy your Azure Stack HCI, carefully review the information contained in the release notes.

This software release maps to software version number **10.2310.0.30**. This release only supports new deployments.

For more information about the new features in this release, see [What's new in 23H2](whats-new.md).

[!INCLUDE [important](../includes/hci-preview.md)]

## Known issues for version 2310

Here are the known issues in version 2310 release:

|Release|Feature|Issue|Workaround/Comments|
|-|------|------|----------|
|2310 <br> 10.2310.0.30| Networking |Use of proxy is not supported in this release. |There's no known workaround in this release. |
|2310 <br> 10.2310.0.30| Deployment |Entering an incorrect DNS updates the DNS configuration in hosts during the validation and the hosts can lose internet connectivity. |There's no known workaround in this release. |
|2310 <br> 10.2310.0.30| Deployment |Providing the OU name in an incorrect syntax is not detected in the Azure portal. The incorrect syntax is however detected at a later step during cluster validation. |There's no known workaround in this release. |
|2310 <br> 10.2310.0.30| Deployment |On modern server hardware, a USB network adapter is created to access the Baseboard Management Controller (BMC). This adapter can cause the cluster validation to fail during the deployment.| Make sure to disable the BMC network adapter before you begin cloud deployment.|
|2310 <br> 10.2310.0.30| Deployment |A new storage account is created for each run of the deployment. Existing storage accounts aren't supported in this release.| |
|2310 <br> 10.2310.0.30| Deployment |A new key vault is created for each run of the deployment. Existing key vaults aren't supported in this release.| |
|2310 <br> 10.2310.0.30| Deployment |The network direct intent overrides defined on the template aren't working in this release.|Use the ARM template to override this parameter and disable RDMA for the intents. |
|2310 <br> 10.2310.0.30| Deployment |Deployments via Azure Resource Manager time out after 2 hours. Deployments that exceed 2 hours show up as failed in the resource group though the cluster is successfully created.| To monitor the deployment in the Azure portal, go to the Azure Stack HCI cluster resource and then go to new **Deployments** entry. |
|2310 <br> 10.2310.0.30| Deployment |If you select **Review + Create** and you haven't filled out all the tabs, the deployment begins and then eventually fails.|There's no known workaround in this release. |
|2310 <br> 10.2310.0.30| Deployment | A resource group with multiple clusters only shows one storage path.| Multiple clusters are not supported for a single resource group in this release.|
|2310 <br> 10.2310.0.30 | Deployment | Marketplace image download provisioning state not matching download percentage on Azure Stack HCI cluster.| There's no known workaround in this release.|
|2310 <br> 10.2310.0.30 <!--25420275-->|Security |When using the `Get-AzsSyslogForwarder` cmdlet with `-PerNode` parameter, an exception is thrown. You aren't able to retrieve the `SyslogForwarder` configuration information of multiple nodes. |The workaround is to go to each server and check the local configuration state of the Syslog component.|


## Next steps

- Read the [Deployment overview](./deploy/deployment-introduction.md).
