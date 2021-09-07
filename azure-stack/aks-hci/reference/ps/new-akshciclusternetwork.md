---
title: New-AksHciClusterNetwork for AKS on Azure Stack HCI
author: mkostersitz
description: The New-AksHciClusterNetwork PowerShell command creates an object for a new virtual network used by a workload cluster.
ms.topic: reference
ms.date: 09/07/2021
ms.author: mikek
---

# New-AksHciClusterNetwork

## Synopsis
Create a virtual network to set the DHCP or static IP address for the control plane, load balancer, agent endpoints, and a static IP range for workload clusters.

## Syntax

### DHCP virtual network configurations

For DHCP configurations without a VLAN:

```powershell
New-AksHciClusterNetwork -name <String>
                         -vswitchName <String>
                         -vipPoolStart <IP address>
                         -vipPoolEnd <IP address>
```

For DHCP configurations with a VLAN:

```powershell
New-AksHciClusterNetwork -name <String>
                         -vswitchName <String>
                         -vipPoolStart <IP address>
                         -vipPoolEnd <IP address>
                         -vlanID <int>
```

### Static IP virtual network configurations

For static IP configurations without a VLAN:

```powershell
New-AksHciClusterNetwork -name <String>
                         -vswitchName <String>
                         -gateway <String>
                         -dnsServers <String[]>
                         -ipAddressPrefix <String> 
                         -vipPoolStart <IP address>
                         -vipPoolEnd <IP address>
                         -k8sNodeIpPoolStart <IP address>
                         -k8sNodeIpPoolEnd <IP address>                                 
```

For static IP configurations with a VLAN:

```powershell
New-AksHciClusterNetwork -name <String>
                         -vswitchName <String>
                         -gateway <String>
                         -dnsServers <String[]>
                         -ipAddressPrefix <String>
                         -vipPoolStart <IP address>
                         -vipPoolEnd <IP address>
                         -k8sNodeIpPoolStart <IP address>
                         -k8sNodeIpPoolEnd <IP address>
                         -vlanID <int>                              
```

## Description
Create a virtual network to set the DHCP or static IP address for the control plane, load balancer, agent endpoints, and a static IP range for nodes in workload clusters. This cmdlet will return a VirtualNetwork object, which can be used later in the configuration steps when creating a new workload cluster. You can create as many virtual networks as needed.

## Examples

Use the examples below to configure virtual networks with either static IP or DHCP. You'll need to customize the values given in the examples for your environment. After configuring the virtual network with static IP or DHCP, run [New-AksHciCluster](new-akshcicluster.md) to deploy a cluster.

### Deploy with a static IP environment without a VLAN

```powershell
PS C:\> $vnet = New-AksHciClusterNetwork -name <String> -vswitchName <String> -gateway <String> -dnsServers <String[]> -ipAddressPrefix <String> -vipPoolStart <IP address> -vipPoolEnd <IP address> -k8sNodeIpPoolStart <IP address> -k8sNodeIpPoolEnd <IP address>
```

### Deploy with a static IP environment and a VLAN

```powershell
PS C:\> $vnet = New-AksHciClusterNetwork -name <String> -vswitchName <String> -gateway <String> -dnsServers <String[]> -ipAddressPrefix <String> -vipPoolStart <IP address> -vipPoolEnd <IP address> -k8sNodeIpPoolStart <IP address> -k8sNodeIpPoolEnd <IP address> -vlanID <int>
```

### Deploy with a DHCP environment without a VLAN

```powershell
PS C:\> $vnet = New-AksHciClusterNetwork -name MyClusterNetwork -vnetName "External" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" 
```

### Deploy with a DHCP environment and a VLAN

```powershell
PS C:\> $vnet = New-AksHciClusterNetwork -name MyClusterNetwork -vnetName "External" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -vlanID 7
```

## Parameters

### -name
The descriptive name of your virtual networks. To get a list of the names of your available virtual networks, run the command [Get-AksHciClusterNetwork](get-akshciclusternetwork.md).

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

### -vswitchName
The name of your external switch. To get a list of the names of your available switches, run the command `Get-VMSwitch`.

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
Required when creating a network with a static IP. This parameter creates an array of IP addresses pointing to the DNS servers to be used for the subnet. A minimum of one and a maximum of three servers can be provided, for example, "8.8.8.8","192.168.1.1".

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
The address prefix to use for static IP assignment.

```yaml
Type: System.String
Parameter Sets: (StaticIP)
Aliases:
Required: False (This is required when creating a network with a static IP.)
Position: Named
Default value: external
Accept pipeline input: False
Accept wildcard characters: False
```

### -vipPoolStart
The start IP address of the VIP pool. The address must be within the range either served by the DHCP server or within the range provided in the subnet CIDR. The IP addresses in the VIP pool will be used for the API Server and for Kubernetes services. If you're using DHCP, make sure your virtual IP addresses are a part of the DHCP IP reserve. If you're using static IP, make sure your virtual IPs are from the same subnet.

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
The start IP address of a VM pool. The address must be in range of the subnet. This is required for static IP deployments.

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

### -k8sNodeIpPoolEnd
The end IP address of a VM pool. The address must be in range of the subnet. This is required for static IP deployments.

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

### -vlanID
Specifies the VLAN ID for the network. If omitted, the network will not be tagged.

```yaml
Type: System.Int32
Parameter Sets: (All)
Aliases:
Required: False (This parameter is required if you configure a virtual network with a VLAN.)
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
## Next steps

[AksHci PowerShell Reference](index.md)