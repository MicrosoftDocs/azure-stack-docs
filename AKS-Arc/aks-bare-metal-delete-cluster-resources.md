---
title: Delete AKS on bare metal cluster resources
description: Learn how to delete Azure Kubernetes Service on bare metal cluster resources and edge machine resources from Azure in the correct order.
ms.topic: how-to
ms.date: 06/01/2026
author: SummerSmith
ms.author: sumsmith
---

# Delete AKS on bare metal cluster resources

> [!IMPORTANT]
> Azure Kubernetes Service on bare metal is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability. Azure Kubernetes Service on bare metal previews are partially covered by customer support on a best-effort basis.

This article shows you how to delete AKS on bare metal cluster and edge machine resources from Azure. You **must** follow the deletion order described in this article. Deleting resources out of order results in orphaned resources or failed deletions.

> [!WARNING]
> Some steps require waiting for completion before proceeding. Don't skip ahead.

## Deletion order

| Step | Resource | Wait required | Notes |
|------|----------|:---:|-------|
| 1 | AKS cluster | ✅ **Yes** | Must fully complete before continuing. |
| 2 | Logical Network (LNET) | No | — |
| 3 | Device Pool | ✅ **Yes** | Automatically deletes the Custom Location. Must fully complete before continuing. |
| 4 | Provisioned Machine | No | — |
| 5 | Resource Group | No | — |
| 6 | Site | No | Automatically deletes the managed resource group. |
| — | SSH Key | — | Can be deleted at any time. |

## Step 1: Delete the AKS cluster

1. In the [Azure portal](https://portal.azure.com), navigate to your resource group.
1. Select the AKS cluster resource.
1. Select **Delete** and confirm.
1. **Wait** for the deletion to complete before proceeding.

**CLI alternative:**

```azurecli
az resource delete --ids <cluster-resource-id>
```

## Step 2: Delete the Logical Network (LNET)

1. In the resource group, select the Logical Network resource.
1. Select **Delete** and confirm.

**CLI alternative:**

```azurecli
az resource delete --ids <lnet-resource-id>
```

## Step 3: Delete the Device Pool

1. In the resource group, select the Device Pool resource.
1. Select **Delete** and confirm.
1. **Wait** for the deletion to complete. This automatically deletes the Custom Location.

**CLI alternative:**

```azurecli
az resource delete --ids <device-pool-resource-id>
```

> [!NOTE]
> You don't need to manually delete the Custom Location. It's removed automatically when the Device Pool is deleted.

## Step 4: Delete the Provisioned Machine

1. In the resource group, select the Provisioned Machine resource.
1. Select **Delete** and confirm.

**CLI alternative:**

```azurecli
az resource delete --ids <provisioned-machine-resource-id>
```

## Step 5: Delete the Resource Group

1. Navigate to the resource group.
1. Select **Delete resource group** and confirm by typing the resource group name.

**CLI alternative:**

```azurecli
az group delete --name <resource-group> --yes --no-wait
```

## Step 6: Delete the Site

1. Navigate to the Site resource. It might be in a different resource group.
1. Select **Delete** and confirm.
1. This automatically deletes the managed resource group.

**CLI alternative:**

```azurecli
az resource delete --ids <site-resource-id>
```

## Delete the SSH Key (anytime)

The SSH Key resource has no dependency on other resources and can be deleted at any point during this process.

```azurecli
az resource delete --ids <ssh-key-resource-id>
```

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| Resource stuck in "Deleting" state | Dependency not deleted first. | Verify you followed the order above. Wait and retry. |
| Custom Location still exists after Device Pool delete | Deletion still in progress. | Wait a few more minutes. The deletion cascades automatically. |
| Resource group delete fails | Resources still present inside. | Ensure steps 1–4 completed successfully first. |
| Site delete doesn't remove managed resource group | Permissions issue. | Verify you have Owner or Contributor role on the managed resource group. |

## Next steps

- [Create a Kubernetes cluster using the Azure portal](create-cluster-portal.md)
- [System requirements and prerequisites](system-requirements.md)
