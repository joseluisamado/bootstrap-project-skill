# CSP headers

The skill does not scaffold Content-Security-Policy headers by default. CSP is high-friction (debugging "why does my page look broken?" is hard), and for the libreta-shaped target (self-hosted personal apps with no untrusted content), risk is low.

## When to add CSP

Add a CSP header when **any** is true:

- The project accepts content from untrusted sources (third-party imports, user submissions, public push access).
- The project will be used by people other than the operator.
- The project wraps externally embedded content (iframes, third-party scripts, CDN assets).
- Compliance requirements demand it.

For the libreta shape — single operator, content authored by the operator — none of these typically applies. But the moment any does, add CSP.

## Minimum useful CSP

Start strict, then loosen as needed:

```
Content-Security-Policy: default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; frame-src 'self' http://drawio:8080
```

Read each directive:

- `default-src 'self'` — by default, only same-origin resources.
- `script-src 'self'` — no inline scripts, no eval. Likely needs work in apps that use inline event handlers.
- `style-src 'self' 'unsafe-inline'` — Tailwind / CSS-in-JS often need inline styles. Tighten if your app doesn't.
- `img-src 'self' data:` — same-origin plus data URIs (common for SVG icons, base64 thumbnails).
- `frame-src 'self' http://drawio:8080` — explicit allowlist for iframes (libreta-style drawio integration).

## Header vs meta tag

Prefer the HTTP header over `<meta http-equiv="Content-Security-Policy">`. Headers apply to all responses; meta tags only apply to the document they're in (and don't apply to e.g. `Refresh` redirects).

In a Caddy reverse proxy, set headers in the Caddyfile:

```
header Content-Security-Policy "default-src 'self'; ..."
```

## Reporting

For early adoption, use `Content-Security-Policy-Report-Only` to log violations without blocking. Switch to `Content-Security-Policy` once the policy is stable.

## Other security headers worth setting

- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY` (or `SAMEORIGIN` if the app uses its own iframes)
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy: geolocation=(), microphone=(), camera=()` — disable APIs the app doesn't use.

These are cheap additions; the Caddy template can include them as commented examples.
