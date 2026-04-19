# PassageExample

Example Vapor applications demonstrating the [Passage](https://github.com/rozd/passage) authentication framework. Each example target wires up a different combination of Passage services (storage, email delivery, federated login, passkeys) so you can pick the one closest to your use case and adapt it.

## Examples

This package ships three independent executable targets:

| Target | Storage | Highlights |
| --- | --- | --- |
| `PassageExample` | In-memory | Minimal setup — username + password and email magic link. Good starting point for exploring the API surface without external services. |
| `PassageFederatedLoginExample` | Postgres via `PassageFluent` | OAuth federated login (GitHub + Google) via `PassageImperial`, with automatic account linking by email/phone. |
| `PassagePasskeyExample` | In-memory | WebAuthn-based passkey registration and authentication via `PassageWebAuthn`, with built-in Leaf views for the passkey ceremonies. |

All three share the same JWT key material (`keypair.jwks`), Leaf-rendered views (mint-dark theme), session middleware, and email magic-link configuration.

## Getting Started

### Prerequisites

- Swift 6.0+
- macOS 13+
- For `PassageFederatedLoginExample`: a running Postgres instance (see `docker-compose.yml`)

### Building

```bash
swift build
```

### Running an example

Because the package contains multiple executable targets, you must specify which one to run:

```bash
# Basic in-memory example
swift run PassageExample

# OAuth federated login with Postgres
swift run PassageFederatedLoginExample

# Passkey / WebAuthn example
swift run PassagePasskeyExample
```

The server listens on `http://localhost:8080` by default.

### Federated login configuration

`PassageFederatedLoginExample` reads database connection details and OAuth credentials from the environment:

```bash
# Postgres (defaults shown)
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=vapor_username
DATABASE_PASSWORD=vapor_password
DATABASE_NAME=passage_example

# OAuth providers (required by Imperial)
GITHUB_CLIENT_ID=...
GITHUB_CLIENT_SECRET=...
GOOGLE_CLIENT_ID=...
GOOGLE_CLIENT_SECRET=...
```

A `docker-compose.yml` is provided to bring up a local Postgres for development.

### Passkey configuration

`PassagePasskeyExample` is configured for `localhost` as the WebAuthn relying party. Browsers require WebAuthn over `https://` — except for `localhost`, which is treated as a secure context, so the example works as-is during local development.

## Project Layout

```
Sources/
├── PassageExample/                  # In-memory store, password + magic link
├── PassageFederatedLoginExample/    # Postgres + Imperial OAuth
└── PassagePasskeyExample/           # WebAuthn passkeys
keypair.jwks                         # JWT signing keys (dev only)
docker-compose.yml                   # Local Postgres for the federated example
```

Each target follows the standard Vapor layout: `entrypoint.swift` boots the application, `configure.swift` wires up Passage and middleware, and `routes.swift` registers any app-specific routes on top of the ones Passage provides.

## Testing

```bash
swift test
```

## See more

- [Passage on GitHub](https://github.com/rozd/passage)
- [Vapor Website](https://vapor.codes)
- [Vapor Documentation](https://docs.vapor.codes)
- [WebAuthn / Passkeys](https://www.w3.org/TR/webauthn-3/)
