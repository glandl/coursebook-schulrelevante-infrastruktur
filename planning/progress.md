# Progress

Stand: 2026-10-03 (updated after self-check removal and Mermaid section). Companion to `01-decisions.md` and `02-tasks.md`.

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
| 02 Networking I | Skeleton | Skeleton |
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
| Lab | Draft, untested | Marked "ungeprüft"; Nextcloud tag `31-apache` to be checked; Apple Silicon/UTM path untested |
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

## Open before the 05.10.2026 session

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

## Known issues

- None known for the Hugo build (`hugo --minify` runs without errors or warnings, 2026-10-03). Mermaid rendering in the browser has not been checked visually.
- English version exists only for `00-documentation` and chapter 01 (draft, not reviewed). Chapters 02-06 are still skeleton.
- The Markdown Guide cheat sheet link is in the EN `sources.md` of chapter 01 but not yet in the DE one.

## Next steps

1. Author review of DE content, apply corrections.
2. Author review of the EN draft of `00-documentation` and chapter 01 (done translating 2026-10-03).
3. Start chapter 02 (Networking I, session 19.10.2026) following the plan in `02-tasks.md`.
4. Update this file whenever a page changes status.
