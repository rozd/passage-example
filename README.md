# PassageExample

A collection of [Vapor](https://vapor.codes) applications demonstrating the [Passage](https://github.com/vapor-community/passage) authentication framework. Each example is an independent executable target that wires up a different combination of Passage services — pick the one closest to your use case and adapt it.

## Getting Started

### Prerequisites

- Swift 6.0+
- macOS 13+
- A Postgres instance — only required for `PassageFederatedLoginExample`

### Build

```bash
swift build
```

### Run

This package contains multiple executable targets, so you must name the one you want to run:

```bash
swift run <TargetName>
```

The server listens on `http://localhost:8080`. JWT signing keys are loaded from `keypair.jwks` at the project root.

See the [Examples](#examples) section below for the available targets and any per-example setup.

## Examples

<details>
<summary><h3>PassageExample</h3> — minimal in-memory setup</summary>

Demonstrates the smallest viable Passage configuration: an in-memory store, username + password registration, email magic-link passwordless login, JWT access tokens, sessions, and the built-in Leaf register/login views. No external services required — ideal for exploring the API surface.

```bash
swift run PassageExample
```
</details>

<details>
<summary><h3>PassageFederatedLoginExample</h3> — OAuth federated login</summary>

Demonstrates federated login via [`PassageImperial`](https://github.com/rozd/passage-imperial) (GitHub + Google), backed by a Postgres database via [`PassageFluent`](https://github.com/rozd/passage-fluent). Includes automatic account linking by email or phone, with a manual fallback when multiple matches exist.

#### Additional setup:
Provide a running Postgres instance and OAuth credentials via environment variables:

```bash
# Postgres (defaults shown)
export DATABASE_HOST=localhost
export DATABASE_PORT=5432
export DATABASE_USERNAME=vapor_username
export DATABASE_PASSWORD=vapor_password
export DATABASE_NAME=passage_example

# OAuth providers
export GITHUB_CLIENT_ID=...
export GITHUB_CLIENT_SECRET=...
export GOOGLE_CLIENT_ID=...
export GOOGLE_CLIENT_SECRET=...
```

Configure the OAuth callback URLs in your provider dashboards to point at `http://localhost:8080`.

```bash
swift run PassageFederatedLoginExample
```

</details>

<details>
<summary><h3>PassagePasskeyExample</h3> — WebAuthn passkeys</summary>

Demonstrates passwordless authentication with WebAuthn passkeys via [`PassageWebAuthn`](https://github.com/rozd/passage-webauthn). Uses an in-memory store and ships the built-in Leaf views for the passkey signup and authentication ceremonies. The relying party is configured as `localhost` / `Passage Demo`.

#### Additional setup:
WebAuthn requires a secure context. Browsers treat `localhost` as secure, so the example works over plain `http://` during local development — no TLS setup needed. If you change the host, you'll need HTTPS and matching `relyingPartyID` / `relyingPartyOrigin` values in `Sources/PassagePasskeyExample/configure.swift`.

```bash
swift run PassagePasskeyExample
```

</details>

## See also

- [Passage](https://github.com/vapor-community/passage) — core authentication framework
- [Vapor Documentation](https://docs.vapor.codes)
- [WebAuthn / Passkeys spec](https://www.w3.org/TR/webauthn-3/)
