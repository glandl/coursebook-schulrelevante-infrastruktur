+++
title = "Verarbeitungsverzeichnis (DSGVO) und ADRs"
weight = 60
+++

{{% callout style="warning" title="Keine Rechtsberatung" %}}
Diese Seite erklärt die Dokumentationstechnik und gibt einen Überblick. Sie ist **keine Rechtsberatung**. Maßgeblich sind die Rechtstexte (DSGVO, österreichisches Datenschutzgesetz) und die Vorgaben der Schulbehörde bzw. des Schulerhalters. Der konkrete Aufbau eines Verzeichnisses an einer Schule ist mit der/dem Datenschutzbeauftragten abzustimmen. Die Rechtsprüfung dieser Seite steht noch aus.
{{% /callout %}}

## Ziel

Du kannst zwei Arten von „Warum-Dokumentation“ erstellen:

1. ein **Verzeichnis von Verarbeitungstätigkeiten** (Verarbeitungsverzeichnis): *Welche personenbezogenen Daten verarbeiten wir, wofür, wo und wie lange?*
2. **Architecture Decision Records (ADRs):** *Warum haben wir uns für diese technische Lösung entschieden?*

## Grundlagen

### Verzeichnis von Verarbeitungstätigkeiten

Artikel 30 der Datenschutz-Grundverordnung (DSGVO) verlangt von Verantwortlichen ein schriftliches Verzeichnis ihrer Verarbeitungstätigkeiten. Es dient der **Rechenschaftspflicht** (Art. 5 Abs. 2 DSGVO) und ist der Aufsichtsbehörde auf Anfrage vorzulegen. In Österreich ist das die Datenschutzbehörde ([dsb.gv.at](https://www.dsb.gv.at)).

Je Verarbeitungstätigkeit enthält das Verzeichnis nach Art. 30 Abs. 1 sinngemäß:

| Angabe | Frage |
|---|---|
| Verantwortlicher | Wer ist verantwortlich? (An Schulen häufig Schulleitung bzw. Schulerhalter, je nach Schulart und Tätigkeit zu klären) |
| Zweck | Wozu werden die Daten verarbeitet? |
| Kategorien betroffener Personen | Schüler, Lehrende, Eltern, Verwaltungspersonal … |
| Kategorien personenbezogener Daten | Name, Klasse, Noten, Fotos, Anmeldedaten … |
| Empfänger | Wer bekommt die Daten (auch Auftragsverarbeiter, Cloud-Dienste)? |
| Drittlandübermittlung | Gehen Daten außerhalb der EU/des EWR? |
| Löschfristen | Wie lange werden die Daten aufbewahrt? |
| Technische und organisatorische Maßnahmen (TOM) | Wie sind die Daten geschützt (Art. 32)? |

Zusätzlich ist eine **Rechtsgrundlage** (Art. 6, ggf. Art. 9 DSGVO) zu benennen. Das ist für die Planung hilfreich, auch wenn Art. 30 sie nicht ausdrücklich verlangt.

Hinweis zu den Nachbarländern: In Deutschland regeln zusätzlich Landesdatenschutz- und Schulgesetze die Verarbeitung an Schulen, in der Schweiz gilt das (revidierte) Bundesgesetz über den Datenschutz (DSG) und kantonales Recht. Das Prinzip „Verzeichnis führen“ bleibt ähnlich, Details unterscheiden sich.

### Architecture Decision Records (ADRs)

Ein ADR ist ein **kurzes Dokument zu genau einer wichtigen Entscheidung**, mit Kontext, Optionen, Entscheidung und Folgen. Es beantwortet später die Frage „Warum haben wir das so gemacht?“, wenn die Beteiligten längst gewechselt haben. Das Format stammt von Michael Nygard (2011) und ist heute in der Softwareentwicklung verbreitet.

Eigenschaften:

- **Unveränderlich:** Ein angenommener ADR wird nicht umgeschrieben. Ändert sich die Entscheidung, entsteht ein neuer ADR, der den alten **ersetzt** (Status *abgelöst durch ADR-007*).
- **Kurz:** eine Seite genügt.
- **Nummeriert:** `ADR-001`, `ADR-002` …, Dateien `adr-001-<titel>.md`.
- **Mit Status:** *vorgeschlagen*, *angenommen*, *abgelöst*, *abgelehnt*.

### Zusammenhang

Eine ADR wie „Wir betreiben Nextcloud selbst statt Microsoft 365“ ändert die Verarbeitungstätigkeiten (Empfänger, Drittlandübermittlung, TOM). Beide Dokumente verweisen aufeinander: Das Verzeichnis nennt den Stand, der ADR den Grund.

## Vorgehen Schritt für Schritt

### Verarbeitungsverzeichnis

1. **Tätigkeiten sammeln:** Wo werden personenbezogene Daten verarbeitet? (Schülerverwaltung, Notenverwaltung, Lernplattform, WLAN-Anmeldung, Videoüberwachung, Website, Fotos …)
2. **Je Tätigkeit einen Eintrag** mit den Angaben aus der Tabelle anlegen.
3. **Rechtsgrundlage und Zweck** klären, bei Unsicherheit die/den Datenschutzbeauftragte/n einbeziehen.
4. **Empfänger und Auftragsverarbeiter erfassen** (Verträge/AVV vorhanden?).
5. **TOM beschreiben** (Zugriff, Verschlüsselung, Backup, Protokollierung) und auf die technische Dokumentation verweisen.
6. **Löschfristen festlegen.**
7. **Reviewen und freigeben**, Datum notieren.
8. **Regelmäßig aktualisieren** (mindestens jährlich, bei jedem neuen Dienst sofort).

### ADR

1. **Entscheidung eingrenzen:** eine Frage, z. B. „Wo hosten wir die Lernplattform?“
2. **Kontext beschreiben:** Anforderungen, Randbedingungen, Beteiligte.
3. **Mindestens zwei Optionen** mit Vor- und Nachteilen nennen.
4. **Entscheidung und Begründung** festhalten.
5. **Folgen** beschreiben (positiv, negativ, offene Risiken, nötige Folgeaufgaben).
6. **Status setzen**, ablegen, im ADR-Index verlinken.

## Vorlage

### Verarbeitungstätigkeit

```markdown
## VT-003 · Lernplattform (Nextcloud)

- **Verantwortlicher:** <Schule / Schulleitung>
- **Datenschutzbeauftragte/r:** <Name oder Stelle>
- **Zweck:** Bereitstellung von Unterrichtsmaterial, Abgabe von Aufgaben
- **Rechtsgrundlage:** <Art. 6 Abs. 1 lit. … DSGVO – mit DSB klären>
- **Betroffene:** Schüler, Lehrende
- **Datenkategorien:** Name, Klasse, Benutzername, abgegebene Dateien, Zugriffsprotokolle
- **Empfänger:** intern: Lehrende der jeweiligen Klasse; extern: <Hosting-Anbieter, Auftragsverarbeiter-Vertrag vom …>
- **Drittlandübermittlung:** nein (Hosting in Österreich/EU)
- **Löschfrist:** Konto bis Ende des Schuljahrs nach Austritt; Abgaben nach <x> Monaten
- **TOM:** Zugriff nach Gruppen, TLS, tägliches Backup (verschlüsselt), Updates monatlich
- **Technische Doku:** Verweis auf Runbook und Netzplan
- **Stand / Prüfung:** <Datum>, nächste Prüfung <Datum>
```

### ADR

```markdown
# ADR-001: <Titel der Entscheidung>

- **Status:** vorgeschlagen | angenommen | abgelöst durch ADR-<n> | abgelehnt
- **Datum:** <TT.MM.JJJJ>
- **Entscheider/Beteiligte:** <Rollen>

## Kontext
<Welches Problem, welche Anforderungen und Randbedingungen?>

## Optionen
1. **<Option A>** – Vorteile / Nachteile
2. **<Option B>** – Vorteile / Nachteile

## Entscheidung
<Gewählte Option und Begründung>

## Folgen
- Positiv: …
- Negativ / Risiken: …
- Folgeaufgaben: …
- Datenschutz: <Auswirkungen auf das Verarbeitungsverzeichnis>
```

## Beispiel

```markdown
# ADR-002: Lernplattform wird selbst gehostet

- **Status:** angenommen
- **Datum:** 12.12.2026

## Kontext
Die Schule braucht eine Plattform für Unterrichtsmaterial und Abgaben. Personenbezogene
Schülerdaten sollen in der EU bleiben. Betreuung durch zwei Lehrende im Nebenamt.

## Optionen
1. **Nextcloud selbst betrieben (VM beim Schulerhalter)** – volle Datenkontrolle, kein Drittland;
   Aufwand für Updates und Backups.
2. **Cloud-Dienst eines Anbieters** – wenig Betriebsaufwand; Auftragsverarbeitung und
   Drittlandübermittlung genau zu prüfen, laufende Kosten.

## Entscheidung
Option 1. Datenkontrolle und Datenschutz wiegen für diese Daten schwerer als der Aufwand,
sofern ein Runbook für Updates und Restore existiert.

## Folgen
- Positiv: Daten bleiben in der Hand der Schule.
- Negativ: Betriebsverantwortung und Bus-Faktor 2 → Runbooks, Vertretungsregelung.
- Folgeaufgaben: Runbook „Update“, Runbook „Restore“, Eintrag VT-003 im Verzeichnis.
```

## Häufige Fehler

| Fehler | Besser |
|---|---|
| Verzeichnis einmal erstellt, nie gepflegt | Prüfdatum, jährliche Revision, Pflege bei jedem neuen Dienst |
| Nur „Daten der Schüler“ als Kategorie | konkrete Datenkategorien (Name, Noten, Fotos …) |
| Auftragsverarbeiter und Drittländer fehlen | alle Empfänger und Anbieter erfassen |
| Löschfristen leer („nach Bedarf“) | konkrete Frist oder Kriterium |
| TOM nur „angemessen geschützt“ | konkrete Maßnahmen beschreiben |
| ADR beschreibt nur das Ergebnis | Optionen und Gründe festhalten |
| ADR im Nachhinein umgeschrieben | neuen ADR anlegen, alten als *abgelöst* markieren |
| ADR für Kleinigkeiten | nur für wesentliche, schwer umkehrbare Entscheidungen |
| Rechtsfragen selbst „erraten“ | Datenschutzbeauftragte/n einbeziehen |

## Einsatz in der Lehrveranstaltung

Hauptsächlich eingesetzt in: [Einheit 6]({{% relref "/06-it-security-data-protection" %}})

ADRs können schon ab Einheit 1 genutzt werden, z. B. für die Entscheidung *VM oder Container* (siehe [Hausaufgabe Einheit 1]({{% relref "/01-virtualization-containerization/homework" %}})).

Quellen: [DSGVO, Art. 30 (EUR-Lex)](https://eur-lex.europa.eu/legal-content/DE/TXT/?uri=CELEX:32016R0679), [Datenschutzbehörde Österreich](https://www.dsb.gv.at), [Michael Nygard: Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions).
