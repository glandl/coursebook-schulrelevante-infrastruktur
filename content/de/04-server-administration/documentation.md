+++
title = "Dokumentationsaufgabe: Rollen-Runbook"
weight = 50
+++

{{% callout style="info" title="Technik" %}}
Lies zuerst im Dokumentationsskript: [Runbooks]({{% relref "/00-documentation/runbooks" %}})
{{% /callout %}}

{{% callout style="warning" title="Bewertet" %}}
Das **Rollen-Runbook** ist der bewertete Portfolio-Eintrag dieses Kapitels (Rubrik siehe [Bewertung]({{% relref "/rubric" %}})). Abgabe: **06.12.2026**. Eine eigene Hausaufgabe gibt es in diesem Kapitel nicht.
{{% /callout %}}

## Aufgabe

Jedes Rollenteam schreibt **ein gemeinsames Runbook** für seine Rolle. Es beschreibt, wie man die Rolle in der **Windows-Welt** und in der **Linux-Welt** einrichtet, prüft und wieder zurücknimmt, so dass ein anderes Lehrenden-Team es ohne Rückfrage nachbauen kann. Das Runbook liegt in den Portfolios **aller** Teammitglieder (gleiche Datei). Dazu schreibt **jede Person** eine eigene, kurze Reflexion.

**Ablage:** `04-server-administration/README.md` (Runbook) und `04-server-administration/reflexion.md` (persönlich), Bilder in `assets/`, Branch `einheit-04`, Abgabe per Pull Request.

## Inhalt

1. **Kopf** nach der Vorlage im Dokumentationsskript: Titel „Runbook: Serverrolle `<Rolle>` in Windows und Linux einrichten“, Version, Stand, Autorinnen und Autoren, geprüft von (ein anderes Team), geschätzte Dauer.
2. **Ausgangslage:** Maschinen, Adressen, Betriebssystem-Versionen, Software-Versionen (z. B. `Get-ComputerInfo`, `cat /etc/debian_version`, `kea-dhcp4 -V`).
3. **Voraussetzungen und Abhängigkeiten:** Welche anderen Rollen müssen laufen? Welche Konten werden gebraucht (Passwörter nur als Platzhalter)?
4. **Schritte in der Windows-Welt** und **Schritte in der Linux-Welt** als Tabelle mit einer **Spalte zum Zurücknehmen**:

   | # | Schritt | Befehl | Erwartet | Zurücknehmen |
   |---|---|---|---|---|
   | 1 | Rolle installieren | `Install-WindowsFeature DHCP -IncludeManagementTools` | `Success: True` | `Uninstall-WindowsFeature DHCP` |

   Befehle **kopierbar** (Codeblock oder Code in der Tabelle). Wo ein Klickpfad nötig war, steht er vollständig da.
5. **Abnahmetests** vom Testclient aus, mit Ergebnis (Ausgabe als Text, mindestens ein Screenshot pro Welt).
6. **Integration und Kombination** (Einheit 2): Was musste mit welchem Team abgestimmt werden, welche Kombination Windows und Linux habt ihr getestet, mit welchem Ergebnis?
7. **Probleme und Lösungen:** Mindestens zwei echte Probleme mit Ursache und Lösung.
8. **Vergleich Windows und Linux** als Tabelle: Aufwand (Anzahl Schritte, Zeit), Lizenzkosten, Abhängigkeit vom Hersteller, Weiterentwicklung, Datenschutz, Eignung für ein Lehrenden-Team. Mit **einer Empfehlung** für die *Mittelschule Musterstadt* und kurzer Begründung.
9. **Quellen:** die verwendeten offiziellen Dokumentationen.

**Persönliche Reflexion** (`reflexion.md`, je Person ca. 150–250 Wörter): Was hast du selbst gemacht, was hat dich überrascht, welche Welt würdest du an deiner Schule betreuen wollen und warum?

## Prüfen durch ein anderes Team

Bis **30.11.2026** gebt ihr euer Runbook einem anderen Team (Team 1 an Team 2, Team 2 an Team 3, …, Team 8 an Team 1). Es liest das Runbook und notiert jede Stelle, an der es eine Rückfrage hätte, als Kommentar im Pull Request. Jede Rückfrage ist ein Fehler im Runbook.

## Kontrollliste

- [ ] Kopf vollständig, „Geprüft von“ eingetragen.
- [ ] Beide Welten beschrieben, jeder Schritt hat eine Spalte „Zurücknehmen“.
- [ ] Befehle sind kopierbar, Ausgaben als Text, Screenshots in `assets/` mit Alternativtext.
- [ ] Mindestens zwei Probleme mit Ursache und Lösung.
- [ ] Vergleichstabelle und Empfehlung vorhanden.
- [ ] Keine Passwörter, keine echten Personennamen.
- [ ] Persönliche Reflexion jeder Person vorhanden.
- [ ] Pull Request geöffnet, Kommentare des prüfenden Teams beantwortet.
