---
external help file: 
Module Name: Aks.Hci
online version: 
schema: 
---

# New-AksHciNetworkSetting

## SYNOPSIS
Create an object for a new virtual network.

## SYNTAX

```powershell
New-AksHciNetworkSetting -vnetName <String>
                         -gateway <String>
                         -dnsServers <String[]>
                         -ipAddressPrefix <String>
                         -vipPoolStart <IP address>
                         -vipPoolEnd <IP address>
                        [-vlanID <int>]
                    
```

## DESCRIPTION
Create a virtual network to set static IP address for control plane, load balancer, agent endpoints and a static IP range for nodes in all Kubernetes clusters. You should create a virtual network in an environment variable which will be used later in configuration steps.

## EXAMPLES

### Example
```powershell
PS C:\> $vnet = New-AksHciNetworkSetting -vnetName "Default Switch" -vipPoolStart "172.16.255.0" -vipPoolEnd "172.16.255.254" -ipAddressPrefix "172.16.0.0/16" -gateway "172.16.0.1" -dnsServers "172.16.0.1"
```

## PARAMETERS

### -vnetName
The alphanumeric name of your virtual network.

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
Parameter Sets: (All)
Aliases:

Required: False (True when SubnetCidr is provided)
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dnsServers
Required: (when SubnetCidr is provided). An array of IP addresses pointing to the DNS servers to be used for the subnet. A minimum of one and a maximum of 3 servers can be provided. i.e. "8.8.8.8","192.168.1.1".

```yaml
Type: System.String[]
Parameter Sets: (All)
Aliases:

Required: False (True when SubnetCidr is provided)
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ipAddressPrefix
The address prefix to use for Static IP assignment.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: external
Accept pipeline input: False
Accept wildcard characters: False
```

### -vipPoolStart
The start IP address of the VIP pool. The address must be within the range either served by the DHCP server or within the range provided in the Subnet CIDR.

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
The end IP address of the VIP pool. The address must be within the range either served by the DHCP server or within the range provided in the Subnet CIDR.

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
