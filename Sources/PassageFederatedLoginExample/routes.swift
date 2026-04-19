import Vapor
import Passage

func routes(_ app: Application) throws {
    app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app
        .grouped(PassageSessionAuthenticator())
        .grouped(PassageBearerAuthenticator())
        .grouped(PassageGuard())
        .get("protected") { req async throws -> String in
            let user = try req.passage.user
            return "Hello, \(String(describing: user.id))!"
    }
}
