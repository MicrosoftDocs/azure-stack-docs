---
title: New-AksHciSSHConfiguration for AKS hybrid
author: sethmanheim
description: The New-AksHciSSHConfiguration PowerShell command creates an object for a new SSH configuration.
ms.topic: reference
ms.date: 04/26/2023
ms.author: sethm
---

# New-AksHciSSHConfiguration

## Synopsis

Creates an object for a new SSH configuration.

## Syntax

```powershell
New-AksHciSSHConfiguration -name <String>
                           -ipAddresses <String>
                           -cidr <String>
                          [-sshPublicKey <String>]
                          [-sshPrivateKey <String>]
                          [-restrictSSHCommands]
```

## Description

Creates an SSH configuration for AKS-HCI virtual machines to define SSH access.

## Examples

### Create SSH configuration with public key

```powershell
New-AksHciSSHConfiguration -name sshConfig -sshPublicKey C:\AksHci\akshci_rsa.pub
```

### Create SSH configuration with public key and restrict access to CIDR

```powershell
New-AksHciSSHConfiguration -name sshConfig -sshPublicKey C:\AksHci\akshci_rsa.pub -cidr 172.16.0.0/24
```

### Create SSH configuration with public key and restrict access to IP addresses

```powershell
New-AksHciSSHConfiguration -name sshConfig -sshPublicKey C:\AksHci\akshci_rsa.pub -ipAddresses 4.4.4.4,8.8.8.8
```

### Create SSH configuration and restrict access to CIDR

```powershell
New-AksHciSSHConfiguration -name sshConfig -cidr 172.16.0.0/24
```

### Create SSH configuration and restrict access to IP addresses

```powershell
New-AksHciSSHConfiguration -name sshConfig -ipAddresses 4.4.4.4,8.8.8.8
```

### Create SSH configuration and restrict access to IP addresses and SSH commands

```powershell
New-AksHciSSHConfiguration -name sshConfig -ipAddresses 4.4.4.4,8.8.8.8 -restrictSSHCommands
```

## Parameters

### -name

The name of the SSH configuration.

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

### -ipAddresses

Restricts SSH access to certain IP addresses.

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

### -cidr

Restricts SSH access to a CIDR.

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

### -sshPublicKey

The path to an SSH public key file. Using this public key, you can sign in to any of the VMs created by the AKS hybrid deployment. If you have your own SSH public key, you can pass its location here. If no key is provided, we look for one under **%systemdrive%\akshci\.ssh\akshci_rsa.pub**. If the file does not exist, an SSH key pair in the above location is generated and used.

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

### -sshPrivateKey

The path to the SSH private key file.

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

### -restrictSSHCommands

Restricts SSH access to certain commands.

```yaml
Type: Parameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

