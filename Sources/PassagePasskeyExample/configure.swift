import Leaf
import Vapor
import Passage
import PassageWebAuthn
import PassageOnlyForTest

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // enable Leaf templating to use Passage's built-in views
    app.views.use(.leaf)

    // enable sessions middleware
    app.middleware.use(app.sessions.middleware)

    // Configure Passage with in-memory store for testing
    try await app.passage.configure(
        services: .init(
            store: Passage.OnlyForTest.InMemoryStore(),
            emailDelivery: nil,
            phoneDelivery: nil,
            passkey: WebAuthnPasskeyService(
                configuration: .init(
                    relyingPartyID: "localhost",
                    relyingPartyName: "Passage Demo",
                    relyingPartyOrigin: "http://localhost:8080",
                )
            ),
        ),
        configuration: .init(
            origin: URL(string: "http://localhost:8080")!,
            sessions: .init(enabled: true),
            jwt: .init(
                jwks: .file(path: "\(app.directory.workingDirectory)keypair.jwks")
            ),
            passwordless: .init(
                emailMagicLink: .email(
                    autoCreateUser: true,
                    requireSameBrowser: true
                )
            ),
            verification: .init(
                email: .init(
                    codeLength: 6,
                    codeExpiration: 600,
                    maxAttempts: 5
                )
            ),
            restoration: .init(
                preferredDelivery: .email,
                email: .init(
                    codeLength: 6,
                    codeExpiration: 600,
                    maxAttempts: 5
                )
            ),
            views: .init(
                register: .init(
                    style: .minimalism,
                    theme: .init(
                        colors: .mintDark
                    ),
                    identifier: .username
                ),
                login: .init(
                    style: .minimalism,
                    theme: .init(
                        colors: .mintDark
                    ),
                    identifier: .username
                ),
                passkeySignup: .init(
                    style: .minimalism,
                    theme: .init(
                        colors: .mintDark
                    ),
                    identifier: .username
                ),
                passkeyAuthenticate: .init(
                    style: .minimalism,
                    theme: .init(
                        colors: .mintDark
                    ),
                    redirect: .init()
                )
            )
        )
    )

    // register routes
    try routes(app)
    printRegisteredRoutes(app)
}

// MARK: - Debugging Helpers

func printRegisteredRoutes(_ app: Application) {
    app.logger.info("Registered routes:")
    for route in app.routes.all {
        let method = String(describing: route.method)
        let path = route.path.map { $0.description }.joined(separator: "/")
        // use logger or print
        app.logger.info("\(method) /\(path)")
    }
}
