---
title: Other security features for Azure Stack HCI (preview)
description: Learn about security features for Azure Stack HCI security information and event management (SIEM). (preview)
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/13/2023
---

# Other security features for Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes components in the security layer of the Azure Stack HCI, version 23H2 solution for security information and event management (SIEM).

For additional security considerations, see:

- [Security baseline settings on Azure Stack HCI (preview)](/azure-stack/hci/concepts/secure-baseline).
- [BitLocker encryption on Azure Stack HCI (preview)](/azure-stack/hci/concepts/security-bitlocker).

[!INCLUDE [important](../../includes/hci-preview.md)]

## About local built-in user accounts

In this release, the names of local built-in users associated with the `RID 500` and `RID 501` accounts are updated. The following table provides details of the built-in accounts:

|Name |Enabled |Description |
|-----|-----|-----|
|ASBuiltInAdmin |True |Built-in account for administering the computer/domain |
|ASBuiltInGuest |False |Built-in account for guest access to the computer/domain |

> [!Important]
> We recommend that you create your own local administrator account, and also that you disable the well-known `RID 500` user account.

The `ASBuiltInGuest` account is protected by the security baseline drift control mechanism. For more information, see [Security baseline settings for Azure Stack HCI (preview)](/azure-stack/hci/concepts/secure-baseline).

We also added two net new components to Azure Stack HCI in 23H2 release, as follows:

- Secrets management engine.
- SIEM syslog forwarder agent.

## Manage secrets in Azure Stack HCI

The Lifecycle Manager (LCM) stack requires multiple components to maintain secure communications with other infrastructure resources and services. To ensure security, we implemented internal secret creation and rotation capabilities.

