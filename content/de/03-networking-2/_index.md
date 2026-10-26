+++
title = "Netzwerktechnik II: VLANs, DNS, DHCP"
type = "chapter"
weight = 3
+++

**Unit:** 16.11.2026 · **Documentation technique:** [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}}) · **Homework deadline:** 22.11.2026

{{% callout style="info" title="Unit 3: last network unit – first server contact" %}}
This unit is the last network unit **and** the **first unit with a Windows Server in front of the class**. It **finishes the network part** and **starts the server part**. The **first 30 min recap**: `ping`, `traceroute`, `dig` / DNS lookup, **reading an IP plan** – **one network is deliberately broken** and **is diagnosed** ([Einheit 1]({{% relref "/01-virtualization-containerization/lab" %}}), [Einheit 2]({{% relref "/02-networking-1/lab" %}})). **Why**: weaker students came late and did not work through units 1 and 2 fully.
{{% /callout %}}

In unit 2 you **built a school network** – **one flat network**. Here you **segment** it: **one network, several user groups**. The four user groups (**Schüler, Lehrenden, Administration, Storage**, the class list in reality) hang in **four VLANs**, each with **its own number range** (VLAN-ID as **third octet** / **fourth octet**, bitmask, CIDR). A **permission matrix** makes visible **who is allowed to do what**. One learns **why VLANs exist** – not only how one clicks them in.

In the second half follow DNS and DHCP: **How does a device find its way in the network without typing an address**. And then **what this means on a Windows Server**: **captive portal** as the built-in mechanism for network login of Windows and Apple devices, name/DNS and DHCP distribution, and the place **where VLANs end**. **Still no server administration** here – but **first contact**. **First contact**: [Einheit 4]({{% relref "/04-server-administration" %}}) is the administration unit.

**Flow of the Unit (08:45–13:00, netto 255 min including breaks):**

| Time | Duration | Content |
|---|---|---|
| 08:45–09:15 | 30 min | Recap and network first aid (Units 1 and 2): ping, traceroute, `dig` / DNS lookup, reading an IP plan – one deliberately broken network to diagnose |
| 09:15–10:00 | 45 min | Theory: VLAN segmentation and permission matrices, why VLANs exist, number ranges, four user groups |
| 10:00–10:15 | 15 min | Break |
| 10:15–11:15 | 60 min | Lab part 1: VLANs, DNS and DHCP in the Packet Tracer file from Unit 2 + in the Debian VM (`dig`, `/etc/resolv.conf`, DNS forwarding) |
| 11:15–11:30 | 15 min | Break |
| 11:30–12:00 | 30 min | Theory: The school network on a Windows Server – captive portal, name/DNS + DHCP distribution |
| 12:00–12:45 | 45 min | Lab part 2: Windows Server 2025 Evaluation in a VM (text mode) installed, first console commands |
| 12:45–13:00 | 15 min | Documentation task, homework outlook |

The Preparation (**ISO download of the Windows Server 2025 Evaluation** and of the **Windows Platform Drivers / vendor tooling**) you complete **before the Unit, at home**: The download spans several Gigabytes and needs a stable network. A USB with the ISO and a pre-installed VM image are insurance, not the plan. The [Exercise]({{% relref "exercise" %}}) is **freely chosen** and gets deepened at home or in the next unit if needed.

{{% pages display="tree" levels="1" %}}
