---
title: Troubleshoot Power Supply Voltage for Azure Operator Nexus
description: Troubleshoot Power Supply Voltage for Azure Operator Nexus
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 02/16/2026
author: RaghvendraMandawale
ms.author: rmandawale
---

# Troubleshoot Power Supply Voltage for Azure Operator Nexus

## Power Supply Voltage – Input 

### High voltage and Low voltage (Any or All) 

#### What to check 

- Monitor voltage with `show environment power` or `show system environment all`.  
- Check for:  
  - UPS/Generator Problems: Malfunctions in uninterruptible power supply (UPS) units or backup generators. 
  - Faulty Power Cords/Connections: Damaged power cords or loose connections at the switch or the power source. 
  - Incorrect Voltage Setting: For some AC PSUs, incorrect voltage input settings (though most Arista PSUs are auto-ranging). 
- Ensure redundancy.  
    

#### Recommended actions 

- Ensure PSU redundancy is in place and functioning correctly. 
- Correct upstream power issues (UPS, generator, facility power). 
- Replace faulty power cords or secure loose connections. 
- If the issue persists, engage Arista TAC and provide power and environment diagnostics. 
    

## Power Supply Voltage – Output 

### High voltage and Low voltage (Any or All) 

#### What to check 

- Failing Power Supply Unit: The PSU itself may be degrading or have an internal fault. 
- Overload Condition: The switch might be drawing more power than the PSU can reliably provide, especially if components are failing or misbehaving. 
- Internal Component Failure: A fault within the switch's motherboard or other components requiring power. 
- Check PSU Status LEDs: Examine the LEDs on the power supply modules themselves. Typically, a green LED indicates normal operation, while red or amber indicates a fault or issue. Refer to your switch's specific documentation for LED meanings. 
- Hot-Swap PSUs (If Supported): If your switch has redundant, hot-swappable PSUs, and you suspect one is faulty, try removing and re-inserting it. If the problem persists or is on a different PSU, you may need to replace the faulty unit. 
- Test with a Single PSU: If you have redundant PSUs and suspect one is causing issues, try operating the switch with only one PSU connected (if safe to do so and the switch can run on a single PSU) to isolate the problem. 
- Replace Faulty PSU: If show environment power or the PSU's LEDs indicate a fault, replace the suspect power supply unit with a known good, compatible unit. Always use genuine Arista replacement parts. 
- Contact Arista TAC: If you've exhausted these steps or suspect a more complex issue, open a support case with Arista TAC. Provide the output of show tech-support, show environment power, and any relevant log messages. 
    

#### Recommended actions 

- Reseat hot‑swappable PSUs (if supported) to rule out seating issues. 
- If redundant PSUs are present, test the device with a single PSU (where safe) to isolate the fault. 
- Replace the faulty PSU with a compatible, genuine replacement if indicators show failure. 
- If the issue persists or diagnosis is unclear, open a support case with Arista TAC and provide: 
  - power/environment diagnostics 
  - relevant logs 
    

## References  

- [Customer Support - Arista](https://www.arista.com/en/support/customer-support) 
- [EOS 4.34.2F - Environment Commands - Arista](https://www.arista.com/en/um-eos/eos-environment-commands) 
- [Troubleshooting PowerSupply Failure](https://arista.my.site.com/AristaCommunity/s/article/Troubleshooting-PowerSupply-Failure) 
- [Troubleshooting PSU issues/failovers](https://arista.my.site.com/AristaCommunity/s/article/Troubleshooting-PSU-issues-failovers)