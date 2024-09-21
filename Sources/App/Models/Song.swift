//
//Song.swift

//
//
//  Created by 赵康 on 2024/9/18.
//

import Foundation
import Fluent
// 服务器端的Swift框架, 用于构建Web应用程序和APIs
import Vapor

// Model提供数据库表对应的字段和行为, Content使模型可以作为JSON编码和解码

final class Song: Model, Content, @unchecked Sendable {
//    与数据库中的song表进行交互
    static let schema: String = "songs"
    
//    定义表的主键字段(表的唯一标识符)
    @ID(key: .id)
    var id: UUID? // 创建实例时ID可以为空, 数据库会自动生成UUID值
    
    //    定义表的普通字段
    @Field(key: "title")
    var title: String
    
//    允许创建一个空的Song对象
    init() {}
    
    
    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
