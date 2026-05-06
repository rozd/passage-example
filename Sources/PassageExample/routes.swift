import Vapor
import Passage

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    let protected = app
        .grouped(PassageSessionAuthenticator())
        .grouped(PassageBearerAuthenticator())
        .grouped(PassageGuard())

    protected.get("protected") { req async throws -> String in
        let user = try req.passage.user
        return "Hello, \(String(describing: user.id))!"
    }

    protected.get("dashboard") { req async throws in
        let view = try DashboardView(
            theme: .mintDark,
            params: .init(
                user: req.passage.user,
                logoutRoute: "/auth/logout"
            )
        )

        return try await req.view.render("dashboard", view)
    }
}
