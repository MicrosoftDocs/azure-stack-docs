---
title: Privileged Access Workstation and privileged endpoint access
description: Learn about the Privileged Access Workstation and privileged endpoint access
author: myoungerman

ms.topic: how-to
ms.date: 11/13/2020
ms.author: v-myoung
ms.reviewer: 
ms.lastreviewed: 

# Intent: 
# Keyword: 

---

# Privileged Access Workstation and privileged endpoint access

### Overview

For this procedure, you must connect to the Privileged Access
Workstation (PAW). The customer will need to provide you with the
ability to connect to the PAW using Remote Desktop.

### Configuring the WinRM

To allow connections to the privileged endpoint from the PAW, ensure
that the privileged endpoint IP addresses, as defined in the Azure
Stack Hub Admin Portal, are set as a trusted host on the PAW. The
instructions for obtaining these IP addresses from the Administrator
Portal are in Verifying Scale Unit node access and
health on page 16.

To view or edit the WinRM trusted hosts, launch an elevated PowerShell
session:

-   View trusted hosts.

To view the current trusted hosts, in PowerShell run:

-   Edit trusted hosts.

If the Emergency Recovery Console Server (ERCS) IPs are not present,
then run the following to set a new value for trusted hosts, replacing
*\<ERCS01_IP\*, *\<ERCS02_IP\* and *\<ERCS03_IP\* with the three
privileged endpoint IPs defined within the Azure Stack Hub Admin
Portal:

### Connect to the privileged endpoint

On the PAW, open an elevated PowerShell session and run the following
two commands. Replace *\<ERCS_IP\* with an IP of one of the
privileged endpoint instances as noted earlier in this procedure. When
prompted enter the privileged endpoint (PEP) credentials supplied by
the customer.

### Close the privileged endpoint

To close the privileged endpoint session, run the following:

### Further reading

For more information on connecting to and working with the privileged
endpoint see [Use the privileged endpoint in Azure
Stack](https://docs.microsoft.com/azure-stack/operator/azure-stack-privileged-endpoint)
[Hub](https://docs.microsoft.com/azure-stack/operator/azure-stack-privileged-endpoint).
