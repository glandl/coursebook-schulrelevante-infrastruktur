+++
title = "Runbooks"
weight = 40
+++

## Ziel

Du kannst eine wiederkehrende Aufgabe oder Störungsbehebung so beschreiben, dass **eine andere Person sie ohne Rückfrage korrekt durchführt**, auch unter Zeitdruck. Ein Runbook beantwortet: *Wie führe ich diese Aufgabe reproduzierbar durch?*

## Grundlagen

### Runbook, Anleitung, Handbuch

| Dokumentart | Zweck | Beispiel |
|---|---|---|
| **Runbook** | konkrete Abfolge für eine bestimmte Aufgabe oder Störung | „Neuen Lehrer-Account anlegen“, „Nextcloud wiederherstellen“ |
| Konzept | Warum ist etwas so aufgebaut? | Architekturbeschreibung, ADR |
| Referenz | Nachschlagen | IP-Plan, Matrizen |

### Arten von Runbooks

- **Routine** (Standardaufgaben): Benutzer anlegen, Updates einspielen, Backup prüfen, Schuljahreswechsel.
- **Störung** (Incident): Dienst nicht erreichbar, WLAN ausgefallen, Speicher voll.
- **Notfall / Wiederherstellung:** Restore aus dem Backup, Server-Ausfall.

### Eigenschaften eines guten Runbooks

- **Ausführbar:** nummerierte Schritte, je Schritt eine Handlung (Befehl oder Klickpfad).
- **Prüfbar:** Nach wichtigen Schritten steht, woran man den Erfolg erkennt.
- **Sicher:** Warnungen vor destruktiven Schritten stehen **vor** dem Schritt. Rückweg (Rollback) ist beschrieben.
- **Vollständig:** Voraussetzungen, Berechtigungen, geschätzte Dauer, Ansprechpartner.
- **Aktuell:** Datum der letzten Prüfung. Idealerweise wird es bei der nächsten Durchführung getestet und korrigiert.

## Vorgehen Schritt für Schritt

1. **Aufgabe abgrenzen:** Titel nennt Aktion und Objekt („Backup von Nextcloud wiederherstellen“).
2. **Aufgabe selbst durchführen** und dabei Schritte und Befehle mitschreiben.
3. **Voraussetzungen klären:** Zugänge, Werkzeuge, Rechte, Wartungsfenster.
4. **Schritte glätten:** eine Handlung pro Schritt, Befehle im Codeblock, erwartete Ausgabe angeben.
5. **Kontrollpunkte und Warnungen einfügen.**
6. **Rollback beschreiben:** Wie kehrt man zum Ausgangszustand zurück?
7. **Testlauf durch eine andere Person**, die nur das Runbook benutzt. Jede Rückfrage ist ein Fehler im Runbook.
8. **Veröffentlichen, mit Version und Datum versehen**, am bekannten Ort ablegen (Repository, Wiki).

## Vorlage

````markdown
# Runbook: <Aktion> <Objekt>

- **Version / Stand:** 1.0 / <TT.MM.JJJJ>
- **Autor/in:** <Name>   **Geprüft von:** <Name>, <Datum>
- **Typ:** Routine | Störung | Notfall
- **Geschätzte Dauer:** <Minuten>
- **Auswirkung:** <Wer ist betroffen? Gibt es Ausfallzeit?>

## Voraussetzungen
- Zugang: <System, Konto, wo das Passwort liegt – nicht das Passwort selbst>
- Werkzeuge: <Software, Version>
- Vorher erledigt: <z. B. aktuelles Backup vorhanden>

## Schritte
1. <Handlung>
   ```bash
   <Befehl>
   ```
   **Erwartet:** <Ausgabe oder Zustand>
2. ...

> **Achtung:** <Warnung vor destruktivem Schritt>

## Erfolg prüfen
- [ ] <Prüfpunkt 1>
- [ ] <Prüfpunkt 2>

## Rollback
1. <Rückweg>

## Bei Problemen
- <Typische Fehlermeldung> → <Lösung>
- Ansprechpartner: <Rolle, Kontakt>

## Änderungen
| Datum | Version | Änderung | Autor/in |
|---|---|---|---|
````

## Beispiel

Kurzes Routine-Runbook (Befehle *ungeprüft*, Pfade abhängig von der Installation):

````markdown
# Runbook: Snapshot einer VM vor dem Update erstellen

- **Version / Stand:** 1.0 / 05.10.2026
- **Typ:** Routine, **Dauer:** ca. 5 Minuten
- **Auswirkung:** keine (VM läuft weiter)

## Voraussetzungen
- VirtualBox-Host mit Zugriff auf die VM `ubuntu-lab`
- Mindestens 5 GB freier Speicher auf dem Host

## Schritte
1. Prüfen, ob die VM läuft und keine Wartung läuft.
   ```bash
   VBoxManage list runningvms
   ```
   **Erwartet:** `"ubuntu-lab" {…}` ist in der Liste.
2. Snapshot erstellen.
   ```bash
   VBoxManage snapshot ubuntu-lab take "vor-update-2026-10-05" --description "Vor apt upgrade"
   ```
3. Update in der VM durchführen: `sudo apt update && sudo apt upgrade`.

## Erfolg prüfen
- [ ] `VBoxManage snapshot ubuntu-lab list` zeigt den neuen Snapshot.

## Rollback
1. VM herunterfahren.
2. `VBoxManage snapshot ubuntu-lab restore "vor-update-2026-10-05"`
> **Achtung:** Beim Wiederherstellen gehen alle Änderungen seit dem Snapshot verloren.
````

## Häufige Fehler

| Fehler | Besser |
|---|---|
| Schritte setzen Wissen voraus („dann wie üblich konfigurieren“) | jede Handlung ausschreiben |
| Mehrere Handlungen in einem Schritt | eine Handlung pro Schritt |
| Keine erwartete Ausgabe | Kontrollpunkte nennen |
| Warnung steht nach dem gefährlichen Schritt | Warnung vor den Schritt |
| Kein Rollback | Rückweg immer beschreiben |
| Passwörter im Runbook | Verweis auf Passwortmanager |
| Nie getestet, nie aktualisiert | Testlauf durch Dritte, Prüfdatum eintragen |
| Befehle als Screenshot | Text im Codeblock, kopierbar |

## Einsatz in der Lehrveranstaltung

Hauptsächlich eingesetzt in: [Einheit 4]({{% relref "/04-server-administration" %}})

Schon in Einheit 1 hilft das Prinzip: Das [Praxis-Lab]({{% relref "/01-virtualization-containerization/lab" %}}) ist selbst ein kleines Runbook.
