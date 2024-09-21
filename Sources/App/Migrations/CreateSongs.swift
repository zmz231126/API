//
//CreateSongs.swift
//
//
//  Created by 赵康 on 2024/9/18.
//

import Foundation
import Fluent // Vapor中的ORM(对象关系映射)框架, 帮助你与数据库交互
import Vapor
struct CreateSongs: Migration {
    // 创建表
    func prepare(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }
//    删除表
    func revert(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("songs").delete()
    }
    

}





/*
 Migration是Fluent框架中用于管理数据库架构更改的功能
 */