All services exposed internally by LCM have authentication or encryption certificates associated with them. When you look into your cluster nodes, you will see several certificates created under the path `LocalMachine/Personal certificate store (Cert:\LocalMachine\My).

Example output from PowerShell:

```Output
Name                          StartDate              EndDate                usage                                                                                  Issuer                              KeyLength KeyExchangeAlgorithm                
----                          ---------              -------                -----                                                                                  ------                              --------- ------------------
CN=DownloadService            11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=ECEngineAgentService       11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Client Authentication (1.3.6.1.5.5.7.3.2)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=ECEngineAgentService       11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=ECEngineService            11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Client Authentication (1.3.6.1.5.5.7.3.2)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=ECEngineService            11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=ECEServiceSecretEncryption 11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=NODE01.contoso.com         11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM {Server Authentication (1.3.6.1.5.5.7.3.1), Client Authentication (1.3.6.1.5.5.7.3.2)} CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=HealthAgent                11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=HealthAgent                11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Client Authentication (1.3.6.1.5.5.7.3.2)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=HealthService              11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Client Authentication (1.3.6.1.5.5.7.3.2)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=HealthService              11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=LogCollectorService        11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=LogCollectorService        11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Client Authentication (1.3.6.1.5.5.7.3.2)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=MetricServiceAgent         11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=PMCService                 11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=URP                        11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Client Authentication (1.3.6.1.5.5.7.3.2)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
CN=URP                        11/27/2023 12:00:00 AM 11/26/2025 12:00:00 AM Server Authentication (1.3.6.1.5.5.7.3.1)                                              CN=AzureStackCertificationAuthority      4096 RSA-PKCS1-KeyEx   
```

This new component enables three major capabilities:

- The ability to create certificates during deployment and post deployment cluster scale actions.
- Automated auto-rotation mechanism before certificates expire, and a customer option to rotate certificates during the lifetime of the cluster.
- The ability to monitor and alert if certificates are still valid.

Run the following cmdlet to manually start a certificate rotation in your Azure Stack HCI cluster:

> [!NOTE]
> This action will take place using LCM actions and will last about 10 minutes, depending on the size of the cluster.  This action affects all nodes that use LCM, and requires the user to belong to the `LCM authorization` group (PREFIX-ECESG) and `CredSSP` for remote Powershell invocation or remote desktop protocol (RDP) connection.

```Powershell
Start-SecretRotation 
```

## Integrate Azure Stack HCI with monitoring solutions using syslog forwarding

Security compliance requires strict log and audit of security events; in Azure Stack HCI, we recommend that customers use our Azure Cloud Sentinel service. For more information, see [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel).

For customers and organizations that require their own local SIEM, Azure Stack HCI, version 23H2 comes with an integrated mechanism that enables customers to forward security-related events to a local SIEM.

Azure Stack HCI has an integrated syslog forwarder that, once configured, emits syslog messages defined in RFC3164, with the payload in Common Event Format (CEF).

The following diagram illustrates integration of Azure Stack HCI with an external SIEM. All audits, security logs, and alerts are collected on each host and exposed via syslog with the CEF payload.  

:::image type="content" source="media/other-security-features/integration-of-azure-stack-hci-with-external-siem.png" alt-text="The following diagram describes the integration of Azure Stack HCI with an external SIEM." border="false" lightbox="media/other-security-features/integration-of-azure-stack-hci-with-external-siem.png":::

## Configure syslog forwarding

Syslog forwarding agents are deployed on every Azure Stack HCI host. Each of the agents will forward syslog messages collected from the host they are on, to the customer configured syslog server.

Syslog forwarding agents work independently from each other but can be managed all together on any one of the hosts. You can use provided cmdlets with administrative privileges on any host to control the behavior of all forwarder agents.

The syslog forwarder in Azure Stack HCI supports the following configurations:

- **Syslog forwarding with TCP, mutual authentication (client and server), and TLS 1.2 encryption:** In this configuration, both the syslog server and the syslog client can verify the identity of each other via certificates. Messages are sent over a TLS 1.2 encrypted channel. For more information, see [Syslog forwarding with TCP, mutual authentication, and TLS 1.2 encryption](#syslog-forwarding-with-tcp-mutual-authentication-and-tls-12-encryption).
- **Syslog forwarding with TCP, server authentication, and TLS 1.2 encryption** In this configuration, the syslog client can verify the identity of the syslog server via a certificate. Messages are sent over a TLS 1.2 encrypted channel. For more information, see [Syslog forwarding with TCP, server authentication, and TLS 1.2 encryption](#syslog-forwarding-with-tcp-server-authentication-and-tls-12-encryption).
- **Syslog forwarding with TCP and no encryption:** In this configuration, the syslog client and syslog server identities aren’t verified. Messages are sent in clear text over TCP. For more information, see [Syslog forwarding with TCP and no encryption](#syslog-forwarding-with-tcp-and-no-encryption).
- **Syslog with UDP and no encryption:** In this configuration, the syslog client and syslog server identities aren’t verified. Messages are sent in clear text over UDP. For more information, see [Syslog forwarding with UDP and no encryption](#syslog-forwarding-with-udp-and-no-encryption).

  >[!IMPORTANT]
  > To protect against man-in-the-middle attacks and eavesdropping of messages, Microsoft strongly recommends that you use TCP with authentication and encryption in production environments.

### Cmdlets to configure syslog forwarding

Configuring syslog forwarder requires access to the physical host using a domain administrator account. A set of PowerShell cmdlets have been added to all Azure Stack HCI hosts to control behavior of the syslog forwarder.

The `Set-AzSSyslogForwarder` cmdlet is used to set the syslog forwarder configuration for all hosts. If successful, an action plan instance will be started to config the syslog forwarder agents across all hosts. The action plan instance ID will be returned.

Use the following cmdlet to pass the syslog server information to the forwarder and to configure the transport protocol, the encryption, the authentication, and the optional certificate used between the client and the server:

```azurepowershell
Set-AzSSyslogForwarder [-ServerName <String>] [-ServerPort <UInt16>] [-NoEncryption] [-SkipServerCertificateCheck | -SkipServerCNCheck] [-UseUDP] [-ClientCertificateThumbprint <String>] [-OutputSeverity {Default | Verbose}] [-Remove] 
```

#### Cmdlet parameters

The following table provides parameters for the `Set-AzSSyslogForwarder` cmdlet:

|Parameter |Description |Type |Required |
|-----|-----|------|-----|
|ServerName |FQDN or IP address of the syslog server. |String |Yes |
|ServerPort |Port number the syslog server is listening on. |UInt16 |Yes |
|NoEncryption |Force the client to send syslog messages in clear text. |Flag |No |
|SkipServerCertificateCheck |Skip validation of the certificate provided by the syslog server during initial TLS handshake. |Flag |No |
|SkipServerCNCheck |Skip validation of the Common Name value of the certificate provided by the syslog server during initial TLS handshake. |Flag |No |
|UseUDP |Use syslog with UDP as transport protocol. |Flag |No |
|ClientCertificateThumbprint |Thumbprint of the client certificate used to communicate with syslog server. |String |No |
|OutputSeverity |Level of output logging. Values are Default or Verbose. Default includes severity levels: warning, critical, or error. Verbose includes all severity levels: verbose, informational, warning, critical, or error. |String |No |
|Remove |Remove current syslog forwarder configuration and stop syslog forwarder. |Flag |No |

### Syslog forwarding with TCP, mutual authentication, and TLS 1.2 encryption

In this configuration, the syslog client in Azure Stack HCI forwards messages to the syslog server over TCP using TLS 1.2 encryption. During the initial handshake, the client verifies that the server provides a valid, trusted certificate. The client also provides a certificate to the server as proof of its identity.

This configuration is the most secure as it provides a full validation of the identity of both the client and the server, and it sends messages over an encrypted channel.

> [!IMPORTANT]
> Microsoft strongly recommends that you use this configuration for production environments.

To configure syslog forwarder with TCP, mutual authentication, and TLS 1.2 encryption, run both these cmdlets against a physical host:

Configure the server and provide certificate to the client to authenticate against the server. Run the following command:

   ```azurepowershell
   Set-AzSSyslogForwarder -ServerName <FQDN or ip address of syslog server> -ServerPort <Port number on which the syslog server is listening on> -ClientCertificateThumbprint <Thumbprint of the client certificate>
   ```

> [!IMPORTANT]
> The client certificate must contain a private key. If the client certificate is signed using a self-signed root certificate, you must import the root certificate as well.

Here is an example to set and import certificates for mutual authentication.

This example script must be run from a deployment virtual machine (DVM).

In this example, certificates should have been stored as pfx files on DVM.

1. Provide credentials and configurations.

   ```azurepowershell
   $syslogServerName = "<FQDN or IP address of syslog server>" 
   $syslogServerPort = "<port of your syslog server>" 
 
   $domainAdmin = "<your domainAdmin account name>" 
   $domainAdminPassword = ConvertTo-SecureString -String "<your domainAdmin account password>" -AsPlainText -Force 
 
   $domainAdminCred = New-Object System.Management.Automation.PSCredential ($domainAdmin, $domainAdminPassword) 
 
   $certPassword = ConvertTo-SecureString -String "<your client certificate password>" -AsPlainText -Force 
   $clientCertPath = "<local file path to your client cert pfx file on DVM>" 
 
   Import-Module C:\CloudDeployment\ECEngine\CloudEngine.dll 

   Import-Module C:\CloudDeployment\ECEngine\TestEceInterface.psm1 

   Import-Module C:\CloudDeployment\ECEngine\EnterpriseCloudEngine.psd1 

   $Parameters = Get-EceInterfaceParameters -RolePath "BareMetal" -InterfaceName Deployment 

   $nodes = Get-ClusterNode -Cluster “s-cluster” | ForEach-Object Name
   ```

1. Import client certificate for ($node in $nodes).

   ```azurepowershell
   { 
   $params = @{  
      ComputerName = $nodeName  
      Credential = $domainAdminCred 
   } 
 
   $session = New-PSSession @params 
 
   $tempPath = Invoke-Command -Session $session -ScriptBlock { 
    return $env:TEMP 
   } 
   $clientCertPathOnNode = "$env:Temp\client.pfx" 
   Copy-Item -ToSession $session -Path $clientCertPath -Destination $clientCertPathOnNode 
 
   $params = @{  
      Session = $session  
      ArgumentList = @($serverName, $serverPort, $clientCertPathOnNode, $certPassword)  
   } 
   Invoke-Command @params -ScriptBlock {  
    param($ServerName, $ServerPort, $certPath, $certPassword) 
 
   Import-PfxCertificate -FilePath $certPath -CertStoreLocation "Cert:\\LocalMachine\My" -Password $certPassword 
    Remove-Item -Path $certPath 
   } 
  
   Remove-PSSession -Session $session 
   } 
 
   Import self-signed root certificate
   ```

   Use the following section only in relevant cases:

   ```azurepowershell
   $rootCertPath = "local file path to your client cert pfx file on DVM" 
   foreach ($node in $nodes) 
   { 
   $params = @{  
      ComputerName = $nodeName  
      Credential = $domainAdminCred 
   }

   $session = New-PSSession @params

   $tempPath = Invoke-Command -Session $session -ScriptBlock { 
    return $env:TEMP 
   } 
  
   $rootCertPathOnNode = "$env:Temp\root.pfx" 
   Copy-Item -ToSession $session -Path $rootCertPath -Destination $rootCertPathOnNode 

   $params = @{  
      Session = $session  
      ArgumentList = @($serverName, $serverPort, $clientCertPathOnNode)  
   } 
  
   Invoke-Command @params -ScriptBlock {  
   param($ServerName, $ServerPort, $certPath) 

   Import-PfxCertificate -FilePath $certPath -CertStoreLocation "Cert:\\LocalMachine\root" -Password $certPassword 
   Remove-Item -Path $certPath 
   } 
   Remove-PSSession -Session $session 
   }
   ```

1. Set the syslog forwarder to use mutual authentication.

   An action plan will be started and its ID will be stored in `$actionPlanInstanceId`. Monitor the action plan and validate that it completes successfully.

   ```azurepowershell
   $clientCert = Get-PfxCertificate -FilePath $clientCertPath 
   $params = @{ 
    ComputerName = $nodes[0] 
    ArgumentList = @($syslogServerName, $syslogServerPort, $clientCert.Thumbprint) 
   } 

   $actionPlanInstanceId = Invoke-Command @params -ScriptBlock { 
  
   param($ServerName, $ServerPort, $ClientCertThumbprint) 
   return Set-AzSSyslogForwarder -ServerName $ServerName -ServerPort $ServerPort -ClientCertificateThumbprint $ClientCertThumbprint 
   }
   ```

### Syslog forwarding with TCP, server authentication, and TLS 1.2 encryption

In this configuration, the syslog forwarder in Azure Stack HCI forwards the messages to the syslog server over TCP, with TLS 1.2 encryption. During the initial handshake, the client also verifies that the server provides a valid, trusted certificate.

This configuration prevents the client from sending messages to untrusted destinations. TCP using authentication and encryption is the default configuration and represents the minimum level of security that Microsoft recommends for a production environment.

```azurepowershell
Set-AzSSyslogForwarder -ServerName <FQDN or ip address of syslog server> -ServerPort <Port number on which the syslog server is listening on>
```

In case you want to test the integration of your syslog server with the Azure Stack HCI syslog forwarder by using a self-signed or untrusted certificate, you can use these flags to skip the server validation done by the client during the initial handshake.

1. Skip validation of the Common Name value in the server certificate. Use this flag if you provide an IP address for your syslog server.

   ```azurepowershell
   Set-AzSSyslogForwarder -ServerName <FQDN or ip address of syslog server> -ServerPort <Port number on which the syslog server is listening on> 
   -SkipServerCNCheck
   ```

1. Skip entirely the server certificate validation.

   ```azurepowershell
   Set-AzSSyslogForwarder -ServerName <FQDN or ip address of syslog server> -ServerPort <Port number on which the syslog server is listening on>  
   -SkipServerCertificateCheck
   ```

> [!IMPORTANT]
> Microsoft recommends against the use of the `-SkipServerCertificateCheck` flag in production environments.

### Syslog forwarding with TCP and no encryption

In this configuration, the syslog client in Azure Stack HCI forwards messages to the syslog server over TCP, with no encryption. The client doesn’t verify the identity of the server nor does it provide its own identity to the server for verification.

```azurepowershell
Set-AzSSyslogForwarder -ServerName <FQDN or ip address of syslog server> -ServerPort <Port number on which the syslog server is listening on> -NoEncryption
```

> [!IMPORTANT]
> Microsoft recommends against using this configuration in production environments.

### Syslog forwarding with UDP and no encryption

In this configuration, the syslog client in Azure Stack HCI forwards messages to the syslog server over UDP, with no encryption. The client doesn’t verify the identity of the server nor does it provide its own identity to the server for verification.

```azurepowershell
Set-AzSSyslogForwarder -ServerName <FQDN or ip address of syslog server> -ServerPort <Port number on which the syslog server is listening on> -UseUDP
```

While UDP with no encryption is the easiest to configure, it doesn’t provide any protection against man-in-the-middle attacks or eavesdropping of messages.

> [!IMPORTANT]
> Microsoft recommends against using this configuration in production environments.

## Remove syslog forwarding

Run the following command to remove the syslog forwarder configuration and stop the syslog forwarder:

```azurepowershell
Set-AzSSyslogForwarder -Remove 
```

## Verify syslog setup

After you successfully connect the syslog client to your syslog server, you will soon start to receive event notifications. If you don’t see notifications, verify your cluster syslog forwarder configuration by running the following cmdlet:

```azurepowershell
Get-AzSSyslogForwarder [-Local | -PerNode | -Cluster] 
```

Each host has its own syslog forwarder agent that uses a local copy of the cluster configuration. They are always expected to be the same as the cluster configuration. You can verify the current configuration on each host by using the following cmdlet:

```azurepowershell
Get-AzSSyslogForwarder -PerNode 
```

You can also use the following comdlet to verify the configuration on the host you are connected to:

```azurepowershell
Get-AzSSyslogForwarder -Local
```

Cmdlet parameters for the `Get-AzSSyslogForwarder` cmdlet:

|Parameter |Description |Type |Required |
|----|----|----|----|
|Local |Show currently used configuration on current host. |Flag |No |
|PerNode |Show currently used configuration on each host. |Flag |No |
|Cluster |Show currently global configuration on Azure Stack HCI. This is the default behavior if no parameter is provided. |Flag |No |

## Enable syslog forwarding

```azurepowershell
Enable-AzSSyslogForwarder [-Force]
```

Syslog forwarder will be enabled with the stored configuration provided by last successful `Set-AzSSyslogForwarder` call. The cmdlet will fail if no configuration has been provided using `Set-AzSSyslogForwarder`.

## Disable syslog forwarding

```azurepowershell
Disable-AzSSyslogForwarder [-Force] 
```

Parameter for `Enable-AzSSyslogForwarder` and `Disable-AzSSyslogForwarder` cmdlets:

|Parameter |Description |Type |Required |
|----|----|----|----|
|Force |If specified, an action plan will always be triggered even if the target state is the same as current. This can be helpful when out-of-band changes need to be reset. |Flag |No |

## Syslog message schema

The syslog forwarder of the Azure Stack HCI infrastructure sends messages formatted following the BSD syslog protocol defined in RFC3164. CEF is also used to format the syslog message payload.

Each syslog message is structured based on this schema:
Priority (PRI) | Time | Host | CEF payload |

The PRI part contains two values: facility and severity. Both depend on the type of message, like Windows Event, etc.

## Common Event Format payload schema

The CEF payload is based on the following structure. The mapping for each field varies depending on the type of message, like Windows Event, etc.

CEF: |Version | Device Vendor | Device Product | Device Version | Signature ID | Name | Severity | Extensions |

- Version: 0.0
- Device Vendor: Microsoft
- Device Product: Microsoft Azure Stack HCI
- Device Version: 1.0

## Windows events mapping and examples

All Windows events use the PRI facility value 10.

- Signature ID: ProviderName:EventID
- Name: TaskName
- Severity: Level. For details, see the following Severity table.
- Extension: Custom Extension Name. For details, see the following Custom Extension table.

### Severity table for Windows events

|PRI severity value |CEF severity value |Windows event level |MasLevel value (in extension) |
|----|----|----|----|
|7 |0 |Undefined |Value: 0. Indicates logs at all levels. |
|2 |10 |Critical |Value: 1. Indicates logs for a critical alert. |
|3 |8 |Error |Value: 2. Indicates logs for an error. |
|4 |5 |	Warning |Value: 3. Indicates logs for a warning. |
|6 |2 |Information |Value: 4. Indicates logs for an informational message. |
|7 |0 |Verbose |Value: 5. Indicates logs for a verbose message. |

### Custom extension table for Windows events in Azure Stack HCI

|Custom extension name |Windows event example |
|----|----|
|MasChannel |System |
|MasComputer |test.azurestack.contoso.com |
|MasCorrelationActivityID |C8F40D7C-3764-423B-A4FA-C994442238AF |
|MasCorrelationRelatedActivityID |C8F40D7C-3764-423B-A4FA-C994442238AF |
|MasEventData |svchost!!4132,G,0!!!!EseDiskFlushConsistency!!ESENT!!0x800000 |
|MasEventDescription |The Group Policy settings for the user were processed successfully. There were no changes detected since the last successful processing of Group Policy. |
|MasEventID |1501 |
|MasEventRecordID |26637 |
|MasExecutionProcessID |29380 |
|MasExecutionThreadID |25480 |
|MasKeywords |0x8000000000000000 |
|MasKeywordName |Audit Success |
|MasLevel |4 |
|MasOpcode |1 |
|MasOpcodeName |info |
|MasProviderEventSourceName |  |
|MasProviderGuid | AEA1B4FA-97D1-45F2-A64C-4D69FFFD92C9 |
|MasProviderName |Microsoft-Windows-GroupPolicy |
|MasSecurityUserId |Windows SID |
|MasTask |0 |
|MasTaskCategory |Process Creation |
|MasUserData | KB4093112!!5112!!Installed!!0x0!!WindowsUpdateAgent Xpath: /Event/UserData/* |
|MasVersion |0 |

## Miscellaneous events

List of miscellaneous events being forwarded. Currently, these events can't be customized.

|Event type |Event query |
|----|----|
|Wireless Lan 802.1x authentication events with Peer MAC address |query="Security!*[System[(EventID=5632)]]" |
|New service (4697) |query="Security!*[System[(EventID=4697)]]" |
|TS Session reconnect (4778), TS Session disconnect (4779) |query="Security!*[System[(EventID=4778 or EventID=4779)]]"|
|Network share object access without IPC$ and Netlogon shares |query="Security!*[System[(EventID=5140)] and EventData[Data[@Name='ShareName']!='\\*\IPC$'] and EventData[Data[@Name='ShareName']!='\\*\NetLogon']]" |
|System Time Change (4616) |query="Security!*[System[(EventID=4616)]]"|
|Local logons without network or service events |query="Security!*[System[(EventID=4624)] and EventData[Data[@Name='LogonType']!='3'] and EventData[Data[@Name='LogonType']!='5']]" |
|Security Log cleared events (1102), EventLog Service shutdown (1100) |query="Security!*[System[(EventID=1102 or EventID=1100)]]"|
|User initiated logoff |query="Security!*[System[(EventID=4647)]]" |
|User logoff for all non-network logon sessions |query="Security!*[System[(EventID=4634)] and EventData[Data[@Name='LogonType'] != '3']]" |
|Service logon events if the user account isn't LocalSystem, NetworkService, LocalService |query="Security!*[System[(EventID=4624)] and EventData[Data[@Name='LogonType']='5'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-18'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-19'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-20']]" |
|Network Share create (5142), Network Share Delete (5144) |query="Security!*[System[(EventID=5142 or EventID=5144)]]" |
|Process Create (4688) |query="Security!*[System[EventID=4688]]" |
|Event log service events specific to Security channel |query="Security!*[System[Provider[@Name='Microsoft-Windows-Eventlog']]]" |
|Special Privileges (Admin-equivalent Access) assigned to new logon, excluding LocalSystem |query="Security!*[System[(EventID=4672)] and EventData[Data[1] != 'S-1-5-18']]" |
|New user added to local, global or universal security group |query="Security!*[System[(EventID=4732 or EventID=4728 or EventID=4756)]]" |
|User removed from local Administrators group |query="Security!*[System[(EventID=4733)] and EventData[Data[@Name='TargetUserName']='Administrators']]" |
|Certificate Services received certificate request (4886), Approved and Certificate issued (4887), Denied request (4888) |query="Security!*[System[(EventID=4886 or EventID=4887 or EventID=4888)]]" |
|New User Account Created(4720), User Account Enabled (4722), User Account Disabled (4725), User Account Deleted (4726) |query="Security!*[System[(EventID=4720 or EventID=4722 or EventID=4725 or EventID=4726)]]" |
|Anti-malware *old* events, but only detect events (cuts down noise) |query="System!*[System[Provider[@Name='Microsoft Antimalware'] and (EventID &gt;= 1116 and EventID &lt;= 1119)]]" |
|System startup (12 - includes OS/SP/Version) and shutdown |query="System!*[System[Provider[@Name='Microsoft-Windows-Kernel-General'] and (EventID=12 or EventID=13)]]" |
|Service Install (7000), service start failure (7045) |query="System!*[System[Provider[@Name='Service Control Manager'] and (EventID = 7000 or EventID=7045)]]" |
|Shutdown initiate requests, with user, process and reason (if supplied) |query="System!*[System[Provider[@Name='USER32'] and (EventID=1074)]]" |
|Event log service events | query="System!*[System[Provider[@Name='Microsoft-Windows-Eventlog']]]" |
|Other Log cleared events (104) |query="System!*[System[(EventID=104)]]" |
|EMET/Exploit protection events |query="Application!*[System[Provider[@Name='EMET']]]" |
|WER events for application crashes only | query="Application!*[System[Provider[@Name='Windows Error Reporting']] and EventData[Data[3]='APPCRASH']]" |
|User logging on with Temporary profile (1511), cannot create profile, using temporary profile (1518) |query="Application!*[System[Provider[@Name='Microsoft-Windows-User Profiles Service'] and (EventID=1511 or EventID=1518)]]" |
|Application crash/hang events, similar to WER/1001. These include full path to faulting EXE/Module. |query="Application!*[System[Provider[@Name='Application Error'] and (EventID=1000)] or System[Provider[@Name='Application Hang'] and (EventID=1002)]]" |
|Task scheduler Task Registered (106),  Task Registration Deleted (141), Task Deleted (142) |query="Microsoft-Windows-TaskScheduler/Operational!*[System[Provider[@Name='Microsoft-Windows-TaskScheduler'] and (EventID=106 or EventID=141 or EventID=142 )]]" |
|AppLocker packaged (Modern UI) app execution |query="Microsoft-Windows-AppLocker/Packaged app-Execution!*" |
|AppLocker packaged (Modern UI) app installation |query="Microsoft-Windows-AppLocker/Packaged app-Deployment!*" |
|Log attempted TS connect to remote server |query="Microsoft-Windows-TerminalServices-RDPClient/Operational!*[System[(EventID=1024)]]" |
|Gets all Smart-card Card-Holder Verification (CHV) events (success and failure) performed on the host. |query="Microsoft-Windows-SmartCard-Audit/Authentication!*" |
|Gets all UNC/mapped drive successful connection |query="Microsoft-Windows-SMBClient/Operational!*[System[(EventID=30622 or EventID=30624)]]" |
|Modern SysMon event provider | query="Microsoft-Windows-Sysmon/Operational!*" |
|Modern Windows Defender event provider Detection events (1006-1009) and (1116-1119); plus (5001,5010,5012) req'd by customers |query="Microsoft-Windows-Windows Defender/Operational!*[System[( (EventID &gt;= 1006 and EventID &lt;= 1009) or (EventID &gt;= 1116 and EventID &lt;= 1119) or (EventID = 5001 or EventID = 5010 or EventID = 5012) )]]" |
|Code Integrity events |query="Microsoft-Windows-CodeIntegrity/Operational!*[System[Provider[@Name='Microsoft-Windows-CodeIntegrity'] and (EventID=3076 or EventID=3077)]]" |
|CA stop/Start events CA Service Stopped (4880), CA Service Started (4881), CA DB row(s) deleted (4896), CA Template loaded (4898) |query="Security!*[System[(EventID=4880 or EventID = 4881 or EventID = 4896 or EventID = 4898)]]" |
|RRAS events – only generated on Microsoft IAS server |query="Security!*[System[( (EventID &gt;= 6272 and EventID &lt;= 6280) )]]" |
|Process Terminate (4689) |query="Security!*[System[(EventID = 4689)]]" |
|Registry modified events for Operations: New Registry Value created (%%1904), Existing Registry Value modified (%%1905), Registry Value Deleted (%%1906) |query="Security!*[System[(EventID=4657)] and (EventData[Data[@Name='OperationType'] = '%%1904'] or EventData[Data[@Name='OperationType'] = '%%1905'] or EventData[Data[@Name='OperationType'] = '%%1906'])]" |
|Request made to authenticate to Wireless network (including Peer MAC (5632)) |query="Security!*[System[(EventID=5632)]]" |
|A new external device was recognized by the System(6416) |query="Security!*[System[(EventID=6416)]]" |
|RADIUS authentication events User Assigned IP address (20274), User successfully authenticated (20250), User Disconnected (20275) |query="System!*[System[Provider[@Name='RemoteAccess'] and (EventID=20274 or EventID=20250 or EventID=20275)]]" |
|CAPI events Build Chain (11), Private Key accessed (70), X509 object (90) |query="Microsoft-Windows-CAPI2/Operational!*[System[(EventID=11 or EventID=70 or EventID=90)]]" |
|Groups assigned to new login (except for well known, built-in accounts) |query="Microsoft-Windows-LSA/Operational!*[System[(EventID=300)] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-20'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-18'] and EventData[Data[@Name='TargetUserSid'] != 'S-1-5-19']]" |
|DNS client events |query="Microsoft-Windows-DNS-Client/Operational!*[System[(EventID=3008)] and EventData[Data[@Name='QueryOptions'] != '140737488355328'] and EventData[Data[@Name='QueryResults']='']]" |
|Detect User-Mode drivers loaded - for potential BadUSB detection. |query="Microsoft-Windows-DriverFrameworks-UserMode/Operational!*[System[(EventID=2004)]]" |
|Legacy PowerShell pipeline execution details (800) |query="Windows PowerShell!*[System[(EventID=800)]]" |
|Defender stopped events |query="System!*[System[(EventID=7036)] and EventData[Data[@Name='param1']='Microsoft Defender Antivirus Network Inspection Service'] and EventData[Data[@Name='param2']='stopped']]" |
|BitLocker Management events |query="Microsoft-Windows-BitLocker/BitLocker Management!*" |


## Next steps

Learn more about:
- [Security baseline settings for Azure Stack HCI](./secure-baseline.md).
- [Windows Defender Application Control for Azure Stack HCI](./security-windows-defender-application-control.md).
- [BitLocker for Azure Stack HCI](./security-bitlocker.md).
