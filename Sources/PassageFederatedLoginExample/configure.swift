import Leaf
import Vapor
import Fluent
import FluentPostgresDriver
import Passage
import PassageOnlyForTest
import PassageFluent
import PassageImperial
import ImperialGoogle
import ImperialGitHub

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "passage_example",
        tls: .disable)
//        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    // enable Leaf templating to use Passage's built-in views
    app.views.use(.leaf)

    // enable sessions middleware
    app.middleware.use(app.sessions.middleware)

    // Configure Passage with in-memory store for testing
    try await app.passage.configure(
        services: .init(
            store: DatabaseStore(app: app, db: app.db),
            emailDelivery: Passage.OnlyForTest.MockEmailDelivery(callback: { email in
                print(">>> \(String(describing: email.verificationURL))")
            }),
            phoneDelivery: nil,
            federatedLogin: ImperialFederatedLoginService(
                services: [
                    .github          : GitHub.self,
                    .named("google") : Google.self,
                ]
            )
        ),
        configuration: .init(
            origin: URL(string: "http://localhost:8080")!,
            routes: .init(
                group: "auth",
            ),
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
            federatedLogin: .init(
                routes: .init(group: "connect"),
                providers: [
                    .init(provider: .google()),                         // /auth/connect/google
                    .init(provider: .github())                          // /auth/connect/github
                ],
                accountLinking: .init(
                    resolution: .automatic(
                        matchBy: [.email, .phone],                      // Match only verified identifiers
                        onAmbiguity: .requestManualSelection            // Fall back to manual on multiple matches
                    ),
                    stateExpiration: 600                                // Manual linking flow TTL (seconds)
                ),
                redirectLocation: "/dashboard"
            ),
            views: .init(
                register: .init(
                    style: .minimalism,
                    theme: .init(
                        colors: .mintDark
                    ),
                    identifier: .email
                ),
                login: .init(
                    style: .minimalism,
                    theme: .init(
                        colors: .mintDark
                    ),
                    identifier: .email
                ),
                linkAccountSelect: .init(
                    style: .minimalism,
                    theme: .init(
                        colors: .mintDark
                    ),
                ),
                linkAccountVerify: .init(
                    style: .minimalism,
                    theme: .init(
                        colors: .mintDark
                    ),
                ),
            )
        )
    )

    // register routes
    try routes(app)

    printRegisteredRoutes(app)
}

func printRegisteredRoutes(_ app: Application) {
    app.logger.info("Registered routes:")
    for route in app.routes.all {
        let method = String(describing: route.method)
        let path = route.path.map { $0.description }.joined(separator: "/")
        // use logger or print
        app.logger.info("\(method) /\(path)")
    }
}
