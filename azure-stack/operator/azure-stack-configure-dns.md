---
title: Update the DNS forwarder in Azure Stack Hub | Microsoft Docs
description: Learn how to update the DNS forwarder in Azure Stack Hub.
author: sethmanheim

ms.topic: conceptual
ms.date: 11/21/2019
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 11/21/2019

---

# Update the DNS forwarder in Azure Stack Hub

At least one reachable DNS forwarder is necessary for the Azure Stack Hub infrastructure to resolve external names. A DNS forwarder must be provided for the deployment of Azure Stack Hub. That input is used for the Azure Stack Hub internal DNS servers as forwarder, and enables external name resolution for services like authentication, marketplace management, or usage.

DNS is a critical datacenter infrastructure service that can change, and if it does, Azure Stack Hub must be updated.

This article describes using the privileged endpoint (PEP) to update the DNS forwarder in Azure Stack Hub. It is recommended that you use two reliable DNS
forwarder IP addresses.

1. Connect to the [privileged endpoint](azure-stack-privileged-endpoint.md). Note that it is not necessary to unlock the privileged endpoint by opening a support ticket.

2. Run the following command to review the current configured DNS forwarder. As an alternative, you can also use the admin portal region properties:

   ```powershell
   Get-AzsDnsForwarder
   ```

3. Run the following command to update Azure Stack Hub to use the new DNS forwarder:

   ```powershell
    Set-AzsDnsForwarder -IPAddress "IPAddress 1","IPAddress 2"
   ```

4. Review the output of the command for any errors.

## Next steps

[Firewall integration](azure-stack-firewall.md)
