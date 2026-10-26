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
| 3 | 16.11.2026 | Netzwerktechnik II: VLANs, DNS, DHCP + Windows Server install (last 45-60 min) |
| 4 | 23.11.2026 | Windows Server Administration (Linux as comparison surface, no second install) |
| 5 | 07.12.2026 | Client- & Mobile Device Management: Design and Policy (trial tenant live in class) |
| 6 | 14.12.2026 | IT-Security & Datenschutz: Capstone-Session (ADRs introduced here) |

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

## Structural rework (agreed 2026-10-26)

Session order and dates stay fixed (16.11. / 23.11. / 07.12. / 14.12.); only the content of chapters 3-6 moves. Folder names and Hugo weights do not change, only the `title` front matter. Reason: the IT-Security / capstone session must stay last, because it builds on everything before it.

- **Chapter 3 (16.11.)** is titled “Network Technology II: VLANs, DNS, DHCP” and is the network session **plus the first server contact**. It opens with ~30 min recap/network first aid (ping, traceroute, DNS lookup, reading an IP plan), because weaker students arrived late and did not work through sessions 1-2 fully. Core: VLAN segmentation and permission matrices (why VLANs exist: one network, several user groups — students, teachers, administration, storage; number ranges); DNS and DHCP — how a device finds the network without typing an IP (Debian VM: `dig`, `/etc/resolv.conf`, DNS forwarding, DHCP relay); then how a school network is really realized on a **Windows Server** (captive portal, name/DNS + DHCP distribution). The standalone “analysis tools” block is cut; Wireshark/tcpdump does not get its own chapter section. **Last 45-60 min: install Windows Server 2025 Evaluation in a VM** in text mode, then first commands `ipconfig /all`, `systeminfo`, `nslookup`, `Get-NetworkManager`. The Server Console rule (“the console is the tool, no clicking through settings”) is stated here; the “do not do that” box for Server Explorer/GUI first appears here.
- **Chapter 3 doc task:** VLAN/permission matrix **plus a one-page Server-Setup-Log** (date, ISO/build, VM settings, three screenshots, what failed), explicitly marked as *not* the graded homework. The graded homework is the VLAN/permission matrix only (~1-2 h, low stress for the weak group, due 22.11.).
- **Chapter 4 (23.11.)** is titled **Windows Server Administration**. Cloud and hybrid are cut completely from the plan; the course never leaves the local network plus the locally managed Windows Server and the Debian VM the students own. Linux is a comparison surface, **not** a second installation: three administration tasks (network inspection, process list and filter, one logged administration action) run on both operating systems, Windows done twice, in cmd **and** PowerShell, so the “there are two shells” trap is taught with a cheat-sheet. Doc task: the Runbook, opened with “your install log from 16.11. was already one; a runbook = fixed heading + revert column”.
- **Chapter 5 (07.12.)** is a **design-and-policy** CLODM session: there is no enforcement lab because no real devices are enrollable in class. Theory covers what CLODM promises, age-appropriate access, the Intune/Apple/Chrome school worlds, and what enrollment and login mean. The trial-tenant walkthrough happens live in class. The lab makes a **real, enforceable local device policy on the Windows Server VM** (NTFS ACLs: read-only for students, writable for teachers, `takeown`, `Get-Acl`, `systeminfo`, `powercfg`) — the closest teachable thing to a device policy.
- **Chapter 6 (14.12.)** teaches security **on the artefact students built**: console security/ACL lab on their own Windows Server VM, mirrored in the Debian VM (NTFS ACL vs POSIX permissions, share exposure). The capstone requires VLAN plan + runbook + device-policy change log + DSGVO processing register + **one ADR** (“why Windows Server, not Linux”). ADRs appear only in the capstone; no mini-ADR in the session 6 doc task.
- **Documentation techniques stay exactly six** in session order (no seventh “install log” page). The install log → runbook bridge lives in the session doc-task pages, not in `00-documentation`.
- **Wording change in chapter 2:** the sentence promising “VLANs, permissions and analysis tools in session 3” is updated to name VLANs, DNS and DHCP plus the Windows Server install, since analysis tools are cut.
- **Process:** `planning/01-decisions.md` first (this section), then German chapter pages 3-6; English pages stay untouched and get regenerated in the translation pass after the German was reviewed.

