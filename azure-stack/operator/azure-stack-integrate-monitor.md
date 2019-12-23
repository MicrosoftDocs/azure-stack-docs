---
title: Integrate external monitoring solution with Azure Stack | Microsoft Docs
description: Learn how to integrate Azure Stack with an external monitoring solution in your datacenter.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: PowerShell
ms.topic: article
ms.date: 06/05/2019
ms.author: jeffgilb
ms.reviewer: thoroet
ms.lastreviewed: 06/05/2019

---
# Integrate external monitoring solution with Azure Stack

For external monitoring of the Azure Stack infrastructure, you need to monitor the Azure Stack software, the physical computers, and the physical network switches. Each of these areas offers a method to retrieve health and alert information:

- Azure Stack software offers a REST-based API to retrieve health and alerts. The use of software-defined technologies such as Storage Spaces Direct, storage health, and alerts are part of software monitoring.
- Physical computers can make health and alert information available via the baseboard management controllers (BMCs).
- Physical network devices can make health and alert information available via the SNMP protocol.

Each Azure Stack solution ships with a hardware lifecycle host. This host runs the original equipment manufacturer (OEM) hardware vendor's monitoring software for the physical servers and network devices. Check with your OEM provider if their monitoring solutions can integrate with existing monitoring solutions in your datacenter.

> [!IMPORTANT]
> The external monitoring solution you use must be agentless. You can't install third-party agents inside Azure Stack components.

The following diagram shows traffic flow between an Azure Stack integrated system, the hardware lifecycle host, an external monitoring solution, and an external ticketing/data collection system.

![Diagram showing traffic between Azure Stack, monitoring, and ticketing solution.](media/azure-stack-integrate-monitor/MonitoringIntegration.png)  

> [!NOTE]
> External monitoring integration directly with physical servers isn't allowed and actively blocked by Access Control Lists (ACLs). External monitoring integration directly with physical network devices is supported. Check with your OEM provider on how to enable this feature.

This article explains how to integrate Azure Stack with external monitoring solutions such as System Center Operations Manager and Nagios. It also includes how to work with alerts programmatically by using PowerShell or through REST API calls.

## Integrate with Operations Manager

You can use Operations Manager for external monitoring of Azure Stack. The System Center Management Pack for Microsoft Azure Stack enables you to monitor multiple Azure Stack deployments with a single Operations Manager instance. The management pack uses the health resource provider and update resource provider REST APIs to communicate with Azure Stack. If you plan to bypass the OEM monitoring software that's running on the hardware lifecycle host, you can install vendor management packs to monitor physical servers. You can also use Operations Manager network device discovery to monitor network switches.

The management pack for Azure Stack provides the following capabilities:

- You can manage multiple Azure Stack deployments.
- There's support for Azure Active Directory (Azure AD) and Active Directory Federation Services (AD FS).
- You can retrieve and close alerts.
- There's a health and a capacity dashboard.
- Includes Auto Maintenance Mode detection for when patch and update (P&U) is in progress.
- Includes Force Update tasks for deployment and region.
- You can add custom information to a region.
- Supports notification and reporting.

