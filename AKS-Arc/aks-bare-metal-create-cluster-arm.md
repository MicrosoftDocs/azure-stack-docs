---
title: Create an AKS on bare metal cluster using an ARM template (preview)
description: Learn how to deploy an Azure Kubernetes Service (AKS) cluster on bare metal using an Azure Resource Manager template.
ms.topic: how-to
ms.date: 06/01/2026
author: SummerSmith
ms.author: sumsmith
---

# Create an AKS on bare metal Cluster Using an ARM Template (preview)

> [!IMPORTANT]
> Azure Kubernetes Service on bare metal is currently in preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability. Azure Kubernetes Service on bare metal previews are partially covered by customer support on a best-effort basis.

This article shows you how to create an Azure Kubernetes Service (AKS) cluster on bare metal using an ARM template. The template automates the entire AKS cluster deployment.

## Prerequisites

Complete all [system requirements and prerequisites](aks-bare-metal-system-requirements.md) before you begin.

## Step 1: Download the ARM parameters file

1. Download a local copy of the [ARM parameters file](https://dev.azure.com/msazure/msk8s/_git/Aks-Arc-Assembly?path=/templates/aksarc-bmlinux/brownfield/azuredeploy.parameters.json&_a=contents&version=GBmain).
1. Configure the required parameters:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "edgeMachineName": {
      "value": "<your-edge-machine-name>"
    },
    "controlPlaneIp": {
      "value": "<static-ip-for-k8s-api-server>"
    },
    "adminGroupObjectIds": {
      "value": ["<entra-id-group-object-id>"]
    },
    "sshPublicKey": {
      "value": "<contents-of-your-ssh-public-key>"
    }
  }
}
```

| Parameter | Type |
|-------|-----|
| `edgeMachineName` | String set or automatically assigned during edge machine deployment. |
| `controlPlaneIp` | IP address. Can be the machine IP. |
| `adminGroupObjectIds` | GUID. |
| `sshPublicKey` | Public key from SSH key created during edge machine deployment. |

> [!NOTE]
> All other parameters have sensible defaults. Check the deployment template and override any of the optional parameters as needed.

> [!WARNING]
> If your machine uses DHCP, you must reserve the control plane IP address so it remains permanently assigned to this machine. If the control plane IP changes, the Kubernetes cluster becomes unreachable and must be redeployed.


## Step 2: Download the ARM template

Save the [ARM template](https://dev.azure.com/msazure/msk8s/_git/Aks-Arc-Assembly?path=/templates/aksarc-bmlinux/brownfield/azuredeploy.json&_a=contents&version=GBmain) to the same directory as your parameters file.

## Step 3: Deploy

Run the following command from the directory containing both files:

```azurecli
az deployment group create \
  --resource-group <RESOURCE_GROUP> \
  --template-file aks-arc-bm-cluster-create.json \
  --parameters aks-arc-bm-cluster-create-parameters.json
```

> [!NOTE]
> Deployment typically takes 20 minutes. You can monitor progress in the Azure portal under your resource group > **Deployments**.

## Verify deployment

After the deployment finishes, connect to your cluster:

```azurecli
az connectedk8s proxy --name <clusterName> --resource-group <RESOURCE_GROUP>
```

Then, in a new terminal:

```bash
kubectl get nodes
```

For detailed connection instructions, see [Connect to your cluster](aks-bare-metal-connect-to-cluster.md).


## Troubleshooting

| Issue | Fix |
|-------|-----|
| `edgeMachineName` not found | Verify the Arc machine exists in the same resource group. |
| RBAC assignment fails | Ensure you have **Owner** role on the resource group. |
| Control plane IP conflict | Choose an IP inside `subnetAddressPrefix` but outside `ipPoolStart`–`ipPoolEnd`. |
| Deployment timeout | Check that the Arc machine is online and connected. |

## Next steps

- [Connect to your cluster](aks-bare-metal-connect-to-cluster.md)
- [Deploy an application](aks-bare-metal-deploy-application.md)
