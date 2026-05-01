---
title: List supported Kubernetes versions for Azure Operator Nexus
description: Learn how to query the supported Nexus Kubernetes versions that a Nexus Cluster can deploy or upgrade clusters to, including each version's component manifest and lifecycle dates.
author: ronmiab
ms.author: robess
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 04/30/2026
ms.custom: template-how-to-pattern
---

# List supported Kubernetes versions for Azure Operator Nexus

This article explains how to discover the Nexus Kubernetes [version bundles](./reference-nexus-kubernetes-cluster-supported-versions.md#version-bundles) that an Operator Nexus Cluster can deploy or upgrade clusters to. The kubernetesVersions catalog is published per Nexus Cluster as a `Microsoft.NetworkCloud/kubernetesVersions` resource named `default`. It's anchored to the Nexus Cluster's custom location (extended location).

Use this API when you want to:

- Plan cluster creations or upgrades against a known list of available bundles before targeting a specific cluster.
- Verify the general availability (GA), end-of-support (EOS), and end-of-extended-availability (EOEA) dates for a bundle.
- Inspect the [Features](./concepts-nexus-kubernetes-cluster.md#nexus-kubernetes-cluster-features) and component versions packaged inside a version bundle.

For per-cluster upgrade options for an existing cluster, see [Check for available upgrades](./howto-kubernetes-cluster-upgrade.md#check-for-available-upgrades).

## What the kubernetesVersions catalog contains

Each `Microsoft.NetworkCloud/kubernetesVersions` resource is the catalog of every Nexus Kubernetes [version bundle](./reference-nexus-kubernetes-cluster-supported-versions.md#version-bundles) that the owning Nexus Cluster can deploy or upgrade clusters to. The catalog is structured as follows:

- **Supported Kubernetes minor versions.** The catalog's `properties.values[]` array lists every Kubernetes minor version (for example, `1.30`, `1.31`, `1.32`, `1.33`) for which Operator Nexus currently ships at least one bundle on this Nexus Cluster.
- **Version bundles per minor version.** Each minor version entry contains one or more patch-level version bundles. A bundle is the unit Operator Nexus deploys: it pins a specific Kubernetes patch release together with the [Features](./concepts-nexus-kubernetes-cluster.md#nexus-kubernetes-cluster-features) (Calico, MetalLB, Azure Arc agents, CSI drivers, and so on) and the OS image that ship with that release.
- **Lifecycle dates per bundle.** Each bundle carries a general-availability date, an end-of-support date, and an end-of-extended-availability date. Operator Nexus uses these dates to govern which bundles are valid creation or upgrade targets at any given time. See [Lifecycle visibility rules](#lifecycle-visibility-rules).
- **Component manifest per bundle.** Each bundle records the exact Feature and OS image versions it packages, so you can correlate a Kubernetes patch release with the supporting components that ship alongside it.

In the current preview API version (`2026-01-01-preview`), the patch-level bundle data for a minor version is returned as a single text field named `description`. The remainder of this article shows how to retrieve that field, how to read it, and how to filter it.

## Prerequisites

- An Azure subscription with access to an Azure Operator Nexus instance whose Nexus Cluster is running a build that supports the `2026-01-01-preview` Microsoft.NetworkCloud API version or newer. If the resource doesn't appear for a Nexus Cluster, the build on that instance doesn't yet expose `Microsoft.NetworkCloud/kubernetesVersions`.
- The Azure CLI installed and signed in. If you need to install or upgrade it, see [Install Azure CLI](./howto-install-cli-extensions.md).
- Reader access on the subscription (or on the Nexus Cluster's managed HostedResources resource group). `Microsoft.NetworkCloud/kubernetesVersions` is projected into the HostedResources group.
- To use the `az networkcloud kubernetesversion` commands, install the preview `networkcloud` CLI extension (`5.0.0b1` or later): `az extension add --name networkcloud --version 5.0.0b1 --allow-preview true`. The `az rest` examples in this article work with any Azure CLI install and don't require the preview extension.

## Locate the kubernetesVersions resource

`Microsoft.NetworkCloud/kubernetesVersions` is a singleton named `default` per Nexus Cluster. List the resources visible to your subscription:

```azurecli
az resource list \
  --resource-type Microsoft.NetworkCloud/kubernetesVersions \
  --query "[].{name:name, location:location, id:id}" \
  --output table
```

Or, with the preview `networkcloud` extension, list every Nexus Cluster's kubernetesVersions catalog in a single call:

```azurecli
az networkcloud kubernetesversion list --output table
```

Each row corresponds to one Nexus Cluster. The table view projects `Location`, `Name` (always `default`), `ProvisioningState`, and `ResourceGroup`. To see the full ARM `id` and `extendedLocation`, rerun the command with `--output json` or project them with `--query`:

```azurecli
az networkcloud kubernetesversion list \
  --query "[].{id:id, resourceGroup:resourceGroup, extendedLocation:extendedLocation.name}" \
  --output table
```

Each `id` has the form:

```text
/subscriptions/<sub>/resourceGroups/<cluster>-<hash>-HostedResources-<hash>/providers/Microsoft.NetworkCloud/kubernetesVersions/default
```

The kubernetesVersions resource's `extendedLocation` matches the Nexus Cluster's custom location. Use the `id` value as `<KubernetesVersionsResourceId>` in the next step.

## Find the HostedResources resource group for your cluster

`Microsoft.NetworkCloud/kubernetesVersions` lives in the cluster's managed HostedResources resource group, not in the resource group that holds the Nexus Cluster. The table output from the previous step already exposes the HostedResources group in the `ResourceGroup` column. To extract it programmatically for a specific Nexus Cluster, filter the list by the cluster's custom location:

```azurecli
az networkcloud kubernetesversion list \
  --query "[?contains(extendedLocation.name, '<cluster-name>')].resourceGroup" \
  --output tsv
```

Pass the output as `--resource-group` to every `az networkcloud kubernetesversion` command in this article.

## Get the kubernetesVersions catalog

Fetch the kubernetesVersions catalog through ARM with `az rest`:

```azurecli
az rest --method get \
  --url "https://management.azure.com<KubernetesVersionsResourceId>?api-version=2026-01-01-preview"
```

Or, with the preview `networkcloud` extension:

```azurecli
az networkcloud kubernetesversion show \
  --resource-group <cluster>-<hash>-HostedResources-<hash> \
  --name default
```

You can also list every kubernetesVersions catalog visible to a subscription in a single call (one entry per Nexus Cluster):

```azurecli
az rest --method get \
  --url "https://management.azure.com/subscriptions/<SubscriptionId>/providers/Microsoft.NetworkCloud/kubernetesVersions?api-version=2026-01-01-preview"
```

Or:

```azurecli
az networkcloud kubernetesversion list
```

### Sample output

The current preview `Microsoft.NetworkCloud/kubernetesVersions` API returns a list of supported minor versions. For each minor version, the `description` field is a single text string that embeds every patch-level entry's component manifest and lifecycle dates. The following example is trimmed for readability:

```json
{
  "id": "/subscriptions/<sub>/resourceGroups/<cluster>-<hash>-HostedResources-<hash>/providers/Microsoft.NetworkCloud/kubernetesVersions/default",
  "name": "default",
  "type": "microsoft.networkcloud/kubernetesversions",
  "location": "uksouth",
  "extendedLocation": {
    "name": "/subscriptions/<sub>/resourceGroups/<cluster>-hostedresources-<hash>/providers/microsoft.extendedlocation/customlocations/<cluster>-cstm-loc",
    "type": "CustomLocation"
  },
  "properties": {
    "provisioningState": "Succeeded",
    "values": [
      {
        "version": "1.33",
        "description": "[{ components: {Name: azure-arc-k8sagents, Type: Feature, Version: 1.31.7},{Name: azure-arc-servers, Type: Feature, Version: v1.2.6},{Name: calico, Type: Feature, Version: v1.9.1},{Name: cloud-provider-kubevirt, Type: Feature, Version: v1.0.8},{Name: csi-nfs, Type: Feature, Version: 10.2.0-41},{Name: csi-volume, Type: Feature, Version: 10.2.0-41},{Name: ipam-cni-plugin, Type: Feature, Version: v1.0.13},{Name: metallb, Type: Feature, Version: v1.3.5},{Name: metrics-server, Type: Feature, Version: v1.0.7},{Name: multus, Type: Feature, Version: v1.4.4},{Name: node-local-dns, Type: Feature, Version: v1.2.3},{Name: sriov-dp, Type: Feature, Version: v1.1.7},{Name: AzureLinux3, Type: OSImage, Version: 1.33.x-y.z}, endOfExtendedAvailabilityDate: 2027-MM-DD 00:00:00 +0000 UTC, generalAvailabilityDate: 2026-MM-DD 00:00:00 +0000 UTC, patchVersion: v1.33.x-y.z, supportExpiryDate: 2027-MM-DD 00:00:00 +0000 UTC }, ... ]"
      },
      {
        "version": "1.32",
        "description": "[{ components: {...}, endOfExtendedAvailabilityDate: ..., generalAvailabilityDate: ..., patchVersion: v1.32.x-y.z, supportExpiryDate: ... }, ... ]"
      },
      {
        "version": "1.31",
        "description": "[{ components: {...}, ... patchVersion: v1.31.x-y.z, ... }, ... ]"
      },
      {
        "version": "1.30",
        "description": "[{ components: {...}, ... patchVersion: v1.30.x-y.z, ... }, ... ]"
      }
    ]
  }
}
```

### kubernetesVersions resource and field reference (preview API)

Top-level kubernetesVersions resource:

| Field | Description |
| ----- | ----------- |
| `id` | The ARM ID of the kubernetesVersions catalog. The kubernetesVersions catalog is always named `default`, scoped to the Nexus Cluster's managed HostedResources resource group. |
| `location` | Azure region of the Nexus Cluster. |
| `extendedLocation` | The custom location (extended location) reference of the Nexus Cluster that owns this kubernetesVersions catalog. |
| `properties.provisioningState` | `Succeeded` once the kubernetesVersions catalog has been seeded. |
| `properties.values` | One entry per supported Kubernetes minor version (for example, `1.30`, `1.31`, `1.32`, `1.33`). |

Per-entry fields in `properties.values[]`:

| Field | Description |
| ----- | ----------- |
| `version` | The Kubernetes minor version (`<major>.<minor>`) the entry describes. |
| `description` | A text string that lists every patch-level [version bundle](./reference-nexus-kubernetes-cluster-supported-versions.md#version-bundles) Operator Nexus publishes for this minor version. Each entry includes the bundle's [component](./reference-nexus-kubernetes-cluster-supported-versions.md#components-version-and-breaking-changes) versions, [Feature](./concepts-nexus-kubernetes-cluster.md#nexus-kubernetes-cluster-features) versions, and the lifecycle dates listed in the next table. |

The keys embedded in each patch entry inside `description` are:

| Embedded key | Maps to |
| ------------ | ------- |
| `patchVersion` | The full version bundle identifier in the form `v<major>.<minor>.<patch>-<bundle>`. See [Nexus Kubernetes service version components](./reference-nexus-kubernetes-cluster-supported-versions.md#nexus-kubernetes-service-version-components). |
| `components` | The Features and OS image packaged in the bundle (Calico, MetalLB, container runtime, AzureLinux, and so on). For the public component matrix, see [Components version and breaking changes](./reference-nexus-kubernetes-cluster-supported-versions.md#components-version-and-breaking-changes). |
| `generalAvailabilityDate` | UTC date when the bundle entered [general availability](./reference-nexus-kubernetes-cluster-supported-versions.md#kubernetes-version-support-policy). A zero value (`0001-01-01 00:00:00 +0000 UTC`) means the bundle predates GA tracking on this Nexus Cluster. |
| `supportExpiryDate` | UTC date when the bundle reaches [end of support](./reference-nexus-kubernetes-cluster-supported-versions.md#end-of-support). After this date, Operator Nexus surfaces the bundle with an unsupported warning and stops shipping further patches against it. |
| `endOfExtendedAvailabilityDate` | UTC date when the bundle is removed from `Microsoft.NetworkCloud/kubernetesVersions` and can no longer be selected for cluster creation or upgrade. See [Extended availability policy](./reference-nexus-kubernetes-cluster-supported-versions.md#extended-availability-policy). |

## Lifecycle visibility rules

Regardless of how the data is rendered, the lifecycle rules Operator Nexus applies to entries in the kubernetesVersions catalog are:

- **Generally available bundles** are returned with `supportExpiryDate` and `endOfExtendedAvailabilityDate` in the future.
- **Bundles past end of support but before end of extended availability** are still returned, but Operator Nexus surfaces them with an unsupported warning. New cluster creation on these bundles isn't recommended; existing clusters can still be upgraded *out* of them. Refer to the [Extended availability policy](./reference-nexus-kubernetes-cluster-supported-versions.md#extended-availability-policy) for what's supported during this period.
- **Bundles past end of extended availability** aren't returned. Clusters that remain on a removed bundle become [abandoned clusters](./reference-nexus-kubernetes-cluster-supported-versions.md#abandoned-nexus-kubernetes-clusters) and the only supported operation is deletion.

For the full set of policy questions, including upgrade behavior outside the support window, see the [FAQ](./reference-nexus-kubernetes-cluster-supported-versions.md#faq) in the supported versions reference.

## Filter the kubernetesVersions catalog with JMESPath

The standard Azure CLI `--query` option works on the structured top-level fields. The following examples refine the response.

List only the supported minor versions:

```azurecli
az rest --method get \
  --url "https://management.azure.com<KubernetesVersionsResourceId>?api-version=2026-01-01-preview" \
  --query "properties.values[].version" \
  --output tsv
```

Get every patch entry text blob for a specific minor version:

```azurecli
az rest --method get \
  --url "https://management.azure.com<KubernetesVersionsResourceId>?api-version=2026-01-01-preview" \
  --query "properties.values[?version=='1.33'].description | [0]" \
  --output tsv
```

Find every Nexus Cluster kubernetesVersions catalog visible to the subscription:

```azurecli
az rest --method get \
  --url "https://management.azure.com/subscriptions/<SubscriptionId>/providers/Microsoft.NetworkCloud/kubernetesVersions?api-version=2026-01-01-preview" \
  --query "value[].{customLocation:extendedLocation.name, location:location, minorVersions:properties.values[].version}" \
  --output json
```

## Render the description in human-readable form

Because each minor version's `description` is returned as a single text string, the raw response is difficult to read for catalogs with more than a handful of patches. The following convenience script pulls the value with `az networkcloud kubernetesversion show` and uses two `awk` passes to:

1. Split each patch entry, component row, and lifecycle date onto its own line and strip the surrounding `{`, `}`, and `[]` punctuation.
2. Reorder each patch block so that `patchVersion` appears first, the lifecycle dates appear next, and the `components` list appears last, to match the typical reading order for a version bundle.

The script uses only `az`, `bash`, and `awk` (POSIX), so it can be ran unmodified on Linux operating systems.

```bash
#!/usr/bin/env bash
# Pretty-print the Microsoft.NetworkCloud/kubernetesVersions description blob
# for a single minor version. Replace RESOURCE_GROUP and MINOR as needed.

RESOURCE_GROUP="<cluster>-<hash>-HostedResources-<hash>"
MINOR="1.33"

az networkcloud kubernetesversion show \
  --resource-group "$RESOURCE_GROUP" \
  --name default \
  --query "values[?version=='$MINOR'].description | [0]" \
  --output tsv \
| awk '{
    gsub(/\},\{ components:/, "}\n\n{ components:")
    gsub(/, patchVersion:/, "\n  patchVersion:")
    gsub(/, generalAvailabilityDate:/, "\n  generalAvailabilityDate:")
    gsub(/, supportExpiryDate:/, "\n  supportExpiryDate:")
    gsub(/, endOfExtendedAvailabilityDate:/, "\n  endOfExtendedAvailabilityDate:")
    gsub(/\{Name:/, "\n    {Name:")
    gsub(/[\{\}\[\]]/, "")
    print
  }' \
| awk 'BEGIN{RS=""} {
    pv=""; ga=""; se=""; eea=""; nc=0
    n=split($0, lines, "\n")
    for (i=1; i<=n; i++) {
      if      (lines[i] ~ /^[ \t]*patchVersion:/)                  pv=lines[i]
      else if (lines[i] ~ /^[ \t]*generalAvailabilityDate:/)       ga=lines[i]
      else if (lines[i] ~ /^[ \t]*supportExpiryDate:/)             se=lines[i]
      else if (lines[i] ~ /^[ \t]*endOfExtendedAvailabilityDate:/) eea=lines[i]
      else if (lines[i] ~ /^[ \t]*(components:|.*Name:)/)          comp[++nc]=lines[i]
    }
    if (pv == "") next
    sub(/^[ \t]+/, "", pv);  print pv
    if (ga  != "") { sub(/^[ \t]+/, "", ga);  print ga }
    if (se  != "") { sub(/^[ \t]+/, "", se);  print se }
    if (eea != "") { sub(/^[ \t]+/, "", eea); print eea }
    for (i=1; i<=nc; i++) print comp[i]
    print ""
  }'
```

Sample reformatted output (one patch entry shown; real responses contain several patches per minor version):

```text
patchVersion: v1.33.x-y.z
generalAvailabilityDate: 2026-MM-DD 00:00:00 +0000 UTC
supportExpiryDate: 2027-MM-DD 00:00:00 +0000 UTC
endOfExtendedAvailabilityDate: 2027-MM-DD 00:00:00 +0000 UTC
 components:
    Name: azure-arc-k8sagents, Type: Feature, Version: 1.31.7,
    Name: azure-arc-servers, Type: Feature, Version: v1.2.6,
    Name: calico, Type: Feature, Version: v1.9.1,
    Name: cloud-provider-kubevirt, Type: Feature, Version: v1.0.8,
    Name: csi-nfs, Type: Feature, Version: 10.2.0-41,
    Name: csi-volume, Type: Feature, Version: 10.2.0-41,
    Name: ipam-cni-plugin, Type: Feature, Version: v1.0.13,
    Name: metallb, Type: Feature, Version: v1.3.5,
    Name: metrics-server, Type: Feature, Version: v1.0.8,
    Name: multus, Type: Feature, Version: v1.4.6,
    Name: node-local-dns, Type: Feature, Version: v1.2.4,
    Name: sriov-dp, Type: Feature, Version: v1.1.10,
    Name: AzureLinux3, Type: OSImage, Version: 1.33.x-y.z
```

To render every minor version in the kubernetesVersions catalog with a banner before each block, wrap the same `awk` pipeline in a small loop:

```bash
URL="https://management.azure.com<KubernetesVersionsResourceId>?api-version=2026-01-01-preview"
for v in $(az rest --method get --url "$URL" --query "properties.values[].version" -o tsv); do
  echo "===== Kubernetes $v ====="
  az rest --method get --url "$URL" \
    --query "properties.values[?version=='$v'].description | [0]" -o tsv \
  | awk '{
      gsub(/\},\{ components:/, "}\n\n{ components:")
      gsub(/, patchVersion:/, "\n  patchVersion:")
      gsub(/, generalAvailabilityDate:/, "\n  generalAvailabilityDate:")
      gsub(/, supportExpiryDate:/, "\n  supportExpiryDate:")
      gsub(/, endOfExtendedAvailabilityDate:/, "\n  endOfExtendedAvailabilityDate:")
      gsub(/\{Name:/, "\n    {Name:")
      gsub(/[\{\}\[\]]/, "")
      print
    }' \
  | awk 'BEGIN{RS=""} {
      pv=""; ga=""; se=""; eea=""; nc=0
      n=split($0, lines, "\n")
      for (i=1; i<=n; i++) {
        if      (lines[i] ~ /^[ \t]*patchVersion:/)                  pv=lines[i]
        else if (lines[i] ~ /^[ \t]*generalAvailabilityDate:/)       ga=lines[i]
        else if (lines[i] ~ /^[ \t]*supportExpiryDate:/)             se=lines[i]
        else if (lines[i] ~ /^[ \t]*endOfExtendedAvailabilityDate:/) eea=lines[i]
        else if (lines[i] ~ /^[ \t]*(components:|.*Name:)/)          comp[++nc]=lines[i]
      }
      if (pv == "") next
      sub(/^[ \t]+/, "", pv);  print pv
      if (ga  != "") { sub(/^[ \t]+/, "", ga);  print ga }
      if (se  != "") { sub(/^[ \t]+/, "", se);  print se }
      if (eea != "") { sub(/^[ \t]+/, "", eea); print eea }
      for (i=1; i<=nc; i++) print comp[i]
      print ""
    }'
  echo
done
```

## Compare with per-cluster available upgrades

`Microsoft.NetworkCloud/kubernetesVersions` returns the kubernetesVersions catalog for an entire Nexus Cluster. To see only the upgrade targets that apply to a specific cluster, use the per-cluster query. The per-cluster query is already filtered by the [Kubernetes version-skew policy](./reference-nexus-kubernetes-cluster-supported-versions.md#can-i-skip-multiple-kubernetes-versions-during-cluster-upgrade) and the cluster's current bundle, and it returns structured upgrade candidates today:

```azurecli
az networkcloud kubernetescluster show \
  --name <NexusK8sClusterName> \
  --resource-group <ResourceGroup> \
  --query availableUpgrades \
  --output json
```

For the full upgrade workflow, see [Upgrade an Azure Operator Nexus Kubernetes cluster](./howto-kubernetes-cluster-upgrade.md).

## Related content

- [Supported Kubernetes versions in Azure Operator Nexus Kubernetes service](./reference-nexus-kubernetes-cluster-supported-versions.md)
- [Nexus Kubernetes version bundles](./reference-nexus-kubernetes-cluster-supported-versions.md#version-bundles)
- [Components version and breaking changes](./reference-nexus-kubernetes-cluster-supported-versions.md#components-version-and-breaking-changes)
- [Upgrade an Azure Operator Nexus Kubernetes cluster](./howto-kubernetes-cluster-upgrade.md)
- [Nexus Kubernetes cluster Features](./concepts-nexus-kubernetes-cluster.md#nexus-kubernetes-cluster-features)
