//
//SongController.swift
//  
//
//  Created by 赵康 on 2024/9/18.
//

import Fluent
import Vapor

// 定义路由的注册逻辑
struct SongController: RouteCollection {
    
//    boot方法会在服务器启动时被调用, 负责定义和注册路由
    func boot(routes: any RoutesBuilder) throws {
        
//       创建一个以songs开头的路由组
        let songs = routes.grouped("songs")
        
//       当GET/songs时, 调用index函数来处理请求
        songs.get(use: index)
//        进行一个POST/songs时,调用create函数来处理
        songs.post(use: create)
//        进行一个PUT/songs/id
        songs.put(use: update)
//        进行一个DELETE请求/songs/:songID
        songs.group(":songID") { song in // 注意分号不能少,表示动态参数
            song.delete(use: delete)
        }
    }
    
    @Sendable
//    异步返回一个包含Song数据的JSON数组
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
//    从HTTP请求中解析出一个Song类型的对象, 将其保存到数据库中, 如果保存成功, 返回状态码
    @Sendable
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }
    
//    PUT Request
    @Sendable
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        // 解码一个Song对象
        let song: Song = try req.content.decode(Song.self)
        // 查找该id对应的Song对象
        return Song.find(song.id, on: req.db)
        // unwrap(or:) 方法用于将一个 Optional 值转换为非 Optional 类型，如果 Optional 值为 nil，则抛出一个错误。
        .unwrap(or: Abort(.notFound))
        // 更新该对象
        .flatMap {
             $0.title = song.title 
             // 保存到数据库
             return $0.update(on: req.db).transform(to: .ok)
        }
    }
//    DELETE Request
    @Sendable
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        // 从请求中获取 songID 参数并将其转换为 UUID
        guard let songIDString = req.parameters.get("songID"), let songID = UUID(songIDString) else {
            throw Abort(.badRequest)
        }
        print("Deleting song with ID: \(songID)")
        
        // 在数据库中查找对应ID的Song对象
        return Song.find(songID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}

 



//================================================================
/*
 每一个row都是一个Song实例
 
 query(on: req.db) 表示我们要在某个特定的数据库实例上对 Song 表进行查询。req.db 是从 Request 对象中获取的数据库连接，这个 req 是 HTTP 请求的上下文，req.db 让我们可以在当前请求中与数据库交互。
 
 
 动态参数（Dynamic Parameters）是指在程序运行时根据实际情况而动态决定的参数。与静态参数不同，动态参数的值在编写代码时并不是固定的，而是通过用户输入、外部请求或其他运行时环境来获取和使用的。
 */
