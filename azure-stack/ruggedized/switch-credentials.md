---
title: Switch credentials
description: Learn how to update switch credentials on a ruggedized Azure Stack Hub from an HLH using Remote Desktop.
author: troettinger
ms.author: thoroet
ms.service: azure-stack
ms.topic: article
ms.date: 10/14/2020
ms.reviewer: justinha
ms.lastreviewed: 10/14/2020
ms.custom: kr2b-contr-experiment
---

# Switch credentials

This article shows how to change the administrator (admin) and SNMP credentials on all switches in a ruggedized Azure Stack Hub.

## Prerequisites

Before you run the procedures:

- Use Remote Desktop to connect to the Hardware Lifecycle Host (HLH).
- Locate PuTTY on the HLH, usually E:/\Tools/\Putty/\putty.exe. If PuTTY isn't available, download and install it on the HLH.
- You need both the current and new credentials for the switches.

## Update credentials for the Admin user and Enable accounts 

For each switch in the scale unit (BMC, TOR1, and TOR2):

1. On the HLH, use PuTTY to sign on to the switch using the current credentials. 
1. Run the following command, replacing \<new password\> with the new password and then Enable credentials.

   ```ini
   enable
   configuration terminal
   username admin pass
   word <new_password> privilege 15
   enable password <new_password>

1. Leave the current session to the switch open.
1. On the HLH, use PuTTY to sign on to the switch using the new credentials.
1. Run the following command. Enable shouldn't prompt for a password.

   ```ini
   enable
   write
   dir flash:
   ```

1. Verify that the startup-config shows the current date.
1. Once confirmed, close both this session and the original session.

## Update credentials for SNMP accounts

For each switch in the scale unit (BMC, TOR1, and TOR2):

1. On the HLH, use PuTTY to sign on to the switch.
1. Run the following command to get the current SNMP read/write users and groups:

   ```ini
   enable
   show run snmp | grep user
   ```

   The following example shows the results including user, group name, and password hashes:

   ```ini
   snmp-server user <user> <group> 3 encrypted auth sha <password_hash>
   ```

1. Run the following command, replacing \<user\> and \<group\> with the results from the previous step. Replace \<password\> with the new password:

   ```ini
   configuration terminal
   snmp-server user <user> <group> 3 auth sha <password_new>
   end
   write
   exit
   ```

## Next steps

[Rotate secrets in Azure Stack Hub](../operator/azure-stack-rotate-secrets.md)