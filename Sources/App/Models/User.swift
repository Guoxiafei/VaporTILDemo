//
/**
 * @Name: User.swift
 * @Description:
 * @Author: guoxiafei
 * @Date: 2020/6/2
 * @Copyright:
 */

import FluentMySQL
import Foundation
import Vapor

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String

    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User: MySQLUUIDModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}
