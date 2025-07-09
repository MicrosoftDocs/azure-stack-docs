---
title: Release notes for disconnected operations for Azure Local
description: Read about the known issues and fixed issues for disconnected operations for Azure Local.
author: haraldfianbakken
ms.topic: conceptual
ms.date: 06/27/2025
ms.author: hafianba
ms.reviewer: hafianba
---

# Known issues for disconnected operations for Azure Local
## Unsupported scenarios
The following list is scenarios that have partial functionality and might work, but is unsupported in the current release
- Arc-Enabled servers (Remote/non Azure Local VMs)
- Arc-Enabled K8s (Remote/non AKS clusters)

If you are testing out these scenarios, please note that these systems must trust your custom CA and you need to pass -custom-ca-cert when Arc-enabling them

::: moniker range="=azloc-2506"

<!--[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]-->

This article lists critical known issues and their workarounds in disconnected operations for Azure Local.

These release notes update continuously, and we add critical issues that require a workaround as we find them. Before you deploy disconnected operations with Azure Local, review the information here.

## Known issues for 2506
### Azure Local deployment - Azure Keyvault (permission issues)
RBAC permissions on a newly created Azure Keyvault takes 20 minutes to propagate. If you navigate through the local portal, creating the Azure Keyvault and trying to finalize the cloud deployment - you might hit permission issues when validating the cluster before deployment. 

- ***Resolution***: Wait 20 minutes after creating Azure Keyvault to finalize the cluster deployment. 

### Issues after restarting node or the control plane VM

If you experience issues with the local portal, missing resources, or failed deployments after you restart a node or the control plane VM, the system might not be fully ready.

The system can take an hour after a reboot to become fully ready. If you use the local portal or Azure CLI and experience failures, check the appliance health using the **OperationsModule** to make sure all services are fully converged.

### Azure CLI

The `az cloud show` and `az cloud register` commands treat case sensitivity differently, which can cause issues.

Use only lowercase letters for cloud names in `az cloud` subcommands, such as `register`, `show`, or `set`.

<!--### Deployment

### Azure Local VMs

### AKS on Azure Local-->

### Azure Resource Manager

#### Template specs

Template specs aren't supported in the preview release. Deployments that use ARM templates with template specs fail.

::: moniker-end

::: moniker range="<=azloc-2506"

This feature is available only in Azure Local 2506.

::: moniker-end
