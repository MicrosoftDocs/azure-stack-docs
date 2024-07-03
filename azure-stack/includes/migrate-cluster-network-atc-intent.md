---
author: ronmiab
ms.topic: include
ms.date: 007/03/2024
ms.author: robess
---

## Example intents

Network ATC modifies how you deploy host networking, not what you deploy. You can deploy multiple scenarios so long as each scenario is supported by Microsoft. Here are some examples of common deployment options, and the PowerShell commands needed. These aren't the only combinations available but they should give you an idea of the possibilities.

For simplicity we only demonstrate two physical adapters per SET team, however it's possible to add more. For more information, please see [Plan Host Networking](../concepts/host-network-requirements.md).

### Fully converged intent

For this intent, compute, storage, and management networks are deployed and managed across all cluster nodes.

:::image type="content" source="media/network-atc/network-atc-2-full-converge.png" alt-text="Fully converged intent" lightbox="media/network-atc/network-atc-2-full-converge.png":::

# [22H2](#tab/22H2)

```powershell
Add-NetIntent -Name ConvergedIntent -Management -Compute -Storage -AdapterName pNIC01, pNIC02
```

# [21H2](#tab/21H2)

```powershell
Add-NetIntent -Name ConvergedIntent -Management -Compute -Storage -ClusterName HCI01 -AdapterName pNIC01, pNIC02
```

---

### Converged compute and storage intent; separate management intent

Two intents are managed across cluster nodes. Management uses pNIC01, and pNIC02; Compute and storage are on different adapters.

:::image type="content" source="media/network-atc/network-atc-3-separate-management-compute-storage.png" alt-text="Storage and compute converged intent"  lightbox="media/network-atc/network-atc-3-separate-management-compute-storage.png":::

# [22H2](#tab/22H2)

```powershell
Add-NetIntent -Name Mgmt -Management -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute_Storage -Compute -Storage -AdapterName pNIC03, pNIC04
```

# [21H2](#tab/21H2)

```powershell
Add-NetIntent -Name Mgmt -Management -ClusterName HCI01 -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute_Storage -Compute -Storage -ClusterName HCI01 -AdapterName pNIC03, pNIC04
```
---

### Fully disaggregated intent

For this intent, compute, storage, and management networks are all managed on different adapters across all cluster nodes.

:::image type="content" source="media/network-atc/network-atc-4-fully-disaggregated.png" alt-text="Fully disaggregated intent"  lightbox="media/network-atc/network-atc-4-fully-disaggregated.png":::

# [22H2](#tab/22H2)

```powershell
Add-NetIntent -Name Mgmt -Management -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute -Compute -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Storage -Storage -AdapterName pNIC05, pNIC06
```

# [21H2](#tab/21H2)

```powershell
Add-NetIntent -Name Mgmt -Management -ClusterName HCI01 -AdapterName pNIC01, pNIC02
Add-NetIntent -Name Compute -Compute -ClusterName HCI01 -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Storage -Storage -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```
---

### Storage-only intent

For this intent, only storage is managed. Management and compute adapters aren't managed by Network ATC.

:::image type="content" source="media/network-atc/network-atc-5-fully-disaggregated-storage-only.png" alt-text="Storage only intent"  lightbox="media/network-atc/network-atc-5-fully-disaggregated-storage-only.png":::

# [22H2](#tab/22H2)

```powershell
Add-NetIntent -Name Storage -Storage -AdapterName pNIC05, pNIC06
```

# [21H2](#tab/21H2)

```powershell
Add-NetIntent -Name Storage -Storage -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```
---

### Compute and management intent

For this intent, compute and management networks are managed, but not storage.

:::image type="content" source="media/network-atc/network-atc-6-disaggregated-management-compute.png" alt-text="Management and compute intent"  lightbox="media/network-atc/network-atc-6-disaggregated-management-compute.png":::

# [22H2](#tab/22H2)

```powershell
Add-NetIntent -Name Management_Compute -Management -Compute -AdapterName pNIC01, pNIC02
```

# [21H2](#tab/21H2)

```powershell
Add-NetIntent -Name Management_Compute -Management -Compute -ClusterName HCI01 -AdapterName pNIC01, pNIC02
```

---

### Multiple compute (switch) intents

For this intent, multiple compute switches are managed.

:::image type="content" source="media/network-atc/network-atc-7-multiple-compute.png" alt-text="Multiple switches intent"  lightbox="media/network-atc/network-atc-7-multiple-compute.png":::

# [22H2](#tab/22H2)

```powershell
Add-NetIntent -Name Compute1 -Compute -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Compute2 -Compute -AdapterName pNIC05, pNIC06
```

# [21H2](#tab/21H2)

```powershell
Add-NetIntent -Name Compute1 -Compute -ClusterName HCI01 -AdapterName pNIC03, pNIC04
Add-NetIntent -Name Compute2 -Compute -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```

---