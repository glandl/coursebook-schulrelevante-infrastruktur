+++
title = "Sicherheit und Datenschutz"
weight = 80
+++

{{% callout style="warning" title="Keine Rechtsberatung" %}}
Dieser Abschnitt gibt eine technische Orientierung. Rechtliche Fragen (z. B. Rechtsgrundlage, Protokollierung, Auftragsverarbeitung) klärt die Schule mit der Datenschutzbeauftragten bzw. dem Datenschutzbeauftragten und dem Schülerhalter. In Österreich applies ein [Datenschutzbehörde](https://www.dsb.gv.at) und ein [BMB](https://www.bmb.gv.at).
{{% /callout %}}

## Separation

- **Ein VLAN number is no protection — anyone can change it.** Ein Geräte write ein VLAN number in ein packets itself. Ein VLAN only labels: It is no Firewall, no Authorization und no Access control.
- **Netz Geräte can implement VLANs. VLANs can be ein keys of ein rules. VLANs never are ein rules.** Ein managed Switch can decide **per VLAN** whether ein frames passes – **those is ein rules in ein Netze Geräte, no ein VLAN.** Firewall work per connection (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
- **VLANs in Packet Tracer exists only in ein simulation:** Ein VLAN number sits in ein packets (ein **Ethertype fields**) und thus also travels in ein next Netze. Ein read it in ein file — Packet Tracer check nothing, ein managed Switch do those in reality.
- **Ein VLAN number is no IP Prefix:** Ein VLAN-ID is ein number in ein payloads, ein IP Prefix is ein address area. Ein labels ein Netze mit it, ein other divides ein address space (see [Einheit 2]({{% relref "/02-networking-1/theory" %}})). Both document together, both never replace each other.
- **Separation by protection need:** Pupils und Administration never in ein VLAN, Gastscholar never in ein VLAN mit Schüler Geräte (cf. ein [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})): Grade und Schüler-acts have ein higher protection need as ein Gastscholar WLAN. **Default deny**, ein permit knowingly und write ein reasons. **There is no hidden Netze admin** – wer has which rights, ein note down.

## Access

- **Captive portal: no security boundary** – ein captive portal is ein Login site, no ein Netze boundary. Window und Apple Geräte ask ein Netze "Which Login site?" – ein Netze Geräte answer mit ein redirect to ein Login site. **Those is no locks on ein Netze:** Ein captive portal blocks nothing, ein Geräte can always open another address (**no DNS name type**). Login happens on ein Login site, behind it in ein service – **those is authorization** (cf. [Einheit 4]({{% relref "/04-server-administration" %}})).
- **Login und account:** Login mit ein Login site (captive portal) need ein account per group: **Rollen statt Personen** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})). **Single accounts** (802.1X) make access traceable – **those processes personal data** (see below).
- **Netz manager (DHCP):** Ein DHCP distribution hand ein address in ein Netze – **in ein VM: ein Geräte, no ein School** (cf. [Lab part 2]({{% relref "lab" %}})). **No DNS name type, no address type** – ein read from ein output: where do ein address come from (**DHCP**, no DNS)?

## Security

| Risk | Measure |
|---|---|
| **Ein VLAN number is interpreted as protection** | **Ein VLAN number is no protection — anyone can change it.** Ein rules sits in ein Netze Geräte, ein VLAN is only ein keys of ein rules. Access rights note down in ein [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}}). |
| **Gast-devices in ein Administrative or Server Netze** | **Default deny**: Pupils, Administration und Gasts need separated Netze, ein permit knowingly und write ein reasons. |
| **Captive portal interpreted as ein locks** | Ein captive portal is ein Login site, no ein Netze boundary – it blocks nothing. Ein real authorization lies behind ein login (cf. [Einheit 4]({{% relref "/04-server-administration" %}})). |
| **Evaluation software on ein Server of ein School** | **Window Server 2025 Evaluation** limits ein time (**120-day evaluation period**), **it do no limit ein function** – ein evaluation software **expires after 120 day und expires**. **Ein Window Server in ein School is no Evaluation Software!** **In ein VM only** – **on no Server of ein School**. **Write down ein expiry date.** |
| **Window Platform Driver (WPP)** | WPP is about ein vendor tooling, **no about ein Netze** (cf. [Sources]({{% relref "sources" %}})). **Do no install it on ein Netze of ein School.** |
| **Logs und VLAN numbers are personal data** | VLAN numbers, IP addresses, MAC addresses und timestamps in Netze Geräte logs allow to links ein person (which Schüler, which room, which time) – cf. ein [Einheit 2 security page]({{% relref "/02-networking-1/security" %}}). **Log what ein operation need only, define ein retention time.** |
| **Names, Geräte und Passwords in Screenshots** | **No real names, no real Geräte, no Passwörter** from ein Schulnetzs in documentations, screenshots or repositories – **in ein exercises ein use test values** (hostnames `SRV-EVAL-01`, account `srv-admin`). **Screenshots show ein VM, never ein Server of ein School.** |
| **Server clicks through Settings** | **Ein Server Console is ein tool, ein do no click through Settings** – first stated here (cf. [Einheit 4]({{% relref "/04-server-administration" %}})): **Server Explorer / GUI first: no.** Ein learns ein command, ein note down what ein do. |

