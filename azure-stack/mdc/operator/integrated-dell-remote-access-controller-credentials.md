---
title: Integrated Dell Remote Access Controller credentials
description: Explains how to update credentials for Integrated Dell Remote Access Controller
author: troettinger
ms.author: thoroet
ms.service: azure-stack
ms.topic: article
ms.date: 04/28/2020
ms.reviewer: justinha
ms.lastreviewed: 04/28/2020
---

# Update credentials for the Integrated Dell Remote Access Controller

This section describes how to change the Integrated Dell Remote Access Controller (iDRAC) credentials. 

## Prerequisites

Before running the procedure: 

- Use Remote Desktop to connect to the MGMT virtual machine. 
- Ensure that you have the new credentials for the account or accounts. 
 
## Update the iDRAC credentials

To update the iDRAC credentials for all PowerEdge servers (HLH and scale unit nodes) in the environment:

1. In a web browser, log in to https://<iDRAC_IP>. 
1. Go to **iDRAC Settings** > **Users**. 
1. Select the user that you want to modify, and then click **Edit**. 
1. In the **Edit User** window, enter the new password in **Password** and **Confirm Password**, as shown in the following figure: 

   ![Screenshot showing user information](../operator/media/idrac-credentials/enter-user.png)

1. Click **Save**, and then click **OK**. 

## Next steps

[Rotate secrets in Azure Stack Hub](azure-stack-rotate-secrets.md)