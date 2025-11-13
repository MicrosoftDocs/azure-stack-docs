---
author: PerfectChaos
ms.author: chaoschhapi
ms.date: 08/22/2025
ms.topic: include
ms.service: azure-operator-nexus
---

## <a name = "how-to-view-the-full-output-of-a-command-in-the-associated-storage-account"></a> View the full output of a command in the associated storage account

[!INCLUDE [command-output-access](./command-output-access.md)]

After you configure the necessary permissions and access, you can use the link or command from the output summary to download the zipped output file (tar.gz).

You can also download it via the Azure portal:

1. From the Azure portal, go to **Storage Account**.
1. In **Storage account details**, select **Storage browser** from the left menu.
1. In **Storage browser details**, select **Blob containers**.
1. Select the blob container.
1. Select the output file from the command. You can identify the file name in the output summary. Additionally, the **Last modified** time stamp aligns with when the command was run.
1. You can manage and download the output file from the **Overview** pane.
