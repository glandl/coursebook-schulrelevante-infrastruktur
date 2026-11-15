+++
title = "Security and data protection"
weight = 80
+++

{{% callout style="warning" title="No legal advice" %}}
This section gives technical orientation. Legal questions (e.g. logging, retention periods, youth protection filters) are clarified by the school with the data protection officer and the school maintainer.
{{% /callout %}}

## The essentials

| Topic | Measure |
|---|---|
| **A VLAN is not a firewall** | Always apply access rules between VLANs according to the permission matrix. Without rules, every VLAN reaches every other one via the router. |
| **Native VLAN** | On trunks, do not use VLAN 1 as the untagged VLAN; use a separate, otherwise unused VLAN. This makes *VLAN hopping* harder (an attacker sends frames with two tags). |
| **Unused ports** | Shut them down (`shutdown`) and assign them to an unused VLAN. Network sockets in classrooms are freely accessible. |
| **No automatic trunks** | Configure ports to end devices explicitly as access ports (`switchport mode access`) so that no device can negotiate a trunk. |
| **Rogue DHCP servers** | *DHCP snooping* on the switch: DHCP replies only from the ports of the real servers. |
| **Network management** | Manage switches, access points and routers only from the management VLAN (99), never from the student or guest Wi-Fi. |
| **DNS resolver** | Answer recursive queries only from your own network, otherwise the server can be abused for attacks on third parties. |
| **Guest Wi-Fi** | Separate VLAN, internet only, devices isolated from each other. A captive portal encrypts nothing. |

## Data protection in the school context

- **DHCP logs** show which device (MAC address, device name such as "Annas-Laptop") was on the network when. That is personal data, students' included.
- **DNS logs** show which sites were visited. They reveal more than many people think. Decide whether to log, who may see the logs and when they are deleted.
- **DNS filters** (e.g. for youth protection) are common. They should be transparent: students and parents should know that filtering happens and by which rules.
- **Captive portals** with registration (name, e-mail, phone number) collect data. Ask only for what is necessary and delete the data after a short time.
