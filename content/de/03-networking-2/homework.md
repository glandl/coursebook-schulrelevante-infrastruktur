+++
title = "Hausaufgabe (benotet)"
weight = 70
+++

{{% callout style="warning" title="Hausaufgabe (benotet)" %}}
Abgabe per Pull Request im privaten Portfolio-Repository bis **22.11.2026** (Lehrerben end).
The unit will be discussed on **16.11.2026**. Scope: approx. 1–2 hours, max. 3 hours.
{{% /callout %}}

## Szenario

Das *Muster Mittelschule* (400 pupils, 40 teachers, known from [Einheit 2]({{% relref "/02-networking-1/homework" %}})) **the old building at the back gets a renovation**: A **device system for networks** is laid, **one single network** is laid. The **whole school** hangs out in **one network**: `10.11.0.0/16` **assigned** as school network (address range of your own, known from [Einheit 2]({{% relref "/02-networking-1/theory" %}})). The Schulleadership demands: **"[the network] planned so that for each device it can be stated to which group it belongs – and without a second network per group!"** The IT oversees a **teaching team** (two persons).

**The four user groups from the class list** (the class list of reality, known from [Einheit 1]({{% relref "/01-virtualization-containerization/exercise" %}})):

| Group | Devices | VLAN | VLAN-ID in the 3rd Oktet | Address range | Usable devices |
|---|---|---|---|---|---|
| Schüler | Scholar-Laptops, Classroom Beamer, Scholar-WLAN | VLAN 0 | 3rd Oktet `0` | `10.11.0.0/24` | 254 |
| Lehrer | Teacherroom-Laptops, Teacherroom network | VLAN 1 | 3rd Oktet `1` | `10.11.1.0/24` | 254 |
| Verwaltung | Verwaltung-PCs, Administration network | VLAN 2 | 3rd Oktet `2` | `10.11.2.0/24` | 254 |
| Archive | Archive network, network of the key cabinet | VLAN 3 | 3rd Oktet `3` | `10.11.3.0/24` | 254 |

## Aufgabe

Set up the **VLAN plan and permission matrix** for the old building. **This task part enters the grading ("Graded")** – the **server setup log** from the [documentation task]({{% relref "/03-networking-2/documentation" %}}) does **not enter the grading**.

### Part A: VLAN plan and permission matrix (Graded)

- **Address convention of your network write down** (example: **3rd Oktet = VLAN-ID**, **bitmask `0.0.255.0`**, known from [Einheit 2]({{% relref "/02-networking-1/theory" %}})).
- For **each of the four VLANs** VLAN 0 to VLAN 3: **VLAN number, address range (CIDR), bitmask, usable devices** – **including hand calculation**: **device address bitwise AND bitmask = VLAN number** (see [theory]({{% relref "/03-networking-2/theory" %}}), **binary, one line per Oktet**).
- **Check 3 devices** (address, VLAN number, group **write down**):
  - one Scholar-Laptop `10.11.0.7`
  - one Verwaltung-device `10.11.2.9`
  - one Archive-device `10.11.3.1` → **Which VLAN, how many devices still remain available?**
- **Room for extensions leave:** **How many /24 blocks** in `10.11.0.0/16` **remain unused?** **One extension name** and **its VLAN number**.
- **Permission matrix (VLAN × VLAN):** **Default Deny** – **you begin** with "nothing allowed", **only the necessary connections permit** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})).
  Entries ✔ / ✘ / restricted (port, service). **one line per VLAN, one reason per permission.**
- **Two scenarios through-play** (see [VLAN- and permission matrices]({{% relref "/00-documentation/vlan-permission-matrices" %}})): *"a Scholar reaches the LMS"*, *"the Archive reaches the Administration network"*. **Where does the connection break off and why?**

### Part B: Server-Setup-Log (not graded)

This part is **not graded** – it **does not enter the grading**. Only **Part A** for grading.

- Document your practical lab work ([practical lab]({{% relref "/03-networking-2/lab" %}})) **on one page**: **Windows Server 2025 Evaluation** **in the VM** installation: **date**, **ISO** and **build **date**, **ISO** and **build `10.0.26100.24.07`**, **VM settings** (RAM, disk, EFI, network), **the 4 questions of the textmode installer**, **3 screenshots** (installer, `ipconfig /all`, `systeminfo`) – **and: what failed** (see [change logs]({{% relref "/00-documentation/change-logs" %}})).
- **Use test values:** hostname **`SRV-EVAL-01`**, account **`srv-admin`** – **this is no school server login**!
- **The build number note down** and **the evaluation window of 120 days:** Evaluation software limits the **time** here only, not the function. **A Windows Server in a school is no evaluation software** – the server in the VM has an expiration date (see [security and data protection]({{% relref "/03-networking-2/security" %}})).
- This log **serves as evidence** for the [documentation task]({{% relref "/03-networking-2/documentation" %}}). **Mark: "VM only – no school server!"

## Abgabe im Portfolio

Folder: `03-networking-2/` in your **private portfolio**.

```text
03-networking-2/
├── homework.md            # Scenario, assumptions, reflection
├── vlan-plan.md           # Part A: VLAN table, address ranges, bitmask, device checks
├── netzmatrix.md          # Part A: Permission matrix (VLAN × VLAN), reasons, scenarios
├── server-setup.md        # Part B: server setup log (not graded)
└── assets/
```

Branch `hausaufgabe-03`, Pull Request on `main`. The feedback receives you as comment in the PR. Evaluation with the [rubric]({{% relref "/rubric" %}}):

| Criterion | what is checked |
|---|---|
| Technical correctness | VLAN number ↔ address range ↔ bitmask belong together (bitwise AND), no overlaps, device count (254) correct |
| Completeness | Parts A and B present, assumptions stated, VLAN table and matrix consistent |
| Documentation quality | Markdown clean, template observed, uniform naming, commit message |
| Reflect in school context | VLAN ≠ firewall ≠ authorization reasoned, what actually forbids a connection realistic |

## Problems and Solutions

| Problem | cause and remedy |
|---|---|
| Hand calculation without VLAN number | Calculate in binary, one line per Oktet (see [theory]({{% relref "/03-networking-2/theory" %}})). The AND with bitmask `0.0.255.0` keeps only the 3rd Oktet |
| Mask in table is wrong | Compare bitmask, CIDR and address range with each other again: `/24` means `0.0.255.0` |
| Ping between VLANs fails | Nothing changes in the matrix – a permission matrix is no router setting. **The Packet-Tracer file checks the gateway and switch masks** (see [practical lab]({{% relref "/03-networking-2/lab" %}})) |
| Windows Server installer does not start | The ISO has several gigabytes, **has to be downloaded in advance at home** (see [practical lab, preparation]({{% relref "/03-networking-2/lab" %}})) |
| VM starts from the ISO only to the boot menu | EFI missing in the VM settings or disk too small (see part 2) |

Hint: Expected in the hand calculation: `10.11.2.9` AND `0.0.255.0` gives VLAN 2 – the 3rd Oktet remains standing after the AND, the 4th becomes zero. Verification via Python (`ipaddress`, see [Einheit 2, Lab part 2]({{% relref "/02-networking-1/lab" %}})) is also possible here – the hand calculation in binary **also in the file**.

{{% callout style="info" title="Note on collaboration" %}}
Exchange about problems desired. Submitted **individually**. **You use** KI tools – **mark it as such**, **check calculations yourself**! In the discussion **every VLAN and every permission explained**!
{{% /callout %}}
