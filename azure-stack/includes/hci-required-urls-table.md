---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.topic: include
ms.date: 12/11/2023
ms.lastreviewed: 1/01/2023

---


|Service |  URL | Port | Notes |
|   :---|  :---| :---| :---|
| Azure Stack HCI Updates download | fe3.delivery.mp.microsoft.com | 443 | For updating Azure Stack HCI, version 23H2. |
| Azure Stack HCI Updates download | tlu.dl.delivery.mp.microsoft.com | 80 | For updating Azure Stack HCI, version 23H2. |
| Azure Stack HCI | login.microsoftonline.com  | 443  | For Active Directory Authority and used for authentication, token fetch, and validation.|
| Azure Stack HCI  | graph.windows.net  | 443  | For Graph and used for authentication, token fetch, and validation.   |
| Azure Stack HCI  | management.azure.com  | 443  | For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. |
| Azure Stack HCI | dp.stackhci.azure.com | 443  | For Data plane that pushes up diagnostics data and used in the Azure portal pipeline and pushes billing data.    |
| Azure Stack HCI | *.platform.edge.azure.com | 443  | For Data plane used in the licensing and in pushing alerting and billing data. Required only for Azure Stack HCI, version 23H2.   |
| Azure Stack HCI | azurestackhci.azurefd.net   | 443  | Previous URL for Data plane. This URL was recently changed, customers who registered their cluster using this old URL must allowlist it as well.  |
| Arc For Servers | aka.ms   | 443  | For resolving the download script during installation.  |
| Arc For Servers | download.microsoft.com  | 443  | For downloading the Windows installation package.   |
| Arc For Servers | login.windows.net  | 443  | For Microsoft Entra ID     |
| Arc For Servers | login.microsoftonline.com    | 443  | For Microsoft Entra ID  |
| Arc For Servers | pas.windows.net | 443  | For Microsoft Entra ID   |
| Arc For Servers | management.azure.com | 443  | For Azure Resource Manager to create or delete the Arc Server resource |
| Arc For Servers | guestnotificationservice.azure.com  | 443  | For the notification service for extension and connectivity scenarios  |
| Arc For Servers | *.his.arc.azure.com  | 443  | For metadata and hybrid identity services |
| Arc For Servers | *.guestconfiguration.azure.com  | 443  | For extension management and guest configuration services  |
| Arc For Servers | *.guestnotificationservice.azure.com   | 443  | For notification service for extension and connectivity scenarios |
| Arc For Servers | azgn*.servicebus.windows.net  | 443  | For notification service for extension and connectivity scenarios  |
| Arc For Servers | *.servicebus.windows.net | 443  | For Windows Admin Center and SSH scenarios |
| Arc For Servers | *.waconazure.com   | 443  | For Windows Admin Center connectivity   |
| Arc For Servers | *.blob.core.windows.net | 443  | For download source for Azure Arc-enabled servers extensions  |
