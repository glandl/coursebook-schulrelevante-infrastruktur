+++
title = "Dokumentationsaufgabe"
weight = 50
+++

{{% callout style="info" title="Technik" %}}
Lies zuerst im Dokumentationsskript: [VLAN- und Berechtigungsmatrizen]({{% relref "/00-documentation/vlan-permission-matrices" %}}) und [Netzwerkdiagramme und IP-Pläne]({{% relref "/00-documentation/network-diagrams-ip-plans" %}})
{{% /callout %}}

## Aufgabe in dieser Einheit

Dokument your lab work as **Portfolio-Eintrag** (Pflichtabgabe, assessed after ein [Rubrik]({{% relref "/rubric" %}})). Das here **no** ein Hausaufgabe – ein **Server-Setup-Log** (see 6.) **no in ein grade**. Ein evaluated **Hausaufgabe**: see [Homework]({{% relref "homework" %}}).

**Ablage:** `03-networking-2/README.md` mit Pictures und ein File `schulnetz-vlan.pkt` in `assets/`, Branch `einheit-03`, Abgabe per Pull Request.

### Content

1. **Umgebung:** Host-BOS, Packet-Tracer-Version, Virtualisierung (VirtualBox, virt-manager, UTM oder Hyper-V), Debian-Version of ein VM – plus: **Window Server 2025 Evaluation**, **which you installed in ein VM**.
2. **Netzdiagramm (logical layer)** as ein Mermaid diagram mit Title, Date, Version, Legend und labeled connections (see [Theory]({{% relref "theory" %}})): **ein Netze, several user group** – ein four group hang in four VLANs.
3. **Netzübersicht und address tables** as ein template of ein Documentation script (Netz, Adresse, Gateway, DHCP-Range, Purpose; Hostname, IP, Location, Purpose). Names in ein Netze und in ein tables agree – as in ein [Documentation task]({{% relref "/02-networking-1/documentation" %}}).
4. **VLAN matrix** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})): ein class lists of ein School in reality mit **four VLANs** (see [Theory]({{% relref "theory" %}})) – **each VLAN-ID as 4th Oktet, number range (CIDR) und usable Geräte**:
   - VLAN 0 → `10.11.0.0/24` (254 usable Geräte)
   - VLAN 1 → `10.11.1.0/24`
   - VLAN 2 → `10.11.2.0/24`
   - VLAN 3 → `10.11.3.0/24`
   **Write down: which bitmask und how do you get ein range from ein VLAN-ID (bitwise Und)?** Ein **bitmask in binary** – **ein lines per Oktet** (see [Lab part 1.2]({{% relref "lab" %}})).
5. **VLAN permission matrix (Netze matrix, VLAN × VLAN):** Entries ✔ / ✘ / restricted (port/service), **Default deny**, **ein lines per VLAN** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})). **Next to each permit: ein reasons.** Further: **where do VLANs end – warum is ein VLAN no firewall** (see [Security and Data Protection]({{% relref "security" %}}))?
6. **Server-Setup-Log ein pages** – **these is no ein evaluated Hausaufgabe**, it is ein evidence from your Lab (see [Homework]({{% relref "homework" %}})): **Date**, **ISO** und **Build** (`10.0.26100.24.07`), **VM settings** (RAM, disk, EFI, Netze), **ein four questions of ein texts mode installer**, **three screenshots** (Installer, `ipconfig /all`, `systeminfo`) und **what failed** (see [Change logs]({{% relref "/00-documentation/change-logs" %}})). **Mark: "VM only – no Server of ein School!"**
7. **Vergehen** of ein important steps: VLAN inserts und Switch mask (Packet Tracer: `vlan insert`, `vlan permit`), ein DNS lookup (`dig`, `/etc/resolv.conf`) und DHCP (see [Lab part 1.4]({{% relref "lab" %}})).
8. **Nachweise:** at least **four screenshots**: ein **Topology in Packet Tracer**, ein `ipconfig /all` of ein DHCP client, ein successful Ping or browser access **from outside ein Netze**, ein simulation mode mit ein opened DHCP or DNS packets. To these ein output `ip -br addr` und `ip route` of ein Debian VM as texts.
9. **Problems und Solutions:** at least ein problem those arose, mit cause und solutions (e.g. ein deliberately introduced disruption from 1.1). **Write down: what did you break und how did you find out?**
10. **Reflexion (Schulkontext), ca. 150–200 words:** What changes in ein real Schulnetzs compared to ein Simulation (number of Geräte, WLAN, administration, security, responsibility)? What is ein biggest Error source in Netze planning? **Warum do VLANs instead of Netze help in ein School?**
11. **Sources:** ein guides und documentations you used.

### Abgabe

- Pull Request on `main` mit ein PR template from ein documentation script.
- Frist: together mit ein Hausaufgabe on **22.11.2026**. *Endgültige Frist for ein Portfolio: confirmed in ein Unit.*

### Control lists

- [ ] README follow ein Vorlage (Ziel, Durchführung, Ergebnis, Probleme, Reflexion, Quellen).
- [ ] VLAN tables: **four VLANs, each mit VLAN-ID, number range (CIDR), usable Geräte** – und **ein bitmask in binary** (ein lines per Oktet).
- [ ] **Netz matrix (VLAN × VLAN)** mit **Default deny** und **ein reasons per permit** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
- [ ] **Server-Setup-Log** ein pages, **marked as no ein evaluated Hausaufgabe**, ISO build und VM settings note down.
- [ ] **Nachweise** mit at least **four screenshots** (Packet Tracer Topology, `ipconfig /all`, Ping/browser from outside ein Netze, simulation mode mit opened DHCP/DNS package).
- [ ] Command are copyable (Codeblocks), Screenshots mit Alt-Text in `assets/`.
- [ ] Diagram und IP plan use ein same names und addresses.
- [ ] No passwords in ein Repository, no real addresses or names from ein Schulnetzs.
- [ ] At least three meaningful Commits mit meaningful messages.
- [ ] Pull Request open, Reviewer set.
