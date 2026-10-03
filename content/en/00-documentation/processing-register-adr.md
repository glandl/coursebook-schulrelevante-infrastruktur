+++
title = "Processing register (GDPR) and ADRs"
weight = 60
+++

{{% callout style="warning" title="No legal advice" %}}
This page explains the documentation technique and gives an overview. It is **not legal advice**. The legal texts (GDPR, Austrian Data Protection Act) and the requirements of the school authority or school maintainer are authoritative. The concrete structure of a register at a school must be agreed with the data protection officer. The legal review of this page is still pending.
{{% /callout %}}

## Goal

You can create two kinds of "why documentation":

1. a **record of processing activities** (processing register): *Which personal data do we process, for what purpose, where and for how long?*
2. **Architecture Decision Records (ADRs):** *Why did we decide on this technical solution?*

## Basics

### Record of processing activities

Article 30 of the General Data Protection Regulation (GDPR) requires controllers to keep a written record of their processing activities. It serves the **accountability principle** (Art. 5 (2) GDPR) and must be made available to the supervisory authority on request. In Austria this is the Datenschutzbehörde ([dsb.gv.at](https://www.dsb.gv.at)).

For each processing activity the register contains, in line with Art. 30 (1):

| Item | Question |
|---|---|
| Controller | Who is responsible? (At schools often the school management or school maintainer, to be clarified depending on school type and activity) |
| Purpose | What is the data processed for? |
| Categories of data subjects | Students, teachers, parents, administrative staff … |
| Categories of personal data | Name, class, grades, photos, login data … |
| Recipients | Who receives the data (including processors, cloud services)? |
| Third-country transfers | Does data leave the EU/EEA? |
| Retention periods | How long is the data kept? |
| Technical and organisational measures (TOM) | How is the data protected (Art. 32)? |

In addition, a **legal basis** (Art. 6, where applicable Art. 9 GDPR) should be stated. This is helpful for planning, even though Art. 30 does not explicitly require it.

Note on neighbouring countries: In Germany, state data protection laws and school laws additionally regulate processing at schools; in Switzerland the (revised) Federal Act on Data Protection (FADP) and cantonal law apply. The principle of "keeping a register" stays similar, details differ.

### Architecture Decision Records (ADRs)

An ADR is a **short document about exactly one important decision**, with context, options, decision and consequences. It later answers the question "Why did we do it this way?" when those involved have long since changed. The format comes from Michael Nygard (2011) and is widespread in software development today.

Properties:

- **Immutable:** An accepted ADR is not rewritten. If the decision changes, a new ADR is created that **supersedes** the old one (status *superseded by ADR-007*).
- **Short:** one page is enough.
- **Numbered:** `ADR-001`, `ADR-002` …, files `adr-001-<title>.md`.
- **With status:** *proposed*, *accepted*, *superseded*, *rejected*.

### How they relate

An ADR such as "We run Nextcloud ourselves instead of Microsoft 365" changes the processing activities (recipients, third-country transfers, TOM). Both documents refer to each other: the register states the current situation, the ADR the reason.

## Step by step

### Processing register

1. **Collect activities:** Where is personal data processed? (student administration, grade management, learning platform, WLAN login, video surveillance, website, photos …)
2. **Create one entry per activity** with the items from the table.
3. **Clarify legal basis and purpose**, involve the data protection officer if in doubt.
4. **Record recipients and processors** (contracts/data processing agreements in place?).
5. **Describe the TOM** (access, encryption, backup, logging) and refer to the technical documentation.
6. **Set retention periods.**
7. **Review and approve**, note the date.
8. **Update regularly** (at least annually, immediately with every new service).

### ADR

1. **Narrow down the decision:** one question, e.g. "Where do we host the learning platform?"
2. **Describe the context:** requirements, constraints, people involved.
3. **Name at least two options** with advantages and disadvantages.
4. **Record the decision and reasoning.**
5. **Describe the consequences** (positive, negative, open risks, necessary follow-up tasks).
6. **Set the status**, file it, link it in the ADR index.

## Template

### Processing activity

```markdown
## PA-003 · Learning platform (Nextcloud)

- **Controller:** <School / school management>
- **Data protection officer:** <Name or office>
- **Purpose:** Providing teaching material, handing in assignments
- **Legal basis:** <Art. 6 (1) lit. … GDPR – clarify with the DPO>
- **Data subjects:** Students, teachers
- **Data categories:** Name, class, user name, submitted files, access logs
- **Recipients:** internal: teachers of the respective class; external: <hosting provider, data processing agreement dated …>
- **Third-country transfer:** no (hosting in Austria/EU)
- **Retention period:** Account until the end of the school year after leaving; submissions after <x> months
- **TOM:** Access by groups, TLS, daily backup (encrypted), monthly updates
- **Technical documentation:** Reference to runbook and network plan
- **Date / review:** <Date>, next review <Date>
```

### ADR

```markdown
# ADR-001: <Title of the decision>

- **Status:** proposed | accepted | superseded by ADR-<n> | rejected
- **Date:** <DD.MM.YYYY>
- **Decision makers/participants:** <Roles>

## Context
<Which problem, which requirements and constraints?>

## Options
1. **<Option A>** – advantages / disadvantages
2. **<Option B>** – advantages / disadvantages

## Decision
<Chosen option and reasoning>

## Consequences
- Positive: …
- Negative / risks: …
- Follow-up tasks: …
- Data protection: <Effects on the processing register>
```

## Example

```markdown
# ADR-002: The learning platform is self-hosted

- **Status:** accepted
- **Date:** 12.12.2026

## Context
The school needs a platform for teaching material and submissions. Personal
student data should stay in the EU. Operated by a teacher team (two people).

## Options
1. **Self-hosted Nextcloud (VM at the school maintainer)** – full data control, no third country;
   effort for updates and backups.
2. **Cloud service of a provider** – little operating effort; data processing and
   third-country transfer must be checked carefully, running costs.

## Decision
Option 1. Data control and data protection weigh more heavily for this data than the effort,
provided a runbook for updates and restore exists.

## Consequences
- Positive: Data stays in the hands of the school.
- Negative: Operating responsibility and bus factor 2 → runbooks, cover arrangement.
- Follow-up tasks: Runbook "Update", runbook "Restore", entry PA-003 in the register.
```

## Common mistakes

| Mistake | Better |
|---|---|
| Register created once, never maintained | Review date, annual revision, update with every new service |
| Only "student data" as a category | Concrete data categories (name, grades, photos …) |
| Processors and third countries missing | Record all recipients and providers |
| Retention periods empty ("as needed") | Concrete period or criterion |
| TOM only "adequately protected" | Describe concrete measures |
| ADR describes only the result | Record options and reasons |
| ADR rewritten afterwards | Create a new ADR, mark the old one as *superseded* |
| ADR for trivial matters | Only for significant, hard-to-reverse decisions |
| "Guessing" legal questions | Involve the data protection officer |

## Use in the course

Mainly used in: [Session 6]({{% relref "/06-it-security-data-protection" %}})

ADRs can be used as early as session 1, e.g. for the decision *VM or container* (see [Homework session 1]({{% relref "/01-virtualization-containerization/homework" %}})).

Sources: [GDPR, Art. 30 (EUR-Lex)](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679), [Austrian Data Protection Authority](https://www.dsb.gv.at), [Michael Nygard: Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
