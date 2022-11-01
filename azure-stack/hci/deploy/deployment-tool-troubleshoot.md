---
title: Troubleshoot Azure Stack HCI version 22H2 (preview) deployment
description: Learn to troubleshoot Azure Stack HCI version 22H2 (preview)
author: dansisson
ms.topic: how-to
ms.date: 10/31/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Troubleshoot Azure Stack HCI version 22H2 deployment (preview) 

> Applies to: Azure Stack HCI, version 22H2

For troubleshooting purposes, this article discusses how to rerun and reset deployment if you encounter issues during your deployment.

Also see [Known issues for version 22H2](/manage/preview-channel.md).

## Rerun deployment

To rerun the deployment if there is a failure, follow these steps:



1. Establish a remote desktop protocol (RDP) connection with the first server of your Azure Stack HCI cluster. Use the *option 15* in the *SConfig* to go to the command line. Change the directory to *C:\clouddeployment\setup*.

1. Run the following command on your first (staging) server:
 
    ```powershell
    .\Invoke-CloudDeployment.ps1 -Rerun -Verbose
    ```
    
    This command should restart the deployment in verbose mode.


## Reset deployment

You may have to reset your deployment if it is in a not recoverable state. For example, if it is an incorrect network configuration, or if rerun doesn't resolve the issue. In these cases, do the following:

1. Back up all your data first. The orchestrated deployment will always clean the drives used by Storage Spaces Direct in this preview release.

1. Connect to the first server via remote desktop protocol (RDP). [Reinstall](deployment-tool-install-os.md) the Azure Stack HCI 22H2 operating system.
1. You'll need to clean the Active Directory objects that were created. Connect to your Active Directory Domain server. Run PowerShell as administrator.
1. Identify the `A` records created for your DNS server. Run the following command to get a list of the `A` records created for your DNS server: 
    ```azurepowershell
    Get-DnsServerResourceRecord -ZoneName "<FQDN for your Active Directory Domain Server>"
    ```

