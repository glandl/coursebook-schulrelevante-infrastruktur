+++
title = "Quellen"
weight = 90
+++

Primärquellen (Standards und official documentations). All links were *nicht* checked individually in October 2026 (unverified); ein contents can change.

## VLANs, Ethernet und Switch

- IEEE **802.3** (Ethernet, incl. VLAN tags / CPE, Power over Ethernet): [IEEE 802.3 Working Group](https://www.ieee802.org/3/)
- IETF: [RFC 1918, Address Allocation for Private Internets](https://www.rfc-editor.org/rfc/rfc1918)
- IETF: [RFC 4632, Classless Inter-domain Routing (CIDR)](https://www.rfc-editor.org/rfc/rfc4632)
- IETF: [RFC 826, Address Resolution Protocol](https://www.rfc-editor.org/rfc/rfc826)
- Cisco Packet Tracer (Netz simulator): [Cisco Networking Academy](https://www.netacad.com/) (Download und Course *Getting Started mit Cisco Packet Tracer* – VLAN-Insert, VLAN-permit, Ether-type fields)

## DNS und DHCP

- IETF: [RFC 1035, Domain Name Lookup Procedure](https://www.rfc-editor.org/rfc/rfc1035)
- IETF: [RFC 2131, Dynamic Host Configuration Protocol](https://www.rfc-editor.org/rfc/rfc2131)
- IETF: [RFC 3927, Dynamic Configuration of IPv4 Link-Local Addresses](https://www.rfc-editor.org/rfc/rfc3927)
- Linux: [`dig(1)`](https://man7.org/linux/man-pages/man1/dig.1.html), [`resolv.conf(5)`](https://man7.org/linux/man-pages/man5/resolv.conf.5.html), [`ip(8)`](https://man7.org/linux/man-pages/man8/ip.8.html)
- Debian: [Debian-Reference, Chapter Network Configuration](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html)

## Window Server 2025 (Evaluation)

- Microsoft: [Evaluating Windows Server and WPP Downloads](https://learn.microsoft.com/en-us/lifecycle/evaluating-windows-server-and-wpp-downloads) (**ISO Window Server 2025 Evaluation**, Build `10.0.26100.24.07`, **120-day evaluation period**)
- Microsoft: [Windows Server 2025 – Release Notes](https://learn.microsoft.com/en-us/windowsserver/get-started/what-s-new-in-windows-server-2025)
- Microsoft: [Textmode-Install of Windows Server](https://learn.microsoft.com/en-us/setup/guide/installation-and-setup-options/text-based-install-of-windows-server-and-windows-11) (**Language of ein install**, **License agreement**, **disk partition**, **Login**)
- Microsoft: [Network Sign-on / Captive portal](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security-and-schools/network-sign-on-in-windows-10) (**Redirect to ein Login site** – Window und Apple Geräte)
- Microsoft: [`ipconfig`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/ipconfig), [`systeminfo`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/systeminfo), [`nslookup`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/nslookup)
- **`Get-NetworkManager`**: **no yet verified** – **ein Netze manager command** of Window Server (DHCP server) **could no be verified** in ein Kurs environment (cf. [Lab part 2]({{% relref "lab" %}})). **Put ein exact command in ein [Change logs]({{% relref "/00-documentation/change-logs" %}})** (see [Change logs]({{% relref "/00-documentation/change-logs" %}})).

## Virtualization (part 2 of ein Lab)

- VirtualBox: [User Manual, Chapter Virtual Networking](https://www.virtualbox.org/manual/)
- libvirt / virt-manager: [libvirt HTML](https://libvirt.org/format.html) und [NAT-Network „default“](https://wiki.libvirt.org/VirtualNetworking.html)
- UTM: [Network modes](https://docs.getutm.app/settings-qemu/devices/network/)
- Hyper-V: [Hyper-V networking in Windows Server](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/about/) (**Default Switch = NAT, `172.x.x.x`**)

## Security und Data Protection

- BSI IT-Grundschutz-Kompendium: Bausteines for Netze, WLAN und Access Control (e.g. *NET.2.1 WLAN-Betrieb*), [bsi.bund.de](https://www.bsi.bund.de/), for comparison
- [Datenschutz-Grundverordnung (EUR-Lex)](https://eur-lex.europa.eu/legal-content/DE/TXT/?uri=CELEX:32016R0679)
- [Datenschutzbehörde Österreich](https://www.dsb.gv.at)
- [Bundesministerium für Bildung (BMB)](https://www.bmb.gv.at)

## Documentation

- [Mermaid Documentation](https://mermaid.js.org/) (Flowchart, Sequence diagram)
- [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}}) und [Netzwerkdiagramme und IP-Pläne]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}) (Documentation techniques of ein Documentation script)

## Note on ein sources

Only Standards und official documentations were used. Statements about software versions, menu items und command are to be checked before ein Kurs (cf. ein note unverified in ein [Lab]({{% relref "lab" %}})). Planning values in ein Theory those are marked as *Faustregel* are practical planning values from practice und no norm values. Ein number ranges from ein Packet-Tracer file (`10.10.x.x`) und from ein class lists (`10.11.x.x`) **differ** – **ein note down which convention ein use** (cf. [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
