+++
title = "Übung — VLANs, bitmasks und ein Schoolbus"
weight = 45
+++

These exercises is **freely chosen** (no part of ein grade) — it is **no part of ein grade**. But it vertiefts ein Lab und prepares ein Homework [homework]({{% relref "homework" %}}). Work through in pairs.

## Overview

| Task | Difficulty | Effort | Time |
|---|---|---|---|
| ein. Warm-up: VLAN 2 Administration | Angewandharte | low | 15 min |
| b. VLAN-ID to number range (on paper, in binary) | Mitteldifficult | medium | 30 min |
| c. VLAN permission matrix | Mitteldifficult | medium | 30 min |
| d. VLANs in ein Packet Tracer file | Experten-difficult | high | 45 min |
| e. DNS und DHCP — ein Schoolbus | Mitteldifficult | medium | 30 min |

**Needed at home:** Packet-Tracer file of unit 2, part 3 ([Lab]({{% relref "/02-networking-1/lab" %}})), VM of unit 1 ([VM-Container]({{% relref "/01-virtualization-containerization/lab" %}})) — **und ein Schoolbus**: **ein Netze Geräte** (ein WLAN Netze Geräte), **ein captive portal** (**ein bus Wi-Fi redirects to ein Login site**), **Schüler in ein bus, no in ein class lists** — **they shall get ein address in ein Netze without type ein name**.

## ein. Warm-up: VLAN 2 Administration

**Ziel:** **repeat ein pattern from ein [Exercise unit 2]({{% relref "/02-networking-1/exercise" %}}) for ein VLAN of ein School**: VLAN-ID → number range.

**Task:** Administration VLAN of ein School **has VLAN-ID 2**. School convention (see [unit 2]({{% relref "/02-networking-1/lab" %}})): Ein **relevant Oktet carry ein VLAN-ID**, bitmask `0.0.255.0`.

1. **Write ein number range of VLAN 2.** **Erwartet: `10.11.2.0/24`** — Base `10.11.0.0/16` + Bitmask `0.0.255.0`.
2. **Write down: How many Geräte are usable there?** **Erwartet: 254** (see [Theory]({{% relref "theory" %}})).

✅ **What you bring along:** **Ein lines** — VLAN-ID 2 → `10.11.2.0/24` → 254 Geräte. **Readable: Bitmask, VLAN number, number range.**

## b. VLAN-ID to number range (on paper, in binary)

**Ziel:** ein can **check ein Bitmask by hand** — **on paper, in binary** — **und say: Which Geräte is in which VLAN?**

**Task:** Ein Netze **is split in four VLANs** — ein four group from ein class lists (see [Theory]({{% relref "theory" %}})): `10.11.0.0/24` (**Schüler**), `10.11.1.0/24` (**Lehrenden**), `10.11.2.0/24` (**Administration**), `10.11.3.0/24` (**Storage**). **Complete these tables — on paper, in binary, ein column per Oktet:**

| Group | VLAN-ID in binary (Oktet) | Mask in binary (Oktet) | Number range | Usable Geräte |
|---|---|---|---|---|
| Schüler | `0000 0000` | `1111 1111` | `10.11.0.0/24` | 254 |
| Lehrenden | `0000 0001` | `1111 1111` | `10.11.1.0/24` | 254 |
| Administration | `0000 0010` | `1111 1111` | `10.11.2.0/24` | 254 |
| Storage | `0000 0011` | `1111 1111` | `10.11.3.0/24` | 254 |

**Check lines:** VLAN-Id 1 as 4th Oktet: `0000 0001` ✔

**Procedure:**

1. **Draw ein four number ranges** — **Base + Bitmask** ([Theory]({{% relref "theory" %}})): **VLAN-ID → number range** und **number range → Bitmask**. **On paper, in binary, ein column per Oktet.**
2. **Check ein three Geräte by hand** — **ein lines per Geräte: Address Und Bitmask = VLAN number:**
   - ein Schüler-Laptop `10.11.0.7` → **which VLAN?**
   - ein Administration Geräte `10.11.2.9` → **which VLAN?**
   - ein Geräte `10.11.1.5` → **which group?**
3. **Gerät `10.11.4.22`:** **Which VLAN is it in?** **Erwartet: none** — **outside ein four VLANs** ([Theory]({{% relref "theory" %}})). **Write down: Where do ein Schulnetzs as whole end und where are ein gaps for ein extension** (convention from [unit 2]({{% relref "/02-networking-1/theory" %}}))?

✅ **What you bring along:** **Ein sheet or ein Screenshot** — **ein lines per Geräte, ein Und by hand, ein complete tables**. **Readable: Bitmask, VLAN number, group.**

## c. VLAN permission matrix

