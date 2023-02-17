---
title: AKS Edge Essentials Troubleshoot Common Issues 
description: Common issues and workarounds
author: rcheeran
ms.author: rcheeran
ms.topic: conceptual
ms.date: 02/09/2023
ms.custom: template-concept
ms.reviewer: fcabrera
---

# AKS Edge Essentials Troubleshoot Common Issues

This overview provides guidance on how to find solutions for issues you encounter when using AKS Edge Essentials. Known issues and errors topics are organized by functional area. You can use the links provided in this topic to find the solutions and workarounds to resolve them.

## Deployment Issues 

1. Untrusted publisher issue:
    
Error: you see the message `Do you want to run software from this untrusted publisher? .....`

Workaround: Update your PowerShell execution policy to **RemoteSigned**:

```powershell
# Get the Execution Policy on the system
Get-ExecutionPolicy
# Set the Execution Policy for this process only
if ((Get-ExecutionPolicy) -ne "RemoteSigned") { Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force }
```
