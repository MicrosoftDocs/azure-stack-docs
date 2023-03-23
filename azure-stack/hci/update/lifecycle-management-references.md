---
title:  Lifecycle Management references.
description: This article describes the readiness checks, progress actions, and more associated with the Lifecycle Manager.
author: ronmiab
ms.author: robess
ms.topic: reference
ms.reviewer: aaronfa
ms.lastreviewed: 03/20/2023
ms.date: 03/22/2023
---

# Lifecycle Management references

> Applies to: Azure Stack HCI, Supplemental Package

This article describes the readiness checks, progress actions, and more associated with the Lifecycle Manager.

## Readiness checks

Readiness checks are used to ensure the system is in a good state to install an update. The goal is to minimize disruption to workloads, and to reduce the chance of the update failing. Returned checks contain the following information, similar to the [Environment Checker](../manage/use-environment-checker.md):

|Attribute name     | Description                                                            |
|-------------------|------------------------------------------------------------------------|
|Name               | Name of the test.                                                      |
|Title              | User-facing description of the test.                                   |
|Severity           | Critical, Warning, Informational, or Hidden.                           |
|Description        | Overview of the issue and its effect on the cluster.                   |
|Tags               | Internal Key-value pairs to group or filter tests.                     |
|Status             | Succeeded, Failed, or In Progress.                                     |
|Remediation        | URL link to documentation for remediation.                             |
|TargetResourceID   | Unique identifier for the affected resource (such as a node or drive). |
|TargetResourceName | Name of the affected resource.                                         |
|TargetResourceType | The type of affected resource.                                         |
|Timestamp          | The time that the test was called.                                     |
|AdditionalData     | Property bag of key value pairs for additional information.            |
|HealthCheckSource  | The name of the services called for the health check.                  |

Currently, the Lifecycle Manager checks the following criteria:

- **Cluster-Aware Updating setup**. Cluster-Aware Updating is required for installing certain update content. This test evaluates its configuration requirements. For more information, see [Cluster-Aware Updating requirements and best practices](/windows-server/failover-clustering/cluster-aware-updating-requirements).

- **Memory usage**.

- **CPU usage**.

- **Storage health and capacity**. Here the configuration and capacity of your disks, volumes, and CSVs are tested.

- **Open alerts**. Shows open Health Service alerts, which include faults in the [Windows Health Service](../manage/health-service-faults.md). Open alerts that are **Critical** must be reviewed and closed before performing an update.

- **Workloads that cannot be migrated**.

## Progress actions

The Lifecycle Manager updates its own agents to ensure it has the recent fixes corresponding to the update. There are a few steps taken by the Lifecycle Manager to achieve a successful update of its agents.

1. First, steps referred to as the "servicing stack" are performed:

    - Prepare the servicing stack.
    - Update the servicing stack.
    - Copy the servicing stack agents.
    - Use the latest servicing stack agents.

2. The Lifecycle Manager will begin installing new agents and services, after the servicing stack is updated.

3. Once new agents and services have been installed, the host OS is updated.

    > [!NOTE]
    > For step #3, updating the host OS uses Cluster-Aware Updating to orchestrate reboots.

4. If the update includes Solution Extension content from the Solution Builder, it's installed last with the use of Cluster-Aware Updating

## PowerShell commands

Include content from the Asz.Update PowerShell Module.docx document. This section may need to be linked to a separate article or specific modules need to be pulled from the document.

## Glossary

| Term                                   | Definition  | Notes     |
|----------------------------------------|-------------|-----------|
| Azure Arc                              |             |           |
| Azure Kubernetes Service (AKS)         |             |           |
| Bundle                                 |             |           |
| Hotfixes                               |             |           |
| Hotpatches                             |             |           |
| Latest Cumulative Update               |             |           |
| Lifecycle Manager                      |             |           |
| Original Equipment Manufacturer (OEM)  |             |           |
| Package                                |             |           |
| Platform                               |             |           |
| Small Business Enterprise (SBE)        |             |           |
| Software-defined Networking (SDN)      |             |           |
| Solution                               |             |           |
| Windows Admin Center                   |             |           |
