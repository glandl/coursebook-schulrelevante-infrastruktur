+++
title = "Team 6: Web"
weight = 6
+++

**Windows-Welt:** `10.50.13.15`, Internet Information Services (IIS) · **Linux-Welt:** `10.50.13.26`, nginx (Debian-Container)

## Die Rolle an einer Schule

Das Intranet mit dem Vertretungsplan, die Anmeldeseite für Elternsprechtage, die Lernplattform Moodle, die Weboberfläche des Druckers: In einer Schule laufen viele Webseiten, die nur im eigenen Netz erreichbar sein sollen. Ein **Webserver** liefert sie aus, oft mehrere Seiten auf einem Server, unterschieden nach Namen (*virtuelle Hosts*), und verschlüsselt mit **HTTPS**.

## Abhängigkeiten

- Einheit 1: keine (Aufruf über die IP-Adresse).
- Einheit 2: DNS (Team 2) für Namen, Verzeichnisdienst (Team 3) für eine Seite mit Anmeldung.

## Ziel in der Windows-Welt

- Rolle **Webserver (IIS)** installiert.
- Zwei Seiten auf **einem** Server, unterschieden nach Hostnamen: `intranet-win.labor.test` (Vertretungsplan als einfache HTML-Seite) und `eltern-win.labor.test`.
- HTTPS mit einem **selbst signierten** Zertifikat, HTTP leitet auf HTTPS um.
- Hinweis: `Install-WindowsFeature Web-Server -IncludeManagementTools`, Modul `IISAdministration` (`New-IISSite`), Zertifikat mit `New-SelfSignedCertificate`.

## Ziel in der Linux-Welt

- Paket `nginx` installiert.
- Dieselben zwei Seiten als `server`-Blöcke: `intranet-lx.labor.test` und `eltern-lx.labor.test`, Dateien unter `/var/www/…`, Konfiguration unter `/etc/nginx/sites-available/` mit Verknüpfung in `sites-enabled/`.
- HTTPS mit einem selbst signierten Zertifikat (`openssl req -x509 …`), Umleitung von HTTP auf HTTPS.
- Prüfen vor jedem Neuladen: `nginx -t`.

## Ziel in Einheit 2

1. Team 2 trägt die vier Namen in `labor.test` ein. Die Seiten sind vom Testclient über ihren Namen erreichbar.
2. **Anmeldung:** Die Seite `intranet` ist nur nach Anmeldung erreichbar. Windows: *Windows-Authentifizierung* mit Domänenkonto. Linux: einfache Anmeldung (`auth_basic`) als erster Schritt; Anmeldung am Verzeichnisdienst ist eine Erweiterung.
3. Die Lehrperson zeigt in der Demo, wie ein Zertifikat einer **eigenen Zertifizierungsstelle** die Browserwarnung beseitigt.

## Abnahmetests

| Test | Windows-Testclient | Linux-Testclient |
|---|---|---|
| Seite per IP | Browser: `http://10.50.13.15` | `curl -I http://10.50.13.26` |
| Virtuelle Hosts | `curl.exe -k -H "Host: eltern-win.labor.test" https://10.50.13.15` | `curl -k -H 'Host: eltern-lx.labor.test' https://10.50.13.26` |
| Umleitung | `http://…` landet auf `https://…` | `curl -I http://10.50.13.26` zeigt `301` |
| Per Name (Einheit 2) | Browser: `https://intranet-lx.labor.test` | Browser: `https://intranet-win.labor.test` |

## Stolpersteine

- Ein selbst signiertes Zertifikat ist **verschlüsselt, aber nicht vertrauenswürdig**: Der Browser warnt zu Recht. Lehrende daran zu gewöhnen, Warnungen wegzuklicken, ist an einer Schule gefährlich.
- Zertifikate für interne Namen bekommt man von öffentlichen Stellen wie *Let's Encrypt* nicht, weil die Namen aus dem Internet nicht prüfbar sind.
- nginx: Vergessene Verknüpfung in `sites-enabled` – die Seite existiert, wird aber nicht ausgeliefert.
- IIS: Die Standardseite (*Default Web Site*) belegt Port 80 für alle Namen. Bindungen gezielt setzen.

## Einstiegspunkte

- Microsoft Learn: [IIS-Webserver (Überblick)](https://learn.microsoft.com/de-de/iis/get-started/introduction-to-iis/iis-web-server-overview), [IISAdministration-Modul](https://learn.microsoft.com/de-de/powershell/module/iisadministration/)
- nginx: [Beginner's Guide](https://nginx.org/en/docs/beginners_guide.html), [Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html)
- Debian Wiki: [Nginx](https://wiki.debian.org/Nginx)

## Vergleichsfragen

- Welche Schul-Webanwendungen (Moodle, Nextcloud, WebUntis-Alternativen) laufen auf welcher Welt? Was empfehlen ihre Hersteller?
- Wie viel Arbeitsspeicher braucht der Server in jeder Welt, nur um eine leere Seite auszuliefern?
- Wer ist an einer Schule für die Inhalte, wer für die Technik verantwortlich (Impressum, Barrierefreiheit, Datenschutzerklärung)?
- Warum läuft ein großer Teil aller Webserver weltweit auf Linux?
