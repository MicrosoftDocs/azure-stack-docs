---
title: Create an Azure Operator Nexus virtual machine by using Azure Resource Manager template (ARM template)
description: Learn how to create an Azure Operator Nexus virtual machine (VM) for virtual network function (VNF) workloads by using Azure Resource Manager template (ARM template).
author: dramasamy
ms.author: dramasamy
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 09/30/2025
ms.custom: template-how-to-pattern, devx-track-azurecli, devx-track-arm-template
---

# Quickstart: Create an Azure Operator Nexus virtual machine by using Azure Resource Manager template (ARM template)

* Deploy an Azure Nexus virtual machine using an Azure Resource Manager template.

This quick-start guide is designed to help you get started with using Nexus virtual machines to host virtual network functions (VNFs).
By following the steps outlined in this guide, you're able to quickly and easily create a customized Nexus virtual machine that meets your specific needs and requirements.
Whether you're a beginner or an expert in Nexus networking, this guide is here to help.
You learn everything you need to know to create and customize Nexus virtual machines for hosting virtual network functions.

## Before you begin

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]
* Complete the [prerequisites](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.

## Review the template

Before deploying the virtual machine template, let's review the content to understand its structure.

:::code language="json" source="includes/virtual-machine/virtual-machine-arm-template.json":::

> [!WARNING]
> User data isn't encrypted, and any process on the VM can query this data.
> You shouldn't store confidential information in user data.
> For more information, see [Azure data security and encryption best practices](/azure/security/fundamentals/data-encryption-best-practices).

Once you review and save the template file named ```virtual-machine-arm-template.json```, proceed to the next section to deploy the template.

### Virtual machines with managed identities

Create the virtual machine with either a system-assigned or a user-assigned managed identity.
To add a managed identity to the VM, the API version must be `2025-07-01-preview` or later.

> [!IMPORTANT]
> You must assign a managed identity (system-assigned or user-assigned) when creating the VM.
> Managed identities can't be added after the VM is created.

Update the `apiVersion` for the virtual machine resource in the `virtual-machine-arm-template.json` file:

```json
  ...
  "resources": [
      {
          "type": "Microsoft.NetworkCloud/virtualMachines",
          "apiVersion": "2025-07-01-preview",
          ...
      }
    ]
  }
```

To the `virtual-machine-arm-template.json` file, add the `identity` property to the virtual machine resource definition.

For System-Assigned Managed Identity, use the following snippet:

```json
"identity": {
  "type": "SystemAssigned"
}
```

For User-Assigned Managed Identity, use the following snippet:

```json
"identity": {
  "type": "UserAssigned",
  "userAssignedIdentities": {
    "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identity-name}": {}
  }
}
```

## Deploy the template

1. Create a file named ```virtual-machine-parameters.json``` and add the required parameters in JSON format.
   You can use the following example as a starting point. Replace the values with your own.

:::code language="json" source="includes/virtual-machine/virtual-machine-params.json":::

2. Deploy the template.

```azurecli-interactive
az deployment group create \
  --resource-group myResourceGroup \
  --template-file virtual-machine-arm-template.json \
  --parameters @virtual-machine-parameters.json
```

## Review deployed resources

```azurecli-interactive
az deployment group show --resource-group myResourceGroup --name <deployment-name>
```

[!INCLUDE [quickstart-review-deployment-cli](./includes/virtual-machine/quickstart-review-deployment-cli.md)]

## Clean up resources

[!INCLUDE [quickstart-cleanup](./includes/virtual-machine/quickstart-cleanup-cli.md)]

## Next steps

The Nexus virtual machine is successfully created! You can now use the virtual machine to host virtual network functions (VNFs).