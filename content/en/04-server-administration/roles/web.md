+++
title = "Team 6: Web"
weight = 6
+++

**Windows world:** `10.50.13.15`, Internet Information Services (IIS) · **Linux world:** `10.50.13.26`, nginx (Debian container)

## The role at a school

The intranet with the substitution plan, the sign-up page for parent–teacher days, the Moodle learning platform, the printer's web interface: a school runs many websites that should only be reachable in its own network. A **web server** delivers them, often several sites on one server, distinguished by name (*virtual hosts*), and encrypted with **HTTPS**.

## Dependencies

- Session 1: none (access via the IP address).
- Session 2: DNS (team 2) for names, directory service (team 3) for a site with login.

## Goal in the Windows world

- **Web Server (IIS)** role installed.
- Two sites on **one** server, distinguished by host name: `intranet-win.labor.test` (substitution plan as a simple HTML page) and `eltern-win.labor.test`.
- HTTPS with a **self-signed** certificate, HTTP redirects to HTTPS.
- Hint: `Install-WindowsFeature Web-Server -IncludeManagementTools`, module `IISAdministration` (`New-IISSite`), certificate with `New-SelfSignedCertificate`.

## Goal in the Linux world

- Package `nginx` installed.
- The same two sites as `server` blocks: `intranet-lx.labor.test` and `eltern-lx.labor.test`, files under `/var/www/…`, configuration under `/etc/nginx/sites-available/` with a link in `sites-enabled/`.
- HTTPS with a self-signed certificate (`openssl req -x509 …`), redirect from HTTP to HTTPS.
- Check before every reload: `nginx -t`.

## Goal in session 2

1. Team 2 adds the four names to `labor.test`. The sites are reachable from the test client by name.
2. **Login:** the `intranet` site is only reachable after login. Windows: *Windows Authentication* with a domain account. Linux: simple login (`auth_basic`) as a first step; login against the directory service is an extension.
3. In the demo, the lecturer shows how a certificate from the school's **own certificate authority** removes the browser warning.

## Acceptance tests

| Test | Windows test client | Linux test client |
|---|---|---|
| Site by IP | browser: `http://10.50.13.15` | `curl -I http://10.50.13.26` |
| Virtual hosts | `curl.exe -k -H "Host: eltern-win.labor.test" https://10.50.13.15` | `curl -k -H 'Host: eltern-lx.labor.test' https://10.50.13.26` |
| Redirect | `http://…` ends up at `https://…` | `curl -I http://10.50.13.26` shows `301` |
| By name (session 2) | browser: `https://intranet-lx.labor.test` | browser: `https://intranet-win.labor.test` |

## Pitfalls

- A self-signed certificate is **encrypted but not trusted**: the browser rightly warns. Getting teachers used to clicking warnings away is dangerous at a school.
- Public authorities such as *Let's Encrypt* do not issue certificates for internal names, because the names cannot be verified from the internet.
- nginx: forgotten link in `sites-enabled` – the site exists but is not served.
- IIS: the *Default Web Site* occupies port 80 for all names. Set bindings explicitly.

## Entry points

- Microsoft Learn: [IIS web server (overview)](https://learn.microsoft.com/en-us/iis/get-started/introduction-to-iis/iis-web-server-overview), [IISAdministration module](https://learn.microsoft.com/en-us/powershell/module/iisadministration/)
- nginx: [Beginner's Guide](https://nginx.org/en/docs/beginners_guide.html), [Configuring HTTPS servers](https://nginx.org/en/docs/http/configuring_https_servers.html)
- Debian Wiki: [Nginx](https://wiki.debian.org/Nginx)

## Comparison questions

- Which school web applications (Moodle, Nextcloud, WebUntis alternatives) run on which world? What do their vendors recommend?
- How much memory does the server need in each world just to deliver an empty page?
- Who at a school is responsible for the content, who for the technology (imprint, accessibility, privacy statement)?
- Why do a large share of all web servers worldwide run on Linux?
