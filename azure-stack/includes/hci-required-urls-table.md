---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.topic: include
ms.date: 04/27/2022
ms.lastreviewed: 04/19/2022

---


|Service |  URL | Port | Notes |
|   :---|  :---| :---| :---|
| Azure Stack HCI | login.microsoftonline.com  | 443  | For Active Directory Authority and used for authentication, token fetch, and validation.|
| Azure Stack HCI  | graph.windows.net  | 443  | For Graph and used for authentication, token fetch, and validation.   |
| Azure Stack HCI  | management.azure.com  | 443  | For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. |
| Azure Stack HCI | dp.stackhci.azure.com | 443  | For Dataplane that pushes up diagnostics data and used in the Portal pipeline and pushes billing data.    |
| Azure Stack HCI | azurestackhci.azurefd.net   | 443  | Previous URL for Dataplane. This URL was recently changed, customers who registered their cluster using this old URL must allowlist it as well.  |
| Arc For Servers | aka.ms   | 443  | For resolving the download script during installation.  |
| Arc For Servers | download.microsoft.com  | 443  | For downloading the Windows installation package.   |
| Arc For Servers | login.windows.net  | 443  | For Azure Active Directory     |
| Arc For Servers | login.microsoftonline.com    | 443  | For Azure Active Directory  |
| Arc For Servers | pas.windows.net | 443  | For Azure Active Directory   |
| Arc For Servers | management.azure.com | 443  | For Azure Resource Manager to create or delete the Arc Server resource |
| Arc For Servers | guestnotificationservice.azure.com  | 443  | For the notification service for extension and connectivity scenarios  |
| Arc For Servers | *.his.arc.azure.com  | 443  | For metadata and hybrid identity services |
| Arc For Servers | *.guestconfiguration.azure.com  | 443  | For extension management and guest configuration services  |
| Arc For Servers | *.guestnotificationservice.azure.com   | 443  | For notification service for extension and connectivity scenarios |
| Arc For Servers | azgn*.servicebus.windows.net  | 443  | For notification service for extension and connectivity scenarios  |
| Arc For Servers | *.servicebus.windows.net | 443  | For Windows Admin Center and SSH scenarios |
| Arc For Servers | *.waconazure.com   | 443  | For Windows Admin Center connectivity   |
| Arc For Servers | *.blob.core.windows.net | 443  | For download source for Azure Arc-enabled servers extensions  |