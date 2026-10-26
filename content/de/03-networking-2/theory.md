+++
title = "Theorie"
weight = 20
+++

## Ziel

Here you learn **why Schulnet splits in VLANs**, how VLAN number **lands in an address**, und how DNS und DHCP make network **usable** – nobody **has to enter IP addresses**. Therewith **first Server** comes (Windows Server, hostname `SRV-EVAL-01`, account `srv-admin`) – **managed never**.

## Why VLANs exist — Problem single Network

In [Einheit 2]({{% relref "/02-networking-1/theory" %}}) **Schulnet** built separate Networks (Administration, Lehrende, Server, WLANs) — **separated by address area**. VLANs answer **other half**: **a single network serves whole school** – **nobody writes down who is where**. Three short scenarios make **need** clear:

1. **Network, too many.** Whole school sits **in a network** `10.11.0.0/16`: 400 Schuler devices, 40 Lehrenden, Administration und Storage. Im Netzwerk **everything lies next to each other**: **network events** (flood, fire alarm, bad device) **reach everything**. **Single groups never switchable** – **others likewise** –, **group at frame unclear**.
2. **groups differing in purpose lie next to each other.** **Administration** (Grades, Schüler-Acts, invoices) und **Storage** (key cabinet, room bookings, supplier orders) sit **next to each other**. Schuler device **can in principle** still **reach Administration network**: **address area locks nothing** – **border only convention** (see [Security und Data Protection]({{% relref "security" %}})).
3. **per classroom switched on, whole School never needed.** Klassroom beamers und Klassroom network devices **per wing, per floor on Monday morning** **switched on** – **whole School likewise never needed**. **Groups** (Schüler, Lehrenden, Administration, Storage) **need no own wire Network** – **become numbers**.

**What VLANs do:** In **a single wire Network** **groups become numbers** – **no separate wire Network**.
**What VLANs never do:** VLAN numbers **sit in frame, like a label** – **changeable at any time**. **A VLAN is neither Firewall nor rights** (see [Security und Data Protection]({{% relref "security" %}})).

## VLAN und mask

A VLAN **is bitmask und number**. **Bitmask** decides **who address bits belong to VLAN** – rest **reads as 0**.

**Bitwise rule:** **Device address** bitwise **und bitmask** → **result = VLAN number**. Bit columns **mask bit 1 stay**, columns **mask bit 0 become zero**.

### Worked example: VLAN-ID → number range

School convention (as in [Einheit 2]({{% relref "/02-networking-1/lab" %}})): **dritter Oktet = VLAN-ID**, **fourth Oktet free for devices** – VLAN-ID **gives an address range**:

| Step | What | Result |
|---|---|---|
| 1. Base address | whole School network | `10.11.0.0/16` |
| 2. Bitmask | third Oktet = VLAN-relevant | `0.0.255.0` |
| 3. VLAN-ID in the masked Oktet | VLAN-ID 2 → third Oktet **2** | `10.11.**2**.0` |
| 4. Number range | base + bitmask | **`10.11.2.0/24`** |
| 5. Usable devices | `2⁸ − 2` | **254** |

**Check by hand** (binary, third Oktet alone matters):

```text
Device  Administration-PC      10.11.2.17
bitmask                          0.0.255.0   third Oktet: 0000 0010 AND 1111 1111
10.11.2.17 AND 0.0.255.0     →  10.11.2.0   → VLAN-ID 2 → Administration-VLAN ✔
```

**Read:** VLAN-ID **masked Oktet result** – **address range = bitmask result**, never wire.

## Class list in reality

Four groups – **class lists in reality** (same class list as in Unit 1, [VM-Container]({{% relref "/01-virtualization-containerization/exercise" %}})). All four VLANs, their Adressrange:

| Group | What | VLAN | VLAN-ID as 4th Oktet | Number range | Usable devices |
|---|---|---|---|---|---|
| Schüler | Schüler-Laptops, Klass projectors, Schüler-WLAN | VLAN 0 | third Oktet `0` | `10.11.0.0/24` | 254 |
| Lehrenden | Lehrerroom-Laptops, Lehrerroom network | VLAN 1 | third Oktet `1` | `10.11.1.0/24` | 254 |
| Administration | Administration PCs, Administration network | VLAN 2 | third Oktet `2` | `10.11.2.0/24` | 254 |
| Storage | Storage network, key cabinet network | VLAN 3 | third Oktet `3` | `10.11.3.0/24` | 254 |

**Why four VLANs instead four Networks?** **A single wire Network serves whole school for all four groups** (Router single, managed Switch system single, Uplink single) – **groups become numbers**. **Where VLANs land:** **network serves school, Adressrange belongs** – **single network serves whole school** (see "Problem single Network"). Whole `10.11.0.0/16` **leaves space for 252 further /24 Blocks** – **space for extensions** (school convention, as in [Einheit 2]({{% relref "/02-networking-1/theory" %}})).

**Attention — VLAN number no IP prefix!** VLAN-ID ≠ IP prefix: VLANs **are numbers in payload**, IP prefixes **are Adressranges** (see [Einheit 2]({{% relref "/02-networking-1/theory" %}})). **No Firewall via VLANs** – Firewall **per connection** (see [Security und Data Protection]({{% relref "security" %}})). **Permission matrix** (see [VLAN- und Permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})) **fill out per VLAN — per Network no**.

## VLANs in Packet Tracer: both models

**Cannot be told apart at screenshot – precisely point.** Packet Tracer **offers two different things**, both **go by name "VLAN"**. **Neither real Etherfield** – **model 2 comes closer**.

### Model 1: VLAN field (device-internal)

