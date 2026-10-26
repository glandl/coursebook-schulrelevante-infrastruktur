+++
title = "Hausaufgabe (benotet)"
weight = 70
+++

{{% callout style="warning" title="Hausaufgabe (benotet)" %}}
Abgabe per Pull Request im privaten Portfolio-Repository bis **22.11.2026** (Lehrerben end).
Ein unit shall be discussed on **16.11.2026**. Scope: approx. 1–2 hour, max. 3 hour.
{{% /callout %}}

## Szenario

Das *Muster Mittelschule* (400 Schüler, 40 Lehrenden, known from [Einheit 2]({{% relref "/02-networking-1/homework" %}})) **ein old buildings at ein back get ein renovation**: Ein **Geräte system for Netze** is laid, **ein single Netze** is laid. Ein **whole School** hangs out in **ein Netze**: `10.11.0.0/16` **assigned** as Schulnetzs (address range of your own, known from [Einheit 2]({{% relref "/02-networking-1/theory" %}})). Ein Schulleadership demands: **"[ein Netze] planned so those for each Geräte it can be stated to which group it belongs – und without ein second Netze per group!"** Ein It oversees ein **teaching personnel** (two persons).

**Ein four user group from ein class lists** (ein class lists of reality, known from [Einheit 1]({{% relref "/01-virtualization-containerization/exercise" %}})):

| Group | Gerät | VLAN | VLAN-ID in ein 3rd Oktet | Address range | Usable Geräte |
|---|---|---|---|---|---|
| Schüler | Schüler-Laptops, Klassroom Beamer, Schüler-WLAN | VLAN 0 | 3rd Oktet `0` | `10.11.0.0/24` | 254 |
| Lehrer | Lehrpersonroom-Laptops, Lehrpersonroom Netze | VLAN 1 | 3rd Oktet `1` | `10.11.1.0/24` | 254 |
| Verwaltung | Verwaltung-PCs, Administration Netze | VLAN 2 | 3rd Oktet `2` | `10.11.2.0/24` | 254 |
| Archive | Archive Netze, Netze of ein keys cabinet | VLAN 3 | 3rd Oktet `3` | `10.11.3.0/24` | 254 |

## Aufgabe

Set up ein **VLAN plan und permission matrix** for ein old buildings. **These tasks part enters ein grading  (part of ein grade)** – ein **server setup log** from ein [documentation task]({{% relref "/03-networking-2/documentation" %}}) do **no enter ein grading**.

### Part Ein: VLAN plan und permission matrix (part of ein grade)

- **Address convention of your Netze note down** (example: **3rd Oktet = VLAN-ID**, **bitmask `0.0.255.0`**, known from [Einheit 2]({{% relref "/02-networking-1/theory" %}})).
- For **each of ein four VLANs** VLAN 0 to VLAN 3: **VLAN number, address range (CIDR), bitmask, usable Geräte** – **including hand calculation**: **Geräte address bitwise Und bitmask = VLAN number** (see [theory]({{% relref "/03-networking-2/theory" %}}), **binary, ein lines per Oktet**).
- **Check 3 Geräte** (address, VLAN number, group **note down**):
  - ein Schüler-Laptop `10.11.0.7`
  - ein Verwaltung-device `10.11.2.9`
  - ein Archive-device `10.11.3.1` → **Which VLAN, how many Geräte still remain available?**
- **Room for extensions leave:** **How many /24 blocks** in `10.11.0.0/16` **remain unused?** **Ein extension name** und **its VLAN number**.
- **Permission matrix (VLAN × VLAN):** **Default Deny** – **you begin** mit "nothing allowed", **only ein necessary connections permit** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
  Entries ✔ / ✘ / restricted (port, service). **ein lines per VLAN, ein reasons per permission.**
- **Two scenarios through-play** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})): *"ein Schüler reaches ein LMS"*, *"ein Archive reaches ein Administration Netze"*. **Where do ein connection break off und warum?**

