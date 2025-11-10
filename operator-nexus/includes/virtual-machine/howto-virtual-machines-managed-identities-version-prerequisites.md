---
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
ms.topic: include
ms.service: azure-operator-nexus
---

## Prerequisites on Azure Operator Nexus management bundle, runtime, and API versions

- Ensure that your Operator Nexus Cluster is running management bundle `2510.1` version and runtime version `4.7.0` or later.
  The feature support is available in API version `2025-07-01-preview`, but recommend GA `2025-09-01` version or later.
- The [Azure core CLI](/cli/azure/install-azure-cli) must be installed with version `2.75` or later.
  You can find supported versions in the [Az core CLI release history](/cli/azure/release-notes-azure-cli).
- Make sure the [`networkcloud` az CLI extension](/cli/azure/networkcloud) is installed with a version that supports the required API version.
  You can find supported versions in the [`networkcloud` extension release history](https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst) on GitHub.
  The minimum required version begins in the preview `4.0.0b1` version, but recommend `4.0.0` or later.
- This guide assumes you have a working Operator Nexus Cluster and the necessary permissions to create and manage virtual machines and managed identities in your Azure subscription.
