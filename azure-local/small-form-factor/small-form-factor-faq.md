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

You can delete the resources directly from the Azure portal or Azure CLI. You can even just delete the entire resource group. The only resource that is left behind when deleting the resource group & which needs a specific command to delete is the Azure Arc Site. To delete this resource follow the documentation for [Azure Arc Site](/azure/azure-arc/site-manager/how-to-crud-site).

## Can I register the same device more than once?

No. A device can only have one active provisioned machine registration at a time. If you try to register a device that's already represented by a provisioned machine resource, delete the existing provisioned machine first, or delete the test resource group that contains it if you no longer need any of the resources in that group.

To delete only the provisioned machine by using Azure CLI, run:

```bash
az provisionedmachine delete --name <NAME_OF_MACHINE> --resource-group <RESOURCE_GROUP_NAME>
```

After the delete operation completes, you can claim or provision the device again by using its ownership voucher.

## How do I reset a provisioned machine?

Resetting a provisioned machine brings the device back to the maintenance environment so you can redeploy an OS with new inputs. That's useful if the system becomes unusable or if you need to provision it again with new network or configuration settings.

Run:

```bash
az provisionedmachine reset-os --name <NAME_OF_MACHINE> --resource-group <RESOURCE_GROUP_NAME>
```

After the reset finishes, you can provision the machine again by using either the Azure portal or the Azure CLI.