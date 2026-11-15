+++
title = "Demo: Zertifikatsdienste"
weight = 70
+++

**Wann:** 23.11.2026, ca. 15 min im Block 10:30–11:15 · **Wer:** Lehrperson (Vorführung), zum Nachlesen für alle · **Maschinen:** `10.50.13.18` (Windows), `10.50.13.29` (Linux)

{{% callout style="info" title="Vorführung, keine Teamaufgabe" %}}
Die Zertifikatsdienste sind **keine** Rolle eines Teams. Eine eigene Zertifizierungsstelle ist schwer zurückzunehmen (siehe unten) und hängt vom Verzeichnisdienst ab. Deshalb zeigt sie die Lehrperson einmal in jeder Welt.
{{% /callout %}}

{{% callout style="warning" title="Status: ungeprüft" %}}
Die Befehle wurden noch **nicht** im Proxmox-Labor ausgeführt. *Getestet am: offen.*
{{% /callout %}}

## Worum es geht

Die Webseiten von Team 6 laufen mit HTTPS, aber mit **selbst signierten** Zertifikaten. Der Browser warnt, und zwar zu Recht: Er kann nicht prüfen, ob er wirklich mit dem Schulserver spricht. Öffentliche Stellen wie *Let's Encrypt* stellen für interne Namen wie `intranet-win.labor.test` keine Zertifikate aus.

Die Lösung ist eine **eigene Zertifizierungsstelle** (*Certificate Authority*, CA) der Schule:

1. Die CA erzeugt ein **Stammzertifikat** (*Root-Zertifikat*) und hält dessen privaten Schlüssel geheim.
2. Alle Geräte der Schule vertrauen diesem Stammzertifikat.
3. Die CA stellt Zertifikate für interne Server aus. Weil die Geräte der CA vertrauen, vertrauen sie auch diesen Zertifikaten: **keine Warnung mehr**.

## Wofür eine Schule eine eigene CA braucht

