---
title: Azure Stack Hub ruggedized networking appendix
description: Appendices for Azure Stack Hub ruggedized networking. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: conceptual
ms.date: 10/14/2020
ms.lastreviewed: 10/14/2020
---

# Azure Stack Hub ruggedized network appendix

The appendix provides device parameter and identity information for Azure Stack Hub ruggedized hardware.

## Technical device parameters

### Dell S5048F-ON

Ports: 

- 48 line-rate 25-Gigabit Ethernet SFP28 ports. 
- Six line-rate 100-Gigabit Ethernet QSFP28 ports. 
- One RJ45 console/management port with RS232 signaling.
- One Micro-USB type B optional console port. 
- One 10/100/1000 Base-T Ethernet port used as a management port. 
- One USB type A port for the external mass storage. 

Specifications:

- Size: 1RU,1.72"(h) x 17.1"(w) x 18"(d)  (4.4(h) x 43.4(w) x 45.7(d) cm). 
- Weight: 22 lbs (9.98 kg) 
- ISO 7779 A-weighted sound pressure level:59.6 dBA at 73.4°F (23°C).  
- Power supply: 100–240 VAC 50/60 Hz. 
- Maximum thermal output: 1956 BTU/h. 
- Maximum current draw per system: 
  - 5.73A/4.8A at 100/120V Alternating Current (AC). 
  - 2.87A/2.4A at 200/240V AC. 
- Maximum power consumption: 573 Watts (AC). 
- Typical power consumption: 288 Watts (AC) with all optics loaded.  
- Maximum operating specifications: 
  - Operating temperature: 32° to 113°F (0° to 45°C). 
  - Operating humidity: 10% to 90% (RH), non-condensing. 
  - Fresh Air Compliant to 45°C. 
- Maximum non-operating specifications: 
  - Storage temperature: –40° to 158°F (–40° to 70°C). 
  - Storage humidity: 5% to 95% (RH), non-condensing.

### Dell 3048-ON

Ports:

- 48 line-rate 1000BASE-T ports.  
- Four line-rate 10-GbE SFP+ ports. 
- One RJ45 console/management port with RS232 signaling.  

Specifications:

- Size: One RU, 1.71"(h) x 17.09"(w) x 12.6"(d)  (4.4(h) x 43.4(w) x 32.0(d)s cm).  
- Weight: 12.8 lbs (5.84 kg) with one power supply, 14.8 lbs (6.74 kg) with two power supplies. 
- ISO 7779 A-weighted sound pressure level: \<36 dBA at 78.8°F (26°C). 
- Power supply: 90–264 VAC 50/60 Hz. 
  1) AC forward airflow.  
  2) AC reverse airflow. 
- Maximum thermal output: 290 BTU/h. 
- Maximum current draw per system:  
  - \<1A at 100/120V VAC. 
  - \<0.5A at 200/240 VAC.  
- Maximum power consumption: 87 W. 
- Typical power consumption: 65 Watts. 
- Maximum operating specifications:  
  - Operating temperature: 32° to 113°F (0° to 45°C).  
  - Operating humidity: 5% to 85% (RH), non-condensing.    
  - Operating altitude: 0 ft to 10,000 ft above sea level.  
- Maximum non-operating specifications: 
  - Storage temperature: –40° to 158°F (–40° to 70°C). 
  - Storage humidity: 5% to 95% (RH), non-condensing.   

## Identity

All network devices are designed to work with Terminal Access Controller Access-Control System (TACACS). TACACS provides a centralized identity experience. The TACACS server must be supplied as part of the initial configuration.

Notice once the TACACS server isn't available, the devices will fall back to the local identities listed below. During normal operation, those accounts are disabled.

The following user accounts do exit per device:

| Device | Username | Default password     |
|--------|----------|----------------------|
| Tor 1  | Root     | Assigned by customer |
| Tor 2  | Root     | Assigned by customer |
| BMC    | Root     | Assigned by customer |
