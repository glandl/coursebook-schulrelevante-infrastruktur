+++
title = "Hausaufgabe (benotet)"
weight = 70
+++

{{% callout style="warning" title="Hausaufgabe (benotet)" %}}
Abgabe per Pull Request im privaten Portfolio-Repository bis **18.10.2026** (Tag vor der nächsten Einheit).
Umfang: ca. 2 Stunden, maximal 3 Stunden. Die Hausaufgabe wird in Einheit 2 besprochen.
{{% /callout %}}

## Szenario

Das *Gymnasium Musterstadt* (800 Schüler, 70 Lehrende) betreibt bisher nur einen Dateiserver. Die Schulleitung möchte zwei neue Dienste einführen:

1. ein **Wiki für das Kollegium** (interne Absprachen, Vertretungsregelungen, Anleitungen),
2. einen **Ticket-Dienst**, über den Lehrende Störungen (Beamer, WLAN, Drucker) melden. Hier fallen auch Namen und Räume an.

Die IT wird von **zwei Lehrenden im Nebenamt** betreut. Es gibt einen kleinen Server (8 Kerne, 32 GB RAM, 1 TB SSD) und keinen Cloud-Vertrag. Die Schulleitung fragt dich nach einer Empfehlung.

## Aufgabe

Baue auf deinem Lab aus der Einheit auf und erstelle eine **Empfehlung mit Nachweis**:

### Teil A: Praktischer Nachweis (ca. 1 h)

Starte **einen der beiden Dienste** (oder einen gleichwertigen, mit Begründung) als Docker-Compose-Projekt in deiner Lab-VM, z. B.:

- Wiki: [Wiki.js](https://hub.docker.com/r/requarks/wiki) oder [BookStack](https://hub.docker.com/r/linuxserver/bookstack),
- Tickets: z. B. [Zammad](https://docs.zammad.org) (ressourcenintensiv, bei wenig RAM ein leichteres Open-Source-Ticketsystem wählen und die Wahl begründen).

Anforderungen:

- Compose-Datei mit **fixierter Image-Version**, Volumes für alle persistenten Daten, Passwörter in `.env` (nicht im Repository, stattdessen `.env.example`),
- Dienst im Browser erreichbar (Screenshot ohne Passwörter),
- **Backup- und Restore-Test** wie im Lab dokumentiert,
- `docker stats`-Ausgabe: Wie viel RAM und CPU braucht der Dienst im Leerlauf?

### Teil B: ADR (ca. 1 h)

Schreibe einen **ADR** (Vorlage siehe [Verarbeitungsverzeichnis und ADRs]({{% relref "/00-documentation/processing-register-adr" %}})) zur Entscheidung **„Wie betreiben wir die beiden Dienste?“** mit mindestens diesen Optionen:

1. je Dienst eine eigene **VM**,
2. beide Dienste als **Container in einer gemeinsamen VM**,
3. **Cloud-Dienst** eines Anbieters.

Der ADR enthält Kontext, Optionen mit Vor- und Nachteilen, Entscheidung, Folgen und eine Aussage zum **Datenschutz** (welche personenbezogenen Daten fallen an, wo liegen sie, wer hat Zugriff?).

### Teil C: Kurzreflexion (ca. 30 min)

Beantworte in 100–150 Wörtern: *Was muss die Schule organisatorisch regeln (Zuständigkeit, Vertretung, Updates, Backups), damit die Lösung auch in zwei Jahren noch sicher läuft?*

## Abgabe im Portfolio

Ordner: `01-virtualization-containerization/` im Portfolio-Repository.

```text
01-virtualization-containerization/
├── homework.md            # Szenario, Nachweis (Teil A), Reflexion (Teil C)
├── adr-001-betrieb-wiki-ticket.md
├── homework/
│   ├── compose.yaml
│   ├── .env.example       # Variablennamen ohne echte Werte
│   └── ...
└── assets/
```

Branch `hausaufgabe-01`, Pull Request auf `main`. Das Feedback erhältst du als Kommentar im PR. Bewertung nach der [Rubrik]({{% relref "/rubric" %}}):

| Kriterium | Worauf geachtet wird |
|---|---|
| Technische Korrektheit | Compose-Projekt läuft, Version fixiert, Volumes, Restore getestet |
| Vollständigkeit | Teile A bis C vorhanden, Screenshots, `docker stats` |
| Dokumentationsqualität | Markdown sauber, Commit-Nachrichten, ADR nach Vorlage |
| Reflexion im Schulkontext | Datenschutz, Betrieb und Verantwortung nachvollziehbar begründet |

{{% callout style="info" title="Hinweis zur Zusammenarbeit" %}}
Austausch über Probleme ist erwünscht. Abgegeben wird **individuell**. Verwendest du KI-Werkzeuge, kennzeichne das und prüfe Befehle selbst. Erkläre in der Besprechung jede Zeile deiner Compose-Datei.
{{% /callout %}}
