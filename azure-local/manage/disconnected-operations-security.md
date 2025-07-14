---
title: Security controls with disconnected operations on Azure Local (preview)
description: Learn about the security considerations and compliance regulations for disconnected operations on Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 06/20/2025
ai-usage: ai-assisted
---

# Security considerations for Azure Local with disconnected operations (preview)

::: moniker range=">=azloc-2506"

This article explains the security considerations and compliance regulations for disconnected operations with Azure Local VMs enabled by Azure Arc. Learn how to protect your environment and meet regulatory standards when running Azure Local VMs disconnected.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Security and compliance overview

Azure Local with disconnected operations meets security and compliance needs by using a locked down virtual machine (VM) appliance that's accessible only through the following methods:

- **Management Network Interface Card (NIC)**: Lets you run a limited set of commands for deployment and troubleshooting. It's secured with a customer-provided certificate during bootstrapping. For more information, see [Plan your network for disconnected operations](disconnected-operations-network.md).
- **External (Ingress) NIC**: Exposed to users in your network. This network path is for tenants and services of the system. User authentication uses your identity provider and role-based access control. For more information, see [Plan your identity for disconnected operations](disconnected-operations-identity.md).

An Azure Local VM running disconnected operations uses these security features:

- Transport Layer Security (TLS) 1.2, TLS 1.3, Datagram Transport Layer Security (DTLS) 1.2, and signed Server Message Block (SMB) protocol encryption for all data in transit.
- Microsoft Defender guards against viruses and malware.
- Secure boot checks the integrity of boot components.
- Windows Defender Application Control lets only authorized code run in a disconnected operations VM appliance.

For more information about the security features for Azure Local, see [Security features for Azure Local](/azure/azure-local/concepts/security-features).

## Data at rest encryption

By default, data volumes in the Azure Local disconnected operations VM appliance are encrypted with BitLocker using AES-XTS256 bit encryption. BitLocker recovery passwords (key protectors) stay in an internal secure secret store.

### BitLocker recovery key retrieval

Azure Local with disconnected operations manages BitLocker recovery passwords for data at rest encryption. You don't need to provide them for regular operations or during system startup. However, support scenarios might require these passwords to bring the system online. Without these passwords, some support scenarios can cause data loss and require system redeployment.

Follow these steps to get your BitLocker recovery passwords:

1. Import the `Azure.Local.DisconnectedOperations.psd1` module.

    ```powershell
    # Import-Module (if not already done): 
    Import-Module "C:\azurelocal\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force 
    ```

1. Set the context. The command requires a `DisconnectedOperationsClientContext` object as a parameter.

    ```powershell
    $password = ConvertTo-SecureString "RETRACTED" -AsPlainText -Force 
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress "169.254.53.25" 
    ```

1. Run Get-ApplianceBitLockerRecoveryKeys against the management endpoint.

    ```powershell
    $recoveryKeys = Get-ApplianceBitlockerRecoveryKeys $context 
    $recoveryKeys.recoverykeyset 
    ```

    Here's an example of the output:

    ```output
    protectorid                             recoverypassword  
    -----------                             ----------------  
    {DCA51B1F-F694-439E-BC8D-63AC83F956F9}  1141015-055275-382305-1911114-363957-150975-55  
    {264FB985-6E36-466F-94DD-2F2D8328C9F8}  186516-209792-097229-117040-638286-147048-26  
    {CABBDD12-1EDE-4C4D-9985-326F77490E60}  510950-025762-385451-679074-429990-493845-49  
    {067ECC8D-DD78-133E-9886-FA2DC695F6C3}  177397-082045-290301-199375-309676-673838-67  
    {9C658F04-83A8-496D-9107-DE6ECC770E82}  653796-380369-402963-237864-1486629-485254-00  
    {8F84B18A-670E-4B3E-A194-0C6ABA022083}  604494-676940-630740-390940-155859-514789-56  
    ```

1. Get your BitLocker recovery passwords and store them in a secure location outside Azure Local or the Azure Local host.

If your system is experiencing BitLocker issues, like Azure Local with disconnected operations failing to start, contact support and provide your BitLocker recovery passwords.

Manually unlock the virtual hard drive or virtual storage disk using BitLocker recovery passwords. If BitLocker recovery keys aren't available, you need to redeploy the disconnected operations VM appliance.

## Export Host Guardian Service certificates

This procedure isn’t supported in the preview release.

To back up Host Guardian Service certificates from your cluster, run these commands from your seed node:

