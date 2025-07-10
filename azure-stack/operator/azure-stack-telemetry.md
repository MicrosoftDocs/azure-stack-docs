---
title: Configure Azure Stack Hub telemetry
titleSuffix: Azure Stack
description: Learn about Azure Stack Hub telemetry and how to configure telemetry settings using PowerShell.
author: sethmanheim

ms.topic: how-to
ms.date: 10/25/2021
ms.author: sethm
ms.reviewer: comartin
ms.lastreviewed: 09/30/2021

# Intent: As an Azure Stack operator, I want to configure telemetry settings using Powershell.
# Keyword: configure telemetry azure stack

---

# Configure Azure Stack Hub telemetry

Azure Stack Hub telemetry automatically uploads system data to Microsoft via the Connected User Experience. Microsoft teams use the data that Azure Stack Hub telemetry gathers to improve customer experiences. This data is also used for security, health, quality, and performance analysis.

For an Azure Stack Hub operator, telemetry can provide valuable insights into enterprise deployments and gives you a voice that helps shape future versions of Azure Stack Hub.

> [!NOTE]
> You can also configure Azure Stack Hub to forward usage information to Azure for billing. This is required for multi-node Azure Stack Hub customers who choose pay-as-you-use billing. Usage reporting is controlled independently from telemetry and isn't required for multi-node customers who choose the capacity model or for Azure Stack Development Kit users. For these scenarios, usage reporting can be turned off [using the registration script](azure-stack-usage-reporting.md).

::: moniker range="< azs-1908"
Azure Stack Hub telemetry is based on the Windows Server 2016 Connected User Experience and Telemetry component.
This component uses the [Event Tracing for Windows (ETW)](/windows/win32/tracelogging/trace-logging-about) TraceLogging technology to gather and store events and data. Azure Stack components use the same technology to publish events and data gathered by using public operating system event logging and tracing APIs. Examples of these Azure Stack Hub components include these providers: Network Resource, Storage Resource, Monitoring Resource, and Update Resource. The Connected User Experience and Telemetry component encrypts data using SSL and uses certificate pinning to transmit data over HTTPS to the Microsoft Data Management service.
::: moniker-end

::: moniker range=">= azs-1908"
Azure Stack Hub telemetry is based on the Windows Server 2019 Connected User Experience and Telemetry component.
This component uses the [Event Tracing for Windows (ETW)](/windows/win32/tracelogging/trace-logging-about) TraceLogging technology to gather and store events and data. Azure Stack components use the same technology to publish events and data gathered by using public operating system event logging and tracing APIs. Examples of these Azure Stack Hub components include these providers: Network Resource, Storage Resource, Monitoring Resource, and Update Resource. The Connected User Experience and Telemetry component encrypts data using SSL and uses certificate pinning to transmit data over HTTPS to the Microsoft Data Management service.
::: moniker-end

## Network requirements

To enable telemetry data flow, the following outbound ports and endpoints must be open and allowed in your network:

::: moniker range="< azs-2108"
| Endpoint | Protocol / Ports | Description |
|---------|---------|---------|
|`https://settings-win.data.microsoft.com` | HTTPS 443 |Cloud configuration endpoint for UTC, DiagTrack, and Feedback hub |
|`https://login.live.com` | HTTPS 443 | Provides a more reliable device identity |
|`*.events.data.microsoft.com` | HTTPS 443 | Endpoint for UTC, DiagTrack, Windows Error Reporting, and Aria |
::: moniker-end

::: moniker range=">= azs-2108"
| Endpoint | Protocol / Ports | Description |
|---------|---------|---------|
|`https://settings-win.data.microsoft.com` | HTTPS 443 |Cloud configuration endpoint for UTC, DiagTrack, and Feedback hub |
|`https://login.live.com` | HTTPS 443 | Provides a more reliable device identity |
|`*.events.data.microsoft.com` | HTTPS 443 | Endpoint for UTC, DiagTrack, Windows Error Reporting, and Aria |
|`https://*.blob.core.windows.net/` | HTTPS 443 | Azure Storage account |
|`https://azsdiagprdwestusfrontend.westus.cloudapp.azure.com/` | HTTPS 443 | Required for successful telemetry data upload to Microsoft |

