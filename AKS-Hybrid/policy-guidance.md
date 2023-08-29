---
title: Azure policy guidance for AKS hybrid
description: Learn about AKS hybrid best practices and guidance in using Azure policy.
ms.topic: article
ms.date: 08/25/2023
author: sethmanheim
ms.author: sethm
ms.lastreviewed: 05/03/2023
ms.reviewer: sulahiri

---

# Azure policy in AKS hybrid

This article provides guidance on applying Azure policies to management clusters and recommendations for deploying AKS hybrid.

## Best practices in using Azure policies

Azure policies are set at the subscription level. By default, the policies apply to both management and target/workload clusters.

### Different subscriptions for different environments

Before launching a policy in production, it's recommended that you test it in a preproduction environment. Because policies are set at the subscription level, it's best to keep preproduction and production environments on separate subscriptions.

### Policy testing in audit mode

Before enforcing a policy in preproduction or production environments, verify its functionality in audit mode.

## Considerations for applying Azure policies to AKS hybrid management clusters

Enforcement mode for Azure policy should not be enabled for management clusters. This is because management clusters don't run customer workloads. Enforcing Azure policies can cause some pods not to start.

### Disable enforcement mode on management clusters

The management cluster and target cluster, being on the same subscription, inherit the same Azure policies by default. To prevent management clusters from running Azure policies in enforcement mode, place the management and target clusters in different resource groups and apply an exclusion policy to the management cluster resource group. For more information about exclusion policy application, see [Azure Policy exemption structure](/azure/governance/policy/concepts/exemption-structure).

### Monitor management clusters

Azure policies are primarily for declarative compliance validation, not behavior-based threat detection. If there is concern about the security posture of the management cluster, a threat monitoring tool to track suspicious activities should be evaluated.

## Next steps

[Security concepts in AKS hybrid](concepts-security.md)