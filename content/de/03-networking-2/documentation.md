+++
title = "Dokumentationsaufgabe"
weight = 50
+++

{{% callout style="info" title="Technik" %}}
Lies zuerst im Dokumentationsskript: [VLAN- und Berechtigungsmatrizen]({{% relref "/00-documentation/vlan-permission-matrices" %}}) und [Netzwerkdiagramme und IP-Pläne]({{% relref "/00-documentation/network-diagrams-ip-plans" %}})
{{% /callout %}}

## Aufgabe in dieser Einheit

Dokument your lab work as **Portfolio-Eintrag** (Pflichtabgabe, assessed after the [Rubrik]({{% relref "/rubric" %}})). Das here **not** the Hausaufgabe – the **Server-Setup-Log** (see 6.) **not in the grade**. The evaluated **Hausaufgabe**: see [Homework]({{% relref "homework" %}}).

**Ablage:** `03-networking-2/README.md` with Pictures and the File `schulnetz-vlan.pkt` in `assets/`, Branch `einheit-03`, Abgabe per Pull Request.

### Content

1. **Umgebung:** Host-BOS, Packet-Tracer-Version, Virtualisierung (VirtualBox, virt-manager, UTM oder Hyper-V), Debian-Version of the VM – plus: **Windows Server 2025 Evaluation**, **which you installed in the VM**.
2. **Netzdiagramm (logical layer)** as a Mermaid diagram with Title, Date, Version, Legend and labeled connections (see [Theory]({{% relref "theory" %}})): **one network, several user groups** – the four groups hang in four VLANs.
3. **Netzübersicht and address table** as a template of the Documentation script (Netz, Adresse, Gateway, DHCP-Range, Purpose; Hostname, IP, Location, Purpose). Names in the network and in the table agree – as in the [Documentation task]({{% relref "/02-networking-1/documentation" %}}).
4. **VLAN matrix** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})): the class list of the school in reality with **four VLANs** (see [Theory]({{% relref "theory" %}})) – **each VLAN-ID as 4th Oktet, number range (CIDR) and usable devices**:
   - VLAN 0 → `10.11.0.0/24` (254 usable devices)
   - VLAN 1 → `10.11.1.0/24`
   - VLAN 2 → `10.11.2.0/24`
   - VLAN 3 → `10.11.3.0/24`
   **Write down: which bitmask and how do you get the range from the VLAN-ID (bitwise AND)?** The **bitmask in binary** – **one line per Oktet** (see [Lab part 1.2]({{% relref "lab" %}})).
5. **VLAN permission matrix (network matrix, VLAN × VLAN):** Entries ✔ / ✘ / restricted (port/service), **Default deny**, **one line per VLAN** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})). **Next to each permit: the reason.** Further: **where do VLANs end – why is a VLAN no firewall** (see [Security and Data Protection]({{% relref "security" %}}))?
6. **Server-Setup-Log one page** – **this is not the evaluated Hausaufgabe**, it is the evidence from your Lab (see [Homework]({{% relref "homework" %}})): **Date**, **ISO** and **Build** (`10.0.26100.24.07`), **VM settings** (RAM, disk, EFI, network), **the four questions of the text mode installer**, **three screenshots** (Installer, `ipconfig /all`, `systeminfo`) and **what failed** (see [Change logs]({{% relref "/00-documentation/change-logs" %}})). **Mark: "VM only – no Server of the school!"**
7. **Vergehen** of the important steps: VLAN inserts and Switch masks (Packet Tracer: `vlan insert`, `vlan permit`), the DNS lookup (`dig`, `/etc/resolv.conf`) and DHCP (see [Lab part 1.4]({{% relref "lab" %}})).
8. **Nachweise:** at least **four screenshots**: the **Topology in Packet Tracer**, the `ipconfig /all` of a DHCP client, a successful Ping or browser access **from outside the network**, the simulation mode with an opened DHCP or DNS packet. To this the output `ip -br addr` and `ip route` of the Debian VM as text.
9. **Problems and Solutions:** at least one problem that arose, with cause and solution (e.g. the deliberately introduced disruption from 1.1). **Write down: what did you break and how did you find out?**
10. **Reflexion (Schulkontext), ca. 150–200 words:** What changes in a real School network compared to the Simulation (number of devices, WLAN, administration, security, responsibility)? What is the biggest Error source in network planning? **Why do VLANs instead of Networks help in the School?**
11. **Sources:** the guides and documentations you used.

### Abgabe

- Pull Request on `main` with the PR template from the documentation script.
- Frist: together with the Hausaufgabe on **22.11.2026**. *Endgültige Frist for the Portfolio: confirmed in the Unit.*

### Control list

- [ ] README follows the template (Goal, Vergeh, Result, Problems, Reflexion, Sources).
- [ ] VLAN table: **four VLANs, each with VLAN-ID, number range (CIDR), usable devices** – and **the bitmask in binary** (one line per Oktet).
- [ ] **Network matrix (VLAN × VLAN)** with **Default deny** and **one reason per permit** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
- [ ] **Server-Setup-Log** one page, **marked as not the evaluated Hausaufgabe**, ISO build and VM settings written down.
- [ ] **Nachweise** with at least **four screenshots** (Packet Tracer Topology, `ipconfig /all`, Ping/browser from outside the network, simulation mode with opened DHCP/DNS package).
- [ ] Commands are copyable (Codeblocks), Screenshots with Alt-Text in `assets/`.
- [ ] Diagram and IP plan use the same names and addresses.
- [ ] No passwords in the Repository, no real addresses or names from the School network.
- [ ] At least three meaningful Commits with meaningful messages.
- [ ] Pull Request open, Reviewer set.
