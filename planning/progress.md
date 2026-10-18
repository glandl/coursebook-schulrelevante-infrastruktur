# Progress

Stand: 2026-10-18 (chapter 02 switched to Packet Tracer 9.0.1, homework revised by the author, EN homework translated; lab VM switched to Debian 13 with platform tabs for VirtualBox, virt-manager, UTM and Hyper-V). Companion to `01-decisions.md` and `02-tasks.md`.

Legend for status:
- **Skeleton**: files exist, content is "folgt"
- **Draft**: content written by Claude, not yet reviewed by the author
- **Reviewed**: author has reviewed
- **Tested**: lab commands run and verified ("getestet am" set)
- **Done**: reviewed and tested (where applicable)

## Overview

| Part | DE | EN |
|---|---|---|
| Site skeleton, config, archetypes, `baseURL` | done | done |
| About, rubric, glossary | skeleton (rubric weighting open) | skeleton |
| 00 Documentation: intro | Draft | Draft (machine-translated) |
| 00 Documentation: Markdown, Mermaid, Git/PR | Draft | Draft (machine-translated) |
| 00 Documentation: Network diagrams, IP plans | Draft | Draft (machine-translated) |
| 00 Documentation: VLAN, permission matrices | Draft | Draft (machine-translated) |
| 00 Documentation: Runbooks | Draft | Draft (machine-translated) |
| 00 Documentation: Change logs | Draft | Draft (machine-translated) |
| 00 Documentation: Processing register, ADR | Draft (legal review open) | Draft (machine-translated) |
| 01 Virtualization & Containerization | Draft | Draft (machine-translated) |
| 02 Networking I | Draft (lab untested) | Skeleton, homework translated (draft) |
| 03 Networking II | Skeleton | Skeleton |
| 04 Server administration | Skeleton | Skeleton |
| 05 Client & mobile device management | Skeleton | Skeleton |
| 06 IT security & data protection (capstone) | Skeleton | Skeleton |

## Chapter 01 pages (DE)

| Page | Status | Notes |
|---|---|---|
| Intro (`_index`) | Draft | Timetable fits 08:45-13:00 with two breaks (lab parts 0-3 = 135 min, to verify in practice) |
| Learning goals | Draft | Mapping to competency list is a placeholder |
| Theory | Draft | One page; plan says "several short pages", split if too long |
| Lab | Draft, untested | Marked "ungeprüft". Since 2026-10-18: Debian 13 VM `debian-lab` from the DVD-1 image, installed offline in class without network mirror, then a copy-paste block enables the online apt sources, Part 1 in tabs for VirtualBox, virt-manager, UTM and Hyper-V (create, SSH, snapshot, clone), optional raw-QEMU box. Nextcloud compose has `NEXTCLOUD_TRUSTED_DOMAINS` for access via VM IP. Untested: Debian installer steps, all non-VirtualBox menus, UTM without snapshots (clone as substitute), Hyper-V Secure Boot template, Nextcloud tag `31-apache` |
| Exercise | Draft | Optional, not graded |
| Documentation task | Draft | Deadline set to 18.10.2026 together with homework, to confirm |
| Homework | Draft | Wiki or ticket service as Compose project, ADR, reflection |
| Security box | Draft | "keine Rechtsberatung" note included |
| Sources | Draft | Links not checked |

## Scope decisions

- Self-check pages removed (all chapters, DE and EN).
- Wording: "Lehrenden-Teams" instead of "Lehrende im Nebenamt".
- README still has no local build instructions.

- Time budget: 255 min on the clock, about 3 h 45 min net with two breaks (see `01-decisions.md`). An earlier timetable summed to 270 min and was corrected.

## Chapter 02 pages (DE)

Drafted 2026-10-05, lab Part 3 rewritten for Cisco Packet Tracer on 2026-10-18.

| Page | Status | Notes |
|---|---|---|
| Intro (`_index`) | Draft | Timetable sums to 255 min (lab parts 1-3 = 120 min, Part 0 is done at home before the session) |
| Learning goals | Draft | Goal 7: network in Packet Tracer incl. router CLI. Mapping to competency list is a placeholder |
| Theory | Draft | Layers, IPv4 and subnetting, cabling, WLAN |
| Lab | Draft, untested | Part 0: NetAcad account and Packet Tracer **9.0.1**. Part 1: network tools in `ubuntu-lab`. Part 2: subnetting with Python, IP plan for Mittelschule Musterstadt (verified with Python). Part 3: 2911 router via CLI, three 2960 switches, `srv-01` with HTTP, DNS and DHCP, DHCP relay via `ip helper-address`, Simulation mode, fault finding, optional WLAN step 3.8. Saved as `schulnetz.pkt`, reused in chapter 03 |
| Exercise | Draft | Optional; extension builds a second floor in Packet Tracer |
| Documentation task | Draft | Packet Tracer screenshots, `show running-config` and `show ip route` as text, `schulnetz.pkt` in `assets/` |
| Homework | Reviewed (author edit 2026-10-18) | Network concept for the extension of Gymnasium Musterstadt: IP plan (at least three networks, no Python check), diagrams and cabling, WLAN concept, reflection. Only Part D has a time estimate |
| Security box | Draft | |
| Sources | Draft | Filius removed, NetAcad link added. Links not checked |

