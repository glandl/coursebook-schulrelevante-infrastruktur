+++
title = "Networking II: VLANs, DNS, DHCP"
type = "chapter"
weight = 30
+++

**Self-study** · no session of its own · not graded · **Time needed:** approx. 2 hours of theory, optionally approx. 2 hours of lab

{{% callout style="info" title="Self-study" %}}
This chapter has **no session** in the timetable and **no** homework or graded submission. You work through it on your own. It is the basis for [chapter 4 (server roles)]({{% relref "/04-server-administration" %}}) on 16.11. and 23.11.2026: if you take on the **DHCP**, **DNS** or **directory service** role there, read the corresponding theory sections beforehand.
{{% /callout %}}

In [session 2]({{% relref "/02-networking-1" %}}) you planned the network of *Mittelschule Musterstadt*: an IP plan with a separate network per group (administration, teachers, student Wi-Fi, servers, …) and a small school network in Packet Tracer. One question from lab step 3.8 remained open: why do Wi-Fi devices end up in the same network as the teachers' PCs, and how do you separate them **without** buying separate switches for every group?

This chapter answers three questions:

1. **VLANs:** How do you separate several networks on the same switches, and where is it decided who may talk to whom?
2. **DHCP:** How does a device get its address without anyone typing it in, even across VLAN boundaries?
3. **DNS:** How does a device find a server by its name, in the school network and on the internet?

| Page | Content | Required? |
|---|---|---|
| [Learning goals]({{% relref "learning-goals" %}}) | What you can do afterwards | read |
| [Theory]({{% relref "theory" %}}) | VLANs, permission matrix, DHCP, DNS, captive portal | read (preparation for chapter 4) |
| [Lab with solutions]({{% relref "lab" %}}) | VLANs and access rules in Packet Tracer, DNS and DHCP in the Debian VM | **optional** |
| [Security and data protection]({{% relref "security" %}}) | What can go wrong with VLANs, DHCP and DNS | read |
| [Sources]({{% relref "sources" %}}) | Standards and documentation | as needed |

{{% pages display="tree" levels="1" %}}
