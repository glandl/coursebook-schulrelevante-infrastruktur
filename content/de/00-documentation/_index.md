+++
title = "Dokumentationstechniken"
type = "chapter"
weight = 5
+++

Dieses Kapitel ist das **durchgehende Skript zur Dokumentation**. Es ist in der Reihenfolge der Einheiten aufgebaut, sodass jede Technik auf der vorherigen aufbaut. Die Kapitel der Einheiten verweisen nur hierher: Hier steht, *wie* dokumentiert wird, dort steht, *was* in der jeweiligen Einheit zu dokumentieren ist.

Alle Abgaben erfolgen im Portfolio-Repository (privat, Pull Requests) und werden nach der [Bewertungsrubrik]({{% relref "/rubric" %}}) bewertet.

## Warum dokumentieren?

Schul-IT wird selten von einer Person allein und selten dauerhaft von derselben Person betreut. Wer die Schule verlässt, in Karenz geht oder krank ist, nimmt sein Wissen mit, wenn es nicht aufgeschrieben ist. Gute Dokumentation

- macht Betrieb **übertragbar** (Vertretung, Nachfolge, externe Dienstleister),
- macht Entscheidungen **nachvollziehbar** (Schulleitung, Schulerhalter, Datenschutz),
- macht Fehlersuche **schneller**, weil der Sollzustand bekannt ist,
- ist bei Datenschutz und IT-Sicherheit oft **Nachweispflicht** (siehe [Verarbeitungsverzeichnis und ADRs]({{% relref "processing-register-adr" %}})).

## Die sechs Techniken im Überblick

| Nr. | Technik | Frage, die sie beantwortet | Einheit |
|---|---|---|---|
| 1 | [Markdown, Git und Pull-Request-Workflow]({{% relref "markdown-git" %}}) | Wie schreibe, versioniere und gebe ich Dokumentation ab? | 1 |
| 2 | [Netzwerkdiagramme und IP-Pläne]({{% relref "network-diagrams-ip-plans" %}}) | Was hängt woran, und wer hat welche Adresse? | 2 |
| 3 | [VLAN- und Berechtigungsmatrizen]({{% relref "vlan-permission-matrices" %}}) | Wer darf worauf zugreifen? | 3 |
| 4 | [Runbooks]({{% relref "runbooks" %}}) | Wie führe ich eine Aufgabe reproduzierbar durch? | 4 |
| 5 | [Änderungsprotokolle für Geräterichtlinien]({{% relref "change-logs" %}}) | Was wurde wann, warum und von wem geändert? | 5 |
| 6 | [Verarbeitungsverzeichnis und ADRs]({{% relref "processing-register-adr" %}}) | Welche Daten verarbeiten wir, und warum haben wir uns so entschieden? | 6 |

## Aufbau jeder Seite

Jede Technik ist gleich gegliedert: **Ziel**, **Grundlagen**, **Vorgehen Schritt für Schritt**, **Vorlage**, **Beispiel**, **Häufige Fehler**, **Einsatz in der Lehrveranstaltung**. Die Vorlagen kannst du in dein Portfolio kopieren.

## Allgemeine Grundsätze

Diese Regeln gelten für alle Techniken:

1. **Für die Leserin oder den Leser schreiben.** Stell dir die Nachfolgerin vor, die in einem Jahr um 7:30 Uhr einen ausgefallenen Server finden muss.
2. **Ein Dokument, ein Zweck.** Lieber mehrere kurze Dokumente mit klarer Aufgabe als ein langes für alles.
3. **Datum, Version und Autor angeben.** Veraltete Dokumentation ist gefährlicher als keine.
4. **Keine Geheimnisse im Klartext.** Passwörter, Schlüssel und Tokens gehören in einen Passwortmanager, nicht ins Repository. In der Dokumentation steht nur, *wo* sie liegen.
5. **Keine personenbezogenen Daten ohne Not.** Keine echten Schülernamen, Klassenlisten oder Fotos von Personen in Screenshots (siehe [Screenshot-Konventionen]({{% relref "markdown-git" %}})).
6. **Überprüfbar machen.** Nenne Versionen, Befehle und erwartete Ergebnisse, damit andere es nachvollziehen können.
7. **Quellen angeben.** Eigene Arbeit von übernommenen Texten trennen. Bei KI-Unterstützung: kennzeichnen und selbst prüfen.

{{% pages display="tree" levels="1" %}}