Lab Part 1 uses the Debian VM; expected addresses per platform are in tabs (VirtualBox 10.0.2.x, libvirt 192.168.122.x, UTM 192.168.64.x, Hyper-V 172.x), DNS via `/etc/resolv.conf` and `getent`, bridge step 1.7 in tabs. All non-VirtualBox values are unverified.

Untested in Packet Tracer 9.0.1 (lab was written from knowledge of 8.x): menu names, 2911/2960 port names, the default `serverPool` next to the relayed DHCP pool, Simulation filters, WPC300N wireless module, login without internet, Apple Silicon. Also untested: VirtualBox NAT defaults (10.0.2.15/24, gateway 10.0.2.2, DNS 10.0.2.3), the DHCP lease display (`valid_lft`) with Debian's DHCP client.

History: Part 3 was planned with Packet Tracer, switched to Filius on 2026-10-05 (no account needed) and back to Packet Tracer on 2026-10-18 (router CLI, DHCP relay, WLAN, VLANs for chapter 03).

## Chapter 02 pages (EN)

| Page | Status | Notes |
|---|---|---|
| Homework | Draft (translated 2026-10-18) | Mirrors the DE version; file and branch names translated (`network-plan.md`, `wlan-concept.md`, `homework-02`) as in chapter 01 |
| All other pages | Skeleton | |

## Open from chapter 01

Carried over from before the 05.10.2026 session; not re-checked since.

- [ ] Author review of `00-documentation` (DE) and chapter 01 (DE)
- [ ] Run the lab end to end (VM, Docker, Compose, backup and restore), then set "getestet am"
- [ ] Check current Nextcloud and MariaDB image tags and Docker install steps
- [ ] Check all links in `sources.md`
- [ ] Add link to the portfolio repository (needs classroom50.org check, see `02-tasks.md` Phase 3)
- [ ] Confirm the portfolio deadline
- [ ] Add the competency list and map the learning goals to it
- [ ] Prepare the hardware poll for the session
- [ ] Decide how the rubric weighting works
- [ ] Add the Markdown Guide cheat sheet link to chapter 01 `sources.md` (optional)
- [ ] README with local build instructions

## Open for chapter 02

- [ ] Run lab Part 3 in Packet Tracer 9.0.1, fix menu names, set "getestet am"
- [ ] Run lab Part 1 in `debian-lab` on each platform and confirm the expected addresses
- [ ] Homework due 08.11.2026 is not "the day before the next session" (session 3 is 16.11.2026): keep or move
- [ ] Author review of the DE pages
- [ ] EN version of the remaining pages

## Open for the Debian/platform switch (2026-10-18)

- [ ] Install Debian 13 once per platform (VirtualBox, virt-manager, UTM, Hyper-V) and check menu names, snapshot/clone steps, default interface names
- [ ] Check what the installer writes to `/etc/apt/sources.list` without network mirror (cdrom line only, or also security lines?) and whether the copy-paste block in Lab 1.2 gives a clean `apt update`
- [ ] Check that an `arm64` DVD-1 ISO is published for Debian 13 (otherwise Apple Silicon needs netinst)
- [ ] Check whether Debian 13 standard install includes `python3`, `iputils-tracepath`, and which services `ss -tuln` shows
- [ ] Check the QEMU command in the "für Neugierige" box
- [ ] Chapter 01 already took place (05.10.2026) with Ubuntu: students' existing VMs are `ubuntu-lab`; decide whether they reinstall or keep Ubuntu for chapter 02. The ch02 lab has a fallback row for an Ubuntu VM (`resolvectl status` instead of `/etc/resolv.conf`, Netplan instead of `/etc/network/interfaces`)

## Known issues

- None known for the Hugo build (`hugo --minify` runs without errors or warnings, 2026-10-18). Mermaid rendering in the browser has not been checked visually.
- English version exists only for `00-documentation`, chapter 01 and the chapter 02 homework (draft, not reviewed). The rest of chapters 02-06 is still skeleton.
- The Markdown Guide cheat sheet link is in the EN `sources.md` of chapter 01 but not yet in the DE one.

## Next steps

1. Before the 19.10.2026 session: tell students to create the NetAcad account and install Packet Tracer 9.0.1 (preparation checklist), run lab Part 3 once in 9.0.1 and fix menu names.
2. Author review of the chapter 02 DE pages, then EN translation of the remaining chapter 02 pages.
3. Decide the chapter 02 homework deadline (see open items).
4. Start chapter 03 (Networking II, session 16.11.2026), building on `schulnetz.pkt` for VLANs.
5. Update this file whenever a page changes status.
