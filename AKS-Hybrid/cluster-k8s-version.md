---
title: Troubleshoot K8sVersionValidation error code
description: Learn how to troubleshoot troubleshoot K8sVersionValidation error code
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 10/02/2024
ms.reviewer: abha

---

# Troubleshoot K8sVersionValidation error code

This article discusses how to identify and resolve the K8sVersionValidation error code that occurs when you try to create and deploy an AKS enabled by Azure Arc cluster.

## Symptoms

When you try to create an AKS Arc cluster, you receive one of the following error message(s):

> "Kubernetes version 1.27.7 is not ready for use on Linux. Please go to https://aka.ms/aksarccheckk8sversions for details of how to check the readiness of Kubernetes versions"

OR

> Kubernetes version 1.26.12 is not supported. Please go to https://aka.ms/aksarcsupportedversions for details about the supported Kubernetes version on this platform.

## Error messages

### Kubernetes version 1.27.7 is not ready for use on Linux. Please go to https://aka.ms/aksarccheckk8sversions for details of how to check the readiness of Kubernetes versions

#### Issue 1: Linux VHD download has not completed

When you install Azure Stack HCI, you download a Linux VHD of approximately 4-5GB in size. This Linux VHD is used to create the underlying VMs for the Kubernetes nodes in your AKS Arc cluster. One cause of the error message is if your Linux VHD has not finished downloading. To resolve this issue, you should wait sometime based on how long it takes for your internet connection to finish downloading the Linux VHD image. 

#### Issue 2: The **kubernetesVersions/default** or the **skus/default** resource in Azure is not yet created, or was deleted for some reason. 

This scenario can happen in older releases when the default resource for Kubernetes version (or VM sizes) was not created as a part of the Azure Stack HCI deployment.

To resolve this issue, run the following command:

```azurecli
$cl_id = "/subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.ExtendedLocation/customLocations/<custom_location_name>"
          
# Get the kubernetes version or the VM sizes using CLI (it automatically creates the **kubernetesVersions/default** or the **skus/default** azure resource).

az aksarc get-versions --custom-location $cl_id
az aksarc vmsize list --custom-location $cl_id
```

#### Issue 3: Recreate **kubernetesVersions/default** 

Sometimes, you may have to recreate the **kubernetesVersions/default**. You can run the following commands to do so:

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

### Kubernetes version 1.26.12 is not supported. Please go to https://aka.ms/aksarcsupportedversions for details about the supported Kubernetes version on this platform.

Azure Stack HCI supports specific Kubernetes versions in each of its releases. As stated in the error message, navigate to https://aka.ms/aksarcsupportedversions for list of supported Kubernetes versions based on your deployed Azure Stack HCI release.


## Next steps

[Troubleshoot issues in AKS enabled by Azure Arc](aks-troubleshoot)
