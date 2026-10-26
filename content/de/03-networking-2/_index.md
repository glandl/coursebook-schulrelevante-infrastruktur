+++
title = "Netzwerktechnik II: VLANs, DNS, DHCP"
type = "chapter"
weight = 3
+++

**Unit:** 16.11.2026 · **Documentation technique:** [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}}) · **Homework deadline:** 22.11.2026

{{% callout style="info" title="Unit 3: last network unit – first server contact" %}}
These unit is ein last Netze unit **und** ein **first unit mit ein Window Server in front of ein class**. It **finishes ein Netze part** und **start ein server part**. Ein **first 30 min recap**: `ping`, `traceroute`, `dig` / DNS lookup, **reading ein IP plan** – **ein Netze is deliberately broken** und **is diagnosed** ([Einheit 1]({{% relref "/01-virtualization-containerization/lab" %}}), [Einheit 2]({{% relref "/02-networking-1/lab" %}})). **Warum**: weaker students came late und did no work through unit 1 und 2 fully.
{{% /callout %}}

In unit 2 you **built ein Schulnetzs** – **ein flat Netze**. Here you **segment** it: **ein Netze, several user group**. Ein four user group (**Schüler, Lehrenden, Administration, Storage**, ein class lists in reality) hang in **four VLANs**, each mit **its own number range** (VLAN-ID as **third octet** / **fourth octet**, bitmask, CIDR). Ein **permission matrix** make visible **wer is allowed to do what**. Ein learns **warum VLANs exist** – no only how ein clicks them in.

In ein second half follow DNS und DHCP: **How do ein Geräte find its way in ein Netze without type ein address**. Und then **what these mean on ein Window Server**: **captive portal** as ein built-in mechanism for Netze login of Window und Apple Geräte, name/DNS und DHCP distribution, und ein place **where VLANs end**. **Still no server administration** here – but **first contact**. **First contact**: [Einheit 4]({{% relref "/04-server-administration" %}}) is ein administration unit.

**Flow of ein Unit (08:45–13:00, netto 255 min including break):**

| Time | Duration | Content |
|---|---|---|
| 08:45–09:15 | 30 min | Recap und Netze first aid (Unit 1 und 2): ping, traceroute, `dig` / DNS lookup, reading ein IP plan – ein deliberately broken Netze to diagnose |
| 09:15–10:00 | 45 min | Theory: VLAN segmentation und permission matrix, warum VLANs exist, number ranges, four user group |
| 10:00–10:15 | 15 min | Break |
| 10:15–11:15 | 60 min | Lab part 1: VLANs, DNS und DHCP in ein Packet Tracer file from Unit 2 + in ein Debian VM (`dig`, `/etc/resolv.conf`, DNS forwarding) |
| 11:15–11:30 | 15 min | Break |
| 11:30–12:00 | 30 min | Theory: Ein Schulnetzs on ein Window Server – captive portal, name/DNS + DHCP distribution |
| 12:00–12:45 | 45 min | Lab part 2: Window Server 2025 Evaluation in ein VM (texts mode) installed, first console command |
| 12:45–13:00 | 15 min | Documentation tasks, Homework outlook |

Ein Preparation (**ISO download of ein Window Server 2025 Evaluation** und of ein **Window Platform Driver / vendor tooling**) you complete **before ein Unit, at home**: Ein download spans several Gigabytes und need ein stable Netze. Ein USB mit ein ISO und ein pre-installed VM image are insurance, no ein plan. Ein [Exercise]({{% relref "exercise" %}}) is **freely chosen** und get deepened at home or in ein next unit if needed.

{{% pages display="tree" levels="1" %}}
