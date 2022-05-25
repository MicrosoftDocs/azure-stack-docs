---
title: Integrated Dell Remote Access Controller credentials - MDC
description: Learn how to update user credentials for the Integrated Dell Remote Access Controller (iDRAC) in a Modular Data Center using Remote Desktop.
author: troettinger
ms.author: thoroet
ms.service: azure-stack
ms.topic: article
ms.date: 10/27/2020
ms.reviewer: justinha
ms.lastreviewed: 10/27/2020
ms.custom: kr2b-contr-experiment
---

# Update credentials for the Integrated Dell Remote Access Controller - Modular Data Center (MDC)

This section describes how to change the Integrated Dell Remote Access Controller (iDRAC) user credentials. 

## Prerequisites

Before running the procedure: 

- Use Remote Desktop to connect to the MGMT virtual machine. 
- Ensure that you have the new credentials for the account or accounts. 
 
## Update the iDRAC credentials

To update the iDRAC credentials for all PowerEdge servers (HLH and scale unit nodes) in the environment:

1. In a web browser, log in to https:\//*\<iDRAC_IP\>*.
1. Go to **iDRAC Settings** > **Users**. 
1. Choose a user to modify, and then click **Edit**. 
1. In the **Edit User** window, enter the new password in the **Password** and **Confirm Password** boxes. 

   ![Screenshot of the Edit User window showing the User Configuration tab. The password and confirm password fields are circled. Save is selected.](../operator/media/idrac-credentials/enter-user.png)

1. Click **Save**, and then **OK**. 

## Next steps

[Rotate secrets in Azure Stack Hub](../../operator/azure-stack-rotate-secrets.md)