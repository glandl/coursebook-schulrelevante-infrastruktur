# Tasks and roadmap

Legend: [ ] open, [x] done. See `01-decisions.md` for the reasoning.

## Open questions for the author
- [x] GitHub account or organisation name for the book (`baseURL` set to glandl.github.io)
- [ ] Earliest session in which the Proxmox/Hyper-V server is ready
- [ ] Student hardware (poll in session 1)
- [ ] Portfolio submission deadline after 14.12
- [ ] Which free exercise and homework scenarios per chapter (Claude proposes, author decides)

## Phase 1: Skeleton (next, before 05.10)
- [x] `hugo.toml`: title, languages de (default) and en, `baseURL` placeholder, Relearn settings (Mermaid, search, print)
- [x] Content tree `content/de` and `content/en` with six chapter folders, same structure
- [x] Archetype for chapters and for pages (learning goals, theory, lab, exercise, documentation task, security box, sources)
- [x] Homepage, "About" (author credit, licence, machine-translation note), rubric page, glossary DE<->EN
- [x] GitHub Actions workflow publishing to the `gh-pages` branch (untested until first push)
- [ ] README with local build instructions
- [x] Separate `00-documentation` reference chapter with six technique pages, linked from the sessions
- [x] Self-check pages and archetype removed (2026-10-03)
- [x] Replace placeholder `baseURL`
- [ ] Check glossary and rubric weighting

## Phase 2: Chapter 1 in German (due 05.10)
Status: all pages drafted (2026-10-03), lab untested. Details in `progress.md`.
Outline: why virtualisation in schools, hypervisor types and VM vs. container, lab 1 (Linux VM, snapshots, clones), container basics, lab 2 (Docker Compose with Moodle or Nextcloud), VM vs. container decision guide, content of `00-documentation/markdown-git` (Markdown/Git/PR), which is needed in session 1, homework (about 2 h), security box.
- [x] Draft of chapter 1 and of all six `00-documentation` pages (DE), Mermaid section in `markdown-git`
- [ ] Verify commands (lab end to end), set "getestet am"; until then flagged "ungeprüft"
- [ ] Author review

## Phase 3: Portfolio template (before the first graded submission)
- [ ] Check what classroom50.org needs (template visibility, layout, naming)
- [ ] Template repo with one folder per chapter and a task README each, plus an `assets/` folder
- [ ] Link from the book's documentation and homework pages

## Phase 4: English chapter 1, then chapters 2-6
One chapter per about two weeks, each ready a few days before its session. Each chapter: German draft, author review, English version, author review.
- [x] Ch. 1 English draft of chapter 1 and `00-documentation` (author review open)
- [ ] Ch. 2 Netzwerktechnik I (19.10)
- [ ] Ch. 3 Netzwerktechnik II (09.11)
- [ ] Ch. 4 Server-Administration (23.11)
- [ ] Ch. 5 Client- & MDM (07.12)
- [ ] Ch. 6 IT-Sicherheit & Datenschutz plus capstone (14.12)

## Rules for every chapter (learned from chapter 1)
- [ ] Session timetable in the chapter `_index.md` sums to 255 min (08:45-13:00) including two 15-min breaks, net about 3 h 45 min
- [ ] Check lab durations against the timetable before writing the lab (chapter 1: lab parts 0-3 = 135 min)
- [ ] Keep DE and EN in sync after every change (same files, same numbers, e.g. IP plan prefixes)

## Later
- [ ] Competency list in the book, mapped to the learning goals
- [ ] Link check for all `sources.md` pages
- [ ] Final portfolio rubric and grading procedure
- [ ] Legal review of the DSGVO/Jugendschutz chapter
