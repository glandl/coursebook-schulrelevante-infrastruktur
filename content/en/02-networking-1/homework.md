+++
title = "Homework (graded)"
weight = 70
+++

{{% callout style="warning" title="Homework (graded)" %}}
Submission via pull request in the private portfolio repository by **08.11.2026**.
Effort: approx. 2 hours, 3 hours at most. The homework is discussed in session 3.
{{% /callout %}}

## Scenario

The *Musterstadt Secondary School* (800 students, 70 teachers, known from session 1) is getting an **extension** with three floors:

- **Ground floor:** library, assembly hall, 2 computer labs (30 fixed PCs each)
- **1st floor:** 9 classrooms
- **2nd floor:** 9 classrooms, 1 staff room

The old building (administration, servers, internet connection) is 40 m away and can be reached through an empty conduit. So far there is one router with a single flat network `192.168.0.0/24` and a WLAN with one shared password for everyone. The school management demands: **reliable WLAN in every classroom, separate networks for administration, teachers, students and guests, and a network that will still be sufficient in five years.** IT is looked after by a teacher team (two people).

## Task

Create an **IP plan for the extension** (including the connection to the old building).

### Part A: IP plan

- Choose a **private address range** (RFC 1918) and justify it.
- Plan **at least three networks** (e.g. administration, teachers, student WLAN, guest WLAN, computer labs, servers, network management), each with **VLAN number, address with prefix, gateway, DHCP range** and **30 % reserve**. Estimate the number of devices from the information given and state your assumptions.
- Define an **addressing convention** and a **naming scheme** for devices.
- Result: network overview and address table (at least five fixed devices) following the [template]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}).

### Part B: Short reflection (approx. 15 min)

Answer in 100–150 words: *Which assumption in your concept is the riskiest, and how would you check it before implementation?*

## Submission in the portfolio

Folder: `02-networking-1/` in the portfolio repository.

```text
02-networking-1/
├── homework.md            # Scenario, assumptions, reflection (part B)
├── ip-plan.md             # Part A: network overview, address table, convention
└── assets/
```

Branch `homework-02`, pull request to `main`. You receive the feedback as a comment in the PR. Assessment according to the [rubric]({{% relref "/rubric" %}}):

| Criterion | What is looked at |
|---|---|
| Technical correctness | Subnets are correct (network address, gateway inside the network, no overlaps), prefixes fit the number of devices including 30 % reserve |
| Completeness | Parts A and B present, assumptions stated, network overview and address table consistent |
| Documentation quality | Clean Markdown, template followed, consistent names, commit messages |
| School-context reflection | Risky assumption justified, check before implementation realistic (operated by a small teacher team) |

{{% callout style="info" title="Note on collaboration" %}}
Exchanging ideas about problems is welcome. Submission is **individual**. If you use AI tools, label this and check calculations yourself. In the discussion, explain every address and every prefix in your IP plan.
{{% /callout %}}
