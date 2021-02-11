---
external help file: 
Module Name: Aks.Hci
online version: 
schema: 
---

# Set-AksHciConfig

## Synopsis
Set or update the configurations settings for the Azure Kubernetes Service host.

## Syntax

### Set configuration for host
```powershell
Set-AksHciConfig [-imageDir <String>]
                 [-cloudConfigLocation <String>]
                 [-nodeConfigLocation <String>]
                 [-vnet <Virtual Network>]
                 [-controlPlaneVmSize <VmSize>]
                 [-sshPublicKey <String>]
                 [-macPoolStart <String>]
                 [-macPoolEnd <String>]       
                 [-proxyServerHTTP <String>]
                 [-proxyServerHTTPS <String>]
                 [-proxyServerNoProxy <String>]
                 [-proxyServerCertFile <String>]
                 [-proxyServerCredential <PSCredential>]
                 [-cloudServiceCidr <String>]
                 [-workingDir <String>]
                 [-version <String>]
                 [-nodeAgentPort <int>]
                 [-nodeAgentAuthorizerPort <int>]
                 [-clusterRoleName <String>]
                 [-cloudLocation <String>]
                 [-skipHostLimitChecks]
                 [-insecure]
                 [-skipUpdates]
                 [-forceDnsReplication]
                 [-enableDiagnosticData]   
```

## Description
Set the configuration settings for the Azure Kubernetes Service host. If you're deploying on a 2-4 node Azure Stack HCI cluster or a Windows Server 2019 Datacenter failover cluster, you must specify the imageDir and cloudConfigLocation parameters. For a single node Windows Server 2019 Datacenter, all parameters are optional and set to their default values. However, for optimal performance, we recommend using a 2-4 node Azure Stack HCI cluster deployment.

## Examples

### To deploy on a 2-4 node cluster with DHCP networking
```powershell
PS C:\> Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config
```

### To deploy with a virtual IP pool
```powershell
PS C:\> New-AksHciNetworkSetting -name newNetwork -subnetCidr 192.168.2.0/32 -defaultGateway 192.168.2.1 -subnetVSwitch External -vipPoolStart 192.168.2.20 -vipPoolEnd 192.168.2.80   
PS C:\> Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -networkSettings newNetwork
```

### To deploy with a proxy server
```powershell
PS C:\> $credential = Get-Credential
```

```powershell
PS C:\> Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -proxyServerHttp "http://proxy.contoso.com:8888" -proxyServerHttps "http://proxy.contoso.com:8888" -proxyServerNoProxy "localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16,10.231.110.0/24,10.68.237.0/24" -proxyServerCredential $credential
```

## Parameters

### -imageDir
The path to the directory where Azure Kubernetes Service on Azure Stack HCI will store its VHD images. Defaults to `%systemdrive%\AksHciImageStore` for single node deployments. For multi-node deployments, this parameter must be specified. The path must point to a shared storage path such as `C:\ClusterStorage\Volume2\ImageStore` or an SMB share such as `\\FileShare\ImageStore`.

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

### -cloudConfigLocation
The location where the cloud agent will store its configuration. Defaults to `%systemdrive%\wssdcloudagent` for single node deployments. The location can be the same as the path of -imageDir above. For multi-node deployments, this parameter must be specified. The path must point to a shared storage path such as `C:\ClusterStorage\Volume2\ImageStore` or an SMB share such as `\\FileShare\ImageStore`. The location needs to be on a highly available share so that the storage will always be accessible.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: %systemdrive%\wssdcloudagent
Accept pipeline input: False
Accept wildcard characters: False
```

### -nodeConfigLocation
The location where the node agents will store their configuration. Every node has a node agent, so its configuration is local to it. This location must be a local path. Defaults to `%systemdrive%\programdata\wssdagent` for all deployments.

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

### -vnet
The name of the AksHciNetworkSetting object created with New-AksHciNetworkSetting command.
```yaml
Type: VirtualNetwork
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -controlPlaneVmSize
The size of the VM to create for the control plane. Default is Standard_A4_V2. To get a list of available VM sizes, run `Get-AksHciVmSize`.

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
Path to an SSH public key file. Using this public key, you will be able to log in to any of the VMs created by the Azure Kubernetes Service on Azure Stack HCI deployment. If you have your own SSH public key, you will pass its location here. If no key is provided, we will look for one under `%systemdrive%\akshci\.ssh\akshci_rsa`.pub. If the file does not exist, an SSH key pair in the above location will be generated and used.

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
This is used to specify the start of the MAC address of the MAC pool that you wish to use for the Azure Kubernetes Service host VM. The syntax for the MAC address requires that the least significant bit of the first byte should always be 0, and the first byte should always be an even number (that is, 00, 02, 04, 06...). A typical MAC address can look like: 02:1E:2B:78:00:00. Use MAC pools for long-lived deployments so that MAC addresses assigned are consistent. This is useful if you have a requirement that the VMs have specific MAC addresses. Default is none.

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
This is used to specify the end of the MAC address of the MAC pool that you wish to use for the Azure Kubernetes Service host VM. The syntax for the MAC address requires that the least significant bit of the first byte should always be 0, and the first byte should always be an even number (that is, 00, 02, 04, 06...). The first byte of the address passed as the -macPoolEnd should be the same as the first byte of the address passed as the -macPoolStart. Use MAC pools for long-lived deployments so that MAC addresses assigned are consistent. This is useful if you have a requirement that the VMs have specific MAC addresses. Default is none.

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

