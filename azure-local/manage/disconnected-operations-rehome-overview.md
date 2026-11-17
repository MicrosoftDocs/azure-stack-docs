---
title: Rehome Azure Local to disconnected operations (preview)
description: Learn how rehoming moves management of an Azure Local instance to disconnected operations without moving workloads, data, or infrastructure.
ms.topic: overview
author: nikuntjo
ms.author: nikuntjo
ms.reviewer: koryd
ms.date: 11/09/2026
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Rehome a connected Azure Local instance to disconnected operations (preview)

::: moniker range=">=azloc-2611"

Rehoming moves the management of an existing Azure Local instance from Azure to [disconnected operations for Azure Local](disconnected-operations-overview.md). Your virtual machines (VMs), Azure Kubernetes Service (AKS) clusters, storage, and networks stay where they are and keep running. Only the resource registrations and management information move, so you manage the instance locally instead of from Azure.

Learn what rehoming is, when to use it, how it works, what's supported in the preview, and how to get access.

> [!IMPORTANT]
> Rehoming is currently in PREVIEW and is available by request only.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Why rehome?

Requirements change after an Azure Local instance is deployed. Rehoming lets you switch an existing instance to a fully disconnected operating model without redeploying the infrastructure or rebuilding workloads. Common reasons include:

- **New sovereignty or regulatory requirements**: Data, operations, and control must now stay inside your organization's boundary.
- **Changing connectivity**: A site is moving to a network that can't maintain a connection to Azure.
- **Security posture**: You want to reduce the external attack surface of an existing deployment.

Without rehoming, moving to disconnected operations means deploying a new instance and migrating every workload to it.

## What moves and what stays

| Stays in place on the Azure Local instance | Moves to disconnected operations |
|---|---|
| Running VMs and AKS clusters (no restart, no redeployment) | Azure Arc registration of the machines in the instance |
| Virtual hard disks, storage paths, and data | Azure Local instance (cluster) resource |
| Logical networks and network configuration | Azure Arc resource bridge and custom location (replaced with new ones in disconnected operations) |
| Applications, in-guest secrets, and SSH keys inside workloads | Resource records for storage paths, logical networks, images, disks, network interfaces, VMs, and AKS clusters |
| Physical machines and hardware | Role assignments and managed identities (re-created, not copied) |

Only resources and features that disconnected operations supports are rehomed. Existing resources and workloads running in the cloud remain unaffected. For what's available, see [Supported services](disconnected-operations-overview.md#supported-services).

After rehoming, you manage these resources from the local portal, Azure Resource Manager (ARM), and Azure CLI that disconnected operations provides.

## How rehoming works

Rehoming is a guided workflow that you run and approve step by step. It runs from the command line on an Azure Arc-enabled Windows machine that can reach Azure, disconnected operations, and every machine in your instance.

Rehoming happens in four stages:

| Stage | What happens |
|---|---|
| **Prepare and capture** | Rehoming checks that your environment is ready, then takes a verified snapshot of your resources, their dependencies, and their role assignments. Nothing in your instance changes. |
| **Review and approve** | You review the plan and approve it. Nothing that changes your instance runs until you approve. |
| **Switch to disconnected operations** | Each machine in the instance reconnects to disconnected operations, and a new Azure Arc resource bridge and custom location are deployed there. |
| **Re-create and verify** | Your storage, networks, images, disks, VMs, AKS clusters, and role assignments are re-created in disconnected operations in the right order. You then confirm that everything is in place. |

### When you can no longer switch back to Azure

You can stop and switch the instance back to Azure at any point before the machines in your instance reconnect to disconnected operations. Your instance continues to run as it did before you started.

**After the machines reconnect, you can't switch the instance back to Azure or restore its original Azure Arc resource bridge.** From that point, rehoming can only continue forward to disconnected operations. Before that step, you can run a test that checks everything without making changes.

### What to expect during rehoming

Your workloads keep running the whole time. While the instance is switching to disconnected operations, you can't use the portal or command line to create, resize, start, or stop VMs or other resources. Plan a maintenance window for management tasks.

### Built-in safeguards

