+++
title = "Team 2: DNS"
weight = 2
+++

**Windows-Welt:** `10.50.13.11`, Windows-DNS-Server · **Linux-Welt:** `10.50.13.22`, BIND 9 (Debian-Container)

## Die Rolle an einer Schule

Lehrende tippen `moodle.schule.lan` oder `drucker-lehrerzimmer` und nicht `10.50.13.15`. Der DNS-Server übersetzt Namen in Adressen (und umgekehrt) und leitet alle anderen Anfragen ins Internet weiter. Ohne DNS funktioniert an einer Windows-Schule fast nichts: Die Anmeldung an der Domäne sucht den Domänencontroller über DNS.

Im Labor teilt sich die Arbeit so auf: Die **Domänen-Zonen** (`win.schule.lan`, `linux.schule.lan`) legt Team 3 beim Einrichten des Verzeichnisdienstes an. Euer Team baut das **DNS rund um die Domänen**: eine Zone mit den Namen aller Laborserver, die Rückwärtsauflösung und die Weiterleitungen, damit beide Welten einander finden.

## Abhängigkeiten

- **Keine** für Einheit 1 (Weiterleitung an den Labor-Router `10.50.13.254`).
- Für Einheit 2: Die Domänencontroller von Team 3 laufen.

## Ziel in der Windows-Welt

- Die Rolle **DNS-Server** ist auf `10.50.13.11` installiert, Weiterleitung (*Forwarder*) an `10.50.13.254`.
- Eine primäre Zone **`labor.test`** mit einem A-Eintrag für **jeden** Server beider Welten nach dem Muster `win-<rolle>` und `lx-<rolle>`, z. B. `win-dhcp.labor.test → 10.50.13.10`, `lx-dhcp.labor.test → 10.50.13.21`.
- Zonenübertragung (*Zone Transfer*) nur an `10.50.13.22` erlaubt.
- Hinweis: PowerShell-Modul `DnsServer`, z. B. `Add-DnsServerPrimaryZone`, `Add-DnsServerResourceRecordA`.

## Ziel in der Linux-Welt

- Paket `bind9` ist installiert, BIND arbeitet als **Resolver** für das Labor (`allow-recursion` nur für `10.50.13.0/24`) mit Weiterleitung an `10.50.13.254`.
- Eine primäre Zone für die **Rückwärtsauflösung** `13.50.10.in-addr.arpa` mit PTR-Einträgen für jeden Server beider Welten.
- Zonenübertragung nur an `10.50.13.11` erlaubt.
- Prüfen vor jedem Neustart: `named-checkconf` und `named-checkzone`.

## Ziel in Einheit 2

1. **Austausch über Weltgrenzen:** BIND wird **sekundärer** Server für `labor.test` (Übertragung von `10.50.13.11`), Windows wird sekundärer Server für `13.50.10.in-addr.arpa` (Übertragung von `10.50.13.22`).
2. **Bedingte Weiterleitungen** (*Conditional Forwarder*) gemeinsam mit Team 3: Wer nach `linux.schule.lan` fragt, landet bei `10.50.13.23`, wer nach `win.schule.lan` fragt, bei `10.50.13.12`. Und die Domänencontroller leiten `labor.test` an euch weiter.
3. Danach findet der Windows-Testclient einen Server der Linux-Welt per Name und umgekehrt.

## Abnahmetests

| Test | Windows-Testclient | Linux-Testclient |
|---|---|---|
| Vorwärts | `Resolve-DnsName lx-web.labor.test -Server 10.50.13.11` | `dig @10.50.13.22 win-web.labor.test` |
| Rückwärts | `Resolve-DnsName 10.50.13.26 -Server 10.50.13.22` | `dig @10.50.13.11 -x 10.50.13.15` |
| Internet über die Weiterleitung | `Resolve-DnsName debian.org -Server 10.50.13.11` | `dig @10.50.13.22 debian.org` |
| Zonenübertragung (Einheit 2) | | `dig @10.50.13.22 labor.test AXFR` zeigt alle Einträge |
| Über Weltgrenzen (Einheit 2) | `Resolve-DnsName dc.linux.schule.lan` | `dig dc.win.schule.lan` |

## Stolpersteine

- **Seriennummer** im SOA-Eintrag nicht erhöht: Der sekundäre Server übernimmt die Änderung nicht.
- Vergessener **Punkt** am Ende eines Namens in BIND-Zonendateien (`ns.labor.test.`): Aus dem Namen wird `ns.labor.test.labor.test`.
- Ein **offener Resolver** (`allow-recursion any`) beantwortet Anfragen aus aller Welt und kann für Angriffe missbraucht werden.
- Unter Debian 13 liest `/etc/resolv.conf` den DNS-Server direkt, ohne `systemd-resolved`. Änderungen am Server selbst prüft ihr mit `dig @127.0.0.1`.
- `.test` ist für Übungen reserviert (RFC 6761). An einer echten Schule verwendet man eine Subdomain der eigenen, registrierten Domäne (z. B. `intern.ms-musterstadt.at`), **nicht** `.local`.

## Einstiegspunkte

- Microsoft Learn: [DNS-Server unter Windows Server](https://learn.microsoft.com/de-de/windows-server/networking/dns/dns-overview)
- Microsoft Learn: [DnsServer-Modul (PowerShell)](https://learn.microsoft.com/de-de/powershell/module/dnsserver/)
- ISC: [BIND 9 Administrator Reference Manual](https://bind9.readthedocs.io/)
- Debian Wiki: [Bind9](https://wiki.debian.org/Bind9)
- IETF: [RFC 6761, Special-Use Domain Names](https://www.rfc-editor.org/rfc/rfc6761)

## Vergleichsfragen

- Windows speichert Zonen in einer Datei oder im Active Directory, BIND in Textdateien. Was bedeutet das für Sicherung, Versionierung (Git) und Fehlersuche?
- Welche Welt zeigt Fehler in der Konfiguration früher an?
- Was protokolliert ein DNS-Server über die Schülerinnen und Schüler (welche Seiten sie aufrufen)? Wer an der Schule darf das sehen?
- Wäre es sinnvoll, DNS für die Schule bei einem Anbieter im Internet zu betreiben? Was spricht dafür, was dagegen?
