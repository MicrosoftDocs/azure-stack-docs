---
title: Release notes with fixed and known issues in Azure Local
description: Read about the known issues and fixed issues in Azure Local.
author: hafianba
ms.topic: conceptual
ms.date: 06/27/2025
ms.author: hafianba
ms.reviewer: hafianba
---

# Known issues for disconnected operations for Azure Local
::: moniker range="=azloc-2506"

This article identifies critical known issues and their workarounds in disconnected operations for Azure Local.

These release notes are continuously updated, and as critical issues requiring a workaround are discovered, they're added. Before you deploy disconnected operations with Azure Local, carefully review the information contained here.
## Known issues for 2506
### Azure CLI

'az cloud show' vs 'az cloud register' treats case sensitivity different - leading to potential issues. 

Use only lower cases for cloud names for az cloud sub-commands (such as register/show/set).


### Deployment

### Azure Local VMs

### AKS on Azure Local


### Azure Resource Manager 
#### Templatespecs
Templatespecs is not supported for the preview release. A deployment using ARM templates that contains templateSpecs will fail. 

