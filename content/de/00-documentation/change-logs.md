+++
title = "Änderungsprotokolle für Geräterichtlinien"
weight = 50
+++

## Ziel

Du kannst Änderungen an Geräte- und Sicherheitsrichtlinien (z. B. in einer MDM-Lösung wie Intune, an Gruppenrichtlinien oder WLAN-Profilen) so protokollieren, dass später klar ist: **Was wurde wann, warum und von wem geändert, und wie macht man es rückgängig?**

## Grundlagen

### Warum Änderungsprotokolle?

Richtlinien wirken auf viele Geräte gleichzeitig. Eine falsche Einstellung kann einen ganzen Schulstandort lahmlegen (z. B. ein blockiertes WLAN-Zertifikat) oder eine Sicherheitslücke öffnen. Ein Protokoll

- ermöglicht **Rückverfolgung** („seit wann tritt das Problem auf?“),
- ermöglicht **Rollback** (alter Zustand ist dokumentiert),
- schafft **Verantwortlichkeit** und **Nachweis** (Datenschutz, Schulleitung),
- zwingt zu **Begründung und Planung** vor der Änderung.

### Changelog vs. Änderungsantrag

| | Änderungsprotokoll (Changelog) | Änderungsantrag (Change Request) |
|---|---|---|
| Zeitpunkt | nachträglich, mit jeder Änderung | **vor** der Änderung |
| Inhalt | was geändert wurde | was geändert werden soll, Risiko, Test, Rollback |
| Umfang an Schulen | immer | bei wesentlichen Richtlinien (z. B. Sicherheit, Zugang) |

Für kleine Schulen genügt oft ein kombiniertes Format: kurzer Antrag im Eintrag und anschließend das Ergebnis.

### Kennzeichen eines guten Eintrags

- **Atomar:** eine fachliche Änderung pro Eintrag.
- **Eindeutig:** Datum, Verantwortliche/r, betroffene Richtlinie und Gerätegruppe.
- **Begründet:** Anlass (Ticket, Beschluss, Vorfall).
- **Umkehrbar:** Alter und neuer Wert, Rollback-Schritte.
- **Geprüft:** Wo getestet (Pilotgruppe) und mit welchem Ergebnis.

### Format

Wie Runbooks als Markdown im Repository. Die Git-Historie ergänzt (wer, wann), ersetzt aber das Changelog **nicht**, weil Konfigurationen oft in Weboberflächen (Intune) liegen, die nicht im Repository sind. Ein häufiger Standard für die Struktur ist [Keep a Changelog](https://keepachangelog.com/de/1.1.0/) (Kategorien *Hinzugefügt*, *Geändert*, *Entfernt*, *Behoben*).

## Vorgehen Schritt für Schritt

1. **Änderung beschreiben:** Was soll sich ändern, warum, für wen?
2. **Ist-Zustand festhalten** (Einstellung, Wert, Screenshot oder Export der Richtlinie).
3. **Risiko und Rollback festlegen:** Was kann schiefgehen? Wie kehrt man zurück?
4. **Zuerst an einer Pilotgruppe testen** (z. B. zwei Geräte der IT-Gruppe), Ergebnis notieren.
5. **Freigabe einholen**, falls erforderlich (Schulleitung, Datenschutzbeauftragte/r).
6. **Änderung ausrollen** und Zeitpunkt festhalten.
7. **Wirkung prüfen** (Gerät meldet Konformität, Nutzer-Rückmeldungen) und Eintrag abschließen.
8. **Bei Problemen:** Rollback durchführen und im Protokoll vermerken, nicht löschen.

## Vorlage

### Eintrag

```markdown
## 2026-11-30 · RL-014 · Bildschirmsperre für Lehrer-Tablets

- **Autor/in:** <Name>
- **Betroffen:** Richtlinie `Tablets-Lehrende`, Gerätegruppe `Lehrende-Tablets` (24 Geräte)
- **Anlass:** Beschluss Schulleitung vom 20.11.2026, Datenschutz-Empfehlung
- **Änderung:** Sperre nach Inaktivität von 15 auf 5 Minuten
- **Alter Wert → neuer Wert:** 15 min → 5 min
- **Risiko:** häufige Sperre im Unterricht beim Präsentieren
- **Test:** Pilotgruppe (3 Geräte), 25.11.–29.11., keine Beschwerden
- **Rollback:** Wert auf 15 min setzen, Richtlinie neu zuweisen
- **Ergebnis:** ausgerollt 30.11., alle Geräte konform am 01.12.
- **Referenz:** Ticket #123
```

### Übersichtstabelle (optional, am Anfang der Datei)

```markdown
| Nr. | Datum | Richtlinie | Kurzbeschreibung | Autor/in | Status |
|---|---|---|---|---|---|
| RL-014 | 30.11.2026 | Tablets-Lehrende | Sperrzeit 15 → 5 min | <Name> | ausgerollt |
```

## Beispiel

Ein Protokoll mit zwei Einträgen, wie es nach einigen Wochen aussehen könnte:

```markdown
# Änderungsprotokoll Geräterichtlinien – <Schule>

| Nr. | Datum | Richtlinie | Kurzbeschreibung | Status |
|---|---|---|---|---|
| RL-015 | 03.12.2026 | WLAN-Profil Schüler | Zertifikat erneuert | ausgerollt |
| RL-014 | 30.11.2026 | Tablets-Lehrende | Sperrzeit 15 → 5 min | ausgerollt |

## 2026-12-03 · RL-015 · WLAN-Zertifikat erneuert
- **Anlass:** Das Zertifikat läuft am 15.12. ab.
- **Änderung:** neues Zertifikat (gültig bis 2027-12-15) im Profil hinterlegt.
- **Test:** 2 Pilotgeräte verbinden sich erfolgreich.
- **Rollback:** altes Zertifikat bleibt bis 15.12. gültig; Profil kann zurückgesetzt werden.
- **Ergebnis:** ausgerollt, 98 % der Geräte neu verbunden bis 05.12.
```

## Häufige Fehler

| Fehler | Besser |
|---|---|
| Änderung nur im Kopf oder per Zuruf | immer schriftlich, mit Datum |
| Mehrere Änderungen in einem Eintrag | ein Eintrag pro fachlicher Änderung |
| Kein Alter Wert | Alt und Neu festhalten, sonst ist Rollback nicht möglich |
| Kein Test an Pilotgruppe | erst Pilot, dann alle Geräte |
| Einträge nachträglich ändern oder löschen | Korrekturen als neuer Eintrag |
| Kein Grund angegeben | Anlass, Beschluss oder Ticket nennen |
| Name der Person fehlt | Verantwortliche/r immer angeben |

## Einsatz in der Lehrveranstaltung

Hauptsächlich eingesetzt in: [Einheit 5]({{% relref "/05-client-mobile-device-management" %}})
