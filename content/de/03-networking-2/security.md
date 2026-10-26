+++
title = "Sicherheit und Datenschutz"
weight = 80
+++

{{% callout style="warning" title="Keine Rechtsberatung" %}}
Dieser Abschnitt gibt eine technische Orientierung. Rechtliche Fragen (z. B. Rechtsgrundlage, Protokollierung, Auftragsverarbeitung) klärt die Schule mit der Datenschutzbeauftragten bzw. dem Datenschutzbeauftragten und dem Schulerhalter. In Österreich applies the [Datenschutzbehörde](https://www.dsb.gv.at) and the [BMB](https://www.bmb.gv.at).
{{% /callout %}}

## Separation

- **A VLAN number is no protection — anyone can change it.** The device writes the VLAN number into the packet itself. A VLAN only labels: It is no Firewall, no Authorization and no Access control.
- **Network devices can implement VLANs. VLANs can be the key of a rule. VLANs never are the rule.** A managed Switch can decide **per VLAN** whether a frame passes – **that is a rule in the network device, not a VLAN.** Firewall works per connection (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
- **VLANs in Packet Tracer exists only in the simulation:** The VLAN number sits in the packet (the **Ethertype field**) and thus also travels into the next network. One reads it in the file — Packet Tracer checks nothing, the managed Switch does that in reality.
- **A VLAN number is no IP Prefix:** The VLAN-ID is a number in the payload, the IP Prefix is an address area. One labels the network with it, the other divides the address space (see [Einheit 2]({{% relref "/02-networking-1/theory" %}})). Both document together, both never replace each other.
- **Separation by protection need:** Pupils and Administration never in one VLAN, Gastscholars never in one VLAN with pupil devices (cf. the [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})): Grades and pupil-acts have a higher protection need as one Gastscholar WLAN. **Default deny**, one permits knowingly and writes the reason. **There is no hidden network admin** – who has which rights, one writes down.

## Access

- **Captive portal: no security boundary** – the captive portal is a login site, not a network boundary. Windows and Apple devices ask the network "Which login site?" – the network device answers with the redirect to the login site. **That is no lock on the network:** The captive portal blocks nothing, one device can always open another address (**no DNS name typing**). Login happens on a login site, behind it in the service – **that is authorization** (cf. [Einheit 4]({{% relref "/04-server-administration" %}})).
- **Login and account:** Login with a login site (captive portal) needs an account per group: **Rollen statt Personen** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})). **Single accounts** (802.1X) make access traceable – **that processes personal data** (see below).
- **Network manager (DHCP):** The DHCP distribution hands the address in the network – **in the VM: one device, not the school** (cf. [Lab part 2]({{% relref "lab" %}})). **No DNS name typing, no address typing** – one reads from the output: where does the address come from (**DHCP**, not DNS)?

## Security

| Risk | Measure |
|---|---|
| **A VLAN number is interpreted as protection** | **A VLAN number is no protection — anyone can change it.** The rule sits in the network device, the VLAN is only the key of a rule. Access rights write down in the [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}}). |
| **Gast-devices in the Administrative or Server network** | **Default deny**: Pupils, Administration and Gasts need separated networks, one permits knowingly and writes the reason. |
| **Captive portal interpreted as a lock** | The captive portal is a login site, not a network boundary – it blocks nothing. The real authorization lies behind the login (cf. [Einheit 4]({{% relref "/04-server-administration" %}})). |
| **Evaluation software on a Server of the school** | **Windows Server 2025 Evaluation** limits the time (**120-day evaluation period**), **it does not limit the function** – the evaluation software **expires after 120 days and expires**. **A Windows Server in a school is no Evaluation Software!** **In the VM only** – **on no Server of the school**. **Write down the expiry date.** |
| **Windows Platform Drivers (WPP)** | WPP is about the vendor tooling, **not about the network** (cf. [Sources]({{% relref "sources" %}})). **Do not install it on the network of the school.** |
| **Logs and VLAN numbers are personal data** | VLAN numbers, IP addresses, MAC addresses and timestamps in network device logs allow to link a person (which pupil, which room, which time) – cf. the [Einheit 2 security page]({{% relref "/02-networking-1/security" %}}). **Log what the operation needs only, define the retention time.** |
| **Names, devices and Passwords in Screenshots** | **No real names, no real devices, no Passwörter** from the school network in documentations, screenshots or repositories – **in the exercise one uses test values** (hostname `SRV-EVAL-01`, account `srv-admin`). **Screenshots show the VM, never a Server of the school.** |
| **Server clicks through Settings** | **The Server Console is the tool, one does not click through Settings** – first stated here (cf. [Einheit 4]({{% relref "/04-server-administration" %}})): **Server Explorer / GUI first: no.** One learns the commands, one writes down what one does. |

