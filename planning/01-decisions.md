# Decisions (grilling session, 2026-10-02)

Status: agreed with the author. Change a decision here first, then adapt the work.

## Course
- **Title:** DE "Schulrelevante Infrastruktur" / EN "School-related IT Infrastructure"
- **Author:** Gerald Landl (only author, no institution named). Licence CC BY-SA 4.0.
- **Audience:** Lehramt Informatik und digitale Grundbildung, Linz (Austria). Basic networking knowledge, no assumed Linux knowledge.
- **Wording:** write "Lehrenden-Teams" for the people running school IT, not "Lehrende im Nebenamt".
- **Tone:** technical and practical, with a school-context lens (admin perspective, communication with staff, parents, school board).
- **Jurisdiction:** Austria, GDPR as EU base, short notes where Germany/Switzerland differ. Ministry is called **BMB** (Bundesministerium für Bildung), not BMBWF.

## Schedule (6 sessions, 08:45-13:00)
**Time budget (corrected 2026-10-03):** 08:45-13:00 is 4 h 15 min on the clock, but the plannable teaching time is only **about 4 hours at most** because breaks are needed. Plan with two 15-minute breaks, so **about 3 h 45 min net**. Every session timetable must add up to 255 minutes including the breaks, with the breaks listed explicitly. Do not plan "4 h 15 min of content". Optional exercises are not scheduled, they are done at home or in the next session.

| # | Date | Chapter |
|---|------|---------|
| 1 | 05.10.2026 | Virtualisierung & Containerisierung |
| 2 | 19.10.2026 | Netzwerktechnik I (planning, wired and WLAN) |
| 3 | 16.11.2026 | Netzwerktechnik II (VLANs, permission concepts per user group, analysis tools) |
| 4 | 23.11.2026 | Server-Administration (Windows/Linux, cloud and hybrid) |
| 5 | 07.12.2026 | Client- & Mobile Device Management |
| 6 | 14.12.2026 | IT-Sicherheit & Datenschutz, documentation, wrap-up, capstone |

Each earlier chapter ends with a short "Security and data protection" box.

## Languages
- Fully parallel DE and EN, Hugo multilingual, same structure and file names.
- German is the master. Workflow: Claude drafts DE, author reviews, then Claude produces EN, author reviews.
- English technical terms stay in the German text, and a DE<->EN glossary exists.
- Credit note: the English version is machine-translated and reviewed by the author.

## Chapter pattern (enforced by archetypes)
Self-check pages were dropped on 2026-10-03 (no content planned).
1. Learning goals (mapped to the competency list)
2. Theory, in several short pages
3. Guided lab with expected results (chapter 6: capstone case study instead)
4. Free exercise or school scenario
5. Documentation task (becomes a portfolio entry)
6. "Security and data protection" box
7. Further reading and sources ("Quellen", primary sources only)

Homework pages are marked "Homework - graded" and link the portfolio template folder.

## Portfolio and assessment
- Private repo per student in one GitHub organisation, created from a template via **classroom50.org** (tool not yet checked, see tasks).
- Main basis of the course grade. Submitted by a deadline after 14.12.
- Rubric (published in the book): technical correctness, completeness, documentation quality, school-context reflection (data protection and security).
- Required: one documentation task per session plus the homework. Other tasks are optional practice.
- **Homework:** sessions 1-5 only, one task each, about 2 h (max 3 h), school scenario built on the lab. Due the day before the next session and discussed there. Session 6 has no homework. Submitted by pull request, with written feedback in the PR.

## Documentation techniques (competency 6)
A separate reference chapter `00-documentation` (shown first in the menu) with one page per technique. It is a continuous script in session order, each page with the same sections (goal, basics, step by step, template, example, common mistakes, use in the course). The session chapters contain no technique content: their "documentation task" page only links to the matching page and states what to document in that session.
1. Markdown, Mermaid diagrams, Git and PR workflow, folder and screenshot conventions (needed in session 1)
2. Network diagrams and IP plans
3. VLAN and permission matrices
4. Runbooks
5. Change logs for device policies
6. DSGVO processing register (Verzeichnis von Verarbeitungstätigkeiten) and ADRs

## Labs and hardware
- Laptop-first, free tools: VirtualBox/Hyper-V, WSL2, Docker, Ubuntu Server, Windows Server evaluation ISO, Packet Tracer or GNS3, Intune/M365 trial tenant plus an open-source MDM for comparison.
- Every lab states minimum hardware and has a fallback (Apple Silicon, 8 GB RAM, Windows Home).
- Server hardware (Proxmox/Hyper-V) is coming. Homework stays independent of it. From chapter 2 it can host shared scenarios (a pool per student or group, campus-only at first). The Proxmox bare-metal install is a lecturer demo. Earliest ready date: **open**.
- Chapter 1 is fully laptop-based and light on RAM. No Windows VMs before chapter 4.
- Poll in session 1: student hardware (OS, RAM, disk).

## Content policy
- Primary sources only (official docs, RIS, datenschutzbehörde.at, BMB).
- Pin versions and show a "tested on" date for every lab.
- Anything not run by Claude is marked "ungeprüft" until the author tests it.
- Legal chapter: "keine Rechtsberatung" note, cite legal texts directly.

## Tech assumptions
- Hugo + Relearn theme (submodule). Mermaid for diagrams (explained in `00-documentation/markdown-git`), built-in search, print/PDF export.
- GitHub Actions deploys to GitHub Pages. `baseURL` points to the GitHub Pages site of the author's account.
- Public book repo, private portfolio repos in the Classroom organisation.
