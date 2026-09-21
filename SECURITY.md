# Security Policy

Festival ships `camp`, `fest`, and `festival`. Security reports are taken seriously.

## Reporting a vulnerability

Email **contact@obediencecorp.com**. Please do not open a public issue for a
suspected vulnerability.

Include what you found, the affected version or commit, and, if you have
one, a minimal reproduction. You can expect an acknowledgment within 5
business days and a decision on scope and fix timeline within 14 days of
that acknowledgment.

## Scope

In scope:

- The `festival` installer and the release artifacts this repository publishes.
- Install scripts, packaging, and the workflows that build and publish them.
- The plugin in this repository, including the session hook that downloads `fest` and `camp`.
- Vulnerabilities in the `camp` and `fest` versions pinned and shipped from here. Those tools are developed in their own repositories; mail sent to this address is routed to the owning repository.

What the installer signs, where those checks run, and what they do not cover are documented in the installer security policy: <https://github.com/Obedience-Corp/festival-installer/blob/main/SECURITY.md>.
