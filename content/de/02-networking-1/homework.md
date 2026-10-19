+++
title = "Hausaufgabe (benotet)"
weight = 70
+++

{{% callout style="warning" title="Hausaufgabe (benotet)" %}}
Abgabe per Pull Request im privaten Portfolio-Repository bis **08.11.2026**.
Umfang: ca. 2 Stunden, maximal 3 Stunden. Die Hausaufgabe wird in Einheit 3 besprochen.
{{% /callout %}}

## Szenario

Das *Gymnasium Musterstadt* (800 Schüler, 70 Lehrende, bekannt aus Einheit 1) bekommt einen **Zubau** mit drei Geschossen:

- **Erdgeschoss:** Bibliothek, Aula, 2 EDV-Räume (je 30 feste PCs)
- **1. Obergeschoss:** 9 Klassenräume
- **2. Obergeschoss:** 9 Klassenräume, 1 Lehrerzimmer

Das Altgebäude (Verwaltung, Server, Internetanbindung) steht 40 m entfernt und ist über ein Leerrohr erreichbar. Bisher gibt es dort einen Router mit einem einzigen flachen Netz `192.168.0.0/24` und ein WLAN mit einem gemeinsamen Passwort für alle. Die Schulleitung fordert: **zuverlässiges WLAN in jedem Klassenraum, getrennte Netze für Verwaltung, Lehrende, Schüler und Gäste, und ein Netz, das in fünf Jahren noch reicht.** Die IT betreut ein Lehrenden-Team (zwei Personen).

## Aufgabe

Erstelle einen **IP-Plan für den Zubau** (inklusive Anschluss an das Altgebäude).

### Teil A: IP-Plan

- Wähle einen **privaten Gesamtbereich** (RFC 1918) und begründe ihn.
- Plane **mindestens drei Netze** (z. B. Verwaltung, Lehrende, Schüler-WLAN, Gäste-WLAN, EDV-Räume, Server, Netzwerkmanagement), jeweils mit **VLAN-Nummer, Adresse mit Präfix, Gateway, DHCP-Bereich** und **30 % Reserve**. Die Geräteanzahl schätzt du aus den Angaben und nennst deine Annahmen.
- Lege eine **Adresskonvention** und ein **Namensschema** für Geräte fest.
- Ergebnis: Netzübersicht und Adresstabelle (mindestens fünf feste Geräte) nach der [Vorlage]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}).

### Teil B: Kurzreflexion (ca. 15 min)

Beantworte in 100–150 Wörtern: *Welche Annahme in deinem Konzept ist am riskantesten, und wie würdest du sie vor der Umsetzung prüfen?*

## Abgabe im Portfolio

Ordner: `02-networking-1/` im Portfolio-Repository.

```text
02-networking-1/
├── homework.md            # Szenario, Annahmen, Reflexion (Teil B)
├── ip-plan.md             # Teil A: Netzübersicht, Adresstabelle, Konvention
└── assets/
```

Branch `hausaufgabe-02`, Pull Request auf `main`. Das Feedback erhältst du als Kommentar im PR. Bewertung nach der [Rubrik]({{% relref "/rubric" %}}):

| Kriterium | Worauf geachtet wird |
|---|---|
| Technische Korrektheit | Subnetze stimmen (Netzadresse, Gateway im Netz, keine Überschneidungen), Präfixe passen zur Geräteanzahl inklusive 30 % Reserve |
| Vollständigkeit | Teile A und B vorhanden, Annahmen genannt, Netzübersicht und Adresstabelle konsistent |
| Dokumentationsqualität | Markdown sauber, Vorlage eingehalten, einheitliche Namen, Commit-Nachrichten |
| Reflexion im Schulkontext | Riskante Annahme begründet, Prüfung vor der Umsetzung realistisch (Betrieb durch ein kleines Lehrenden-Team) |

{{% callout style="info" title="Hinweis zur Zusammenarbeit" %}}
Austausch über Probleme ist erwünscht. Abgegeben wird **individuell**. Verwendest du KI-Werkzeuge, kennzeichne das und prüfe Berechnungen selbst. Erkläre in der Besprechung jede Adresse und jeden Präfix deines IP-Plans.
{{% /callout %}}
