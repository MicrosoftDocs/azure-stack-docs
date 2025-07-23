---
title: Troubleshoot issue where storage provisioning fails
description: Learn how to troubleshoot and mitigate the issue when storage provisioning fails
ms.topic: troubleshooting
author: rcheeran
ms.author: rcheeran
ms.date: 07/23/2025
ms.reviewer: abha

---

# Troubleshoot storage provisioning issues observed during cluster and node pool creation

This article describes the issue where new AKS Arc nodes are created on a single storage path/volume of the Azure Local cluster, breaking the expected round-robin distribution amongst volumes. Over time, this might cause insufficient disk space on that path, potentially resulting in deployment failures.

## Symptoms

During cluster creation or node pool creation and scale operations you might see the following error message: 

```bash
The system failed to create <Azure resource name>: There is not enough space on the disk.
```


## Cause

- The issue is caused by a recent regression introduced in Azure Local version 2506. 

## Mitigation

This issue was fixed in AKS on [Azure Local, version 2507](/azure/azure-local/whats-new?view=azloc-2507#features-and-improvements-in-2507). That said, this mitigation works only when you create new Azure Local instances with 2507 version. Upgrading from Azure Local versions 2506 to 2507 will not resolve the issue.

### Workaround for Azure Local versions 2506

This issue only affects clusters in Azure Local version 2506. Install the [support module](/azure/aks/aksarc/support-module.md) and run the commands provided in this module. 

```powershell
Test-SupportAksArcKnownIssues
```

Run the following the command to fix this known issue on your deployment.

```powershell
Invoke-SupportAksArcRemediation
```

## Verification

Once the fix is done, you should be able to create your clusters and node pools. If you still encounter issues feel free to reach out to Microsoft Support.  

## Contact Microsoft Support

If the problem persists, collect the [AKS cluster logs](get-on-demand-logs.md) before you [create a support request](aks-troubleshoot.md#open-a-support-request).

## Next steps

- [Use the diagnostic checker tool to identify common environment issues](aks-arc-diagnostic-checker.md)
- [Review AKS on Azure Local architecture](cluster-architecture.md)