1. Set the context. The command requires a `DisconnectedOperationsClientContext` object as a parameter.

    ```powershell
    $password = ConvertTo-SecureString "RETRACTED" -AsPlainText -Force 
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress "169.254.53.25" 
    ```

1. To export the Host Guardian Service certificates to a specific path, run `Export-ApplianceHGSCertificates`.

    ```powershell
    Export-ApplianceHGSCertificates -Path D:\AzureLocal\HGSBackup    
    ```
    
## Configure syslog forwarding

You can use the syslog protocol for Azure Local with disconnected operations VM appliance to forward security events to a customer-managed security information and event management (SIEM) system.

The syslog agent of the disconnected operations VM appliance forwards security events in syslog format from the Azure Local VM to the customer-configured syslog server.

To set up syslog forwarding, sign in to the physical host with a domain admin account. Use GET and PUT HTTP commands to check or change the syslog forwarding configuration. The following PowerShell scripts show how to control the syslog forwarder from Azure Local hosts. You can also use any REST client.

For details about setting up syslog forwarding for the Azure Local host, see [Manage syslog forwarding for Azure Local](manage-syslog-forwarding.md).

### Syslog forwarding parameters

The following table provides the parameters for the REST endpoint:

| Parameter                   | Description                                                                 | Type   | Required |  
|-----------------------------|-----------------------------------------------------------------------------|--------|----------|  
| **ClientCertificateThumbprint** | Thumbprint of the client certificate used to communicate with syslog server. | String | No       |  
| **Enabled**                 | Lets you enable or disable the syslog agent in the Azure Local disconnected VM appliance. When disabled, the syslog forwarder configuration is removed and the syslog forwarder stops. | Flag   | Yes      |  
| **NoEncryption**            | Sends syslog messages in clear text.                     | Flag   | No       |  
| **OutputSeverity**          | Sets the output logging level. Use **Default** for warning, critical, or error messages. Use **Verbose** for all severity levels, including verbose, informational, warning, critical, or error. | String | No       |  
| **ServerName**              | FQDN or IP address of the syslog server.                                    | String | No       |  
| **ServerPort**              | Port number used by the syslog server.                              | UInt16 | No       |  
| **SkipServerCertificateCheck** | Skips validation of the syslog server certificate during the initial TLS handshake. | Flag   | No       |  
| **SkipServerCNCheck**       | Skips validation of the Common Name value in the syslog server certificate during the initial TLS handshake. | Flag   | No       |  
| **UseUDP**                  | Uses UDP as the transport protocol for syslog.                                  | Flag   | No       |  
<!--| **ClientCertPfxInBase64**   | Base64-encoded client certificate's public and private keys in `.pfx` format used to communicate with syslog server. | String | No       |  
| **ClientCertPfxPassword**   | Password to use when installing the client certificate passed in `ClientCertPfxInBase64`. | String | No       |
| **RootCertInBase64**        | Base64-encoded root certificate's public key for the Syslog server in `.cer` format. | String | No       |-->

<!--### Syslog forwarding with TCP, mutual authentication, and TLS encryption

In this configuration, the syslog client in Azure Local forwards messages to the syslog server over TCP with TLS encryption. During the initial handshake, the client verifies that the server provides a valid, trusted certificate. The client also provides a certificate to the server as proof of its identity.

This configuration is the most secure because it fully validates the identities of both the client and the server, and it transmits messages over an encrypted channel.

> [!IMPORTANT]
> Microsoft recommends that you use this configuration for production environments.

To configure syslog forwarder with TCP, mutual authentication, and TLS encryption, configure the server and provide a certificate to the client to authenticate against the server.

Run the following cmdlet against a physical host:

```powershell
# Base64-encode the root certificate.
$filename = "<full path to root certificate>"  
$fileContentInBytes = [System.IO.File]::ReadAllBytes($filename)  
$rootCertInBase64 = [System.Convert]::ToBase64String($fileContentInBytes)  
   
# Base64-encode the client certificate and provide its password.
$filename = "<full path to client certificate>"  
$fileContentInBytes = [System.IO.File]::ReadAllBytes($filename)  
$clientCertPfxInBase64 = [System.Convert]::ToBase64String($fileContentInBytes)  
$clientCertPfxPassword = "%Password%"  
   
# Configure syslog forwarder parameters.
$configRequestContent = @{  
    Enabled = $true  
    ServerName = "<FQDN or IP address of syslog server>"  
    ServerPort = "<port number of the syslog server, e.g., 514>"  
    RootCertInBase64 = $rootCertInBase64 # Needed when using self-signed root cert  
    ClientCertPfxInBase64 = $clientCertPfxInBase64  
    ClientCertPfxPassword = $clientCertPfxPassword  
}
   
# Update syslog forwarder configuration.
$IRVMIP = "<Azure Local VM management endpoint IP address>"  
$syslogConfigurationEndpoint = "http://$IRVMIP`:8320/SyslogConfiguration"  
$requestContent = $configRequestContent | ConvertTo-Json  
   
