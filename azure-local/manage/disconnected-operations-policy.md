---
title: Use Azure Policy in a disconnected Azure Local environment (preview)
description: Learn how to use Azure Policy to enforce compliance and manage resources in a disconnected Azure Local environment (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 06/20/2025
ai-usage: ai-assisted
---

# Use Azure Policy in a disconnected Azure Local environment

::: moniker range=">=azloc-2506"

This article explains how to use Azure Policy in a disconnected Azure Local environment to enforce compliance and manage resources at scale. Azure Policy helps organizations meet standards by checking resource properties against business rules, even when disconnected from Azure cloud.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About using Azure Policy in Azure Local disconnected

Azure Policy helps you meet organizational standards by checking resource properties against business rules. These rules, described in JSON format, are called policy definitions. Assign these rules to scopes like subscriptions or individual resources in the Resource Manager scope. For more information, see [Overview of Azure Policy](/azure/governance/policy/overview).

In Azure Local disconnected operations, policy enforcement supports Arc-enabled Kubernetes and Arc-enabled servers. Some built-in policy definitions are included in the Azure Local disconnected operations deployment. Operators turn on these policies by creating policy assignments on the target scope using the disconnected operations portal or CLI. Enforcement depends on the policy type.

## Benefits

Azure Policy for Azure Local disconnected operations lets you enforce policies across all supported Azure services, so you manage and set up resources at scale.

With Azure Policy in a disconnected Azure Local environment, you:

- Ensure resource creation is consistent and compliant.
- Focus on high-sensitivity tasks. Azure Local disconnected operations are ideal for industries with strict regulations, and Azure Policy is essential for the success of the disconnected operations feature.
- Enforce policies across all supported Arc services on disconnected operations.

## Prerequisites

- You have access to an Azure Local instance with Azure Local disconnected operations deployed.
- Review built-in policies.
- Identify the policy definition you want to assign.

For more information, see [Supported built-in policies](#supported-built-in-policies).

## Enable Azure Policy

You can use Azure Policy to enforce tags on various resources. In this example, we've used a built-in policy that enforces tags on resource groups. This prevents the creation of resource groups without the required tag. To enable an Azure Policy, follow these steps:

### Set up the basics

1. Sign in to the Azure Local portal and navigate to **Policy**.

    :::image type="content" source="media/disconnected-operations/azure-policy/policy-main.png" alt-text="Screenshot of the Assign policy page in Azure Local portal showing policy assignment options." lightbox="media/disconnected-operations/azure-policy/policy-main.png":::

2. Under the **Authoring** section, choose **Assignments**, and then select **+ Assign policy**.

    :::image type="content" source="media/disconnected-operations/azure-policy/assign-policy.png" alt-text="Screenshot of the authoring and assignments page." lightbox="media/disconnected-operations/azure-policy/assign-policy.png":::

3. Identify the **Scope**, **Policy definition**, and **Assignment name**.

4. Toggle the **Policy enforcement** to **Enabled**.

5. Select **Parameters** to proceed to the next step.

    :::image type="content" source="media/disconnected-operations/azure-policy/policy-definitions.png" alt-text="Screenshot of the Assign policy basics and available policy definitions." lightbox="media/disconnected-operations/azure-policy/policy-definitions.png":::

### Set the parameters

1. In the **Parameters** section, provide the required **Tag name**.

2. Name your tag and select the **Review + create button**.

    :::image type="content" source="media/disconnected-operations/azure-policy/tag-name.png" alt-text="Screenshot of the parameters page to set a tag name." lightbox="media/disconnected-operations/azure-policy/tag-name.png":::

    After the policy is created, you can't create resource groups without the required tag.
    
    :::image type="content" source="media/disconnected-operations/azure-policy/created-tag.png" alt-text="Screenshot of the tag created and required for resource groups." lightbox="media/disconnected-operations/azure-policy/created-tag.png":::

## Supported built-in policies

The following table summarizes the built-in policies supported for Azure Local disconnected operations.

| Policy name | Description | Azure documentation link |
|--|--|--|
|**Category: Tags** |  |  |
| Add or replace a tag on resources. | - Adds or replaces the specified tag and value when any resource is created or updated.<br>- Existing resources can be remediated by triggering a remediation task.<br>- Doesn't modify tags on resource groups. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Add or replace a tag on resource groups. | - Adds or replaces the specified tag and value when any resource group is created or updated.<br>- Existing resource groups can be remediated by triggering a remediation task. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Add or replace a tag on subscriptions. | - Adds or replaces the specified tag and value on subscriptions via a remediation task.<br>- Existing resource groups can be remediated by triggering a remediation task. For more information, see [Azure Policy remediation](https://aka.ms/azurepolicyremediation). | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Add a tag to resources. | - Adds the specified tag and value when any resource missing this tag is created or updated.<br>- Existing resources can be remediated by triggering a remediation task.<br>- If the tag exists with a different value, it isn't changed.<br>- Doesn't modify tags on resource groups. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Add a tag to resource groups. | - Adds the specified tag and value when any resource group missing this tag is created or updated.<br>- Existing resource groups can be remediated by triggering a remediation task.<br>- If the tag exists with a different value, it isn't changed. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Add a tag to subscriptions. | - Adds the specified tag and value to subscriptions via a remediation task.<br>- If the tag exists with a different value, it isn't changed. For more information, see [Azure Policy remediation](https://aka.ms/azurepolicyremediation). | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Inherit a tag from the resource group. | - Adds or replaces the specified tag and value from the parent resource group when any resource is created or updated.<br>- Existing resources can be remediated by triggering a remediation task. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Inherit a tag from the subscription if missing. | - Adds the specified tag with its value from the containing subscription when any resource missing this tag is created or updated.<br>- Existing resources can be remediated by triggering a remediation task.<br>- If the tag exists with a different value, it isn't changed. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Inherit a tag from the resource group if missing. | - Adds the specified tag and value from the resource group when any resource which is missing this tag is created or updated.<br>- Existing resources can be remediated by triggering a remediation task.<br>- Existing resources can be remediated by triggering a remediation task.<br>- If the tag exists with a different value, it isn't changed. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Append a tag and its value from the resource group. | - Appends the specified tag and value from the resource group when any resource which is missing this tag is created or updated.<br>- Doesn't modify the tags of resources created before this policy was applied until those resources are changed.<br>- Doesn't modify the tags of resources created before this policy was applied until those resources are changed.<br>- New 'modify' effect policies are available that support remediation of tags on existing resources. For more information, see [Modify effect policies](https://aka.ms/modifydoc). | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Append a tag and its value to resources. | - Appends the specified tag and value when any resource which is missing this tag is created or updated.<br>- Doesn't modify the tags of resources created before this policy was applied until those resources are changed.<br>- Doesn't apply to resource groups.<br>- New 'modify' effect policies are available that support remediation of tags on existing resources (see https://aka.ms/modifydoc).| [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Append a tag and its value to resource groups. | - Appends the specified tag and value when any resource group which is missing this tag is created or updated.<br>- Doesn't modify the tags of resource groups created before this policy was applied until those resource groups are changed.<br>- New 'modify' effect policies are available that support remediation of tags on existing resources. For more information, see [Modify effect policies](https://aka.ms/modifydoc). | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Require a tag and its value on resources. | Enforces a required tag and its value on resource groups. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Require a tag on resources | Enforces existence of a tag. Doesn't apply to resource groups. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Require a tag and its value on resource groups. | Enforces a required tag and its value on resource groups. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Require a tag on resource groups. | Enforces existence of a tag on resource groups. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| **Category: Azure Kubernetes Service** |  |  |
| Kubernetes cluster containers CPU and memory resource limits shouldn't exceed the specified limits. | - Enforce container CPU and memory resource limits to prevent resource exhaustion attacks in a Kubernetes cluster.<br>- This policy is generally available for Kubernetes Service (AKS), and preview for Azure Arc enabled Kubernetes.<br>- For more information, see [Azure Kubernetes Service policy](https://aka.ms/kubepolicydoc). | [Azure Policy built-in definitions for Azure Kubernetes Service](/azure/aks/policy-reference) |
| Kubernetes cluster containers should only use allowed images. | - Use images from trusted registries to reduce the Kubernetes cluster's exposure risk to unknown vulnerabilities, security issues, and malicious images.<br>- For more information, see [Azure Kubernetes Service policy](https://aka.ms/kubepolicydoc). | [Azure Policy built-in definitions for Azure Kubernetes Service](/azure/aks/policy-reference) |
| Kubernetes cluster pod hostPath volumes should only use allowed host paths. | - Limit pod HostPath volume mounts to the allowed host paths in a Kubernetes Cluster.<br>- This policy is generally available for Azure Kubernetes Service (AKS), and Azure Arc enabled Kubernetes. For more information, see https://aka.ms/kubepolicydoc. | [Azure Policy built-in definitions for Azure Kubernetes Service](/azure/aks/policy-reference) |
| **Category: Guest configuration** |  |  |
| Configure Linux Server to disable local users. | - Creates a Guest Configuration assignment to configure disabling local users on Linux Server.<br>- This policy ensures that only a Microsoft Entra account or a list of explicitly allowed users can access Linux servers, improving overall security posture. | [Azure Policy built-in definitions for Azure Virtual Machines](/azure/virtual-machines/policy-reference) |
| Configure secure communication protocols, Transport Layer Security (TLS) 1.2, or TLS 1.3 on Windows servers. | - Creates a Guest Configuration assignment to configure specified secure protocol version (TLS 1.2 or TLS 1.3) on Windows machine.|  [Azure Policy built-in definitions for Azure Virtual Machines](/azure/virtual-machines/policy-reference) |
| Configure time zone on Windows machines. | This policy creates a Guest Configuration assignment to set specified time zone on Windows virtual machines. | [Azure Policy built-in definitions for Azure Virtual Machines](/azure/virtual-machines/policy-reference) |
| Requires resources to not have a specific tag. |     |    |
| Inherit a tag from the subscription. | - Adds or replaces the specified tag and value from the subscription when you create or update any resource.<br>- Existing resources can be remediated by triggering a remediation task. | [Assign policy definitions for tag compliance](/azure/azure-resource-manager/management/tag-policies) |
| Windows web servers should be configured to use secure communication protocols. |    |    |

## Unsupported features

In this preview, the compliance dashboard, remediation actions, and policy exemptions aren't supported.

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
