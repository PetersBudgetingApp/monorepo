# Velum Privacy Policy

_Last updated: February 25, 2026_

---

## Overview

Velum is a personal budgeting app. This policy explains what data Velum collects, where it is stored, and how it is used. The short version: Velum does not operate any servers, does not collect analytics, and does not have access to your data.

---

## Data We Collect

### Financial Data
Velum stores account information and transaction records that you either import via SimpleFIN or add manually. This data is created by you and belongs entirely to you.

### No Analytics or Crash Reporting
Velum does not include any analytics SDKs, crash reporters, or telemetry of any kind. No usage data, device identifiers, or behavioral data is ever collected.

---

## Where Your Data Is Stored

### Default: iCloud
By default, all of your data is stored in your personal iCloud account using Apple's CloudKit framework. Velum has no access to this data. It is subject to [Apple's iCloud privacy policy](https://www.apple.com/legal/privacy/).

### Optional: Self-Hosted Server
If you choose to self-host a Velum server, your data is stored on your own infrastructure. Velum (the project) has no access to data on self-hosted instances. You are responsible for the security and privacy of your own server.

When running a self-hosted server, your server will generate standard web server access logs. These logs may include:
- Request paths and query parameters (e.g. `/api/v1/analytics/spending?startDate=...`)
- HTTP method, status code, and response size
- Timestamp of each request
- Browser user agent string
- Referrer URL
- Network-level IP address as seen from the server (typically a private or internal network address, depending on your network configuration)

These logs are stored on your own server and are not sent to Velum or any third party.

---

## SimpleFIN

If you choose to link financial institutions, Velum uses [SimpleFIN](https://beta-bridge.simplefin.org) to retrieve your transaction data. SimpleFIN acts as a read-only data bridge between your financial institutions and Velum. Your banking credentials are never stored by SimpleFIN or shared with Velum.

For full details on how SimpleFIN handles your data, see [SimpleFIN's security page](https://beta-bridge.simplefin.org/info/security).

---

## Data Sharing

Velum does not sell, share, or transmit your data to any third party. The only data movement that occurs is:
- Between your device and your iCloud account (if using iCloud storage).
- Between your device and your self-hosted server (if you have configured one).
- Between your device and SimpleFIN's servers (if you have connected financial institutions).

---

## Data Deletion

Because Velum does not store your data on any Velum-operated servers, data deletion is handled entirely by you:
- **iCloud data** can be deleted by removing the app or clearing its iCloud storage from your device settings.
- **Self-hosted server data** can be deleted by removing your account or wiping your server's database directly.

---

## Children's Privacy

Velum is not directed at children under the age of 13 and does not knowingly collect data from children.

---

## Changes to This Policy

If this policy is updated, the "Last updated" date at the top of this document will be changed. Significant changes will be noted in the app's release notes.

---

## Contact

If you have questions or concerns about this privacy policy, please email [petergelgor7@gmail.com](mailto:petergelgor7@gmail.com).
