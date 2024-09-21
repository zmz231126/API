// 确保数据通信通过安全的加密通道进行
import NIOSSL

// 允许用户通过模型来与数据库交互,而不是直接编写SQL语句
import Fluent

// 数据库驱动
import FluentPostgresDriver


import Vapor

// configures your application
public func configure(_ app: Application) async throws {

    
//*************数据库连接配置****************
    
    
    // 使用use方法来配置数据库
    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        
        // 配置数据库的主机名
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        // 设置数据库的端口号, 默认使用标准PostgreSQL端口
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        // 设置数据库用户名
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        // 设置数据库密码
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        // 设置数据库名
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        // 启用TLS加密
        tls: .prefer(try .init(configuration: .clientDefault)))
     // 指定数据库类型为PostgreSQL
    ), as: .psql)
    
    
//************数据库迁移***********************
    
    // 添加一个迁移任务到迁移队列
    app.migrations.add(CreateSongs())
    // 自动执行所有的数据库迁移, 确保数据库的结构与应用程序一致
    try await app.autoMigrate().get()
    
    
    
//***************路由注册**********************
    
    // 注册应用程序的所有路由, 当用户访问某个URL时, 服务器应该执行什么操作
    try routes(app)
}