try {
  Invoke-RestMethod -Uri $syslogConfigurationEndpoint -Method Put -Body $requestContent -ContentType "application/json" -Verbose  
}catch {
  $_.Exception
}
```

> [!IMPORTANT]
> The client certificate must contain a private key. If the client certificate is signed using a self-signed root certificate, you must import the root certificate as well.-->

### Configure syslog forwarding with TCP, server authentication, and TLS encryption

In this configuration, the syslog forwarder in Azure Local forwards the messages to the syslog server over TCP with TLS encryption. During the initial handshake, the client also verifies that the server provides a valid, trusted certificate.

This configuration prevents the client from sending messages to untrusted destinations. By default, TCP with authentication and encryption is used, which is the minimum level of security recommended for production. Don't use the `-SkipServerCertificateCheck` flag in production environments.

To enable syslog forwarding with TCP, server authentication, and TLS encryption, prepare a configuration request in PowerShell with the following values:

```powershell
$configRequestContent = @{
    Enabled = $true
    ServerName = "<FQDN or IP address of syslog server>"
    ServerPort = "<port number of the syslog server, e.g., 514>"
}
```

To test integration with a self-signed or untrusted certificate, use these flags to skip server validation during the initial handshake.

- Skip validation of the Common Name value in the server certificate. Use this flag if you enter an IP address for your syslog server.

```powershell
$configRequestContent = @{
    ...
    SkipServerCNCheck = $true
}  
```

- Skip server certificate validation. Use this flag if you use a self-signed certificate for your syslog server.

```powershell
$configRequestContent = @{
    ...  
    SkipServerCertificateCheck = $true
}  
```

### Configure syslog forwarding with TCP and no encryption

In this configuration, the syslog client in Azure Local forwards messages to the syslog server over TCP with no encryption. The client doesn't verify the server's identity or provide its own identity for verification. Don't use this configuration in production environments.

To enable syslog forwarding with TCP and no encryption, prepare a configuration request in PowerShell with the following values:

```powershell
$configRequestContent = @{
    Enabled = $true
    ServerName = "<FQDN or IP address of syslog server>"
    ServerPort = "<port number of the syslog server, e.g., 514>"
    NoEncryption = $true
}
```

> [!IMPORTANT]
> To protect against man-in-the-middle attacks and eavesdropping, use TCP with authentication and encryption in production environments. The handshake between endpoints determines the TLS version, and both TLS 1.2 and TLS 1.3 are supported by default.

### Configure syslog forwarding with UDP and no encryption

In this configuration, the syslog client in Azure Local forwards messages to the syslog server over UDP with no encryption. The client doesn't verify the server's identity or provide its own identity for verification. Don't use this configuration in production environments.

To enable syslog forwarding with UDP and no encryption, prepare a configuration request in PowerShell with the following values:

```powershell
$configRequestContent = @{
    Enabled = $true
    ServerName = "<FQDN or IP address of syslog server>"
    ServerPort = "<port number of the syslog server, e.g., 514>"
    UseUDP = $true
}
```

UDP with no encryption is the easiest to set up, but it doesn't protect against man-in-the-middle attacks or eavesdropping.

## Manage syslog forwarding

### Disable syslog forwarding

To disable syslog forwarding, run this cmdlet:

```powershell
$configRequestContent = @{
    Enabled = $false
    ServerName = "<FQDN or IP address of syslog server>"
    ServerPort = "<port number of the syslog server, e.g., 514>"
}
```

### Syslog setup update

After you define the configuration, send the configuration request by running this PowerShell script:

```powershell
$IRVMIP = "<Azure Local VM management endpoint IP address>"
$clientCertPath = "<path to client certificate pfx file for management endpoint>"
$clientCertPassword = "<client certificate password>"

$syslogConfigurationEndpoint = "https://$IRVMIP`:9443/sysconfig/SyslogConfiguration"
$clientCert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($clientCertPath, $clientCertPassword)