| Einsatz | Was das Zertifikat leistet |
|---|---|
| **Interne Webseiten** (Intranet, Moodle, Drucker-Oberflächen) | HTTPS ohne Browserwarnung |
| **WLAN mit 802.1X** (EAP-TLS) | Geräte von Lehrenden melden sich mit einem Zertifikat statt mit einem gemeinsamen WLAN-Passwort an und landen automatisch im richtigen VLAN (siehe [Kapitel 3]({{% relref "/03-networking-2/theory" %}}#vlans-im-wlan)) |
| **Geräteverwaltung** (Einheit 5) | Intune und andere MDM-Systeme verteilen Gerätezertifikate (SCEP, PKCS) |
| **Verzeichnisdienst** | verschlüsselte LDAP-Verbindungen (LDAPS) zwischen Servern |

## Teil 1: Windows-Welt mit AD CS (ca. 7 min)

Voraussetzung: `10.50.13.18` ist Mitglied von `win.schule.lan`. Eine **Unternehmens-CA** (*Enterprise CA*) braucht Active Directory: Sie veröffentlicht ihr Stammzertifikat dort, und alle Domänenmitglieder vertrauen ihm automatisch.

```powershell
# auf 10.50.13.18, als Domänen-Administrator
Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
Install-AdcsCertificationAuthority -CAType EnterpriseRootCa `
    -CACommonName "Schule Musterstadt Root CA" `
    -KeyLength 4096 -HashAlgorithmName SHA256 `
    -ValidityPeriod Years -ValidityPeriodUnits 10
```

Zertifikat für die Webseite von Team 6 ausstellen und in IIS einbinden:

```powershell
# auf 10.50.13.15 (IIS), als Domänen-Administrator
$cert = Get-Certificate -Template WebServer `
    -DnsName intranet-win.labor.test `
    -CertStoreLocation Cert:\LocalMachine\My
$thumb = $cert.Certificate.Thumbprint
# bestehende HTTPS-Bindung von Team 6 entfernen, dann neu binden
# ("intranet" = Name der Site, den Team 6 vergeben hat)
New-IISSiteBinding -Name "intranet" -Protocol https `
    -BindingInformation "*:443:intranet-win.labor.test" -SslFlag Sni `
    -CertificateThumbPrint $thumb -CertStoreLocation "Cert:\LocalMachine\My"
```

Zeigen:

1. Am Windows-Testclient `gpupdate /force`, dann in `certlm.msc` unter *Vertrauenswürdige Stammzertifizierungsstellen* die neue CA zeigen.
2. Im Browser `https://intranet-win.labor.test`: **keine Warnung**, Schloss-Symbol, Zertifikatskette bis zur Schul-CA.
3. Gegenprobe am **Linux**-Testclient: Warnung bleibt. Er ist nicht in der Windows-Domäne und kennt die CA nicht.

## Teil 2: Linux-Welt mit step-ca (ca. 5 min)

[step-ca](https://smallstep.com/docs/step-ca/) von Smallstep ist eine freie Zertifizierungsstelle. Installation nach der offiziellen Anleitung (Debian-Pakete `step-cli` und `step-ca`) vorab auf `10.50.13.29`. Team 2 trägt `ca.labor.test → 10.50.13.29` in die Zone `labor.test` ein.

```bash
# auf 10.50.13.29: CA einrichten (einmalig, vorab)
step ca init --name "Schule Musterstadt Linux CA" \
    --dns ca.labor.test --address :443 --provisioner admin
step-ca $(step path)/config/ca.json      # CA starten (in der Demo im Vordergrund)

# Zertifikat für die nginx-Seite von Team 6 ausstellen
step ca certificate intranet-lx.labor.test intranet-lx.crt intranet-lx.key
```

Zertifikat und Schlüssel auf `10.50.13.26` kopieren und in nginx als `ssl_certificate` und `ssl_certificate_key` eintragen, `nginx -t`, `systemctl reload nginx`.

Den Linux-Testclient der CA vertrauen lassen:

```bash
# Stammzertifikat liegt auf 10.50.13.29 unter $(step path)/certs/root_ca.crt;
# auf den Testclient kopieren und systemweit eintragen
sudo cp root_ca.crt /usr/local/share/ca-certificates/schule-linux-ca.crt
sudo update-ca-certificates
curl https://intranet-lx.labor.test     # ohne -k, ohne Warnung
```

Zeigen:

1. `curl` funktioniert ohne `-k`.
2. **Gültigkeit:** `step certificate inspect intranet-lx.crt` zeigt, dass das Zertifikat nur **24 Stunden** gilt (Voreinstellung von step-ca). Kurzlebige Zertifikate sind sicherer, müssen aber automatisch erneuert werden, z. B. über **ACME**, dasselbe Verfahren, das Let's Encrypt verwendet. step-ca kann ACME anbieten.
3. Firefox verwendet einen eigenen Zertifikatsspeicher. Dort muss die CA zusätzlich eingetragen werden (oder per Richtlinie für alle Geräte).

## Teil 3: Warum eine CA schwer zurückzunehmen ist (ca. 3 min)

- Das Stammzertifikat liegt nach kurzer Zeit auf **jedem** Gerät der Schule. Wer die CA neu aufsetzt, muss jedes Gerät neu ausstatten und jedes ausgestellte Zertifikat ersetzen.
- Wer den **privaten Schlüssel** der CA stiehlt, kann für jeden beliebigen Namen gültige Zertifikate ausstellen, auch für `bank.at`, denen die Schulgeräte dann vertrauen. Der Schlüssel ist das wertvollste Geheimnis im Schulnetz.
- In der Praxis baut man deshalb **zwei Stufen**: eine Stamm-CA, die fast immer **ausgeschaltet** ist (offline), und eine ausstellende CA darunter. In der Demo ist es zur Vereinfachung eine Stufe.
- Name, Laufzeit und Schlüssellänge der CA lassen sich nachträglich nicht ändern. Deshalb wird eine CA **geplant und dokumentiert**, bevor sie installiert wird, z. B. mit einer Architekturentscheidung (ADR, siehe [Einheit 6]({{% relref "/06-it-security-data-protection" %}})).

## Vergleich

| | AD CS (Windows) | step-ca (Linux) |
|---|---|---|
| Lizenz | in Windows Server enthalten, Server-Lizenz und CALs nötig | freie Software (Apache 2.0) |
| Verteilung des Stammzertifikats | automatisch an alle Domänenmitglieder | selbst verteilen (Konfigurationsverwaltung, MDM, Richtlinie) |
| Automatische Erneuerung | *Autoenrollment* für Domänenmitglieder | ACME (wie Let's Encrypt), auch für Nicht-Windows-Geräte |
| Typische Stärke | Windows-Clients, WLAN mit 802.1X in einer AD-Umgebung | Server, Container, gemischte Umgebungen, kurzlebige Zertifikate |

## Quellen

- Microsoft Learn: [Active Directory Certificate Services (Überblick)](https://learn.microsoft.com/de-de/windows-server/identity/ad-cs/active-directory-certificate-services-overview), [Install-AdcsCertificationAuthority](https://learn.microsoft.com/de-de/powershell/module/adcsdeployment/install-adcscertificationauthority)
- Smallstep: [step-ca Dokumentation](https://smallstep.com/docs/step-ca/), [Installation](https://smallstep.com/docs/step-ca/installation/)
- IETF: [RFC 5280, X.509 Public Key Infrastructure Certificate Profile](https://www.rfc-editor.org/rfc/rfc5280), [RFC 8555, ACME](https://www.rfc-editor.org/rfc/rfc8555)
- Debian: `man update-ca-certificates`
