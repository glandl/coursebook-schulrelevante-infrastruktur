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

Erstelle ein **Netzkonzept für den Zubau** (inklusive Anschluss an das Altgebäude).

### Teil A: IP-Plan (ca. 40 min)

- Wähle einen **privaten Gesamtbereich** (RFC 1918) und begründe ihn.
- Plane **mindestens sechs Netze** (z. B. Verwaltung, Lehrende, Schüler-WLAN, Gäste-WLAN, EDV-Räume, Server, Netzwerkmanagement), jeweils mit **VLAN-Nummer, Adresse mit Präfix, Gateway, DHCP-Bereich** und **30 % Reserve**. Die Geräteanzahl schätzt du aus den Angaben und nennst deine Annahmen.
- Lege eine **Adresskonvention** und ein **Namensschema** für Geräte fest.
- Ergebnis: Netzübersicht und Adresstabelle (mindestens fünf feste Geräte) nach der [Vorlage]({{% relref "/00-documentation/network-diagrams-ip-plans" %}}).
- Rechne mindestens ein Netz mit Python (oder von Hand, mit Rechenweg) nach.

### Teil B: Diagramme und Verkabelung (ca. 40 min)

- **Logisches Netzdiagramm** (Mermaid): Internet, Firewall/Router, Core, Verteiler je Geschoss, Netze mit Adressen.
- **Verkabelungsplan eines Geschosses** (Mermaid oder Tabelle): Verteiler, Dosen je Raum, Access Points, Uplink mit Medium und Geschwindigkeit.
- **Stückliste (ohne Preise):** Anzahl Dosen, Patchfeld-Ports, Access Points, Switches (Ports, PoE-Standard, PoE-Budget), Verbindungskabel zum Altgebäude (Medium begründen).
- Trage mindestens **zwei Annahmen** und **eine Reserve** (Ports, Fasern oder Rack-Platz) ein.

### Teil C: WLAN-Konzept (ca. 30 min)

Beschreibe in höchstens einer Seite:

1. **Anzahl und Platzierung** der Access Points (mit Begründung der Kapazität).
2. **Bänder und Kanalbreite** (2,4 / 5 GHz, ggf. 6 GHz) und Sendeleistung.
3. **SSIDs** mit Zweck, Netz (VLAN) und **Sicherheitsverfahren** (PSK oder 802.1X). Begründe die Wahl **für Lehrende, Schüler und Gäste**. Was muss die Schule organisatorisch leisten, damit das Verfahren funktioniert (z. B. Benutzerverwaltung, Passwortwechsel)?
4. **Verwaltung** der Access Points (Standalone, Controller, Cloud) mit Aussage zum Datenschutz.

### Teil D: Kurzreflexion (ca. 15 min)

Beantworte in 100–150 Wörtern: *Welche Annahme in deinem Konzept ist am riskantesten, und wie würdest du sie vor der Umsetzung prüfen?*

## Abgabe im Portfolio

Ordner: `02-networking-1/` im Portfolio-Repository.

```text
02-networking-1/
├── homework.md            # Szenario, Annahmen, Reflexion (Teil D)
├── ip-plan.md             # Teil A: Netzübersicht, Adresstabelle, Konvention
├── netzplan.md            # Teil B: Diagramme, Stückliste
├── wlan-konzept.md        # Teil C
└── assets/
```

Branch `hausaufgabe-02`, Pull Request auf `main`. Das Feedback erhältst du als Kommentar im PR. Bewertung nach der [Rubrik]({{% relref "/rubric" %}}):

| Kriterium | Worauf geachtet wird |
|---|---|
| Technische Korrektheit | Subnetze stimmen (Netzadresse, Gateway im Netz, keine Überschneidungen), Kabellängen und PoE-Budget plausibel, WLAN-Planung nachvollziehbar |
| Vollständigkeit | Teile A bis D vorhanden, Annahmen genannt, Diagramme und Tabellen konsistent |
| Dokumentationsqualität | Markdown sauber, Mermaid rendert, einheitliche Namen, Commit-Nachrichten |
| Reflexion im Schulkontext | Datenschutz (WLAN-Anmeldung, Protokolle), Betrieb und Zuständigkeit begründet |

{{% callout style="info" title="Hinweis zur Zusammenarbeit" %}}
Austausch über Probleme ist erwünscht. Abgegeben wird **individuell**. Verwendest du KI-Werkzeuge, kennzeichne das und prüfe Berechnungen selbst. Erkläre in der Besprechung jede Adresse und jeden Präfix deines IP-Plans.
{{% /callout %}}