In simulation **every device, every link carries internal VLAN fields** ('VLAN-Insert' at simulator): device **`VLAN = 2` itself**. Frame **crossing managed Switch or Router** simulator **whether link allows checks**.

- **Property:** **device carries VLAN number**, frame outside – device **cannot lie about itself**.
- **Reality:** Ethernet frames **carry VLAN tags**, devices **no labels**. **Model 1 models decision per connection** – **decision per connection** (see [Security und Data Protection]({{% relref "security" %}})).

### Model 2: VLAN-ID leg — Ether-type field

VLAN number **in frame**: VLAN-ID **lies in Ether-type field** – Ethernet header (in reality **before payload**, data field): **sending device `vlan 2` writes** → **frame VLAN 2 carries**.

- **Property:** Number **sits in frame** – **sending device can write what it wants**. **Simulator cannot forbid it, only observe**.
- **Reality:** VLAN tag in Ethernet frames, real managed Switches und Etherbridge hardware **read** it und **decide per VLAN**.

| Model | The VLAN number lies … | that corresponds to … | in the Lab you … |
|---|---|---|---|
| **Model 1 — internal VLAN field** | in the device/link fields | the **Firewall rule per connection** | Lab part 1.2 |
| **Model 2 — VLAN-ID leg (Ether-type field)** | in the Etherfield of the frame | the real **VLAN tag in the payload** | Lab part 1.3 |

**What stays constant across both models:** VLAN **is number belonging to group**. It **labels**. **Protects nothing** – border effect **network devices bring**, never number.

## DNS und DHCP: resolution order

**between typing name, first packet lies resolution order.** Every step **has its role**:

1. **name → address (DNS lookup):** Names like `lms.muster-city.bmb` → **number**: DNS lookup, **in table**.
2. **device → address in network (DHCP):** DHCP **assigns address** in network. **It names nothing** – **finds no name, gives address**.

**Distinguish: IP never typed in, found via name (DNS) or assigned in network (DHCP)**.

| What | What exactly happens | What it is **not** |
|---|---|---|
| **DNS** | name → number (`dig`, `/etc/resolv.conf`) | doesn't know the device, **doesn't assign an address** |
| **DHCP** | device → address in the network (**one network device**, **not** DNS) | **names nothing** |

### Worked example: resolution order

| # | Who | What | What realizes it |
|---|---|---|---|
| 1 | Schüler | types a **name** | — |
| 2 | DNS lookup | name → number | **DNS** (name → number) |
| 3 | Address in the network | device → IP in the network (Schüler) | **DHCP** (**network device**) |

**DHCP-Server:** **Network device** (managed Switch, Server, VM frontend network device, see [VM-Container]({{% relref "/01-virtualization-containerization/lab" %}})) **assigns address**. **Address needs nobody.** Device **gets address**.

**DNS lookup:** DNS lookup **works only then**, **when DNS server named** (`/etc/resolv.conf`, see [VM-Container]({{% relref "/01-virtualization-containerization/lab" %}})). **networks know no names** – **frames carry numbers only**. **Name is help for humans** (see [Einheit 2]({{% relref "/02-networking-1/theory" %}})).

## VLANs on a Windows Server

**School VLANs never come about in Packet-Tracer world – but in school network** – und **Windows Server sits in middle**: network devices, **Server** und **captive portal**. **Still no server management** – follows in [Einheit 4]({{% relref "/04-server-administration" %}}).
**Evaluation edition:** Windows Server 2025 Evaluation **has 120 days time limit** – build `10.0.26100.24.07` **write down** – **in VM only** – School-Server never.

### Captive portal — network login Windows / Apple devices

**For what:** **Windows or Apple device** on network shall reach **login site** – **family typing no address first**. Device **asks network**: **login site for network** – **network device answers**.

**What it does:** **Redirect to login site.** **No security boundary** – captive portal **no lock on network** und **no login**: **Login on login site** (see [Security und Data Protection]({{% relref "security" %}})).
**Where visible:** Windows: `ipconfig /all` – **who assigned address** – und `Get-NetworkManager` – **login site for network**. Apple devices: network **signals login site directly**.

| On | How |
|---|---|
| Windows | on first network use the device **probes** the network → **redirect to the login site** |
| Apple devices | the network **signals** the login site, the device **shows it** |

**Name login site:** **found via name** – **DNS lookup**, never typed in. **Address device:** **assigned in network** – **DHCP** (see next section).

### Name/DNS und DHCP distribution

A Windows Server **in middle** can **do two things** for network: **answers name questions** – **name/DNS** (name → number) – und **can be DHCP server** – **DHCP distribution** – for device groups **per VLAN**.

| It can | It does **not** |
|---|---|
| **assign** an address in the network (DHCP distribution) | doesn't name anything — **that is DNS** |
| **answer name questions** (name/DNS) | doesn't assign an address |
| **host the login site** (captive portal, see above) | is **no Firewall** und **no VLAN border** — see below |
**Checks:** `nslookup lms.muster-city.bmb` – **name lookup visible** – und `ipconfig /all` – **address assigned by DHCP**, chosen by nobody.

## VLANs end

**VLANs end where VLAN numbers end** – **never where rights end.** VLANs **numbers in payload**: **Managed Switch can decide per VLAN** whether frame passes. **No Firewall rule** (**per connection**) **und no authorization** (see [Security und Data Protection]({{% relref "security" %}}) und [VLAN- und Permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})). **Network device can implement VLANs** – **VLAN number can be key for rule. VLAN never is rule.**

**Why matters for class:** Herein **see VLANs** und **first Server** – **managed never**. [Einheit 4]({{% relref "/04-server-administration" %}}) **manages Server**, und **VLAN numbers at school stay same numbers**.
