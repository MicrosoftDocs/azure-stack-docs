---
title: Set-SyslogServer
description: Reference for PowerShell Azure Stack privileged endpoint - Set-SyslogServer
author: mattbriggs

ms.topic: reference
ms.date: 04/27/2020
ms.author: mabrigg
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Set-SyslogServer

## Synopsis
Sets the syslog server endpoint.

## Syntax

```
Set-SyslogServer [-Remove] [[-ServerName] <Object>] [-NoEncryption] [-SkipCertificateCheck] [-UseUDP]
 [-SkipCNCheck] [[-ServerPort] <Object>] [-AsJob]
```


## Examples

### Example 1

```
Set-SyslogServer -ServerName <FQDN or IP address of Syslog server>
```

### Example 2
```
-NoEncryption
```

### Example 3
```
-SkipCertificateCheck
```

### Example 4
```
-SkipCNCheck
```

### Example 5
```
-UseUDP
```

### Example 6
```
Set-SyslogServer -Remove
```

## Parameters

### -ServerName
The FQDN or IPv4 Address of syslog server.
Without any other parameter, default protocol is TCP with enabled encryption; Certificate validation; Certificate name check.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerPort
The server port of the Syslog server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoEncryption
Specify NoEncryption if desire to disable encryption for TCP traffic.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCNCheck
Specify SkipCNCheck if desire to skip checking certificate name.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Specify SkipCertificateCheck if desire to skip checking Syslog Server certificate.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseUDP
Specify UseUDP if Syslog server uses UDP protocol.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
 

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsJob


```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

For information on how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
