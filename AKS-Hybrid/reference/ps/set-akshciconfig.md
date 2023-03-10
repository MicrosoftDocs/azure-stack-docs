---
title: Set-AksHciConfig for AKS hybrid
description: The Set-AksHciConfig PowerShell command updates the configurations settings for the Azure Kubernetes Service host.
ms.topic: reference
ms.date: 01/25/2023
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 01/25/2023
ms.reviewer: jeguan

---

# Set-AksHciConfig

## Synopsis

Sets or updates the configuration settings for the Azure Kubernetes Service host.

## Syntax

### Set configuration for host

```powershell
Set-AksHciConfig  -imageDir <String>
                  -workingDir <String>
                  -cloudConfigLocation <String>
                  -vnet <Virtual Network>
                 [-createAutoConfigContainers {true, false}]
                 [-offlineDownload]
                 [-offsiteTransferCompleted]
                 [-stagingShare <String>]
                 [-nodeConfigLocation <String>]
                 [-controlPlaneVmSize <VmSize>]
                 [-sshPublicKey <String>]
                 [-macPoolStart <String>]
                 [-macPoolEnd <String>]       
                 [-proxySettings <ProxySettings>]
                 [-cloudServiceCidr <String>]
                 [-version <String>]
                 [-nodeAgentPort <int>]
                 [-nodeAgentAuthorizerPort <int>]
                 [-cloudAgentPort <int>]
                 [-cloudAgentAuthorizerPort <int>]
                 [-clusterRoleName <String>]
                 [-cloudLocation <String>]
                 [-concurrentDownloads <int>]
                 [-skipHostLimitChecks]
                 [-skipRemotingChecks]
                 [-skipValidationChecks]
                 [-insecure]
                 [-skipUpdates]
                 [-forceDnsReplication]   
```

## Description

Sets the configuration settings for the Azure Kubernetes Service host. If you're deploying on a 2-4 node Azure Stack HCI cluster or a Windows Server 2019 Datacenter failover cluster, you must specify the `-workingDir` and `-cloudConfigLocation` parameters. For a single-node Windows Server 2019 Datacenter, all parameters are optional and set to their default values. However, for optimal performance, we recommend using a 2-4 node Azure Stack HCI cluster deployment.

## Examples

### To deploy on a 2-4 node cluster with DHCP networking

```powershell
PS C:\> $vnet = New-AksHciNetworkSetting -name newNetwork -vswitchName "DefaultSwitch" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" 

Set-AksHciConfig -workingDir c:\ClusterStorage\Volume1\WorkDir -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16"
```

### To deploy with static IP networking

```powershell
PS C:\> $vnet = New-AksHciNetworkSetting -name newNetwork -vswitchName "DefaultSwitch" -k8snodeippoolstart "172.16.10.0" -k8snodeippoolend "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipaddressprefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsservers "172.16.0.1" 

Set-AksHciConfig -workingDir c:\ClusterStorage\Volume1\WorkDir -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16"
```

### To deploy with a proxy server

```powershell
PS C:\> $proxySettings = New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 -credential $proxyCredential

Set-AksHciConfig -workingDir c:\ClusterStorage\Volume1\WorkDir -cloudConfigLocation c:\clusterstorage\volume1\Config -proxySetting $proxySettings -vnet $vnet -cloudservicecidr "172.16.10.10/16"
```

## Parameters

### -imageDir

The path to the directory in which AKS hybrid will store its VHD images. This parameter is required. The path must point to a shared storage path, such as `C:\ClusterStorage\Volume2\ImageStore`, or an SMB share, such as `\\FileShare\ImageStore`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: %systemdrive%\AksHciImageStore
Accept pipeline input: False
Accept wildcard characters: False
```

### -workingDir

This is a working directory for the module to use for storing small files. This parameter is required. The path must point to a shared storage path, such as `c:\ClusterStorage\Volume2\ImageStore`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: %systemdrive%\AksHci
Accept pipeline input: False
Accept wildcard characters: False
```

### -cloudConfigLocation

The location in which the cloud agent stores its configuration. This parameter is required. The path must point to a shared storage path, such as `C:\ClusterStorage\Volume2\ImageStore`, or an SMB share such as `\\FileShare\ImageStore`. The location needs to be on a highly available share so that the storage is always accessible.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: %systemdrive%\wssdcloudagent
Accept pipeline input: False
Accept wildcard characters: False
```

### -vnet

The name of the **AksHciNetworkSetting** object created with the `New-AksHciNetworkSetting` command.

```yaml
Type: VirtualNetwork
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -createAutoConfigContainers

Allows you to disable auto distribution of VM data on your cluster shared volumes (CSV). To disable auto distribution, use `false` as the argument for this parameter. If auto distribution is disabled, only the CSV you selected for `imageDir` will be used. The default value is `true`.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -offlineDownload

Invokes offline download during [Install-AksHci](install-akshci.md). You must also run [Enable-AksHciOfflineDownload](enable-akshciofflinedownload.md). This flag is used in tandem with the `-stagingShare` parameter.

