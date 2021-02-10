---
title: Azure Stack Hub ruggedized site readiness for Azure Stack Hub | Microsoft Docs
description: Learn site readiness specifications for a Azure Stack Hub ruggedized  .
services: azure-stack
documentationcenter: ''
author: PatAltimore
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/14/2020
ms.author: wamota
ms.reviewer: wamota
ms.lastreviewed: 10/14/2020
---

# Azure Stack Hub ruggedized site readiness

This topic covers environmental and PDU power drop requirements for the Azure Stack Hub ruggedized. 

>[!NOTE]
>These values are intended solely for facility planning purposes and are approximate and conservative. Actual requirements may vary.

## Environmental requirements

The table below lists the environmental requirements for an Azure Stack Hub ruggedized solution with the following configuration:

- 14 TB scale unit
- 200 volt AC input voltage
- 35°C maximum ambient temperature

*Table 1. High/low configuration environmental requirements*

| Object                         | Azure Stack Hub ruggedized requirements               |
|--------------------------------|--------------------------------|
|Operating temperature           | Azure Stack Hub ruggedized operating temperature (with heater requirements): -32°C (-25.6°F) to 43°C (109°F).    |
|Humidity and moisture           | Storage: 5% to 95% RH with 33°C (91°F) maximum dew point. Atmosphere must be non-condensing at all times. <br> Operating: 5% to 85% RH with 29°C (84.2°F) maximum dew point.
|Physical connectivity           | Azure Stack Hub ruggedized can be physically connected via the following: <br>4x10G SR SFP+ <br>4x1000BASE-SX <br>4x 1000BASE-T
|Power input                     | Max 4.981 Kw, Avg 4.391 KW<br> Input Connector C13/C14<br> Input: 100-240V 50/60Hz

## PDU power drop requirements

The following table lists the power drops required for the Azure Stack Hub ruggedized.

*Table 2. Required number of power drops*

| Configuration  | Single phase  | Three-phase Delta |Three-phase Wye |
|----------------|---------------|-------------------|----------------|
|High/low        | 2             | 2                 | 2              |

The Azure Stack integrated system enables you to use different PDU connector types to best integrate into your datacenter. The table below lists the connector types:

*Table 3. PDU and connector options*

| Location     | Single phase                                | Three-phase Delta                                   | Three-phase Wye                                        |
|--------------|---------------------------------------------|-----------------------------------------------------|-----------------------------------------------------------|
|North America |- L630P<br>- L7-30P<br>- Russellstoll 3750DP |- Hubbell Pro CS8365L<br>- Russellstoll 9P54U2T/1100 |- Hubbell C530P6S<br>- ABL Sursum S52S0A<br>- Flying Leads |


