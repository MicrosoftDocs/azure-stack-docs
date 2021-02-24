---
title: New-AksHciNetworkSetting
author: jessicaguan
description: The New-AksHciNetworkSetting PowerShell command creates an object for a new virtual network.
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# New-AksHciNetworkSetting

## Synopsis
Create an object for a new virtual network.

## Syntax
```powershell
New-AksHciNetworkSetting -vnetName <String>
                         -gateway <String>
                         -dnsServers <String[]>
                         -ipAddressPrefix <String>
                         -vipPoolStart <IP address>
                         -vipPoolEnd <IP address>
                         -k8sNodeIpPoolStart <IP address>
                         -k8sNodeIpPoolEnd <IP address>
                        [-vlanID <int>]
                    
```

## Description
Create a virtual network to set the DHCP or static IP address for the control plane, load balancer, agent endpoints, and a static IP range for nodes in all Kubernetes clusters. This cmdlet will return a VirtualNetwork object, which can be used later in the configuration steps.

## Examples

### Deploy with a static IP environment

```powershell
PS C:\> $vnet = New-AksHciNetworkSetting -vnetName "External" -k8sNodeIpPoolStart "172.16.10.0" -k8sNodeIpPoolEnd "172.16.10.255" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipAddressPrefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsServers "172.16.0.1" 
PS C:\> Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -enableDiagnosticData -cloudservicecidr "172.16.10.10/16"
```

> [!NOTE]
> The values given in this example command will need to be customized for your environment.

### Deploy with a DHCP environment

```powershell
PS C:\> $vnet = New-AksHciNetworkSetting -vnetName "External" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" 
```

```powershell
PS C:\> Set-AksHciConfig -imageDir c:\clusterstorage\volume1\Images -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -enableDiagnosticData"
```

## Parameters

### -vnetName
The the name of your external switch. To get a list of the names of your available switches, run the command `Get-VMSwitch`.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -gateway
The IP address of the default gateway of the subnet.

```yaml
Type: System.String
Parameter Sets: (StaticIP)
Aliases:

Required: False (This is required when creating a network with a static IP.)
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dnsServers
Required when creating a network with a static IP. An array of IP addresses pointing to the DNS servers to be used for the subnet. A minimum of one and a maximum of 3 servers can be provided. i.e. "8.8.8.8","192.168.1.1".

```yaml
Type: System.String[]
Parameter Sets: (StaticIP)
Aliases:

Required: False (This is required when creating a network with a static IP.)
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ipAddressPrefix
The address prefix to use for Static IP assignment.

```yaml
Type: System.String
Parameter Sets: (StaticIP)
Aliases:

Required: True
Position: Named
Default value: external
Accept pipeline input: False
Accept wildcard characters: False
```

### -vipPoolStart
The start IP address of the VIP pool. The address must be within the range either served by the DHCP server or within the range provided in the Subnet CIDR. The IP addresses in the VIP pool will be used for the API Server and for Kubernetes services. If you're using DHCP, make sure your virtual IP addresses are a part of the DHCP IP reserve. If you're using static IP, make sure your virtual IPs are from the same subnet.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -vipPoolEnd
The end IP address of the VIP pool. The address must be within the range either served by the DHCP server or within the range provided in the Subnet CIDR. The IP addresses in the VIP pool will be used for the API Server and for Kubernetes services. If you're using DHCP, make sure your virtual IP addresses are a part of the DHCP IP reserve. If you're using static IP, make sure your virtual IPs are from the same subnet.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -k8sNodeIpPoolStart
The start IP address of a VM pool. The address must be in range of the subnet. This is required for Static IP deployments.

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

### -k8sNodeIpPoolEnd
The end IP address of a VM pool. The address must be in range of the subnet. This is required for Static IP deployments.

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

### -vlanID
The vLAN ID for the network specified. If omitted the network will not be tagged.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!--- ### -macPoolName
The name of the MAC address pool that you wish to use for the Azure Kubernetes Service host VM. The pool will be created with the New-AksHciMacPoolSetting command.

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
--->