```yaml
Type: System.Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -offsiteTransferCompleted

Sets deployment to use artifacts downloaded offsite and transfered to deployment server during [Install-AksHci](install-akshci.md). This flag is used in tandem with the `-offlineDownload` and `-stagingShare` parameter.

### -stagingShare

The local path to where you want the images to be downloaded. Use in tandem with the `offlineDownload` parameter.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -nodeConfigLocation

The location in which the node agents store their configuration. Every node has a node agent, so its configuration is local to that node. This location must be a local path. Defaults to `%systemdrive%\programdata\wssdagent` for all deployments.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: %systemdrive%\programdata\wssdagent
Accept pipeline input: False
Accept wildcard characters: False
```

### -controlPlaneVmSize

The size of the VM to create for the control plane. To get a list of available VM sizes, run `Get-AksHciVmSize`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Standard_A4_V2
Accept pipeline input: False
Accept wildcard characters: False
```

### -sshPublicKey

Path to an SSH public key file. Using this public key, you will be able to log in to any of the VMs created by the AKS hybrid deployment. If you have your own SSH public key, pass its location here. If no key is provided, we will look for one under `%systemdrive%\akshci\.ssh\akshci_rsa`.pub. If the file does not exist, an SSH key pair in the above location is generated and used.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -macPoolStart

Specifies the start of the MAC address of the MAC pool that you want to use for the Azure Kubernetes Service host VM. The syntax for the MAC address requires that the least significant bit of the first byte should always be 0, and the first byte should always be an even number (that is, 00, 02, 04, 06...). A typical MAC address can look like this: 02:1E:2B:78:00:00. Use MAC pools for long-lived deployments so that MAC addresses assigned are consistent. MAC pools are useful if you have a requirement that the VMs have specific MAC addresses. The default is `None`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -macPoolEnd

Specifies the end of the MAC address of the MAC pool that you want to use for the Azure Kubernetes Service host VM. The syntax for the MAC address requires that the least significant bit of the first byte should always be 0, and the first byte should always be an even number (that is, 00, 02, 04, 06...). The first byte of the address passed as the `-macPoolEnd` should be the same as the first byte of the address passed as the `-macPoolStart`. Use MAC pools for long-lived deployments so that MAC addresses assigned are consistent. MAC pools are useful if you have a requirement that the VMs have specific MAC addresses. The default is `None`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -proxySettings

The proxy object created using [New-AksHciProxySetting](new-akshciproxysetting.md).

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -cloudServiceCidr

Provides a static IP/network prefix to be assigned to the MOC CloudAgent service. This value should be provided using the CIDR format; for example, **192.168.1.2/16**. You may want to specify this parameter to ensure that anything important on the network is always accessible, because the IP address will not change. The default is `None`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -version

The version of AKS hybrid that you want to deploy. The default is the latest version. We do not recommend changing the default.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Latest version
Accept pipeline input: False
Accept wildcard characters: False
```

### -nodeAgentPort

The TCP/IP port number on which node agents should listen, which defaults to 45000. We do not recommend changing the default.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 45000
Accept pipeline input: False
Accept wildcard characters: False
```

### -nodeAgentAuthorizerPort

The TCP/IP port number that node agents should use for their authorization port. Defaults to 45001. We do not recommend changing the default.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 45001
Accept pipeline input: False
Accept wildcard characters: False
```

### -cloudAgentPort

The TCP/IP port number that the cloud agent should listen on. Defaults to 55000. We do not recommend changing the default.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 55000
Accept pipeline input: False
Accept wildcard characters: False
```

### -cloudAgentAuthorizerPort

The TCP/IP port number that the cloud agent should use for its authorization port. Defaults to 65000. We do not recommend changing the default.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 65000
Accept pipeline input: False
Accept wildcard characters: False
```

### -clusterRoleName

Specifies the name to use when creating the cloud agent as a generic service within the cluster. This parameter defaults to a unique name with a prefix of **ca-** and a GUID suffix. We do not recommend changing the default.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: A unique name with a prefix of ca- and a guid suffix
Accept pipeline input: False
Accept wildcard characters: False
```

### -cloudLocation

Provides a custom Microsoft Operated Cloud location name. The default name is **MocLocation**. We do not recommend changing the default.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: MocLocation
Accept pipeline input: False
Accept wildcard characters: False
```

### -skipHostLimitChecks

Requests that the script skips any checks to confirm that memory and disk space is available before allowing the deployment to proceed. We do not recommend using this setting.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -skipRemotingChecks

Requests that the script skips any checks to confirm remoting capabilities to both local and remote nodes. We do not recommend using this setting.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -insecure

Deploys AKS hybrid components, such as cloud agent and node agent(s), in insecure mode (no TLS secured connections). We do not recommend using insecure mode in production environments.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -skipUpdates

Use this flag if you want to skip any updates available. We do not recommend using this setting.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -forceDnsReplication

DNS replication can take up to an hour on some systems. This causes the deployment to be slow. If you experience this issue, you'll see that `Install-AksHci` will be stuck in a loop. To get past this issue, try to use this flag. The `-forceDnsReplication` flag is not a guaranteed fix. If the logic behind the flag fails, the error will be hidden, and the command will proceed as if the flag was not provided.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -skipValidationChecks

Use this flag if you want to skip the validation checks of the environment infrastructure and user configuration input. These checks will highlight potential issues to address before proceeding with the install. We do not recommend using this setting.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksHci PowerShell Reference](index.md)
