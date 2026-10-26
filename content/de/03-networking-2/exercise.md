+++
title = "Übung — VLANs, bitmasks and a Schoolbus"
weight = 45
+++

This exercise is **freely chosen** (not part of the grade) — it is **not part of the grade**. But it vertiefts the Lab and prepares the Homework [homework]({{% relref "homework" %}}). Work through in pairs.

## Overview

| Task | Difficulty | Effort | Time |
|---|---|---|---|
| a. Warm-up: VLAN 2 Administration | Angewandharte | low | 15 min |
| b. VLAN-ID to number range (on paper, in binary) | Mitteldifficult | medium | 30 min |
| c. VLAN permission matrix | Mitteldifficult | medium | 30 min |
| d. VLANs in the Packet Tracer file | Experten-difficult | high | 45 min |
| e. DNS and DHCP — the Schoolbus | Mitteldifficult | medium | 30 min |

**Needed at home:** Packet-Tracer file of unit 2, part 3 ([Lab]({{% relref "/02-networking-1/lab" %}})), VM of unit 1 ([VM-Container]({{% relref "/01-virtualization-containerization/lab" %}})) — **and one Schoolbus**: **one network device** (one WLAN network device), **one captive portal** (**the bus Wi-Fi redirects to a login site**), **Scholars in the bus, not in the class list** — **they shall get an address in the network without typing a name**.

## a. Warm-up: VLAN 2 Administration

**Ziel:** **repeat the pattern from the [Exercise unit 2]({{% relref "/02-networking-1/exercise" %}}) for one VLAN of the School**: VLAN-ID → number range.

**Task:** Administration VLAN of the School **has VLAN-ID 2**. School convention (see [unit 2]({{% relref "/02-networking-1/lab" %}})): The **relevant Oktet carries the VLAN-ID**, bitmask `0.0.255.0`.

1. **Write the number range of VLAN 2.** **Erwartet: `10.11.2.0/24`** — Base `10.11.0.0/16` + Bitmask `0.0.255.0`.
2. **Write down: How many devices are usable there?** **Erwartet: 254** (see [Theory]({{% relref "theory" %}})).

✅ **What you bring along:** **One line** — VLAN-ID 2 → `10.11.2.0/24` → 254 devices. **Readable: Bitmask, VLAN number, number range.**

## b. VLAN-ID to number range (on paper, in binary)

**Ziel:** one can **check a Bitmask by hand** — **on paper, in binary** — **and say: Which device is in which VLAN?**

**Task:** One network **is split into four VLANs** — the four groups from the class list (see [Theory]({{% relref "theory" %}})): `10.11.0.0/24` (**Scholars**), `10.11.1.0/24` (**Teachers**), `10.11.2.0/24` (**Administration**), `10.11.3.0/24` (**Storage**). **Complete this table — on paper, in binary, one column per Oktet:**

| Group | VLAN-ID in binary (Oktet) | Mask in binary (Oktet) | Number range | Usable devices |
|---|---|---|---|---|
| Scholars | `0000 0000` | `1111 1111` | `10.11.0.0/24` | 254 |
| Teachers | `0000 0001` | `1111 1111` | `10.11.1.0/24` | 254 |
| Administration | `0000 0010` | `1111 1111` | `10.11.2.0/24` | 254 |
| Storage | `0000 0011` | `1111 1111` | `10.11.3.0/24` | 254 |

**Check line:** VLAN-Id 1 as 4th Oktet: `0000 0001` ✔

**Procedure:**

1. **Draw the four number ranges** — **Base + Bitmask** ([Theory]({{% relref "theory" %}})): **VLAN-ID → number range** and **number range → Bitmask**. **On paper, in binary, one column per Oktet.**
2. **Check the three devices by hand** — **one line per device: Address AND Bitmask = VLAN number:**
   - one Scholar-Laptop `10.11.0.7` → **which VLAN?**
   - one Administration device `10.11.2.9` → **which VLAN?**
   - one device `10.11.1.5` → **which group?**
3. **Device `10.11.4.22`:** **Which VLAN is it in?** **Erwartet: none** — **outside the four VLANs** ([Theory]({{% relref "theory" %}})). **Write down: Where does the School network as whole end and where are the gaps for an extension** (convention from [unit 2]({{% relref "/02-networking-1/theory" %}}))?

✅ **What you bring along:** **One sheet or one Screenshot** — **one line per device, the AND by hand, the complete table**. **Readable: Bitmask, VLAN number, group.**

## c. VLAN permission matrix

