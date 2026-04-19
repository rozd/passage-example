// swift-tools-version:6.3
import PackageDescription

let package = Package(
    name: "PassageExample",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.121.4"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.13.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.12.0"),
        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "4.5.1"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.98.0"),
        // ✉️ Mailgun email sending package for Vapor.
        .package(url: "https://github.com/vapor-community/mailgun.git", from: "6.0.1"),
        // 🔐 OAuth2 authentication framework for Vapor.
        .package(url: "https://github.com/vapor-community/Imperial.git", from: "2.2.0"),
        // 🛂 Authentication and user management for Vapor.
        .package(url: "https://github.com/rozd/passage", branch: "main"),
        .package(url: "https://github.com/rozd/passage-fluent", branch: "main"),
        .package(url: "https://github.com/rozd/passage-imperial", branch: "main"),
        .package(url: "https://github.com/rozd/passage-webauthn", branch: "main"),
        .package(url: "https://github.com/rozd/passage-mailgun", branch: "main"),

    ],
    targets: [
        .executableTarget(
            name: "PassageExample",
            dependencies: [
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Passage", package: "passage"),
                .product(name: "PassageOnlyForTest", package: "passage"),
            ],
            swiftSettings: swiftSettings
        ),
        .executableTarget(
            name: "PassageFederatedLoginExample",
            dependencies: [
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Passage", package: "passage"),
                .product(name: "PassageOnlyForTest", package: "passage"),
                .product(name: "PassageFluent", package: "passage-fluent"),
                .product(name: "PassageImperial", package: "passage-imperial"),
            ]
        ),
        .executableTarget(
            name: "PassagePasskeyExample",
            dependencies: [
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Passage", package: "passage"),
                .product(name: "PassageOnlyForTest", package: "passage"),
                .product(name: "PassageWebAuthn", package: "passage-webauthn"),
            ]
        ),
        .testTarget(
            name: "PassageExampleTests",
            dependencies: [
                .target(name: "PassageExample"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
