---
title: Frequently Asked Questions for Small Form Factor Deployments of Azure Local (preview)
description: This FAQ provides answers to common questions about small form factor deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.date: 05/04/2026
ms.topic: faq
ms.service: azure-local
ms.subservice: small-form-factor
---

# Frequently asked questions for small form factor deployments of Azure Local (preview)

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## How do I delete all the resources from a test?

You can delete test resources directly from the Azure portal or by using the Azure CLI. You can also delete the entire resource group to remove most associated resources. However, one resource isn’t deleted when you remove the resource group: the Azure Arc Site. To delete this resource, follow the documentation for [Azure Arc Site](/azure/azure-arc/site-manager/how-to-crud-site).

## Can I register the same device more than once?

No. A device can only have one active provisioned machine registration at a time. If you try to register a device that's already represented by a provisioned machine resource, delete the existing provisioned machine first, or delete the test resource group that contains it if you no longer need any of the resources in that group.

To delete only the provisioned machine by using Azure CLI, run:

```bash
az provisionedmachine delete --name <NAME_OF_MACHINE> --resource-group <RESOURCE_GROUP_NAME>
```

After the delete operation completes, you can claim or provision the device again by using its ownership voucher.

## How do I reset a provisioned machine?

When you reset a provisioned machine, it returns to the maintenance environment so you can redeploy an OS. This reset process is useful when a system becomes unusable or when you need to reprovision it with different network or configuration settings.

Run:

```bash
az provisionedmachine reset-os --name <NAME_OF_MACHINE> --resource-group <RESOURCE_GROUP_NAME>
```

After the reset finishes, you can provision the machine again by using either the Azure portal or the Azure CLI.