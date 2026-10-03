+++
title = "Homework (graded)"
weight = 70
+++

{{% callout style="warning" title="Homework (graded)" %}}
Submission via pull request in the private portfolio repository by **18.10.2026** (the day before the next session).
Effort: approx. 2 hours, 3 hours at most. The homework is discussed in session 2.
{{% /callout %}}

## Scenario

The *Musterstadt Secondary School* (800 students, 70 teachers) has so far run only a file server. The school management wants to introduce two new services:

1. a **wiki for the staff** (internal agreements, substitution rules, guides),
2. a **ticket service** through which teachers report faults (projector, WLAN, printer). Names and rooms are also recorded here.

IT is looked after by a **teacher team** (two people). There is a small server (8 cores, 32 GB RAM, 1 TB SSD) and no cloud contract. The school management asks you for a recommendation.

## Task

Build on your lab from the session and create a **recommendation with evidence**:

### Part A: Practical evidence (approx. 1 h)

Start **one of the two services** (or an equivalent one, with justification) as a Docker Compose project in your lab VM, e.g.:

- Wiki: [Wiki.js](https://hub.docker.com/r/requarks/wiki) or [BookStack](https://hub.docker.com/r/linuxserver/bookstack),
- Tickets: e.g. [Zammad](https://docs.zammad.org) (resource-intensive; with little RAM choose a lighter open-source ticket system and justify the choice).

Requirements:

- Compose file with a **pinned image version**, volumes for all persistent data, passwords in `.env` (not in the repository, provide `.env.example` instead),
- service reachable in the browser (screenshot without passwords),
- **backup and restore test** as documented in the lab,
- `docker stats` output: How much RAM and CPU does the service use when idle?

### Part B: ADR (approx. 1 h)

Write an **ADR** (template see [Processing register and ADRs]({{% relref "/00-documentation/processing-register-adr" %}})) on the decision **"How do we operate the two services?"** with at least these options:

1. a separate **VM** per service,
2. both services as **containers in a shared VM**,
3. **cloud service** of a provider.

The ADR contains context, options with advantages and disadvantages, decision, consequences and a statement on **data protection** (which personal data is generated, where is it stored, who has access?).

### Part C: Short reflection (approx. 30 min)

Answer in 100–150 words: *What must the school regulate organisationally (responsibility, cover, updates, backups) so that the solution is still safe to run in two years?*

## Submission in the portfolio

Folder: `01-virtualization-containerization/` in the portfolio repository.

```text
01-virtualization-containerization/
├── homework.md            # Scenario, evidence (part A), reflection (part C)
├── adr-001-operation-wiki-ticket.md
├── homework/
│   ├── compose.yaml
│   ├── .env.example       # Variable names without real values
│   └── ...
└── assets/
```

Branch `homework-01`, pull request to `main`. You receive the feedback as a comment in the PR. Assessment according to the [rubric]({{% relref "/rubric" %}}):

| Criterion | What is looked at |
|---|---|
| Technical correctness | Compose project runs, version pinned, volumes, restore tested |
| Completeness | Parts A to C present, screenshots, `docker stats` |
| Documentation quality | Clean Markdown, commit messages, ADR following the template |
| School-context reflection | Data protection, operation and responsibility reasoned comprehensibly |

{{% callout style="info" title="Note on collaboration" %}}
Exchanging ideas about problems is welcome. Submission is **individual**. If you use AI tools, label this and check commands yourself. In the discussion, explain every line of your Compose file.
{{% /callout %}}
