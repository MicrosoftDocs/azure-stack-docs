---
title: Troubleshoot no VM sizes listed on Azure portal
description: Learn how to troubleshoot no VM sizes listed on Azure portal when you create an AKS Arc cluster.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 11/22/2024
ms.reviewer: sumsmith

---

# No VM sizes listed on Azure portal when you create an AKS Arc cluster

When you try to create an AKS Arc cluster from the Azure portal, you can see that there are no VM sizes listed. This can happen if the **skus/default** resource in Azure is not yet created, or was deleted for some reason. This scenario can happen in Azure Local releases 2408 or older, when the default resource was not created as a part of the Azure Local deployment.

## Workaround

Run the following command:

```azurecli
$cl_id = "/subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.ExtendedLocation/customLocations/<custom_location_name>"
          
# Get the VM sizes using CLI (it automatically creates the **skus/default** Azure resource).

az aksarc vmsize list --custom-location $cl_id
```

## Validation

Verify that Azure portal now displays the correct list of VM sizes.

## Next steps

[Troubleshoot issues in AKS enabled by Azure Arc](aks-troubleshoot.md)