## Data protection

- **Connections data are personal data:** VLAN number, IP, MAC, login time and location (which AP, which VLAN) allow the linking of persons – also the **DHCP leases** and the **VLAN decisions of a managed Switch**. See the [Einheit 2 security page]({{% relref "/02-networking-1/security" %}}).
- **Protokollierung limited:** Only so much protokolieren as the operation and security need is, **retention time is defined** (who may view the protocols, for which purpose?). In a school with Minors a **legal basis** is needed – **the school clarifies it**, not the installer.
- **Login site and captive portal:** A login site **processes account data** (name, class, time). **Information of the affected** and **purpose** document – **not the Redirect itself** is the problem, **the account behind it** is.
- **Network devices:** **No cloud-managed network devices** in this course (cf. [Einheit 2]({{% relref "/02-networking-1/security" %}})): **The school network works with its own devices.** **In the VM: one network device, no school device.**
- **Exercise environment:** **The VM is not the school network:** The address of the VM (`172.x.x.x` under Hyper-V, `10.10.x.x` in the Packet Tracer file, `10.11.x.x` in the class list) **is no address of the school** – **write down "VM only"** (cf. [Lab part 2]({{% relref "lab" %}})).
- **Entries in the processing register:** VLAN planning, permission matrices, logging and network login are processing activities (cf. [Verarbeitungsverzeichnis und ADRs]({{% relref "/00-documentation/processing-register-adr" %}})).

## Responsibilities

- **Evaluation software:** **Windows Server 2025 Evaluation** limits **the time** (**120-day evaluation period**, cf. [Lab part 2]({{% relref "lab" %}})) – **the evaluation software expires after 120 days and expires**. **Mark accordingly:** **In the VM only** – **on no Server of the school**. **Write down the expiry date.** **A Windows Server in a school is no Evaluation Software!**
- **The Server Console is the tool:** **Server Explorer / GUI first: no** (cf. [Einheit 4]({{% relref "/04-server-administration" %}})). One learns the commands, one writes down what one does.
- **Server-Setup-Log (Homework part B):** The **Server-Setup-Log (Homework part B) is not part of the grade** – **it does not enter the grading**. Only **part A** for grading. The log stays the evidence from your Lab: **Date**, **ISO** and **Build** (`10.0.26100.24.07`), **VM settings**, **the four questions of the text mode installer** and **what failed** (cf. [Homework]({{% relref "homework" %}}), [Change logs]({{% relref "/00-documentation/change-logs" %}})).
- **Documentation responsibility:** The VLAN table, the network matrix (VLAN × VLAN) and the IP-Plan belong to the schützensworthy documents – **Default deny** and **one reason per permit** written down (cf. [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})). **No Passwörter in Plän.**

**Continued in:** **Segmentation with VLANs and permission matrices** (this unit, [Lab part 1]({{% relref "lab" %}})), **server administration and user management** ([Einheit 4]({{% relref "/04-server-administration" %}})), **Datenschutzrecht and Jugendschutz** (Einheit 6).
