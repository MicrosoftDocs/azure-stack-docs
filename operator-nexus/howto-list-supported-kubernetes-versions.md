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

This article explains how to discover the Nexus Kubernetes [version bundles](./reference-nexus-kubernetes-cluster-supported-versions.md#version-bundles) that an Operator Nexus Cluster can deploy or upgrade clusters to. The catalog is published per Nexus Cluster as a `Microsoft.NetworkCloud/kubernetesVersions` resource named `default`, anchored to the Nexus Cluster's custom location (extended location).

Use this API when you want to:

- Plan cluster creations or upgrades against a known list of available bundles before targeting a specific cluster.
- Verify the general availability (GA), end-of-support (EOS), and end-of-extended-availability (EOEA) dates for a bundle.
- Inspect the [Features](./concepts-nexus-kubernetes-cluster.md#nexus-kubernetes-cluster-features) and component versions packaged inside a version bundle.

For per-cluster upgrade options for an existing cluster, see [Check for available upgrades](./howto-kubernetes-cluster-upgrade.md#check-for-available-upgrades).

## Prerequisites

- An Azure subscription with access to an Azure Operator Nexus instance whose Nexus Cluster is running a build that publishes the `Microsoft.NetworkCloud/kubernetesVersions/default` resource. If the resource does not appear for a Nexus Cluster, the catalog has not yet been seeded for that instance.
- The Azure CLI installed and signed in. If you need to install or upgrade it, see [Install Azure CLI](./howto-install-cli-extensions.md).
- Reader access on the subscription (or on the Nexus Cluster's managed `*-HostedResources-*` resource group). The supported-versions resource is projected into that managed resource group.

## Locate the kubernetesVersions resource

The supported-versions resource is a singleton named `default` per Nexus Cluster. List the resources visible to your subscription:

```azurecli
az resource list \
  --resource-type Microsoft.NetworkCloud/kubernetesVersions \
  --query "[].{name:name, location:location, id:id}" \
  --output table
```

Each row returns one Nexus Cluster's catalog, with an `id` of the form:

```text
/subscriptions/<sub>/resourceGroups/<cluster>-HostedResources-<hash>/providers/Microsoft.NetworkCloud/kubernetesVersions/default
```

The catalog's `extendedLocation` matches the Nexus Cluster's custom location. Use the `id` value from this output as `<KubernetesVersionsResourceId>` in the next step.

## Get the supported-versions catalog

Fetch the catalog through ARM with `az rest`:

```azurecli
az rest --method get \
  --url "https://management.azure.com<KubernetesVersionsResourceId>?api-version=2026-01-01-preview"
```

You can also list every catalog visible to a subscription in a single call (one entry per Nexus Cluster):

```azurecli
az rest --method get \
  --url "https://management.azure.com/subscriptions/<SubscriptionId>/providers/Microsoft.NetworkCloud/kubernetesVersions?api-version=2026-01-01-preview"
```

### Sample output

The current preview API returns a list of supported minor versions. For each minor version, the `description` field is a single text blob that embeds every patch-level entry's component manifest and lifecycle dates. The example below is trimmed for readability:

```json
{
  "id": "/subscriptions/<sub>/resourceGroups/<cluster>-HostedResources-<hash>/providers/Microsoft.NetworkCloud/kubernetesVersions/default",
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

### Resource and field reference (preview API)

Top-level resource:

| Field | Description |
| ----- | ----------- |
| `id` | The ARM ID of the catalog. The catalog is always named `default`, scoped to the Nexus Cluster's managed `*-HostedResources-*` resource group. |
| `location` | Azure region of the Nexus Cluster. |
| `extendedLocation` | The custom location (extended location) reference of the Nexus Cluster that owns this catalog. |
| `properties.provisioningState` | `Succeeded` once the catalog has been seeded. |
| `properties.values` | One entry per supported Kubernetes minor version (for example, `1.30`, `1.31`, `1.32`, `1.33`). |

Per-entry fields in `properties.values[]`:

| Field | Description |
| ----- | ----------- |
| `version` | The Kubernetes minor version (`<major>.<minor>`) the entry describes. |
| `description` | A text blob that lists every patch-level [version bundle](./reference-nexus-kubernetes-cluster-supported-versions.md#version-bundles) Operator Nexus publishes for this minor version, including each bundle's [component](./reference-nexus-kubernetes-cluster-supported-versions.md#components-version-and-breaking-changes) and [Feature](./concepts-nexus-kubernetes-cluster.md#nexus-kubernetes-cluster-features) versions and the lifecycle dates listed below. |

The keys embedded in each patch entry inside `description` are:

| Embedded key | Maps to |
| ------------ | ------- |
| `patchVersion` | The full version bundle identifier in the form `v<major>.<minor>.<patch>-<bundle>`. See [Nexus Kubernetes service version components](./reference-nexus-kubernetes-cluster-supported-versions.md#nexus-kubernetes-service-version-components). |
| `components` | The Features and OS image packaged in the bundle (Calico, MetalLB, container runtime, AzureLinux, and so on). For the public component matrix, see [Components version and breaking changes](./reference-nexus-kubernetes-cluster-supported-versions.md#components-version-and-breaking-changes). |
| `generalAvailabilityDate` | UTC date when the bundle entered [general availability](./reference-nexus-kubernetes-cluster-supported-versions.md#kubernetes-version-support-policy). A zero value (`0001-01-01 00:00:00 +0000 UTC`) means the bundle predates GA tracking on this Nexus Cluster. |
| `supportExpiryDate` | UTC date when the bundle reaches [end of support](./reference-nexus-kubernetes-cluster-supported-versions.md#end-of-support). After this date Operator Nexus surfaces the bundle with an unsupported warning and stops shipping further patches against it. |
| `endOfExtendedAvailabilityDate` | UTC date when the bundle is removed from the supported-versions catalog and can no longer be selected for cluster creation or upgrade. See [Extended availability policy](./reference-nexus-kubernetes-cluster-supported-versions.md#extended-availability-policy). |

> [!NOTE]
> Because `description` is currently a single text field rather than a structured object, programmatic consumers should treat it as informational and parse the embedded keys with caution. A future API version will replace `description` with structured properties for `patchVersion`, `components`, `generalAvailabilityDate`, `supportExpiryDate`, and `endOfExtendedAvailabilityDate` so that the same data is queryable with JMESPath and SDK models. Until then, the recommended programmatic surface for upgrade decisions on a specific cluster is the cluster's own `availableUpgrades` field, described in [Compare with per-cluster available upgrades](#compare-with-per-cluster-available-upgrades) below.

## Lifecycle visibility rules

Regardless of how the data is rendered, the lifecycle rules Operator Nexus applies to entries in this catalog are:

- **Generally available bundles** are returned with `supportExpiryDate` and `endOfExtendedAvailabilityDate` in the future.
- **Bundles past end of support but before end of extended availability** are still returned, but Operator Nexus surfaces them with an unsupported warning. New cluster creation on these bundles isn't recommended; existing clusters can still be upgraded *out* of them. Refer to the [Extended availability policy](./reference-nexus-kubernetes-cluster-supported-versions.md#extended-availability-policy) for what's supported during this period.
- **Bundles past end of extended availability** aren't returned. Clusters that remain on a removed bundle become [abandoned clusters](./reference-nexus-kubernetes-cluster-supported-versions.md#abandoned-nexus-kubernetes-clusters) and the only supported operation is deletion.

For the full set of policy questions, including upgrade behavior outside the support window, see the [FAQ](./reference-nexus-kubernetes-cluster-supported-versions.md#faq) in the supported versions reference.

## Filter the catalog with JMESPath

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

Find every Nexus Cluster catalog visible to the subscription:

```azurecli
az rest --method get \
  --url "https://management.azure.com/subscriptions/<SubscriptionId>/providers/Microsoft.NetworkCloud/kubernetesVersions?api-version=2026-01-01-preview" \
  --query "value[].{customLocation:extendedLocation.name, location:location, minorVersions:properties.values[].version}" \
  --output json
```

> [!TIP]
> JMESPath cannot pattern-match inside the `description` text. To filter on a specific `patchVersion`, GA date, or component version today, retrieve the `description` text and parse it with the tooling of your choice (for example, `jq`, `grep`, or a small Python script). Once the structured properties ship, the same filters can be expressed directly in `--query`.

## Render the description in human-readable form

Because each minor version's `description` is returned as a single text blob, the raw response is difficult to read for any catalog containing more than a handful of patches. The convenience script below pulls the blob with `az rest` and uses two `awk` passes to:

1. Split each patch entry, component row, and lifecycle date onto its own line and strip the surrounding `{`, `}`, and `[]` punctuation.
2. Reorder each patch block so that `patchVersion` is shown first, the lifecycle dates next, and the `components` list last — matching the order an operator typically reads a version bundle.

The script uses only `az`, `bash`, and `awk` (POSIX), so it runs unmodified on macOS, Linux, and WSL without requiring `perl`, GNU `sed`, or any extra dependencies.

```bash
#!/usr/bin/env bash
# Pretty-print the Microsoft.NetworkCloud/kubernetesVersions description blob
# for a single minor version. Replace the URL placeholder and MINOR as needed.

URL="https://management.azure.com<KubernetesVersionsResourceId>?api-version=2026-01-01-preview"
MINOR="1.33"

az rest --method get \
  --url "$URL" \
  --query "properties.values[?version=='$MINOR'].description | [0]" \
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

To render every minor version in the catalog with a banner before each block, wrap the same `awk` pipeline in a small loop:

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

The reformatting is purely cosmetic — the underlying string is unchanged, so the lifecycle rules in the next section apply identically. Once the structured-properties API ships (see the [preview note](#field-reference) above), this script becomes obsolete and `--query` selectors against `patchVersion`, `components`, `generalAvailabilityDate`, `supportExpiryDate`, and `endOfExtendedAvailabilityDate` will work directly.

## Compare with per-cluster available upgrades

The supported-versions API returns the catalog for an entire Nexus Cluster. To see only the upgrade targets that apply to a specific cluster — already filtered by the [Kubernetes version-skew policy](./reference-nexus-kubernetes-cluster-supported-versions.md#can-i-skip-multiple-kubernetes-versions-during-cluster-upgrade) and the cluster's current bundle — use the per-cluster query, which returns structured upgrade candidates today:

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
