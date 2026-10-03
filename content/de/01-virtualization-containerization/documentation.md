+++
title = "Dokumentationsaufgabe"
weight = 50
+++

{{% callout style="info" title="Technik" %}}
Lies zuerst im Dokumentationsskript: [Markdown, Git und Pull-Request-Workflow]({{% relref "/00-documentation/markdown-git" %}})
{{% /callout %}}

## Aufgabe in dieser Einheit

Dokumentiere dein Lab als **Portfolio-Eintrag** (Pflichtabgabe, bewertet nach der [Rubrik]({{% relref "/rubric" %}})). Das ist **nicht** die Hausaufgabe, sondern der Nachweis deiner Laborarbeit.

**Ablage:** `01-virtualization-containerization/README.md` mit Bildern in `assets/`, Branch `einheit-01`, Abgabe per Pull Request.

### Inhalt

1. **Umgebung:** Host-Betriebssystem, RAM, VirtualBox-/UTM-Version, Ubuntu-Version, Docker-Version.
2. **Durchführung** mit allen wichtigen Schritten (Befehle als Codeblöcke, nicht als Screenshot):
   - VM angelegt (Einstellungen),
   - Snapshot erstellt und wiederhergestellt,
   - Docker installiert,
   - Nextcloud (oder nginx) mit Compose gestartet,
   - Backup und Restore durchgeführt.
3. **Ergebnis:** Mindestens **vier Screenshots** nach den [Konventionen]({{% relref "/00-documentation/markdown-git" %}}): VM-Einstellungen, Snapshot-Liste, `docker compose ps`, Weboberfläche. Keine Passwörter, keine echten Namen.
4. **Probleme und Lösungen:** Mindestens ein aufgetretenes Problem mit Ursache und Lösung (auch wenn es klein war).
5. **Reflexion (Schulkontext), ca. 150–200 Wörter:** Würdest du diese Lösung an einer Schule einsetzen? Was wäre der größte Stolperstein (Betreuung, Datenschutz, Backups)?
6. **Quellen:** Verwendete Anleitungen und Dokumentationen.

### Abgabe

- Pull Request auf `main` mit der PR-Vorlage aus dem Dokumentationsskript.
- Frist: gemeinsam mit der Hausaufgabe am **18.10.2026** (Tag vor Einheit 2). _Endgültige Frist für das Portfolio wird in der Einheit bestätigt._

### Kontrollliste

- [ ] README folgt der Vorlage (Ziel, Durchführung, Ergebnis, Probleme, Reflexion, Quellen).
- [ ] Befehle sind kopierbar (Codeblöcke).
- [ ] Screenshots in `assets/`, sinnvoll benannt, mit Alternativtext.
- [ ] Keine Passwörter, `.env`-Dateien oder personenbezogenen Daten.
- [ ] Mindestens drei sinnvolle Commits mit aussagekräftigen Nachrichten.
- [ ] Pull Request geöffnet, Reviewer eingetragen.
