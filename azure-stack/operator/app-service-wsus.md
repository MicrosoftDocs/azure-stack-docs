---
title: Updating Windows OS in Azure App Service on Azure Stack Hub
description: Learn about how Windows updates are applied in Azure App Service on Azure Stack Hub and the controls available to an administrator
author: apwestgarth
manager: stefsch

ms.topic: article
ms.date: 08/26/2026
ms.author: anwestg
ms.reviewer: 
ms.lastreviewed: 

# Intent: As an Azure Stack Hub Administrator, I want to configure Windows Update in Azure App Service on Azure Stack Hub so that I can keep the infrastructure up to date.
# Keyword: Notdone: keyword noun phrase

---

# Updating Windows OS in Azure App Service on Azure Stack Hub

The Azure App Service on Azure Stack Hub resource provider consists of various roles, and each role runs on a Windows Server instance. When you update App Service on Azure Stack Hub, the update process applies the latest Windows Server Update Package and Servicing Stack.

## Controlling the frequency of patches from Windows Update

Azure Stack Hub administrators can choose from three modes to search for and apply updates to the underlying Windows OS.

1. **Automatic** - Enable the Windows Update service. Windows Update determines how and when to update.
1. **Managed** - Disable the Windows Update service. Azure App Service runs a Windows Update cycle during `OnStart` of the individual role. This cycle runs whenever the platform or administrator restarts an instance or during an App Service on Azure Stack Hub update.
1. **Disabled** - Disable the Windows Update service. Update Windows with the KB that's included in Azure App Service on Azure Stack Hub releases.

### How do I change the mode of operation?

To change the mode of operation, follow these steps:

1. In the Azure Stack Hub admin portal, go to **Network Security Groups** and view the **ControllersNSG** Network Security Group.

1. By default, remote desktop is disabled for all App Service infrastructure roles. Change the **Inbound_Rdp_3389** rule action to **Allow** access.

1. Go to the resource group that contains the App Service Resource Provider deployment. By default, the name is **AppService.\<region\>**. Connect to **CN0-VM**.

1. Launch the **Web Cloud Management Console**.

1. Go to **Settings** and select the **RunWindowsUpdate** setting.

1. Select **Edit Setting** in the menu bar, change to your preferred mode, and select **OK** to apply.

1. Disconnect the RDP session.

1. In the Azure Stack admin portal, go back to the **ControllersNSG** Network Security Group.

1. Change the **Inbound_Rdp_3389** rule to deny access.

### Configuring Azure App Service on Azure Stack Hub to use Windows Server Update Services as the source for Windows Updates

> [!NOTE]
> These steps don't cover the supporting file server and SQL Server infrastructure because this infrastructure is [customer managed and supported](azure-stack-app-service-before-you-get-started.md#operational-responsibility-for-the-file-server-and-sql-server).

By default, Windows Server uses the public Microsoft Update service to get update packages. Some customers already use, or want to use, Windows Server Update Services to provide update packages to deployed infrastructure within their network.

#### Prerequisites

To use WSUS as the source for Windows Updates to the App Service RP roles, you need to meet the following requirements:

- Your Azure Stack Hub must run Azure App Service on Azure Stack Hub version 2022 H1 or newer. If your Azure Stack Hub runs an older version, upgrade it before you set this configuration.
- Windows Server Update Services must already be [set up and configured](https://go.microsoft.com/fwlink/?LinkId=2378113).
- All clients (App Service role instances - controllers, management servers, front ends, publishers, and workers) must connect by using HTTPS to the WSUS servicing point (default is 8531).

#### Configuration steps

> [!IMPORTANT]
> This configuration doesn't change the behavior of Windows Update on the App Service roles. It only changes the source of the Windows Server update packages. 

 

Follow these steps to configure Microsoft Update on the App Service roles to use WSUS as the source for Microsoft Update packages.
1. In the Azure Stack Hub admin portal, go to **Network Security Groups** and view the **ControllersNSG** Network Security Group.

1. By default, remote desktop is disabled for all App Service infrastructure roles. Change the **Inbound_Rdp_3389** rule action to **Allow** access.

1. Go to the resource group that contains the App Service Resource Provider deployment. By default, the name is **AppService.\<region\>**. Connect to **CN0-VM**.

1. Launch the **Web Cloud Management Console**.

1. Go to **Settings** and select the **AlternativeWSUSServer** setting.

1. Select **Edit Setting** in the menu bar, enter the WSUS endpoint in the form **https://\<WSUSEndpoint\>:\<WSUS Service Port\>**, and select **OK** to apply.

1. Disconnect the RDP session.

1. In the Azure Stack admin portal, go back to the **ControllersNSG** Network Security Group.

1. Change the **Inbound_Rdp_3389** rule to deny access.

1. Go to the **WorkersNSG** Network Security Group.

1. Add a new **Outbound security rule** to allow access to the WSUS servicing endpoint.

    - Source: Any
    - Source port range: *
    - Destination: IP Addresses
    - Destination IP address range: Range of IPs for your WSUS Servicing Endpoint
    - Destination port range: 8531
    - Protocol: Any
    - Action: Allow
    - Priority: 760
    - Name: Outbound_Allow_Outbound_to_WSUS


## Next steps
[Backup App Service on Azure Stack Hub](app-service-back-up.md)
[Restore App Service on Azure Stack Hub](app-service-recover.md)
