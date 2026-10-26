+++
title = "Quellen"
weight = 90
+++

Primärquellen (Standards and official documentations). All links were *nicht* checked individually in October 2026 (unverified); the contents can change.

## VLANs, Ethernet and Switches

- IEEE **802.3** (Ethernet, incl. VLAN tag / CPE, Power over Ethernet): [IEEE 802.3 Working Group](https://www.ieee802.org/3/)
- IETF: [RFC 1918, Address Allocation for Private Internets](https://www.rfc-editor.org/rfc/rfc1918)
- IETF: [RFC 4632, Classless Inter-domain Routing (CIDR)](https://www.rfc-editor.org/rfc/rfc4632)
- IETF: [RFC 826, Address Resolution Protocol](https://www.rfc-editor.org/rfc/rfc826)
- Cisco Packet Tracer (Network simulator): [Cisco Networking Academy](https://www.netacad.com/) (Download and Course *Getting Started with Cisco Packet Tracer* – VLAN-Insert, VLAN-permit, Ether-type field)

## DNS and DHCP

- IETF: [RFC 1035, Domain Name Lookup Procedure](https://www.rfc-editor.org/rfc/rfc1035)
- IETF: [RFC 2131, Dynamic Host Configuration Protocol](https://www.rfc-editor.org/rfc/rfc2131)
- IETF: [RFC 3927, Dynamic Configuration of IPv4 Link-Local Addresses](https://www.rfc-editor.org/rfc/rfc3927)
- Linux: [`dig(1)`](https://man7.org/linux/man-pages/man1/dig.1.html), [`resolv.conf(5)`](https://man7.org/linux/man-pages/man5/resolv.conf.5.html), [`ip(8)`](https://man7.org/linux/man-pages/man8/ip.8.html)
- Debian: [Debian-Reference, Chapter Network Configuration](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html)

## Windows Server 2025 (Evaluation)

- Microsoft: [Evaluating Windows Server and WPP Downloads](https://learn.microsoft.com/en-us/lifecycle/evaluating-windows-server-and-wpp-downloads) (**ISO Windows Server 2025 Evaluation**, Build `10.0.26100.24.07`, **120-day evaluation period**)
- Microsoft: [Windows Server 2025 – Release Notes](https://learn.microsoft.com/en-us/windowsserver/get-started/what-s-new-in-windows-server-2025)
- Microsoft: [Textmode-Install of Windows Server](https://learn.microsoft.com/en-us/setup/guide/installation-and-setup-options/text-based-install-of-windows-server-and-windows-11) (**Language of the install**, **License agreement**, **disk partition**, **Login**)
- Microsoft: [Network Sign-on / Captive portal](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security-and-schools/network-sign-on-in-windows-10) (**Redirect to the login site** – Windows and Apple devices)
- Microsoft: [`ipconfig`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/ipconfig), [`systeminfo`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/systeminfo), [`nslookup`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/nslookup)
- **`Get-NetworkManager`**: **not yet verified** – **the network manager command** of Windows Server (DHCP server) **could not be verified** in the Kurs environment (cf. [Lab part 2]({{% relref "lab" %}})). **Put the exact command in the [Change logs]({{% relref "/00-documentation/change-logs" %}})** (see [Change logs]({{% relref "/00-documentation/change-logs" %}})).

## Virtualization (part 2 of the Lab)

- VirtualBox: [User Manual, Chapter Virtual Networking](https://www.virtualbox.org/manual/)
- libvirt / virt-manager: [libvirt HTML](https://libvirt.org/format.html) and [NAT-Network „default“](https://wiki.libvirt.org/VirtualNetworking.html)
- UTM: [Network modes](https://docs.getutm.app/settings-qemu/devices/network/)
- Hyper-V: [Hyper-V networking in Windows Server](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/about/) (**Default Switch = NAT, `172.x.x.x`**)

## Security and Data Protection

- BSI IT-Grundschutz-Kompendium: Bausteines for Networks, WLAN and Access Control (e.g. *NET.2.1 WLAN-Betrieb*), [bsi.bund.de](https://www.bsi.bund.de/), for comparison
- [Datenschutz-Grundverordnung (EUR-Lex)](https://eur-lex.europa.eu/legal-content/DE/TXT/?uri=CELEX:32016R0679)
- [Datenschutzbehörde Österreich](https://www.dsb.gv.at)
- [Bundesministerium für Bildung (BMB)](https://www.bmb.gv.at)

## Documentation

- [Mermaid Documentation](https://mermaid.js.org/) (Flowchart, Sequence diagram)
- [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}}) and [Netzwerkdiagramme und IP-Pläne]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}) (Documentation techniques of the Documentation script)

## Notes on the sources

Only Standards and official documentations were used. Statements about software versions, menu items and commands are to be checked before the Kurs (cf. the note unverified in the [Lab]({{% relref "lab" %}})). Planning values in the Theory that are marked as *Faustregel* are practical planning values from practice and no norm values. The number ranges from the Packet-Tracer file (`10.10.x.x`) and from the class list (`10.11.x.x`) **differ** – **one writes down which convention one uses** (cf. [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
