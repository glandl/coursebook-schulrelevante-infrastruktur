+++
title = "Theorie"
weight = 20
+++

## Ziel

explainst you now **warum one splits the Schulnet into VLANs**, how the VLAN number **into an address lands**, und how DNS and DHCP render the network **usable**, that nobody **an IP types**.

## Why VLANs exist — the problem with one network

In [Einheit 2]({{% relref "/02-networking-1/theory" %}}) baust du **a Schulnet out of a few Networks** (Administration, Lehrende, Server, WLANs) — **separated by address area**. VLANs solve the **other half**: **one network can serve the whole School**, but **not without one says who is where**. Three short scenarios make **the need** clear:

1. **one network serves too many.** The whole School sits in **one single Network** `10.11.0.0/16`: 400 Schuler devices, 40 Lehrenden, Administration und Storage. In one Network sit **all** **next to each other**: **one network event** (one flood, one fire alarm, one bad device) **reaches** everything. One can **not switch off one group** without the other, und one **from a frame not can say** to which group it belongs.
2. **groups that are not equal sit next to each other.** **Administration** (Grades, Schüler-Acts, invoices) und **Storage** (key cabinet, room bookings, supplier orders) sit **next to each other**. A Schuler device **can in principle** address the Administration network: **an address area is no lock** — the **border is only a convention** (see [Security and Data Protection]({{% relref "security" %}})).
3. **one device type, switched at once.** The Klassroom beamer und the Klassroom network devices **on Monday morning** **per wing, per floor** get **switched on** — **not** whole School. The **groups** (Schüler, Lehrenden, Administration, Storage) **must not be** one wire network each — **they shall be numbers**.

**What VLANs do:** In **one wire network** are the **groups numbers**, not wires.
**What VLANs not do:** The VLAN number **sits in the frame**, like a label — **one can at any time change it**. **A VLAN is no Firewall and no right** (see [Security and Data Protection]({{% relref "security" %}})).

## VLAN and mask

A VLAN is **one number + one bitmask**. The **bitmask** says: **Which bits of the address are relevant for the VLAN** — the rest read you as 0.

**"AND" rule:** **Device address** bitwise **and** bitmask → **the result is the VLAN number**. The bit columns **with mask bit 1 stay**, the columns **with mask bit 0 to zero set**.

### Worked example: VLAN-ID → number range

Konvention of the School (same as in [Einheit 2]({{% relref "/02-networking-1/lab" %}})): **dritter Oktet = VLAN-ID**, the **fourth Oktet** stays **free for the devices**. One VLAN-ID **as 4th Oktet** → **number range**:

| Step | What | Result |
|---|---|---|
| 1. Base address | whole School network | `10.11.0.0/16` |
| 2. Bitmask | third Oktet = VLAN-relevant | `0.0.255.0` |
| 3. VLAN-ID in the masked Oktet | VLAN-ID 2 → third Oktet **2** | `10.11.**2**.0` |
| 4. Number range | base + bitmask | **`10.11.2.0/24`** |
| 5. Usable devices | `2⁸ − 2` | **254** |

**Check by hand** (binary, only the third Oktet matters):

```text
Device  Administration-PC      10.11.2.17
bitmask                          0.0.255.0   third Oktet: 0000 0010 AND 1111 1111
10.11.2.17 AND 0.0.255.0     →  10.11.2.0   → VLAN-ID 2 → Administration-VLAN ✔
```

**Read:** The VLAN-ID **is** the masked Oktet — **the number range comes from the bitmask**, not from a wire.

## The class list of the School in reality

Four groups — **from the class list** (the class list in reality, same as in Unit 1, [VM-Container]({{% relref "/01-virtualization-containerization/exercise" %}})). **Four VLANs with number ranges:**

| Group | What | VLAN | VLAN-ID as 4th Oktet | Number range | Usable devices |
|---|---|---|---|---|---|
| Schüler | Schüler-Laptops, Klass projectors, Schüler-WLAN | VLAN 0 | third Oktet `0` | `10.11.0.0/24` | 254 |
| Lehrenden | Lehrerroom-Laptops, Lehrerroom network | VLAN 1 | third Oktet `1` | `10.11.1.0/24` | 254 |
| Administration | Administration PCs, Administration network | VLAN 2 | third Oktet `2` | `10.11.2.0/24` | 254 |
| Storage | Storage network, key cabinet network | VLAN 3 | third Oktet `3` | `10.11.3.0/24` | 254 |

**Why four VLANs and not four networks?** In the whole School **one wire network** serves **all four groups** (one Router, one managed Switch system, one Uplink) — **the groups are numbers**. That is **where** VLANs land: **one network serves the School, the number ranges come about** because **one network serves the whole School** (see "the problem with one network"). The whole `10.11.0.0/16` leaves **252 further /24-Blocks** for Extensions — **with Lücken for Extensions** (the convention from [Einheit 2]({{% relref "/02-networking-1/theory" %}})).

**Attention — the VLAN number is not the IP Prefix!** VLAN-ID ≠ IP Prefix: VLANs are **numbers in the payload**, IP Prefixes are **address areas** (see [Einheit 2]({{% relref "/02-networking-1/theory" %}})). **VLANs are no Firewall** — Firewall works **per connection** (see [Security and Data Protection]({{% relref "security" %}})). The **permission matrices** (see [VLAN- and Permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})) you fill out **on the VLANs** — not on the networks.