**Ziel:** one can **complete the VLAN permission matrix** — **groups as rows, groups as columns** — **and give reason for each permit** (see [VLAN- and Permission Matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).

**Task:** The four groups from the class list as **network matrix (VLAN × VLAN)** — **each group once as row (from), once as column (to)**. Entries: **✔** (permit), **✘** (no permit), **restricted** (only Port/service). **default: deny** — **what is not marked is denied**.

| From \ To | Scholars | Teachers | Administration | Storage |
|---|---|---|---|---|
| **Scholars** | ✔ | ✘ | ? | ? |
| **Teachers** | ? | ✔ | ? | ? |
| **Administration** | ? | ? | ✔ | ? |
| **Storage** | ? | ? | ? | ✔ |

**Procedure:**

1. **Fill in the free cells** — **✔ / ✘ / restricted** — **default: deny** ([VLAN- and Permission Matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
2. **Give reason for each ✔ or restricted** — **one sentence per cell**. **Erwartet: each cell has reason, the diagonal ✔.**
3. **Write down: Why is a VLAN no firewall?** **Erwartet: The VLAN number lies in the frame — one can always relabel it; the matrix is convention, no lock** (see [Security and Data Protection]({{% relref "security" %}})).

✅ **What you bring along:** **The complete matrix** — **✔ / ✘ / restricted, default: deny, one reason per permit**. **Next to the picture: which VLAN which row and which column stands for.**

## d. VLANs in the Packet Tracer file

**Ziel:** **put the VLANs of the School in reality onto the managed Switch** — **VLAN-ID + Bitmask** — **and switch off one device group** (Packet Tracer: **managed Switch, `vlan insert`/`vlan permit`**, see [Lab part 1.2]({{% relref "lab" %}})).

**Task:**

```text
VLAN 0 — Scholars       Number range 10.11.0.0/24   Mask 0.0.255.0
VLAN 1 — Teachers       Number range 10.11.1.0/24   Mask 0.0.255.0
VLAN 2 — Administration Number range 10.11.2.0/24   Mask 0.0.255.0

1. Insert VLAN 0–2 into the managed Switch (`vlan insert`).
2. Permit VLAN 2 for the link Administration (`vlan permit`).
3. Send one frame from one Scholar device and one Administration device through the Switch.
4. Then let one Scholar device lie `vlan 2` in the Ether-type field (model 2), send one frame again.
```

**Procedure:**

1. **Configure the managed Switch** — **VLAN-ID 2, Bitmask `0.0.255.0`** — **write in the Switch mask**.
2. **Switch off the Scholars on the Administration VLAN:** **Scholar frame shall not pass** — **Erwartet: frame stops at the managed Switch** ([Theory]({{% relref "theory" %}})).
3. **At the same time permit one Storage device** (VLAN 3) **on the link** — **one managed Switch, `vlan permit` with both numbers**. **Erwartet: Storage frame passes, Scholar frame stops.**
4. **Let one Scholar device lie `vlan 2` in the Ether-type field** (model 2, [Lab part 1.3]({{% relref "lab" %}})) — **Erwartet: frame arrives**. **Write down: What stopped, what did not stop and why** ([Theory]({{% relref "theory" %}})).

✅ **What you bring along:** **Packet-Tracer file + one Screenshot** — **Switch mask, VLAN numbers, one frame that stops, one frame that arrives**. **Next to the picture: which VLAN lied.**

## e. DNS and DHCP — the Schoolbus with a name

**Ziel:** one can **tell DNS and DHCP apart** in a scenario **outside the class list** — **and draw the resolution order** ([Theory]({{% relref "theory" %}})).

**Task:**

```text
DNS  — Name → Address:             Name like bus.wifi.muster-city.bmb → a number (DNS lookup).
DHCP — Device → Address in network: One device (one WLAN network device) → an address
                                   in the network — without typing, without name.

Scholars in the Schoolbus do not lie in the class list —
they shall get an address in the network without typing a name.

1. Draw the resolution order — one step per line: Name → Number (DNS),
   Device → Address in network (DHCP). Mark: Which step names and which step gives an address.
2. Show both in the VM.
3. Captive portal: Write down, what it does and what it does not do.
```

**Procedure:**

1. **Draw the resolution order** — **one step per line** ([Theory]({{% relref "theory" %}})): **Name → Number (DNS lookup)**, **Device → Address in network (DHCP, one network device)**. **Mark: Which step names and which step gives an address.**
2. **Show in the VM** ([VM-Container]({{% relref "/01-virtualization-containerization/lab" %}})):

```bash
scholar@debian-lab:~$ dig +short bus.wifi.muster-city.bmb
```

```text
10.11.4.1
```

```bash
scholar@debian-lab:~$ cat /etc/resolv.conf
```

```text
nameserver 10.11.4.1
```

**Erwartet:** **one number** — **Name → Number**. **Without resolv.conf: no DNS lookup** ([Theory]({{% relref "theory" %}})) — **show both**.

3. **Captive portal:** **Write down, what it does and what it does not do** ([Theory]({{% relref "theory" %}})): **redirect to login site — no lock on the network** ([Security and Data Protection]({{% relref "security" %}})). **Login itself: Which place? Which name is looked up via name?**
4. **Write down — one line:** **IP is not typed in — it is looked up via name (DNS) or assigned in the network (DHCP)**. **Name both for the bus of the bus**.

✅ **What you bring along:** **Screenshot of `dig` with and without resolv.conf** + **drawing of the resolution order** + **three sentences about the captive portal**. **Next to the picture: bus Wi-Fi, VLAN number (see [VLAN- and Permission Matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})), "VM only".** **From [the Exercise unit 2]({{% relref "/02-networking-1/exercise" %}}):** where the School network ends and where the gaps for an extension are.

## Leitquestions

- What happens, if a Scholar at home plugs a Cable with two ends into two data outlets?
- How do you find out after two years, which data outlet belongs to which Port?
- Who may know the WLAN-Password and what happens, if someone hands it on?
- What happens in the exam, if a whole class downloads one Document all at once?
- On the Schoolbus: Who exactly **names** something and who **gives an address** — and who can be held responsible for it afterwards?

## Extension (for fast ones)

Configure **one VLAN from the class list of the School in reality** (Administration, VLAN 2) **on one further managed Switch** in the Packet-Tracer file, such that **two device groups at once** are switched off, vergib Adressen and weise afterwards, that Scholars, Teachers and Administration still communicate with each other and with the Server. **Write down:** What changes, if one Scholar device lies `vlan 2` in the Ether-type field?
