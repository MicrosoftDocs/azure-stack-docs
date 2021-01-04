---
title: Modular Data Center (MDC) networking appendix
description: Appendices for MDC networking. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: conceptual
ms.date: 12/30/2019
ms.lastreviewed: 12/30/2019
---

# MDC network appendix

The appendix provides device parameter and identity information for MDC hardware.

## Technical device parameters

### Cisco 93360YC-FX2 & Cisco 9348GC-FXP

| **Feature** | **Cisco Nexus 93360YC-FX2** | **Cisco Nexus 9348GC-FXP** |
|---|---|---|
| Ports | 96 x 1/10/25-Gbps and 12 x 40/100-Gbps QSFP28 ports | 48 x 1-GBASE-T ports, 4 x 1/10/25-Gbps SFP28 ports and 2 x 40/100 QSFP28 ports |
| Supported speeds | 1/10/25-Gbps on downlinks, 40/100-Gbps on uplinks, Breakout supported ports, 97-108: 4x10/25G | 100-Mbps and 1-Gbps speeds |
| CPU | Four cores | Four cores |
| System memory | Up to 24 GB | 24 GB |
| SSD drive | 128 GB | 128 GB |
| System buffer | 40 MB | 40 MB |
| Management ports | Two ports: One RJ-45 and One SFP+ | Two ports: One RJ-45 and One SFP+ |
| USB ports | One | One |
| RS-232 serial ports | One | One |
| Power supplies (up to two) | 1200 W Alternating Current (AC), 1200 W HVAC/HVDC | 350 W AC, 440 W DC |
| Typical power (AC) | 404 W | 178 W |
| Maximum power (AC) | 900 W | 287 W |
| Input voltage (AC) | 100 V to 240 V | 100 V to 240 V |
| Input voltage (High-Voltage AC [HVAC]) | 100 V to 277 V | 90 V to 305 V |
| Input voltage (DC) | –40 V to –72 V | \-36 V to -72 V |
| Input voltage (High-Voltage DC [HVDC]) | –240V to –380V | 192 V to 400 V |
| Frequency (AC) | 50 Hz to 60 Hz | 50 Hz to 60 Hz |
| Fans | Three fan trays | Three |
| Airflow | Port-side intake and exhaust | Port-side intake and exhaust |
| Physical dimensions | 3.38 x 17.41 x 24.14in. (8.59 x 44.23 x 61.31 cm) | 1.72 x 17.3 x 19.7 in. |
| (H x W x D) | | (4.4 x 43.9 x 49.9 cm) |
| Acoustics | 76.7 dBA at 40% fan speed, 88.7 dBA at 70% Fan speed and 97.4 dBA at 100% Fan speed | 67.5 dBA at 50% fan speed, 73.2 dBA at 70% fan speed, and 81.6 dBA at 100% fan speed |
| RoHS compliance | Yes | Yes |
| MTBF | 320,040 hours | 257,860 hours |
| Minimum ACI image | ACI-N9KDK9-14.1.2 | ACI-N9KDK9-13.0 |
| Minimum NX-OS image | NXOS-9.3(1) | NXOS-703I7.1 |

### Juniper MX204

:::row:::
    :::column:::
        **Layout**
    :::column-end:::
    :::column:::
        System capacity

        Slot Orientation

        Mounting
    :::column-end:::
    :::column span="2":::
        3 Tbps

        NA

        Front or center
    :::column-end:::
:::row-end:::

:::row:::
    :::column:::
        **Physical Specification**
    :::column-end:::
    :::column:::
        Dimensions (W x H x D)

        Weight fully loaded

        Weight unloaded
    :::column-end:::
    :::column span="2":::
        17.45" x 8.71" x 24.5" (44.3 x 22.1 x 62.2 cm)

        130 lb/59 kg

        52 lbs/23.6 kg
    :::column-end:::
:::row-end:::

:::row:::
    :::column:::
        **Routing Engine**
    :::column-end:::
    :::column:::
        Default memory

        Number of cores
    :::column-end:::
    :::column span="2":::
        2x16 MB NOR flash storage; 64 GB of DDR4 RAM; 2x50 GB SSD

        6 cores
    :::column-end:::
:::row-end:::

:::row:::
    :::column:::
        **Redundancy**
    :::column-end:::
    :::column:::
        Components
    :::column-end:::
    :::column span="2":::
        Power supplies, REs, fans
    :::column-end:::
:::row-end:::

:::row:::
    :::column:::
        **Environmental**
    :::column-end:::
    :::column:::
        Air flow

        Operating temperature

        Operating humidity

        Operating altitude
    :::column-end:::
    :::column span="2":::
        Side to side

        32° to 115° F (0° to 46° C) at sea level

        5% to 90%

        10,000 ft (3048 m)
    :::column-end:::
:::row-end:::

:::row:::
    :::column:::
        **Certifications**
    :::column-end:::
    :::column:::
        NEBS
    :::column-end:::
    :::column span="2":::
        • GR-1089-Core EMC and Electrical Safety

        • Common Bonding Network (CBN)

        • National Electrical Code (NEC)

        • GR-63-Core Physical Protection
    :::column-end:::
:::row-end:::

### Dell EMC S4148F-ON

Features:

- 48 10 Gigabit Ethernet SFP+ ports
- Six 40 Gigabit Ethernet QSFP+ ports
- One RJ45 console/management port with RS232 signaling 
- One RJ45 micro-USB-B console port 
- One RJ45 10/100/1000Base-T management Ethernet port 

Specifications:

- Size: 
  - One RU, 1.75"(h) x 17"(w) x 18"(d) (4.4 cm (h) x 43.1 cm (w) x 45.7 cm (d)) 
  - S4112: 1.7"(h) x 8.28"(w) x 18"(d) (4.125 cm (h) x 20.9 cm (w) x 45 cm (d) 
- Power supply: 100–240 VAC 50/60 Hz
- Power supply (DC), applicable to S4412: rated -40 VDC to -72 VDC
- Maximum current draw per system: 6A/5A at 100/120V AC; 3A/2.5A at 200/240V AC
- S4112: 2A/1.7A at 100/120V AC; 1A/0.8A at 200/240V AC. 
- S4112 (DC): -40V/5A, -48V/4.2A, -72V/2.8A 

Maximum operating specifications:
- Operating temperature: 41° to 104° F (5° to 40° C)
- Operating humidity: 5% to 85% (RH), non- condensing 

Maximum non-operating specifications:
- Storage temperature: -40° to 149°F (-40° C to 65° C) 
- Storage humidity: 5% to 95% (RH), non-condensing


## Identity

All network devices are designed to work with Terminal Access Controller Access-Control System (TACACS). TACACS provides a centralized identity experience. The TACACS server must be supplied as part of the initial configuration.

Notice once the TACACS server isn't available, the devices will fall back to the local identities listed below. During normal operation, those accounts are disabled.


The following user accounts do exit per device:

| Device | Username | Default password |
|---------|--------------|----------------------|
| Edge 1 | root | Assigned by customer |
| Edge 2 | Root | Assigned by customer |
| Tor 1 | Root | Assigned by customer |
| Tor 2 | Root | Assigned by customer |
| BMC | Root | Assigned by customer |
| PDU 1 | root | Assigned by customer |
| PDU 2 | root | Assigned by customer |
| Serial | Root | Assigned by customer |
| Avocent | Root & Admin | Assigned by customer |