To download the System Center Management Pack and the associated user guide, see [Download System Center Management Pack for Microsoft Azure Stack](https://www.microsoft.com/en-us/download/details.aspx?id=55184). You can also download it directly from Operations Manager.

For a ticketing solution, you can integrate Operations Manager with System Center Service Manager. The integrated product connector enables bidirectional communication that allows you to close an alert in Azure Stack and Operations Manager after you resolve a service request in Service Manager.

The following diagram shows integration of Azure Stack with an existing System Center deployment. You can automate Service Manager further with System Center Orchestrator or Service Management Automation (SMA) to run operations in Azure Stack.

![Diagram showing integration with OM, Service Manager, and SMA.](media/azure-stack-integrate-monitor/SystemCenterIntegration.png)

## Integrate with Nagios

You can set up and configure the Nagios Plugin for Microsoft Azure Stack.

A Nagios monitoring plugin was developed together with partner Cloudbase Solutions, which is available under the permissive free software license - MIT (Massachusetts Institute of Technology).

The plugin is written in Python and leverages the health resource provider REST API. It offers basic functionality to retrieve and close alerts in Azure Stack. Like the System Center management pack, it enables you to add multiple Azure Stack deployments and to send notifications.

With Version 1.2 the Azure Stack – Nagios plugin leverages the Microsoft ADAL library and supports authentication using  Service Principal with a secret or certificate. Also, the configuration has been simplified using a single configuration file with new parameters. It now supports Azure Stack deployments using Azure AD and AD FS as the identity system.

The plugin works with Nagios 4x and XI. To download the plugin, see [Monitoring Azure Stack Alerts](https://exchange.nagios.org/directory/Plugins/Cloud/Monitoring-AzureStack-Alerts/details). The download site also includes installation and configuration details.

### Requirements for Nagios

1. Minimum Nagios Version is 4.x

2. Microsoft Azure Active Directory Python library. This library can be installed using Python PIP.

    ```bash  
    sudo pip install adal pyyaml six
    ```

### Install plugin

This section describes how to install the Azure Stack plugin assuming a default installation of Nagios.

The plugin package contains the following files:

```
azurestack_plugin.py
azurestack_handler.sh
samples/etc/azurestack.cfg
samples/etc/azurestack_commands.cfg
samples/etc/azurestack_contacts.cfg
samples/etc/azurestack_hosts.cfg
samples/etc/azurestack_services.cfg
```

1. Copy the plugin `azurestack_plugin.py` into the following directory: `/usr/local/nagios/libexec`.

2. Copy the handler `azurestack_handler.sh` into the following directory: `/usr/local/nagios/libexec/eventhandlers`.

3. Make sure the plugin file is set to be executable:

    ```bash
    sudo cp azurestack_plugin.py <PLUGINS_DIR>
    sudo chmod +x <PLUGINS_DIR>/azurestack_plugin.py
    ```

### Configure plugin

The following parameters are available to be configured in the azurestack.cfg file. Parameters in bold need to be configured independently from the authentication model you choose.

For more information on how to create an SPN, see [Use an app identity to access resources](azure-stack-create-service-principals.md).

| Parameter | Description | Authentication |
| --- | --- | --- |
| **External_domain_fqdn ** | External Domain FQDN |    |
| **region: ** | Region Name |    |
| **tenant_id: ** | Tenant ID\* |    |
| client_id: | Client ID | SPN with secret |
| client_secret: | Client Password | SPN with secret |
| client_cert\*\*: | Path to Certificate | SPN with certificate |
| client_cert_thumbprint\*\*: | Certificate Thumbprint | SPN with certificate |

\*Tenant ID isn't required for Azure Stack deployments with AD FS.

\*\* Client secret and client cert are mutually exclusive.

The other configuration files contain optional configuration settings as they can be configured in Nagios as well.

> [!Note]  
> Check the location destination in azurestack_hosts.cfg and azurestack_services.cfg.

| Configuration | Description |
| --- | --- |
| azurestack_commands.cfg | Handler configuration no changes requirement |
| azurestack_contacts.cfg | Notification Settings |
| azurestack_hosts.cfg | Azure Stack Deployment Naming |
| azurestack_services.cfg | Configuration of the Service |

### Setup steps

1. Modify the configuration file.

2. Copy the modified configuration files into the following folder: `/usr/local/nagios/etc/objects`.

### Update Nagios configuration

The Nagios configuration needs to be updated to ensure the Azure Stack – Nagios Plugin is loaded.

1. Open the following file:

   ```bash  
   /usr/local/nagios/etc/nagios.cfg
   ```

2. Add the following entry:

   ```bash  
   # Load the Azure Stack Plugin Configuration
   cfg_file=/usr/local/Nagios/etc/objects/azurestack_contacts.cfg
   cfg_file=/usr/local/Nagios/etc/objects/azurestack_commands.cfg
   cfg_file=/usr/local/Nagios/etc/objects/azurestack_hosts.cfg
   cfg_file=/usr/local/Nagios/etc/objects/azurestack_services.cfg
   ```

3. Reload Nagios.

   ```bash  
   sudo service nagios reload
   ```

### Manually close active alerts

Active alerts can be closed within Nagios using the custom notification functionality. The custom notification must be:

```
/close-alert <ALERT_GUID>
```

An alert can also be closed using a terminal with the following command:

```bash
/usr/local/nagios/libexec/azurestack_plugin.py --config-file /usr/local/nagios/etc/objects/azurestack.cfg --action Close --alert-id <ALERT_GUID>
```

### Troubleshooting

Troubleshooting the plugin is done by calling the plugin manually in a terminal. Use the following method:

```bash
/usr/local/nagios/libexec/azurestack_plugin.py --config-file /usr/local/nagios/etc/objects/azurestack.cfg --action Monitor
```

## Use PowerShell to monitor health and alerts

If you're not using Operations Manager, Nagios, or a Nagios-based solution, you can use PowerShell to enable a broad range of monitoring solutions to integrate with Azure Stack.

1. To use PowerShell, make sure that you have [PowerShell installed and configured](azure-stack-powershell-install.md) for an Azure Stack operator environment. Install PowerShell on a local computer that can reach the Resource Manager (administrator) endpoint (https://adminmanagement.[region].[External_FQDN]).

2. Run the following commands to connect to the Azure Stack environment as an Azure Stack operator:

   ```powershell
   Add-AzureRMEnvironment -Name "AzureStackAdmin" -ArmEndpoint https://adminmanagement.[Region].[External_FQDN] `
      -AzureKeyVaultDnsSuffix adminvault.[Region].[External_FQDN] `
      -AzureKeyVaultServiceEndpointResourceId https://adminvault.[Region].[External_FQDN]

   Connect-AzureRmAccount -EnvironmentName "AzureStackAdmin"
   ```

3. Use commands such as the following examples to work with alerts:
   ```powershell
    # Retrieve all alerts
    $Alerts = Get-AzsAlert
    $Alerts

    # Filter for active alerts
    $Active = $Alerts | Where-Object { $_.State -eq "active" }
    $Active

    # Close alert
    Close-AzsAlert -AlertID "ID"

    #Retrieve resource provider health
    $RPHealth = Get-AzsRPHealth
    $RPHealth

    # Retrieve infrastructure role instance health
    $FRPID = $RPHealth | Where-Object { $_.DisplayName -eq "Capacity" }
    Get-AzsRegistrationHealth -ServiceRegistrationId $FRPID.RegistrationId
    ```

## Learn more

For information about built-in health monitoring, see [Monitor health and alerts in Azure Stack](azure-stack-monitor-health.md).

## Next steps

[Security integration](azure-stack-integrate-security.md)