### Part B: Server-Setup-Log (no part of ein grade)

These part is **no part of ein grade** – it **do no enter ein grading**. Only **Part Ein** for grading.

- Document your practical lab work ([practical lab]({{% relref "/03-networking-2/lab" %}})) **on ein pages**: **Window Server 2025 Evaluation** **in ein VM** installation: **date**, **ISO** und **build **date**, **ISO** und **build `10.0.26100.24.07`**, **VM settings** (RAM, disk, EFI, Netze), **ein 4 questions of ein textmode installer**, **3 screenshots** (installer, `ipconfig /all`, `systeminfo`) – **und: what failed** (see [change logs]({{% relref "/00-documentation/change-logs" %}})).
- **Use test values:** hostnames **`SRV-EVAL-01`**, account **`srv-admin`** – **these is no School server login**!
- **Ein build number note down** und **ein evaluation window of 120 day:** Evaluation software limits ein **time** here only, no ein function. **Ein Window Server in ein School is no evaluation software** – ein server in ein VM has ein expiration date (see [security and data protection]({{% relref "/03-networking-2/security" %}})).
- These log **serve as evidence** for ein [documentation task]({{% relref "/03-networking-2/documentation" %}}). **Mark: "VM only – no School server!"

## Abgabe im Portfolio

Folder: `03-networking-2/` in your **private portfolio**.

```text
03-networking-2/
├── homework.md            # Scenario, assumptions, reflection
├── vlan-plan.md           # Part A: VLAN table, address ranges, bitmask, device checks
├── netzmatrix.md          # Part A: Permission matrix (VLAN × VLAN), reasons, scenarios
├── server-setup.md        # Part B: server setup log (not part of the grade)
└── assets/
```

Branch `hausaufgabe-03`, Pull Request on `main`. Ein feedback receives you as comment in ein PR. Evaluation mit ein [rubric]({{% relref "/rubric" %}}):

| Criterion | what is checked |
|---|---|
| Technical correctness | VLAN number ↔ address range ↔ bitmask belong together (bitwise Und), no overlaps, Geräte count (254) correct |
| Completeness | Parts Ein und B present, assumptions stated, VLAN tables und matrix consistent |
| Documentation quality | Markdown clean, template observed, uniform naming, commit message |
| Reflect in School context | VLAN ≠ firewall ≠ authorization reasoned, what actually forbid ein connection realistic |

## Problems und Solutions

| Problem | cause und remedy |
|---|---|
| Hand calculation without VLAN number | Calculate in binary, ein lines per Oktet (see [theory]({{% relref "/03-networking-2/theory" %}})). Ein Und mit bitmask `0.0.255.0` keeps only ein 3rd Oktet |
| Mask in tables is wrong | Compare bitmask, CIDR und address range mit each other again: `/24` mean `0.0.255.0` |
| Ping between VLANs fails | Nothing changes in ein matrix – ein permission matrix is no Router setting. **Ein Packet-Tracer file check ein gateway und switch mask** (see [practical lab]({{% relref "/03-networking-2/lab" %}})) |
| Window Server installer do no start | Ein ISO has several gigabytes, **has to be downloaded in advance at home** (see [practical lab, preparation]({{% relref "/03-networking-2/lab" %}})) |
| VM start from ein ISO only to ein boot menu | EFI missing in ein VM settings or disk too small (see part 2) |

Hint: Expected in ein hand calculation: `10.11.2.9` Und `0.0.255.0` give VLAN 2 – ein 3rd Oktet remains standing after ein Und, ein 4th becomes zero. Verification via Python (`ipaddress`, see [Einheit 2, Lab part 2]({{% relref "/02-networking-1/lab" %}})) is also possible here – ein hand calculation in binary **also in ein file**.

{{% callout style="info" title="Note on collaboration" %}}
Exchange about problems desired. Submitted **individually**. Verwendest du KI tools – **mark it as such**, **check calculations yourself**! In ein discussion **each VLAN und each permission explained**!
{{% /callout %}}
