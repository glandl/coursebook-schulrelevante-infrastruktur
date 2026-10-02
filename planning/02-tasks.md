# Tasks and roadmap

Legend: [ ] open, [x] done. See `01-decisions.md` for the reasoning.

## Open questions for the author
- [ ] GitHub account or organisation name for the book (sets the Pages URL and `baseURL`)
- [ ] Earliest session in which the Proxmox/Hyper-V server is ready
- [ ] Student hardware (poll in session 1)
- [ ] Portfolio submission deadline after 14.12
- [ ] Which free exercise and homework scenarios per chapter (Claude proposes, author decides)

## Phase 1: Skeleton (next, before 05.10)
- [ ] `hugo.toml`: title, languages de (default) and en, `baseURL` placeholder, Relearn settings (Mermaid, search, print)
- [ ] Content tree `content/de` and `content/en` with six chapter folders, same structure
- [ ] Archetype for chapters and for pages (learning goals, theory, lab, exercise, documentation task, self-check, security box, sources)
- [ ] Homepage, "About" (author credit, licence, machine-translation note), rubric page, glossary DE<->EN
- [ ] GitHub Actions workflow for Pages deployment
- [ ] README with local build instructions

## Phase 2: Chapter 1 in German (due 05.10)
Outline: why virtualisation in schools, hypervisor types and VM vs. container, lab 1 (Linux VM, snapshots, clones), container basics, lab 2 (Docker Compose with Moodle or Nextcloud), VM vs. container decision guide, documentation basics (Markdown/Git/PR), self-check, homework (about 2 h), security box.
- [ ] Draft, verify commands in the devcontainer where possible, flag the rest "ungeprüft"
- [ ] Author review

## Phase 3: Portfolio template (before the first graded submission)
- [ ] Check what classroom50.org needs (template visibility, layout, naming)
- [ ] Template repo with one folder per chapter and a task README each, plus an `assets/` folder
- [ ] Link from the book's documentation and homework pages

## Phase 4: English chapter 1, then chapters 2-6
One chapter per about two weeks, each ready a few days before its session. Each chapter: German draft, author review, English version, author review.
- [ ] Ch. 2 Netzwerktechnik I (19.10)
- [ ] Ch. 3 Netzwerktechnik II (09.11)
- [ ] Ch. 4 Server-Administration (23.11)
- [ ] Ch. 5 Client- & MDM (07.12)
- [ ] Ch. 6 IT-Sicherheit & Datenschutz plus capstone (14.12)

## Later
- [ ] Final portfolio rubric and grading procedure
- [ ] Legal review of the DSGVO/Jugendschutz chapter
