---
title: Validate deployment for Azure Stack HCI version 22H2 (preview)
description: Learn how to validate deployment for Azure Stack HCI version 22H2 (preview)
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Validate deployment for Azure Stack HCI version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

Once your deployment has successfully completed, you should verify and validate your deployment:

## Validate using PowerShell

You can validate your cluster using PowerShell by running the following command in an administrative prompt:

```powershell
get-AzureStackhci
```

## View your cluster in the Azure portal

You can view your cluster, verify it's online, and ensure your server nodes are connected in the Azure portal:

:::image type="content" source="media/deployment-tool/deployment-validate-azure.png" alt-text="Azure portal screen" lightbox="media/deployment-tool/deployment-validate-azure.png":::

## Next step

If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).