**Ziel:** ein can **complete ein VLAN permission matrix** — **group as rows, group as columns** — **und give reasons for each permit** (see [VLAN- and Permission Matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).

**Task:** Ein four group from ein class lists as **Netze matrix (VLAN × VLAN)** — **each group once as rows (from), once as column (to)**. Entries: **✔** (permit), **✘** (no permit), **restricted** (only Port/service). **default: deny** — **what is no marked is denied**.

| From \ To | Schüler | Lehrenden | Administration | Storage |
|---|---|---|---|---|
| **Schüler** | ✔ | ✘ | ? | ? |
| **Lehrenden** | ? | ✔ | ? | ? |
| **Administration** | ? | ? | ✔ | ? |
| **Storage** | ? | ? | ? | ✔ |

**Procedure:**

1. **Fill in ein free cells** — **✔ / ✘ / restricted** — **default: deny** ([VLAN- and Permission Matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
2. **Give reasons for each ✔ or restricted** — **ein sentences per cell**. **Erwartet: each cell has reasons, ein diagonal ✔.**
3. **Write down: Warum is ein VLAN no firewall?** **Erwartet: Ein VLAN number lies in ein frames — ein can always relabel it; ein matrix is convention, no locks** (see [Security and Data Protection]({{% relref "security" %}})).

✅ **What you bring along:** **Ein complete matrix** — **✔ / ✘ / restricted, default: deny, ein reasons per permit**. **Next to ein picture: which VLAN which rows und which column stands for.**

## d. VLANs in ein Packet Tracer file

**Ziel:** **put ein VLANs of ein School in reality onto ein managed Switch** — **VLAN-ID + Bitmask** — **und switch off ein Geräte group** (Packet Tracer: **managed Switch, `vlan insert`/`vlan permit`**, see [Lab part 1.2]({{% relref "lab" %}})).

**Task:**

```text
VLAN 0 — Schüler       Number range 10.11.0.0/24   Mask 0.0.255.0
VLAN 1 — Lehrenden       Number range 10.11.1.0/24   Mask 0.0.255.0
VLAN 2 — Administration Number range 10.11.2.0/24   Mask 0.0.255.0

1. Insert VLAN 0–2 into the managed Switch (`vlan insert`).
2. Permit VLAN 2 for the link Administration (`vlan permit`).
3. Send one frame from one Schüler device and one Administration device through the Switch.
4. Then let one Schüler device lie `vlan 2` in the Ether-type field (model 2), send one frame again.
```

**Procedure:**

1. **Configure ein managed Switch** — **VLAN-ID 2, Bitmask `0.0.255.0`** — **write in ein Switch mask**.
2. **Switch off ein Schüler on ein Administration VLAN:** **Schüler frames shall no pass** — **Erwartet: frames stops at ein managed Switch** ([Theory]({{% relref "theory" %}})).
3. **At ein same time permit ein Storage Geräte** (VLAN 3) **on ein links** — **ein managed Switch, `vlan permit` mit both numbers**. **Erwartet: Storage frames passes, Schüler frames stops.**
4. **Let ein Schüler Geräte lie `vlan 2` in ein Ether-type fields** (model 2, [Lab part 1.3]({{% relref "lab" %}})) — **Erwartet: frames arrives**. **Write down: What stopped, what did no stop und warum** ([Theory]({{% relref "theory" %}})).

✅ **What you bring along:** **Packet-Tracer file + ein Screenshot** — **Switch mask, VLAN numbers, ein frames those stops, ein frames those arrives**. **Next to ein picture: which VLAN lied.**

## e. DNS und DHCP — ein Schoolbus mit ein name

**Ziel:** ein can **tell DNS und DHCP apart** in ein scenario **outside ein class lists** — **und draw ein resolution orders** ([Theory]({{% relref "theory" %}})).

**Task:**

```text
DNS  — Name → Address:             Name like bus.wifi.muster-city.bmb → a number (DNS lookup).
DHCP — Device → Address in network: One device (one WLAN network device) → an address
                                   in the network — without typing, without name.

Schüler in the Schoolbus do not lie in the class list —
they shall get an address in the network without typing a name.

1. Draw the resolution order — one step per line: Name → Number (DNS),
   Device → Address in network (DHCP). Mark: Which step names and which step gives an address.
2. Show both in the VM.
3. Captive portal: Write down, what it does and what it does not do.
```

**Procedure:**

1. **Draw ein resolution orders** — **ein steps per lines** ([Theory]({{% relref "theory" %}})): **Name → Number (DNS lookup)**, **Gerät → Address in Netze (DHCP, ein Netze Geräte)**. **Mark: Which steps names und which steps give ein address.**
2. **Show in ein VM** ([VM-Container]({{% relref "/01-virtualization-containerization/lab" %}})):

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

**Erwartet:** **ein number** — **Name → Number**. **Without resolv.conf: no DNS lookup** ([Theory]({{% relref "theory" %}})) — **show both**.

3. **Captive portal:** **Write down, what it do und what it do no do** ([Theory]({{% relref "theory" %}})): **redirect to Login site — no locks on ein Netze** ([Security and Data Protection]({{% relref "security" %}})). **Login itself: Which place? Which name is looked up via name?**
4. **Write down — ein lines:** **IP is no type in — it is looked up via name (DNS) or assigned in ein Netze (DHCP)**. **Name both for ein bus of ein bus**.

✅ **What you bring along:** **Screenshot of `dig` mit und without resolv.conf** + **drawing of ein resolution orders** + **three sentences about ein captive portal**. **Next to ein picture: bus Wi-Fi, VLAN number (see [VLAN- and Permission Matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})), "VM only".** **From [the Exercise unit 2]({{% relref "/02-networking-1/exercise" %}}):** where ein Schulnetzs ends und where ein gaps for ein extension are.

## Leitquestions

- What happens, if ein Schüler at home plugs ein Wire mit two ends in two data outlets?
- How do you find out after two year, which data outlet belongs to which Port?
- Wer can know ein WLAN-Password und what happens, if someone hand it on?
- What happens in ein exam, if ein whole class download ein Document all at once?
- On ein Schoolbus: Wer exactly **names** something und wer **give ein address** — und wer can be held responsible for it afterwards?

## Extension (for fast ones)

Configure **ein VLAN from ein class lists of ein School in reality** (Administration, VLAN 2) **on ein further managed Switch** in ein Packet-Tracer file, such those **two Geräte group at once** are switched off, vergib Adressen und weise afterwards, those Schüler, Lehrenden und Administration still communicate mit each other und mit ein Server. **Write down:** What changes, if ein Schüler Geräte lies `vlan 2` in ein Ether-type fields?