- **You stay in control**: You start each step yourself. Nothing advances on its own.
- **Test before change**: You can test steps to see what they'll do before anything changes.
- **Verified backup**: Rehoming confirms that its backup is complete and can be restored before it makes changes to your instance.
- **Pause and resume**: Progress is saved after each step, so you can stop, investigate, and continue later.
- **Local audit trail**: Logs and approval records stay on your premises, with no dependency on a cloud connection.
- **Limited privilege**: Rehoming never creates identities or raises its own permissions. You create and scope every account it uses.

## Identity and access

Identities aren't copied between directories. Your connected instance uses Microsoft Entra ID. Disconnected operations uses Active Directory for users and groups, and Active Directory Federation Services (AD FS) for sign-in. For more information, see [Plan your identity for disconnected operations](disconnected-operations-identity.md).

When you rehome:

- **Managed identities** for the instance, machines, resource bridge, VMs, and AKS clusters are created new in disconnected operations, and they receive the same built-in roles they had before.
- **Built-in roles** are matched exactly. If a role isn't available in disconnected operations, rehoming reports it for your review instead of substituting a different role.
- **Users, groups, and service principals** that had access to the instance in Azure don't exist in your local directory. Rehoming lists each one so you can give the equivalent Active Directory user or group access.

### If you use a third-party identity provider

If your organization signs in to Azure through a third-party identity provider that's federated with Microsoft Entra ID, the people and groups who manage the instance today need equivalent accounts in Active Directory before you rehome. Disconnected operations signs users in through AD FS and reads groups from Active Directory.

## Billing

Rehoming adds the rehomed instance to your disconnected operations license. Disconnected operations is billed per physical processor core on a capacity-based, annual term, billed monthly through Azure. For more information, see [Billing for disconnected operations](disconnected-operations-billing.md).

Before you rehome, increase the number of cores on your disconnected operations license to include every physical core in the instance you're rehoming. Billing adjusts for the rest of the license term. The core count and pricing you commit to apply for at least one year.

What happens to the original instance in Azure depends on whether it can reach Azure when you rehome:

- **Connected to Azure**: The original Azure Local instance resources in Azure are deleted automatically, and billing for the connected instance stops.
- **Not connected to Azure**: The original resources remain in Azure and show as disconnected. They're billed until the instance has been disconnected for more than 31 days. To stop billing sooner, delete them after you rehome.

Deleting the original resources in Azure doesn't affect your workloads or the rehomed instance.

## Preview scope

| Supported in preview | Not supported in preview |
|---|---|
| Moving a connected Azure Local instance to disconnected operations | Moving from disconnected operations back to Azure |
| Hyperconverged deployments | Azure Local rack scale |
| One instance at a time | Several instances at once |
| Azure Local VMs, including Trusted launch VMs | Moving between Azure regions |
| AKS enabled by Azure Arc clusters | Portal experience (command line only) |

### Preview limitations

During the preview, some steps that will be automated later are manual:

- Final validation of the rehomed instance.
- Giving your Active Directory users and groups access after rehoming.
- Reconnecting guest management inside VMs, if you use Arc-enabled server features in your VMs.
- Checking that your extensions are supported in disconnected operations. Extensions running on rehomed resources might stop running or require reconfiguration.
- Registering the Lifecycle Manager extension in disconnected operations.

When your request is approved, the Azure Local team shares guidance for each of these steps.

## Get access to the preview

Request access to the preview. To request access, complete the [rehoming preview access request form](https://aka.ms/RehomePP). The Azure Local team reviews each request and contacts you with next steps.

Before you request access, confirm that you meet the [eligibility criteria for disconnected operations](disconnected-operations-overview.md#eligibility-criteria), including an active support plan (Standard or higher).

## Related content

- [Disconnected operations for Azure Local overview](disconnected-operations-overview.md)
- [Plan your identity for disconnected operations](disconnected-operations-identity.md)
- [Billing for disconnected operations](disconnected-operations-billing.md)

::: moniker-end

::: moniker range="<=azloc-2610"

This feature is available only in Azure Local 2611 or later.

::: moniker-end