## VLANs in Packet Tracer: both models

**from a screenshot you can't tell them apart — that is the point.** Packet Tracer offers **two different things**, both go by the name "VLAN". **Neither** is **the real Etherfield** — **model 2 comes closer**.

### Model 1: the internal VLAN field

In the Simulation carries **every device and every link** an **internal VLAN field** (the "VLAN-Insert" of the Simulator): The device **itself** carries `VLAN = 2`. When a frame crosses a **managed Switch** or a **Router**, the Simulator checks whether the VLAN number **is allowed on the link**.

- **Property:** The VLAN number is **part of the device**, **not of the frame**. The device **can't lie about itself**.
- **Reality:** Ethernet frames **carry** a VLAN tag, the device **is not labeled**. **Model 1** models **the decision per connection** — **that is Firewall** (see [Security and Data Protection]({{% relref "security" %}})).

### Model 2: VLAN-ID leg — Ether-type field

The VLAN number is **part of the frame**: In the **Ether-type field** of the Ethernet header (in reality **before the payload** in the data field) **the VLAN-ID lies**: you write `vlan 2` into the **Ether-type field** of the sending device → **the frame carries VLAN 2**.

- **Property:** The number **sits in the frame** — **the sending device** can write **whatever it likes**. The Simulator **can't forbid it**, it **can only observe it**.
- **Reality:** VLAN tag in Ethernet frames, real managed Switches und Etherbridge hardware **read** it und **decide per VLAN**.

| Model | The VLAN number lies … | that corresponds to … | in the Lab you … |
|---|---|---|---|
| **Model 1 — internal VLAN field** | in the device/link fields | the **Firewall rule per connection** | Lab part 1.2 |
| **Model 2 — VLAN-ID leg (Ether-type field)** | in the Etherfield of the frame | the real **VLAN tag in the payload** | Lab part 1.3 |

**What stays constant across both models:** A VLAN **is a number that belongs to a group**. It **labels**. **It protects nothing** — the border effect comes **from the network devices**, not from the number.

## DNS and DHCP: resolution order

**between you typing a name and the first packet lies a resolution order.** Every step does **one thing**:

1. **the name → an address (DNS lookup):** A name like `lms.muster-city.bmb` → **a number**: DNS lookup, **in a table**.
2. **the device → an address in the network (DHCP):** DHCP **assigns an address** in the network. **It names nothing** — it **does not find a name, it gives an address**.

**One distinguishes: The IP is not typed in, but found via name (DNS) or assigned in the network (DHCP).**

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

**DHCP-Server:** **The network device** (one managed Switch, one Server, in the VM the network device of the VM frontend, see [VM-Container]({{% relref "/01-virtualization-containerization/lab" %}})) **assigns the address**. **One does not need to know the address.** The device **gets one**.

**DNS forwarding:** DNS lookup **works only then**, **when a DNS server is named** (`/etc/resolv.conf`, see [VM-Container]({{% relref "/01-virtualization-containerization/lab" %}})). **networks know no names** — **frames carry numbers only**. The **name is a help for the humans** (see [Einheit 2]({{% relref "/02-networking-1/theory" %}})).

## VLANs on a Windows Server

**The VLANs of a School not come about in the Packet-Tracer world, but in the network of the School** — und **Windows Server sits in the middle**: network devices, **the Server** und the **captive portal**. **This is still no server management** — that follows in [Einheit 4]({{% relref "/04-server-administration" %}}).

### Captive portal — network login of Windows and Apple devices

**For what:** A **Windows or Apple device** on the network shall reach **a login site** — **without** the family first **types an address**. The device **asks the network**: "Which login site has this network?" — **the network device answers**.

**What that does:** **The redirect to the login site.** **That is not a security boundary** — the captive portal is **no lock on the network** und **no login**: **The login happens on a login site** (see [Security and Data Protection]({{% relref "security" %}})).

| On | How |
|---|---|
| Windows | on first network use the device **probes** the network → **redirect to the login site** |
| Apple devices | the network **signals** the login site, the device **shows it** |

**The name of the login site:** **found via name** — **DNS lookup**, not typed in. **The address of the device:** **assigned in the network** — **DHCP** (see next section).

### Name/DNS and DHCP distribution

One Windows Server **in the middle** can **do two things** for the network: It **answers name questions** — **name/DNS** (name → number) — und it **can be the DHCP server** — **the DHCP distribution** — for the device groups **of one VLAN**.

| It can | It does **not** |
|---|---|
| **assign** an address in the network (DHCP distribution) | doesn't name anything — **that is DNS** |
| **answer name questions** (name/DNS) | doesn't assign an address |
| **host the login site** (captive portal, see above) | is **no Firewall** und **no VLAN border** — see below |

### Where VLANs end

**VLANs end where the VLAN numbers end** — **that is not where the rights end.** VLANs are **numbers in the payload**: **A managed Switch can decide per VLAN** whether a frame passes. **That is not a Firewall rule** (that is **per connection**) **und no authorization** (see [Security and Data Protection]({{% relref "security" %}}) und [VLAN- and Permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})). **A network device can implement VLANs** — **a VLAN number can be the key of a rule. A VLAN never is the rule.**

**Why this matters for the class:** In this Unit you **see the VLANs** und **the first Server** — **you don't manage it**. [Einheit 4]({{% relref "/04-server-administration" %}}) **manages the Server**, und **the VLAN numbers of the School stay the same numbers**.