Beginning with Azure Stack Hub version 2108, telemetry data will upload to Azure Storage account managed and controlled by Microsoft.
::: moniker-end

## Privacy considerations

The ETW service routes telemetry data back to protected cloud storage. The principal of least privilege guides access to telemetry data. Only Microsoft personnel with a valid business need are given access to the telemetry data. Microsoft doesn't share personal customer data with third parties, except at the customer's discretion or for the limited purposes described in the [Microsoft Privacy Statement](https://privacy.microsoft.com/PrivacyStatement). Business reports that are shared with OEMs and partners include aggregated, anonymized data. Data sharing decisions are made by an internal Microsoft team including privacy, legal, and data management stakeholders.

Microsoft believes in, and practices information minimization. We strive to gather only the information that's needed, and store it for only as long as necessary to provide a service or for analysis. Much of the information about how the Azure Stack Hub system and Azure services are functioning is deleted within six months. Summarized or aggregated data will be kept for a longer period.

We understand that the privacy and security of customer information is important.  Microsoft takes a thoughtful and comprehensive approach to customer privacy and the protection of customer data in Azure Stack Hub. IT administrators have controls to customize features and privacy settings at any time. Our commitment to transparency and trust is clear:

- We're open with customers about the types of data we gather.
- We put enterprise customers in control -- they can customize their own privacy settings.
- We put customer privacy and security first.
- We're transparent about how telemetry data gets used.
- We use telemetry data to improve customer experiences.

Microsoft doesn't intend to gather sensitive data, like credit card numbers, usernames and passwords, email addresses, or similar sensitive information. If we determine that sensitive information has been inadvertently received, we delete it.

## Examples of how Microsoft uses the telemetry data

Telemetry plays an important role in helping to quickly identify and fix critical reliability issues in customer deployments and configurations. Insights from telemetry data can help identify issues with services or hardware configurations. Microsoft's ability to get this data from customers and drive improvements to the ecosystem raises the bar for the quality of integrated Azure Stack Hub solutions.

Telemetry also helps Microsoft to better understand how customers deploy components, use features, and use services to achieve their business goals. These insights help prioritize engineering investments in areas that can directly impact customer experiences and workloads.

Some examples include customer use of containers, storage, and networking configurations that are associated with Azure Stack Hub roles. We also use the insights to drive improvements and intelligence into Azure Stack Hub management and monitoring solutions. These improvements make it easier for customers to diagnose issues and save money by making fewer support calls to Microsoft.

## Manage telemetry collection

We don't recommend turning off telemetry in your organization. However, in some scenarios it may be necessary.

In these scenarios, you can configure the telemetry level sent to Microsoft by using registry settings before you deploy Azure Stack Hub, or by using the Telemetry Endpoints after you deploy Azure Stack Hub.

### Telemetry levels and data collection

Before you change telemetry settings, you should understand the telemetry levels and what data is collected at each level.

The telemetry settings are grouped into four levels (0-3) that are cumulative and categorized as the follows:

**0 (Security)**</br>
Security data only. Information that's required to keep the operating system secure. This includes data about the Connected User Experience and Telemetry component settings, and Windows Defender. No telemetry specific to Azure Stack Hub is emitted at this level.

**1 (Basic)**</br>
Security data, and Basic Health and Quality data. Basic device information, including: quality-related data, app compatibility, app usage data, and data from the **Security** level. Setting your telemetry level to Basic enables Azure Stack Hub telemetry. The data gathered at this level includes:

::: moniker range="< azs-1908"
- *Basic device information* that provides an understanding about the types and configurations of native and virtual Windows Server 2016 instances in the ecosystem. This includes:
  - Machine attributes, such as the OEM, and model.
  - Networking attributes, such as the number of network adapters and their speed.
  - Processor and memory attributes, such as the number of cores, and amount of installed memory.
  - Storage attributes, such as the number of drives, type of drive, and drive size.
::: moniker-end
::: moniker range=">= azs-1908"
- *Basic device information* that provides an understanding about the types and configurations of native and virtual Windows Server 2019 instances in the ecosystem. This includes:
  - Machine attributes, such as the OEM, and model.
  - Networking attributes, such as the number of network adapters and their speed.
  - Processor and memory attributes, such as the number of cores, and amount of installed memory.
  - Storage attributes, such as the number of drives, type of drive, and drive size.
::: moniker-end
- *Telemetry functionality*, including the percentage of uploaded events, dropped events, and the last data upload time.
- *Quality-related information* that helps Microsoft develop a basic understanding of how Azure Stack Hub is performing. For example, the count of critical alerts on a particular hardware configuration.
- *Compatibility data* that helps provide an understanding about which Resource Providers are installed on a system and a virtual machine (VM). This identifies potential compatibility problems.

**2 (Enhanced)**</br>
Additional insights, including: how the operating system and Azure Stack Hub services are used, how these services perform, advanced reliability data, and data from the **Security** and **Basic** levels.

> [!NOTE]
> This is the default telemetry setting.

**3 (Full)**</br>
All data necessary to identify and help to fix problems, plus data from the **Security**, **Basic**, and **Enhanced** levels.

> [!IMPORTANT]
> These telemetry levels only apply to Microsoft Azure Stack Hub components. Non-Microsoft software components and services that are running in the Hardware Lifecycle Host from Azure Stack Hub hardware partners may communicate with their cloud services outside of these telemetry levels. You should work with your Azure Stack Hub hardware solution provider to understand their telemetry policy, and how you can opt in or opt out.

Turning off Windows and Azure Stack Hub telemetry also disables SQL telemetry. For more information about the implications of the Windows Server telemetry settings, see the [Windows Telemetry Whitepaper](/windows/privacy/configure-windows-diagnostic-data-in-your-organization).

### ASDK: set the telemetry level in the Windows registry

You can use the Windows Registry Editor to manually set the telemetry level on the physical host computer before you deploy Azure Stack Hub. If a management policy already exists, such as Group Policy, it overrides this registry setting.

Before you deploy Azure Stack Hub on the development kit host, boot into CloudBuilder.vhdx and run the following script in an elevated PowerShell window:

```powershell
### Get current AllowTelemetry value on DVM Host
(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" `
-Name AllowTelemetry).AllowTelemetry
### Set & Get updated AllowTelemetry value for ASDK-Host
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" `
-Name "AllowTelemetry" -Value '0' # Set this value to 0,1,2,or3.  
(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" `
-Name AllowTelemetry).AllowTelemetry
```

### ASDK and Multi-Node: enable or disable telemetry after deployment

To enable or disable telemetry after deployment, you need access to the privileged endpoint (PEP) which is exposed on the ERCS VMs.

- To Enable: `Set-Telemetry -Enable`
- To Disable: `Set-Telemetry -Disable`

PARAMETER details:
- `.PARAMETER Enable` - Turn on telemetry data upload
- `.PARAMETER Disable` - Turn off telemetry data upload  

**Script to enable telemetry:**

```powershell
$ip = "<IP ADDRESS OF THE PEP VM>" # You can also use the machine name instead of IP here.
$pwd= ConvertTo-SecureString "<CLOUD ADMIN PASSWORD>" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("<DOMAIN NAME>\CloudAdmin", $pwd)
$psSession = New-PSSession -ComputerName $ip -ConfigurationName PrivilegedEndpoint -Credential $cred -SessionOption (New-PSSessionOption -Culture en-US -UICulture en-US)
Invoke-Command -Session $psSession {Set-Telemetry -Enable}
if($psSession)
{
    Remove-PSSession $psSession
}
```

**Script to disable telemetry:**

```powershell
$ip = "<IP ADDRESS OF THE PEP VM>" # You can also use the machine name instead of IP here.
$pwd= ConvertTo-SecureString "<CLOUD ADMIN PASSWORD>" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ("<DOMAIN NAME>\CloudAdmin", $pwd)
$psSession = New-PSSession -ComputerName $ip -ConfigurationName PrivilegedEndpoint -Credential $cred -SessionOption (New-PSSessionOption -Culture en-US -UICulture en-US)
Invoke-Command -Session $psSession {Set-Telemetry -Disable}
if($psSession)
{
    Remove-PSSession $psSession
}
```

## Next steps

[Register Azure Stack Hub with Azure](azure-stack-registration.md)