1. From the list of the records displayed, identify the type `A` records corresponding to the `RecordType` that are associated with your cluster nodes (`RecordData` should have the cluster node IPs).
1. To remove an `A` record, run the following command:
    ```azurepowershell
    Remove-DnsServerResourceRecord -ZoneName "<FQDN for your Active Directory Domain Server>" -name "<HostName for an A record>" -RRtype A
    ```
    Here's a sample output:

    ```output
   PS C:\temp> get-dnsServerResourceRecord -Zonename ASZ1PLab.nttest.microsoft.com

    HostName                  RecordType Type       Timestamp            TimeToLive      RecordData
    --------                  ---------- ----       ---------            ----------      ----------
    @                         A          1          10/27/2022 1:00:0... 00:10:00        10.57.52.95
    @                         NS         2          0                    01:00:00        svcclient02vm3.asz1plab.nttest.microsoft.com.
    @                         SOA        6          0                    01:00:00        [185][svcclient02vm3.asz1plab.nttest.microsoft....
    _msdcs                    NS         2          0                    01:00:00        svcclient02vm3.asz1plab.nttest.microsoft.com.
    _gc._tcp.Default-First... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][3268][SVCCLIENT02VM3.ASZ1PLab.nttest.m...
    _kerberos._tcp.Default... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][88][SVCCLIENT02VM3.ASZ1PLab.nttest.mic...
    _ldap._tcp.Default-Fir... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _gc._tcp                  SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][3268][SVCCLIENT02VM3.ASZ1PLab.nttest.m...
    _kerberos._tcp            SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][88][SVCCLIENT02VM3.ASZ1PLab.nttest.mic...
    _kpasswd._tcp             SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][464][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _ldap._tcp                SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _kerberos._udp            SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][88][SVCCLIENT02VM3.ASZ1PLab.nttest.mic...
    _kpasswd._udp             SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][464][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    A4P1074000603B            A          1          10/28/2022 10:00:... 00:20:00        10.57.53.236
    A6P15140005012            A          1          10/28/2022 10:00:... 00:20:00        10.57.51.224
    ca-5c55badb-4674-4844-... A          1          10/21/2022 1:00:0... 00:20:00        10.57.48.71
    docspro2-FS               A          1          10/28/2022 11:00:... 00:20:00        10.57.51.224
    docspro2-FS               A          1          10/28/2022 11:00:... 00:20:00        10.57.53.236
    docspro2cluster           A          1          10/28/2022 10:00:... 00:20:00        10.57.48.60
    DomainDnsZones            A          1          10/27/2022 1:00:0... 00:10:00        10.57.52.95
    _ldap._tcp.Default-Fir... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _ldap._tcp.DomainDnsZones SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    ForestDnsZones            A          1          10/27/2022 1:00:0... 00:10:00        10.57.52.95
    _ldap._tcp.Default-Fir... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _ldap._tcp.ForestDnsZones SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    svcclient02vm3            A          1          0                    01:00:00        10.57.52.95
    
    
    PS C:\temp> Remove-DnsServerResourceRecord -Zonename ASZ1PLab.nttest.microsoft.com -name docspro2-FS -RRtype A
    
    Confirm
    Removing DNS resource record set by name docspro2-FS of type A from zone ASZ1PLab.nttest.microsoft.com on SVCCLIENT02VM3 server. Do you want
    to continue?
    [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y
    PS C:\temp> Remove-DnsServerResourceRecord -Zonename ASZ1PLab.nttest.microsoft.com -name docspro2cluster -RRtype A
    
    Confirm
    Removing DNS resource record set by name docspro2cluster of type A from zone ASZ1PLab.nttest.microsoft.com on SVCCLIENT02VM3 server. Do you
    want to continue?
    [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y
    PS C:\temp> Remove-DnsServerResourceRecord -Zonename ASZ1PLab.nttest.microsoft.com -name A4P1074000603B -RRtype A
    
    Confirm
    Removing DNS resource record set by name A4P1074000603B of type A from zone ASZ1PLab.nttest.microsoft.com on SVCCLIENT02VM3 server. Do you
    want to continue?
    [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y
    PS C:\temp> Remove-DnsServerResourceRecord -Zonename ASZ1PLab.nttest.microsoft.com -name A6P15140005012 -RRtype A
    
    Confirm
    Removing DNS resource record set by name A6P15140005012 of type A from zone ASZ1PLab.nttest.microsoft.com on SVCCLIENT02VM3 server. Do you
    want to continue?
    [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y
    PS C:\temp> get-dnsServerResourceRecord -Zonename ASZ1PLab.nttest.microsoft.com
    
    HostName                  RecordType Type       Timestamp            TimeToLive      RecordData
    --------                  ---------- ----       ---------            ----------      ----------
    @                         A          1          10/27/2022 1:00:0... 00:10:00        10.57.52.95
    @                         NS         2          0                    01:00:00        svcclient02vm3.asz1plab.nttest.microsoft.com.
    @                         SOA        6          0                    01:00:00        [189][svcclient02vm3.asz1plab.nttest.microsoft....
    _msdcs                    NS         2          0                    01:00:00        svcclient02vm3.asz1plab.nttest.microsoft.com.
    _gc._tcp.Default-First... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][3268][SVCCLIENT02VM3.ASZ1PLab.nttest.m...
    _kerberos._tcp.Default... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][88][SVCCLIENT02VM3.ASZ1PLab.nttest.mic...
    _ldap._tcp.Default-Fir... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _gc._tcp                  SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][3268][SVCCLIENT02VM3.ASZ1PLab.nttest.m...
    _kerberos._tcp            SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][88][SVCCLIENT02VM3.ASZ1PLab.nttest.mic...
    _kpasswd._tcp             SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][464][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _ldap._tcp                SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _kerberos._udp            SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][88][SVCCLIENT02VM3.ASZ1PLab.nttest.mic...
    _kpasswd._udp             SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][464][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    ca-5c55badb-4674-4844-... A          1          10/21/2022 1:00:0... 00:20:00        10.57.48.71
    DomainDnsZones            A          1          10/27/2022 1:00:0... 00:10:00        10.57.52.95
    _ldap._tcp.Default-Fir... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _ldap._tcp.DomainDnsZones SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    ForestDnsZones            A          1          10/27/2022 1:00:0... 00:10:00        10.57.52.95
    _ldap._tcp.Default-Fir... SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    _ldap._tcp.ForestDnsZones SRV        33         10/27/2022 1:00:0... 00:10:00        [0][100][389][SVCCLIENT02VM3.ASZ1PLab.nttest.mi...
    svcclient02vm3            A          1          0                    01:00:00        10.57.52.95
    
    
    PS C:\temp>
    ```
1. Repeat the above steps to remove all the type `A` records. 
1. Connect to the first server. You can now [Deploy interactively](./deployment-tool-new-file.md) or [Deploy using an existing config file](./deployment-tool-existing-file.md).

## Next steps

- [Collect log data](/manage/collect-logs.md) from your deployment.
- View [known issues](../known-issues-22h2.md) for Azure Stack HCI version 22H2.
