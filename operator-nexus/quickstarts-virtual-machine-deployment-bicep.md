---
title: Create an Azure Operator Nexus virtual machine by using Bicep
description: Learn how to create an Azure Operator Nexus virtual machine (VM) for virtual network function (VNF) workloads by using Bicep
author: dramasamy
ms.author: dramasamy
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 09/24/2025
ms.custom:
  - template-how-to-pattern
  - devx-track-azurecli
  - devx-track-bicep
  - build-2025
---

# Quickstart: Create an Azure Operator Nexus virtual machine by using Bicep

* Deploy an Azure Nexus virtual machine using Bicep

This quick-start guide is designed to help you get started with using Nexus virtual machines to host virtual network functions (VNFs).
By following the steps outlined in this guide, you're able to quickly and easily create a customized Nexus virtual machine that meets your specific needs and requirements.
Whether you're a beginner or an expert in Nexus networking, this guide is here to help.
You learn everything you need to know to create and customize Nexus virtual machines for hosting virtual network functions.

## Before you begin

[!INCLUDE [virtual-machine-prereq](./includes/virtual-machine/quickstart-prereq.md)]
* Complete the [prerequisites](./quickstarts-tenant-workload-prerequisites.md) for deploying a Nexus virtual machine.

## Review the template

Before deploying the virtual machine template, let's review the content to understand its structure.

:::code language="bicep" source="includes/virtual-machine/virtual-machine-bicep-file.bicep":::

> [!WARNING]
> User data isn't encrypted, and any process on the VM can query this data.
> You shouldn't store confidential information in user data.
> For more information, see [Azure data security and encryption best practices](/azure/security/fundamentals/data-encryption-best-practices).

Review and save the template file named ```virtual-machine-bicep-file.bicep```, then proceed to the next section and deploy the template.

## Deploy the template

1. Create a file named ```virtual-machine-parameters.json``` and add the required parameters in JSON format. You can use the following example as a starting point. Replace the values with your own.

:::code language="json" source="includes/virtual-machine/virtual-machine-params.json":::

2. Deploy the template.

```azurecli-interactive
    az deployment group create --resource-group myResourceGroup --template-file virtual-machine-bicep-file.bicep --parameters @virtual-machine-parameters.json
```

### Virtual machine Arc enrollment with managed identities

If you want to enroll the virtual machine with Azure Arc using managed identities, you _must_ create the virtual machine with either a system-assigned managed identity or a user-assigned managed identity.

The following example shows how to create a virtual machine with a system-assigned managed identity using Bicep.
The examples build on the previous Bicep example by adding the managed identity section.

:::code language="bicep" source="includes/virtual-machine/virtual-machine-with-managed-identity-bicep-file.bicep":::

For detailed steps on how to create a virtual machine with managed identities and enroll it with Azure Arc, see [Enroll a Nexus virtual machine with Azure Arc using managed identities].

[Enroll a Nexus virtual machine with Azure Arc using managed identities]: ./howto-virtual-machine-arc-enroll-managed-identities.md

## Review deployed resources

```azurecli-interactive
    az deployment group show --resource-group myResourceGroup --name <deployment-name>
```

[!INCLUDE [quickstart-review-deployment-cli](./includes/virtual-machine/quickstart-review-deployment-cli.md)]

## Clean up resources

[!INCLUDE [quickstart-cleanup](./includes/virtual-machine/quickstart-cleanup-cli.md)]

## Next steps

The Nexus virtual machine is successfully created! You can now use the virtual machine to host virtual network functions (VNFs).