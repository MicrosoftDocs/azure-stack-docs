---
title: Plan for an Azure Stack update | Microsoft Docs
description: Learn to plan for an Azure Stack update.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/17/2019
ms.author: mabrigg
ms.lastreviewed: 08/23/2019
ms.reviewer: ppacent 

---

# Plan for an Azure Stack update

*Applies to: Azure Stack integrated systems*

You can prepare your Azure Stack to make the update process go as smoothly as possible so that there is a minimal impact on your users. In this article, review steps for notifying your users of possible service outages, and steps you will want to take to prepare for an update.

## Notify your users of maintenance operations

You should notify users of any maintenance operations, and that you schedule normal maintenance windows during non-business hours if possible. Maintenance operations can affect both tenant workloads and portal operations.

## Prepare for an Azure Stack update

You can prepare to the update by making sure you have applied all the hotfixes, security patches, and OEM updates, validated the health of your Azure Stack instance, checked the available capacity, and reviewed the update package.

1. Review known issues. For instructions, see [Azure Stack Known Issues](https://docs.microsoft.com/azure-stack/operator/release-notes).

2. Review security updates. For a list of updates, see [Azure Stack security updates](https://docs.microsoft.com/azure-stack/operator/release-notes-security-updates).

3. Before you start installation of this update, run [Test-AzureStack](https://docs.microsoft.com/azure-stack/operator/azure-stack-diagnostic-test) to validate the status of your Azure Stack and resolve any operational issues found, including all warnings and failures. Also review active alerts and resolve any that require action.

    1. Open a Privileged Endpoint Session from a machine with network access to the Azure Stack ERCS VMs. For instructions on using the PEP, see [Using the privileged endpoint in Azure Stack](https://docs.microsoft.com/azure-stack/operator/azure-stack-privileged-endpoint).

    2. Test-AzureStack -Group UpdateReadiness

    3. Review the output and resolve any health errors. For more information, see [Run a validation test of Azure Stack](https://docs.microsoft.com/azure-stack/operator/azure-stack-diagnostic-test).

4. Resolve issues. You can refer to the Monitor health and alerts topic for guidance on learning more about the flagged issue. For instructions, see [Monitor health and alerts in Azure Stack](https://docs.microsoft.com/azure-stack/operator/azure-stack-monitor-health).

5. Apply latest hotfixes. For a list of the latest hotfixes, see the release notes Hotfix section. Repeat steps 3 and 4 after applying the latest hotfix.

6. Ensure your OEM package is compatible with the Azure Stack version you are updating to. If your OEM package is not compatible with the Azure Stack version you are updating to, you will need to perform an OEM package update before running an Azure Stack update. For instructions, see "Apply Azure Stack original equipment manufacturer (OEM) updates." Repeat steps 3 and 4 after applying the OEM package update.

7. Run the capacity planner tool. For an overview and instructions on using the tool, see [Overview of Azure Stack capacity planning](https://docs.microsoft.com/azure-stack/operator/azure-stack-capacity-planning-overview).

8. Optionally, you can [enable automatic diagnostic log collection](azure-stack-configure-automatic-diagnostic-log-collection.md) to proactively collect logs for customer support analysis if the update fails with an alert such as **Update failed**. 

8. Review the update package. When planning for your maintenance window, it's important to review the specific type of update package released from Microsoft as called out in the release notes.

## Next steps

[Apply the Azure Stack update](azure-stack-apply-updates.md).
