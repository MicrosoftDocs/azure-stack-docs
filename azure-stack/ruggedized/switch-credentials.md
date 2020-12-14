---
title: Switch credentials
description: Explains how to update switch credentials for a Azure Stack Hub ruggedized 
author: troettinger
ms.author: thoroet
ms.service: azure-stack
ms.topic: article
ms.date: 10/14/2020
ms.reviewer: justinha
ms.lastreviewed: 10/14/2020
---

# Switch credentials

This topic shows how to change the administrator (admin) and Simple Network Management Protocol (SNMP) credentials on all switches. 

## Prerequisites

Before you run the procedures:

- Use Remote Desktop to connect to the HLH.
- Locate PuTTY on the HLH, usually E:\Tools\Putty\putty.exe. If PuTTY is not available, download and copy it onto the HLH.
- Make sure you have both the current and new credentials for the switches.

## Update credentials for the Admin and Enable accounts 

For each switch in the scale unit (BMC, TOR1, and TOR2):

1. On the HLH, using PuTTY, log in to the switch using the current credentials. 
1. Run the following command, replacing \<new password\> with your new Admin and Enable credentials. 
   ```ini
   enable
   configuration terminal
   username admin pass
   word <new_password> privilege 15
   enable password <new_password>
   ```
1. Leave the current session to the switch open.
1. On the HLH, using PuTTY, log in to the switch using the new credentials.
1. Run the following command. Enable should not prompt for a password.

   ```ini
   enable
   write
   dir flash:
   ```

1. Verify the startup-config has today's date.
1. On confirmation, close both this session and the original session.

## Update SNMP accounts

For each switch in the scale unit (BMC, TOR1, and TOR2):

1. On the HLH, using PuTTY, log in to the switch.
1. Run the following command to get the current SNMP read/write users and groups:

   ```ini
   enable
   show run snmp | grep user
   ```

   The following example shows the type of content that is returned, including user, group name, and password hashes:

   ```ini
   snmp-server user <user> <group> 3 encrypted auth sha <password_hash>
   ```

1. Run the following command, replacing \<user\> and \<group\> with the details determined from the previous step, and replacing \<password\> with your new password:

   ```ini
   configuration terminal
   snmp-server user <user> <group> 3 auth sha <password_new>
   end
   write
   exit
   ```

## Next steps

[Rotate secrets in Azure Stack Hub](../operator/azure-stack-rotate-secrets.md)