$requestBody = $configRequestContent | ConvertTo-Json

Invoke-RestMethod -Certificate $clientCert -Uri $syslogConfigurationEndpoint -Method Put -Body $requestBody -ContentType "application/json" -Verbose
```

### Syslog setup verification

After you connect the syslog client to your syslog server, you start to receive event notifications. If you don't see notifications, check your cluster syslog forwarder configuration by running this cmdlet:

```powershell
$IRVMIP = "<Azure Local VM management endpoint IP address>"
$clientCertPath = "<path to client certificate pfx file for management endpoint>"
$clientCertPassword = "<client certificate password>"

$syslogConfigurationEndpoint = "https://$IRVMIP`:9443/sysconfig/SyslogConfiguration"
$clientCert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($clientCertPath, $clientCertPassword)

Invoke-RestMethod -Certificate $clientCert -Uri $syslogConfigurationEndpoint -Method Get -ContentType "application/json" -Verbose

```

If a setting property isn't configured, you see its default value when you retrieve the current configuration.

## Reference: Message schema and event log

This section describes the syslog message schema and event definitions.

### Syslog message schema

The syslog forwarder in Azure Local infrastructure sends messages formatted using the Berkeley Software Distribution (BSD) syslog protocol defined in RFC3164. The syslog message payload uses the Common Event Format (CEF).

Each syslog message uses this schema:

`Priority (PRI) | Time | Host | CEF payload |`

The PRI part has two values: *facility* and *severity*. Both values depend on the message type, like Windows Event.

### Common event format payload schema/definitions

The CEF payload uses the following structure. Field mapping varies depending on the message type, like Windows Event.

`CEF: |Version | Device Vendor | Device Product | Device Version | Signature ID | Name | Severity | Extensions |`

- Version: 0.0
- Device Vendor: Microsoft
- Device Product: Microsoft Azure Local
- Device Version: 1.0

### Windows event mapping and examples

All Windows events use the PRI facility value of 10.

- Signature ID: ProviderName:EventID
- Name: TaskName
- Severity: Level. For details, see the following severity table.
- Extension: Custom Extension Name. For details, see the following table.

#### Severity of windows events

| PRI severity value | CEF severity value | Windows event level | MasLevel value (in extension) |
|--------------------|--------------------|---------------------|-------------------------------|
| 7                  | 0                  | Undefined           | Value: 0. Indicates logs at all levels. |
| 2                  | 10                 | Critical            | Value: 1. Indicates logs for a critical alert. |
| 3                  | 8                  | Error               | Value: 2. Indicates logs for an error. |
| 4                  | 5                  | Warning             | Value: 3. Indicates logs for a warning. |
| 6                  | 2                  | Information         | Value: 4. Indicates logs for an informational message. |
| 7                  | 0                  | Verbose             | Value: 5. Indicates logs for a verbose message. |

#### Custom extensions and Windows events in Azure Local

| Custom extension name          | Windows event |
|--------------------------------|---------------|
| MasChannel                     | System        |
| MasComputer                    | test.azurestack.contoso.com |
| MasCorrelationActivityID       | C8F40D7C-3764-423B-A4FA-C994442238AF |
| MasCorrelationRelatedActivityID| C8F40D7C-3764-423B-A4FA-C994442238AF |
| MasEventData                   | svchost!!4132,G,0!!!!EseDiskFlushConsistency!!ESENT!!0x800000 |
| MasEventDescription            | The Group Policy settings for the user were processed successfully. There were no changes detected since the last successful processing of Group Policy. |
| MasEventID                     | 1501          |
| MasEventRecordID               | 26637         |
| MasExecutionProcessID          | 29380         |
| MasExecutionThreadID           | 25480         |
| MasKeywords                    | 0x8000000000000000 |
| MasKeywordName                 | Audit Success |
| MasLevel                       | 4             |
| MasOpcode                      | 1             |
| MasOpcodeName                  | info          |
| MasProviderEventSourceName     |               |
| MasProviderGuid                | AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9 |
| MasProviderName                | Microsoft-Windows-GroupPolicy |
| MasSecurityUserId              | Windows SID   |
| MasTask                        | 0             |
| MasTaskCategory                | Process Creation |
| MasUserData                    | KB4093112!!5112!!Installed!!0x0!!WindowsUpdateAgent Xpath: /Event/UserData/* |
| MasVersion                     | 0             |

### Miscellaneous events

This section lists miscellaneous events that are forwarded. You can't customize these events.

| Event type | Event query |
|------------|-------------|
| Wireless Lan 802.1x authentication events with Peer MAC address | `query="Security!*[System[(EventID=5632)]]"` |
| New service (4697) | `query="Security!*[System[(EventID=4697)]]"` |
| TS session reconnect (4778), TS session disconnect (4779) | `query="Security!*[System[(EventID=4778 or EventID=4779)]]"` |
| Network share object access without IPC$ and Netlogon shares | `query="Security![System[(EventID=5140)] and EventData[Data[@Name='ShareName']!='\\IPC$']]"` |
| System time change (4616) | `query="Security!*[System[(EventID=4616)]]"` |
| Local logons without network or service events | `query="Security!*[System[(EventID=4624)] and EventData[Data[@Name='LogonType']!='3'] and EventData[Data[@Name='LogonType']!='5']]"` |
| Security log cleared events (1102), EventLog Service shutdown (1100) | `query="Security!*[System[(EventID=1102 or EventID=1100)]]"` |
| User initiated logoff | `query="Security!*[System[(EventID=4647)]]"` |
| User logoff for all non-network logon sessions | `query="Security!*[System[(EventID=4634)] and EventData[Data[@Name='LogonType'] != '3']]"` |
| Service logon events if the user account isn't LocalSystem, NetworkService, LocalService | `query="Security!*[System[(EventID=4624)] and EventData[Data[@Name='LogonType']='5'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-18'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-19'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-20']]"` |
| Network share create (5142), Network share delete (5144) | `query="Security!*[System[(EventID=5142 or EventID=5144)]]"` |
| Process create (4688) | `query="Security!*[System[EventID=4688]]"` |
| Event log service events specific to security channel | `query="Security!*[System[Provider[@Name='Microsoft-Windows-Eventlog']]]"` |
| Special privileges (admin-equivalent access) assigned to new logon, excluding LocalSystem | `query="Security!*[System[(EventID=4672)] and EventData[Data != 'S-1-5-18']]"` |
| New user added to local, global, or universal security group | `query="Security!*[System[(EventID=4732 or EventID=4728 or EventID=4756)]]"` |
| User removed from local Administrators group | `query="Security!*[System[(EventID=4733)] and EventData[Data[@Name='TargetUserName']='Administrators']]"` |
| Certificate services received certificate request (4886), approved and certificate issued (4887), denied request (4888) | `query="Security!*[System[(EventID=4886 or EventID=4887 or EventID=4888)]]"` |
| New user account created(4720), user account enabled (4722), user account disabled (4725), user account deleted (4726) | `query="Security!*[System[(EventID=4720 or EventID=4722 or EventID=4725 or EventID=4726)]]"` |
| Anti-malware old events, but only detect events (cuts down noise) | `query="System!*[System[Provider[@Name='Microsoft Antimalware'] and (EventID >= 1116 and EventID <= 1119)]]"` |
| System startup (12 - includes OS/SP/Version) and shut down | `query="System!*[System[Provider[@Name='Microsoft-Windows-Kernel-General'] and (EventID=12 or EventID=13)]]"` |
| Service install (7000), service start failure (7045) | `query="System!*[System[Provider[@Name='Service Control Manager'] and (EventID = 7000 or EventID=7045)]]"` |
| Shutdown initiate requests, with user, process and reason (if supplied) | `query="System!*[System[Provider[@Name='USER32'] and (EventID=1074)]]"` |
| Event log service events | `query="System!*[System[Provider[@Name='Microsoft-Windows-Eventlog']]]"` |
| Other log cleared events (104) | `query="System!*[System[(EventID=104)]]"` |
| EMET/Exploit protection events | `query="Application!*[System[Provider[@Name='EMET']]]"` |
| WER events for application crashes only | `query="Application!*[System[Provider[@Name='Windows Error Reporting']] and EventData[Data='APPCRASH']]"` |
| User logging on with temporary profile (1511), cannot create profile, using temporary profile (1518) | `query="Application!*[System[Provider[@Name='Microsoft-Windows-User Profiles Service'] and (EventID=1511 or EventID=1518)]]"` |
| Application crash/hang events, similar to WER/1001. These include full path to faulting EXE/Module. | `query="Application!*[System[Provider[@Name='Application Error'] and (EventID=1000)] or System[Provider[@Name='Application Hang'] and (EventID=1002)]]"` |
| Task scheduler task registered (106), Task registration deleted (141), Task deleted (142) | `query="Microsoft-Windows-TaskScheduler/Operational!*[System[Provider[@Name='Microsoft-Windows-TaskScheduler'] and (EventID=106 or EventID=141 or EventID=142 )]]"` |
| AppLocker packaged (Modern UI) app execution | `query="Microsoft-Windows-AppLocker/Packaged app-Execution!*"` |
| AppLocker packaged (Modern UI) app installation | `query="Microsoft-Windows-AppLocker/Packaged app-Deployment!*"` |
| Log attempted TS connect to remote server | `query="Microsoft-Windows-TerminalServices-RDPClient/Operational!*[System[(EventID=1024)]]"` |
| Gets all Smart-Card card-holder verification (CHV) events (success and failure) performed on the host. | `query="Microsoft-Windows-SmartCard-Audit/Authentication!*"` |
| Gets all UNC/mapped drive successful connection | `query="Microsoft-Windows-SMBClient/Operational!*[System[(EventID=30622 or EventID=30624)]]"` |
| Modern SysMon event provider | `query="Microsoft-Windows-Sysmon/Operational!*"` |
| Modern Windows Defender event provider detection events (1006-1009) and (1116-1119); plus (5001,5010,5012) required by customers | `query="Microsoft-Windows-Windows Defender/Operational!*[System[( (EventID >= 1006 and EventID <= 1009) or (EventID >= 1116 and EventID <= 1119) or (EventID = 5001 or EventID = 5010 or EventID = 5012) )]]"` |
| Code Integrity events | `query="Microsoft-Windows-CodeIntegrity/Operational!*[System[Provider[@Name='Microsoft-Windows-CodeIntegrity'] and (EventID=3076 or EventID=3077)]]"` |
| CA stop/start events CA service stopped (4880), CA service started (4881), CA DB row(s) deleted (4896), CA template loaded (4898) | `query="Security!*[System[(EventID=4880 or EventID = 4881 or EventID = 4896 or EventID = 4898)]]"` |
| RRAS events – only generated on Microsoft IAS server | `query="Security!*[System[( (EventID >= 6272 and EventID <= 6280) )]]"` |
| Process terminate (4689) | `query="Security!*[System[(EventID = 4689)]]"` |
| Registry modified events for Operations: new registry value created (%%1904), existing registry value modified (%%1905), registry value deleted (%%1904) |`query="Security!*[System[(EventID=4657)] and (EventData[Data[@Name='OperationType'] = '%%1904'] or EventData[Data[@Name='OperationType'] = '%%1905'] or EventData[Data[@Name='OperationType'] = '%%1906'])]"` |
| Existing registry value modified (%%1905), registry value deleted (%%1906) |             |
| Request made to authenticate to wireless network (including Peer MAC (5632)) | `query="Security!*[System[(EventID=5632)]]"` |
| A new external device was recognized by the System(6416) | `query="Security!*[System[(EventID=6416)]]"` |
| RADIUS authentication events user assigned IP address (20274), user successfully authenticated (20250), user disconnected (20275) | `query="System!*[System[Provider[@Name='RemoteAccess'] and (EventID=20274 or EventID=20250 or EventID=20275)]]"` |
| CAPI events build chain (11), private key accessed (70), X509 object (90) | `query="Microsoft-Windows-CAPI2/Operational!*[System[(EventID=11 or EventID=70 or EventID=90)]]"` |
| Groups assigned to new login (except for well known, built-in accounts) | `query="Microsoft-Windows-LSA/Operational!*[System[(EventID=300)] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-20'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-18'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-19']]"` |
| DNS client events | `query="Microsoft-Windows-DNS-Client/Operational!*[System[(EventID=3008)] and EventData[Data[@Name='QueryOptions'] != '140737488355328'] and EventData[Data[@Name='QueryResults']='']]"` |
| Detect User-Mode drivers loaded - for potential BadUSB detection. | `query="Microsoft-Windows-DriverFrameworks-UserMode/Operational!*[System[(EventID=2004)]]"` |
| Legacy PowerShell pipeline execution details (800) | `query="Windows PowerShell!*[System[(EventID=800)]]"` |
| Defender stopped events | `query="System!*[System[(EventID=7036)] and EventData[Data[@Name='param1']='Microsoft Defender Antivirus Network Inspection Service'] and EventData[Data[@Name='param2']='stopped']]"` |
| BitLocker management events | `query="Microsoft-Windows-BitLocker/BitLocker Management!*"` |

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
