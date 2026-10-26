+++
title = "Lernziele"
weight = 10
+++

Nach dieser Einheit kannst du:

1. **dem VLAN-ID and the Bitmask** (example: `0.0.255.0`) **the number range in both directions calculate** (`10.11.2.0/24`, CIDR) and **in binary write out one line per Oktet**; from a **device address** (example: `10.11.2.17`) **which VLAN and which group it belongs to via binary AND determine**, **the number range name** (**`10.11.2.0/24`**) **and the number of usable devices** (254),
2. **the three reasons name why VLANs instead of separate networks are used**: One network per group means **many networks**, **many gateways** and **broadcast-storms**, and – the decisive one: **the VLAN-ID stays constant**,
3. **both VLAN models in Packet Tracer name** and **at which device or in which field the VLAN number sits say**: **the internal VLAN field** ("VLAN-Insert", at device and on link) and **the VLAN-ID leg**, the **Ether-type field** in the Ethernet header (in the Frame). **The real VLAN tag sits in the Ethernet frame** (the "Etherfield" before the Payload) – **model 2 comes closer**. **Model 1 models the decision per connection** – **the firewall** –, **where the two models differ explain**,
4. **the VLAN boundary in one sentence state**: A VLAN **labels a device group**, **it does not authorize**. **A VLAN is no firewall** – **the network devices decide per connection** ([Security and Data Protection]({{% relref "security" %}}), also the [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})),
5. **DNS and DHCP the two steps of the resolution order name** and **tell apart**: **Name → Address (DNS lookup)** and **Device → Address in the network (DHCP)**. **DNS names nothing, DHCP gives an address and no name** – the IP is **found via name** or **assigned in the network** ([Theory]({{% relref "theory" %}})),
6. **the one line name that DNS forwarding needs** (`/etc/resolv.conf`) and **with `dig` in the VM show that there is no DNS lookup without a DNS server**,
7. **the four questions name that the installer asks in text mode** (**language of the install**, **license agreement**, **disk partition**, **Login**) and **what one does with them say** ([Lab part 2]({{% relref "lab" %}})),
8. **in the VM the first four commands run, four outputs read and what they mean write down** ([Lab part 2]({{% relref "lab" %}})): **`ipconfig /all`** – **hostname and address in the network**; **`systeminfo`** – **the build and the evaluation period**; **`nslookup`** – **name → number** or **nothing** (**no DNS forwarding**); **`Get-NetworkManager`** – **the network manager, the DHCP server**. **In the VM only, never on a server of the school**,
9. **why Evaluation Software and why no Windows Platform Drivers (WPP) – the two name and distinguish**: **Evaluation Software** limits **the time** (**120-day evaluation period**), **Windows Platform Drivers (WPP)** **is about the vendor tooling** – **a Windows Server in a school is no Evaluation Software**. The **server setup log** of the [Homework]({{% relref "homework" %}}) **documents** the **evaluation period of 120 days** of the VM server ([Sources]({{% relref "sources" %}})).

*Zuordnung zur Kompetenzliste: folgt (Platzhalter).*
