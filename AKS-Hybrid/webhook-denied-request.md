---
title: Troubleshoot admission webhook denied the request - Kubernetes version x.x.x is not available
description: Learn how to troubleshoot admission webhook denied the request - Kubernetes version x.x.x is not available.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 10/02/2024
ms.reviewer: sumsmith

---

# Admission webhook 'vhybridakscluster.kb.io' denied the request: Kubernetes version x.x.x is not available

When you create an AKS Arc cluster from the Azure portal or using CLI, the following error is returned:

```output
{
  "code": "BadRequest",
  "message": "admission webhook \'vhybridakscluster.kb.io\' denied the request: Kubernetes version x.x.x is not available"
}
```

## Workaround

Run the following command:

```azurecli
$subscription = <subscription_id>
$cl_id = <custom_location_id>

az login --use-device-code
az account set -s $subscription
$token = $(az account get-access-token --query accessToken)
$url = "https://management.azure.com${cl_id}/providers/Microsoft.HybridContainerService/kubernetesVersions/default?api-version=2024-01-01"

# Get the Kubernetes version Azure resource
az rest --headers "Authorization=Bearer $token" "Content-Type=application/json;charset=utf-8" --uri $url --method GET

# Delete the Kubernetes version Azure resource
az rest --headers "Authorization=Bearer $token" "Content-Type=application/json;charset=utf-8" --uri $url --method DELETE

# Get the Kubernetes version using CLI (it automatically creates the Kubernetes version Azure resource)
az aksarc get-versions --custom-location $cl_id
```

## Validation

Verify that the `az aksarc get-versions --custom-location <custom_location_id>` command, or the portal, returns the corrected list of supported K8s versions, and that the error "admission webhook \'vhybridakscluster.kb.io\' denied the request: Kubernetes version x.x.x is not available" does not recur when you recreate the cluster with the correct K8s version.

## Next steps

[Known issues in AKS enabled by Azure Arc](aks-known-issues.md)