## Documentation techniques (competency 6)
A separate reference chapter `00-documentation` (shown first in the menu) with one page per technique. It is a continuous script in session order, each page with the same sections (goal, basics, step by step, template, example, common mistakes, use in the course). The session chapters contain no technique content: their "documentation task" page only links to the matching page and states what to document in that session.
1. Markdown, Mermaid diagrams, Git and PR workflow, folder and screenshot conventions (needed in session 1)
2. Network diagrams and IP plans
3. VLAN and permission matrices
4. Runbooks
5. Change logs for device policies
6. DSGVO processing register (Verzeichnis von Verarbeitungstätigkeiten) and ADRs

## Labs and hardware
- Laptop-first, free tools: VirtualBox, UTM, virt-manager (QEMU/KVM) or Hyper-V, Docker, Debian 13, Windows Server evaluation ISO, Cisco Packet Tracer 9.0.1 for network simulation (switched from Filius on 2026-10-18: router/switch CLI, DHCP relay, simulation mode, WLAN and VLANs, so chapter 3 can reuse the same file; cost: free NetAcad account at a US company needed, English UI), Intune/M365 trial tenant plus an open-source MDM for comparison.
- Every lab states minimum hardware and has a fallback (Apple Silicon, 8 GB RAM, Windows Home).
- **Lab VM: Debian 13 from the DVD-1 image** (installed together in the session without network mirror, so 20 laptops don't load the shared Wi-Fi; students download the ~4 GB ISO at home and enable the online apt sources after install; netinst rejected 2026-10-18. Switched from Ubuntu Server 24.04 on 2026-10-18: Ubuntu ran poorly on BYOD laptops; Debian idles at about 150 MB RAM, no snapd/cloud-init, arm64 ISO for UTM). VM name `debian-lab`. Root password empty in the installer so the user gets `sudo`. DNS is read from `/etc/resolv.conf` (no `systemd-resolved`).
- **Virtualization platform per device** (2026-10-18): VirtualBox stays the default (Windows Home, Intel Mac); virt-manager on Linux, UTM on Apple Silicon, Hyper-V Manager on Windows Pro/Education with WSL2/Hyper-V active. Labs show platform differences in Relearn tabs with `groupid="vm-platform"`, so the reader's choice applies site-wide. Raw QEMU is an optional "for the curious" box only.
- **Windows Server evaluation (introduced 2026-10-26):** Windows Server 2025 Evaluation Edition is installed at the **end of session 3 (16.11.)**, last 45-60 minutes, in a VM. x86-64 ISO is the default (VirtualBox, Hyper-V); an ARM64 ISO tab is required for UTM on Apple Silicon. UEFI + a disk of at least 9 GB from the start. The **120-day evaluation limit** is stated as a plain fact, not as a workaround task. The ISO download belongs to the preparation block (done at home before the session); a USB with the ISO and a pre-installed VM image are insurance.
- **Intune trial tenant:** created **live in class on 07.12.** as a walkthrough, not beforehand. Trial limits (user count, expiry after about 90 days) are stated as facts; a pre-created tenant plus screenshots serve as insurance if the live creation fails. The open-source MDM comparison stays optional (bookmark list), not taught.
- Server hardware (Proxmox/Hyper-V) is coming. Homework stays independent of it. From chapter 2 it can host shared scenarios (a pool per student or group, campus-only at first). The Proxmox bare-metal install is a lecturer demo. Earliest ready date: **open**.
- Chapter 1 is fully laptop-based and light on RAM. The old rule “no Windows VMs before chapter 4” is superseded by the decision above: the Windows Server VM is installed at the end of chapter 3 and owned by every student from session 4 on.
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
