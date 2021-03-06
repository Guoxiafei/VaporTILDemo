//import FluentSQLite
import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
//    try services.register(FluentSQLiteProvider())
    try services.register(FluentMySQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
//    let sqlite = try SQLiteDatabase(storage: .memory)
//    let sqlite = try SQLiteDatabase(storage: .file(path: "/Users/guoxiafei/Desktop/Study/sqlite/db.sqlite"))

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()

//    databases.add(database: sqlite, as: .sqlite)

//    let databaseConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "sqluser", password: "qwer1234", database: "vaporTIL")

    let databaseConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3307, username: "vapor", password: "password", database: "vapor")

    let database = MySQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .mysql)


    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
//    migrations.add(model: Todo.self, database: .sqlite)
//    migrations.add(model: Acronym.self, database: DatabaseIdentifier<Acronym.Database>.sqlite)

    migrations.add(model: Acronym.self, database: DatabaseIdentifier<Acronym.Database>.mysql)

    services.register(migrations)
}
