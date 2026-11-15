+++
title = "Demo: certificate services"
weight = 70
+++

**When:** 23.11.2026, approx. 15 min within the 10:30–11:15 block · **Who:** lecturer (demonstration), for everyone to read afterwards · **Machines:** `10.50.13.18` (Windows), `10.50.13.29` (Linux)

{{% callout style="info" title="Demonstration, not a team task" %}}
Certificate services are **not** a team's role. Your own certificate authority is hard to undo (see below) and depends on the directory service. That is why the lecturer shows it once in each world.
{{% /callout %}}

{{% callout style="warning" title="Status: untested" %}}
The commands have **not** yet been run in the Proxmox lab. *Tested on: open.*
{{% /callout %}}

## What it is about

Team 6's websites run with HTTPS, but with **self-signed** certificates. The browser warns, and rightly so: it cannot check whether it is really talking to the school server. Public authorities such as *Let's Encrypt* do not issue certificates for internal names like `intranet-win.labor.test`.

The solution is the school's **own certificate authority** (CA):

1. The CA creates a **root certificate** and keeps its private key secret.
2. All school devices trust this root certificate.
3. The CA issues certificates for internal servers. Because the devices trust the CA, they also trust these certificates: **no more warning**.

## What a school needs its own CA for

| Use | What the certificate provides |
|---|---|
| **Internal websites** (intranet, Moodle, printer interfaces) | HTTPS without browser warning |
| **Wi-Fi with 802.1X** (EAP-TLS) | teachers' devices log in with a certificate instead of a shared Wi-Fi password and automatically end up in the right VLAN (see [chapter 3]({{% relref "/03-networking-2/theory" %}}#vlans-in-wi-fi)) |
| **Device management** (session 5) | Intune and other MDM systems distribute device certificates (SCEP, PKCS) |
| **Directory service** | encrypted LDAP connections (LDAPS) between servers |

## Part 1: Windows world with AD CS (approx. 7 min)

Prerequisite: `10.50.13.18` is a member of `win.schule.lan`. An **enterprise CA** needs Active Directory: it publishes its root certificate there, and all domain members trust it automatically.

```powershell
# on 10.50.13.18, as domain administrator
Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
Install-AdcsCertificationAuthority -CAType EnterpriseRootCa `
    -CACommonName "Schule Musterstadt Root CA" `
    -KeyLength 4096 -HashAlgorithmName SHA256 `
    -ValidityPeriod Years -ValidityPeriodUnits 10
```

Issue a certificate for team 6's website and bind it in IIS:

```powershell
# on 10.50.13.15 (IIS), as domain administrator
$cert = Get-Certificate -Template WebServer `
    -DnsName intranet-win.labor.test `
    -CertStoreLocation Cert:\LocalMachine\My
$thumb = $cert.Certificate.Thumbprint
# remove team 6's existing HTTPS binding, then bind again
# ("intranet" = name of the site that team 6 chose)
New-IISSiteBinding -Name "intranet" -Protocol https `
    -BindingInformation "*:443:intranet-win.labor.test" -SslFlag Sni `
    -CertificateThumbPrint $thumb -CertStoreLocation "Cert:\LocalMachine\My"
```

Show:

1. On the Windows test client run `gpupdate /force`, then show the new CA in `certlm.msc` under *Trusted Root Certification Authorities*.
2. In the browser, `https://intranet-win.labor.test`: **no warning**, padlock, certificate chain up to the school CA.
3. Counter-check on the **Linux** test client: the warning remains. It is not in the Windows domain and does not know the CA.

## Part 2: Linux world with step-ca (approx. 5 min)

[step-ca](https://smallstep.com/docs/step-ca/) by Smallstep is a free certificate authority. Install it beforehand on `10.50.13.29` following the official instructions (Debian packages `step-cli` and `step-ca`). Team 2 adds `ca.labor.test → 10.50.13.29` to the zone `labor.test`.

```bash
# on 10.50.13.29: set up the CA (once, beforehand)
step ca init --name "Schule Musterstadt Linux CA" \
    --dns ca.labor.test --address :443 --provisioner admin
step-ca $(step path)/config/ca.json      # start the CA (in the foreground for the demo)

# issue a certificate for team 6's nginx site
step ca certificate intranet-lx.labor.test intranet-lx.crt intranet-lx.key
```

Copy certificate and key to `10.50.13.26` and enter them in nginx as `ssl_certificate` and `ssl_certificate_key`, then `nginx -t`, `systemctl reload nginx`.

Make the Linux test client trust the CA:

```bash
# the root certificate is on 10.50.13.29 under $(step path)/certs/root_ca.crt;
# copy it to the test client and add it system-wide
sudo cp root_ca.crt /usr/local/share/ca-certificates/schule-linux-ca.crt
sudo update-ca-certificates
curl https://intranet-lx.labor.test     # without -k, without warning
```

Show:

1. `curl` works without `-k`.
2. **Validity:** `step certificate inspect intranet-lx.crt` shows that the certificate is valid for only **24 hours** (step-ca default). Short-lived certificates are more secure but have to be renewed automatically, e.g. via **ACME**, the same protocol Let's Encrypt uses. step-ca can offer ACME.
3. Firefox uses its own certificate store. The CA has to be added there as well (or via policy for all devices).

## Part 3: why a CA is hard to undo (approx. 3 min)

- After a short time, the root certificate is on **every** school device. Whoever rebuilds the CA has to re-equip every device and replace every certificate issued.
- Whoever steals the CA's **private key** can issue valid certificates for any name, even for `bank.at`, which the school devices will then trust. The key is the most valuable secret in the school network.
- In practice you therefore build **two tiers**: a root CA that is almost always **switched off** (offline), and an issuing CA below it. The demo simplifies this to one tier.
- The name, lifetime and key length of the CA cannot be changed afterwards. That is why a CA is **planned and documented** before it is installed, e.g. with an architecture decision record (ADR, see [session 6]({{% relref "/06-it-security-data-protection" %}})).

## Comparison

| | AD CS (Windows) | step-ca (Linux) |
|---|---|---|
| Licence | included in Windows Server; server licence and CALs needed | free software (Apache 2.0) |
| Distribution of the root certificate | automatic to all domain members | distribute yourself (configuration management, MDM, policy) |
| Automatic renewal | *autoenrollment* for domain members | ACME (like Let's Encrypt), also for non-Windows devices |
| Typical strength | Windows clients, Wi-Fi with 802.1X in an AD environment | servers, containers, mixed environments, short-lived certificates |

## Sources

- Microsoft Learn: [Active Directory Certificate Services (overview)](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/active-directory-certificate-services-overview), [Install-AdcsCertificationAuthority](https://learn.microsoft.com/en-us/powershell/module/adcsdeployment/install-adcscertificationauthority)
- Smallstep: [step-ca documentation](https://smallstep.com/docs/step-ca/), [installation](https://smallstep.com/docs/step-ca/installation/)
- IETF: [RFC 5280, X.509 Public Key Infrastructure Certificate Profile](https://www.rfc-editor.org/rfc/rfc5280), [RFC 8555, ACME](https://www.rfc-editor.org/rfc/rfc8555)
- Debian: `man update-ca-certificates`
