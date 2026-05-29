---
title: Create an AKS on bare metal cluster using an ARM template
description: Learn how to deploy an Azure Kubernetes Service (AKS) cluster on bare metal using an Azure Resource Manager template.
ms.topic: how-to
ms.date: 06/01/2026
author: SummerSmith
ms.author: sumsmith
---

# Create an AKS on bare metal cluster using an ARM template

> [!IMPORTANT]
> Azure Kubernetes Service on bare metal is currently in preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability. Azure Kubernetes Service on bare metal previews are partially covered by customer support on a best-effort basis.

This article shows you how to create an Azure Kubernetes Service (AKS) cluster on bare metal using an ARM template. The template automates the entire deployment, including RBAC role assignments, Device Pool, Logical Network, and the AKS cluster.

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
    "arcMachineName": { "value": "<YOUR_ARC_MACHINE_NAME>" },
    "tags": { "value": { "owner": "<your-alias>", "project": "aksarc-bml" } }
  }
}
```

> [!NOTE]
> `arcMachineName` is the only required parameter. All other parameters have sensible defaults. Override any of the optional parameters as needed.

### Optional parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `location` | Resource group location | Azure region. Use **eastus** for public preview. |
| `clusterName` | `<arcMachineName>-cluster` | Name for the AKS cluster. |
| `kubernetesVersion` | `1.34.3-20260204` | Supported versions: `1.34.2-20260204` or `1.34.3-20260204`. Format: `Major.Minor.Patch-YYYYMMDD`. |
| `controlPlaneIp` | Machine IP | VIP for the Kubernetes control plane. Defaults to the edge machine's IP address if not specified. |
| `controlPlaneCount` | `1` | Number of control plane nodes. |
| `sshPublicKey` | Placeholder key | Provide your own if you need SSH access to nodes. |
| `clusterAdminAadObjectId` | Deployer's object ID | Microsoft Entra ID object ID granted cluster-admin. |
| `aadAdminGroupObjectIds` | `[]` | Microsoft Entra ID group object IDs for admin access. |
| `subnetAddressPrefix` | `10.0.0.0/24` | CIDR for the logical network subnet. |
| `gateway` | `10.0.0.1` | Default gateway IP. |
| `dnsServers` | `["8.8.8.8"]` | DNS servers for the logical network. |
| `ipPoolStart` | `10.0.0.20` | Start of VM IP pool. |
| `ipPoolEnd` | `10.0.0.30` | End of VM IP pool. |
| `vlan` | `0` | VLAN ID (0 = no VLAN tagging). |
| `networkPolicy` | `cilium` | Kubernetes network policy plugin. |
| `podCidr` | `10.244.0.0/16` | CIDR for Kubernetes pod network. |
| `devicePoolName` | `<arcMachineName>-dp` | Name for the Device Pool. |
| `customLocationName` | `<arcMachineName>-cl` | Name for the Custom Location (auto-created). |
| `logicalNetworkName` | `<arcMachineName>-lnet` | Name for the Logical Network. |

> [!WARNING]
> If your machine uses DHCP, you must reserve the control plane IP address so it remains permanently assigned to this machine. If the control plane IP changes, the Kubernetes cluster becomes unreachable and must be redeployed.

### Service principal parameters (advanced)

These parameters default to standard Microsoft tenant values. Override them only if you're deploying in a different tenant.

| Parameter | How to look up |
|-----------|----------------|
| `azureStackHciRpPrincipalId` | `az ad sp show --id 1412d89f-b8a8-4111-b4fd-e82905cbd85d --query id -o tsv` |
| `aksArcCloudMgmtPrincipalId` | `az ad sp show --id 89ad4ee6-8387-4829-9ce1-885479863c60 --query id -o tsv` |
| `cmpAppPrincipalId` | `az ad sp show --id f76c49e3-2a2f-4584-ac3b-0a2ccd30cce2 --query id -o tsv` |
| `cmpDevUaiPrincipalId` | Environment-specific. Override for your subscription. |
| `deployerPrincipalType` | Set to `ServicePrincipal` when deploying from a pipeline. Default: `User`. |

## Step 2: Download the ARM template

Save the [ARM template](https://dev.azure.com/msazure/msk8s/_git/Aks-Arc-Assembly?path=/templates/aksarc-bmlinux/brownfield/azuredeploy.json&_a=contents&version=GBmain) to the same directory as your parameters file.

## Step 3: Deploy

Run the following command from the directory containing both files:

```azurecli
az deployment group create \
  --resource-group <RESOURCE_GROUP> \
  --template-file azuredeploy.json \
  --parameters azuredeploy.parameters.json
```

> [!NOTE]
> Deployment typically takes 20 minutes. The template automatically creates the Device Pool (which auto-creates the Custom Location), Logical Network, RBAC role assignments, and AKS cluster. You can monitor progress in the Azure portal under your resource group > **Deployments**.

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

## What the template creates

The ARM template deploys the following resources in order:

1. **RBAC Role Assignments** — Eight service principal roles required by AKS Arc.
1. **Device Pool** — Registers the Arc machine for AKS workloads and automatically creates Custom Location.
1. **Logical Network** — Networking configuration with IP pools and VIP pool.
1. **AKS Arc Cluster** — Connected cluster with provisioned cluster instance.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `arcMachineName` not found | Verify the Arc machine exists in the same resource group. |
| RBAC assignment fails | Ensure you have **Owner** role on the resource group. |
| Control plane IP conflict | Choose an IP inside `subnetAddressPrefix` but outside `ipPoolStart`–`ipPoolEnd`. |
| Deployment timeout | Check that the Arc machine is online and connected. |

## Next steps

- [Connect to your cluster](aks-bare-metal-connect-to-cluster.md)
- [Deploy an application](aks-bare-metal-deploy-application.md)
