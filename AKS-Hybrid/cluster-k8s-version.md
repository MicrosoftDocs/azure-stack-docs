---
title: Troubleshoot no K8s versions or VM sizes listed when you create an AKS Arc cluster
description: Learn how to troubleshoot no K8s versions or VM sizes listed when you create an AKS Arc cluster.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 10/02/2024
ms.reviewer: sumsmith

---

# Troubleshoot no K8s versions or VM sizes listed when you create an AKS Arc cluster

The **kubernetesVersions/default** or the **skus/default** resource in Azure is not yet created, or was deleted for some reason. This scenario can happen in older releases when the default resource was not created as a part of the deployment.

## Workaround

Run the following command:

```azurecli
$cl_id = "/subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.ExtendedLocation/customLocations/<custom_location_name>"
          
# Get the kubernetes version or the VM sizes using CLI (it automatically creates the **kubernetesVersions/default** or the **skus/default** azure resource).

az aksarc get-versions --custom-location $cl_id
az aksarc vmsize list --custom-location $cl_id
```

## Validation

Verify that the portal displays the correct list of supported K8s versions and VM sizes. See [this list of supported K8s versions](aks-whats-new-23h2.md#release-2408) for each Azure Stack HCI release.

## Next steps

[Known issues in AKS enabled by Azure Arc](aks-known-issues.md)