### -proxyServerHTTP
This provides a proxy server URI that should be used by all components that need to reach HTTP endpoints. The URI format includes the URI schema, server address, and port (that is, https://server.com:8888). Default is none.

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

### -proxyServerHTTPS
This provides a proxy server URI that should be used by all components that need to reach HTTPS endpoints. The URI format includes the URI schema, server address, and port (that is, https://server.com:8888). Default is none.

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

### -proxyServerNoProxy
This is a comma-delimited string of addresses that will be exempt from the proxy. Default value is localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16. This excludes the localhost traffic (localhost, 127.0.0.1), internal Kubernetes service traffic (.svc), the Kubernetes Service CIDR (10.96.0.0/12), and the Kubernetes POD CIDR (10.244.0.0/16) from the proxy server. You can use this parameter to add more subnet ranges or name exemptions. **The settings for this parameter are very important because, if it's not correctly configured, you may unexpectedly route internal Kubernetes cluster traffic to your proxy. This can cause various failures in network communication.**

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

### -proxyServerCertFile
The certificate used to authenticate to the proxy server.

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

### -proxyServerCredential
This provides the username and password to authenticate to your HTTP/HTTPS proxy servers. You can use `Get-Credential` to generate a PSCredential object to pass to this parameter. Default is none.

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
This can be used to provide a static IP/network prefix to be assigned to the MOC CloudAgent service. This value should be provided using the CIDR format. (Example: 192.168.1.2/16). You may want to specify this to ensure that anything important on the network is always accessible because the IP address will not change. Default is none.

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

### -workingDir
This is a working directory for the module to use for storing small files. Defaults to `%PROGRAMFILES%\AksHci` and should not be changed for most deployments. We do not recommend changing the default.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: %PROGRAMFILES%\AksHci
Accept pipeline input: False
Accept wildcard characters: False
```

### -version
The version of Azure Kubernetes Service on Azure Stack HCI that you want to deploy. The default is the latest version. We do not recommend changing the default.

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
The TCP/IP port number that node agents should listen on. Defaults to 45000. We do not recommend changing the default.

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

### -clusterRoleName
This specifies the name to use when creating cloud agent as a generic service within the cluster. This defaults to a unique name with a prefix of ca- and a guid suffix (for example: “ca-9e6eb299-bc0b-4f00-9fd7-942843820c26”). We do not recommend changing the default.

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
This parameter provides a custom Microsoft Operated Cloud location name. The default name is "MocLocation". We do not recommend changing the default.

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
Requests the script to skip any checks it does to confirm memory and disk space is available before allowing the deployment to proceed. We do not recommend using this setting.

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

### -insecure
Deploys Azure Kubernetes Service on Azure Stack HCI components such as cloud agent and node agent(s) in insecure mode (no TLS secured connections).  We do not recommend using insecure mode in production environments.

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
DNS replication can take up to an hour on some systems. This will cause the deployment to be slow. If you hit this issue, you'll see that the Install-AksHci will be stuck in a loop. To get past this issue, try to use this flag. The -forceDnsReplication flag is not a guaranteed fix. If the logic behind the flag fails, the error will be hidden, and the command will carry on as if the flag was not provided.

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