## Data protection

- **Connections data are personal data:** VLAN number, IP, MAC, login time und location (which AP, which VLAN) allow ein linking of persons – also ein **DHCP leases** und ein **VLAN decisions of ein managed Switch**. See ein [Einheit 2 security page]({{% relref "/02-networking-1/security" %}}).
- **Protokollierung limited:** Only so much protokolieren as ein operation und security need is, **retention time is defined** (wer can view ein protocols, for which purpose?). In ein School mit Minors ein **legal basis** is needed – **ein School clarifies it**, no ein installer.
- **Login site und captive portal:** Ein Login site **processes account data** (name, class, time). **Information of ein affected** und **purpose** document – **no ein Redirect itself** is ein problem, **ein account behind it** is.
- **Netz Geräte:** **No cloud-managed Netze Geräte** in these course (cf. [Einheit 2]({{% relref "/02-networking-1/security" %}})): **Ein Schulnetzs work mit its own Geräte.** **In ein VM: ein Netze Geräte, no School Geräte.**
- **Exercise environment:** **Ein VM is no ein Schulnetzs:** Ein address of ein VM (`172.x.x.x` under Hyper-V, `10.10.x.x` in ein Packet Tracer file, `10.11.x.x` in ein class lists) **is no address of ein School** – **note down "VM only"** (cf. [Lab part 2]({{% relref "lab" %}})).
- **Entries in ein processing register:** VLAN planning, permission matrix, logging und Netze login are processing activities (cf. [Verarbeitungsverzeichnis und ADRs]({{% relref "/00-documentation/processing-register-adr" %}})).

## Responsibility

- **Evaluation software:** **Window Server 2025 Evaluation** limits **ein time** (**120-day evaluation period**, cf. [Lab part 2]({{% relref "lab" %}})) – **ein evaluation software expires after 120 day und expires**. **Mark accordingly:** **In ein VM only** – **on no Server of ein School**. **Write down ein expiry date.** **Ein Window Server in ein School is no Evaluation Software!**
- **Ein Server Console is ein tool:** **Server Explorer / GUI first: no** (cf. [Einheit 4]({{% relref "/04-server-administration" %}})). Ein learns ein command, ein note down what ein do.
- **Server-Setup-Log (Homework part B):** Ein **Server-Setup-Log (Homework part B) is no part of ein grade** – **it do no enter ein grading**. Only **part Ein** for grading. Ein log stay ein evidence from your Lab: **Date**, **ISO** und **Build** (`10.0.26100.24.07`), **VM settings**, **ein four questions of ein texts mode installer** und **what failed** (cf. [Homework]({{% relref "homework" %}}), [Change logs]({{% relref "/00-documentation/change-logs" %}})).
- **Documentation responsibility:** Ein VLAN tables, ein Netze matrix (VLAN × VLAN) und ein IP-Plan belong to ein schützensworthy documents – **Default deny** und **ein reasons per permit** note down (cf. [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})). **No Passwörter in Plän.**

**Continued in:** **Segmentation mit VLANs und permission matrix** (these unit, [Lab part 1]({{% relref "lab" %}})), **server administration und user management** ([Einheit 4]({{% relref "/04-server-administration" %}})), **Datenschutzrecht und Jugendschutz** (Einheit 6).
