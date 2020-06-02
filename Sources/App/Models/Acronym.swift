//
/**
 * @Name: Acronym.swift
 * @Description:
 * @Author: guoxiafei
 * @Date: 2020/6/1
 * @Copyright:
 */

//import FluentSQLite
import FluentMySQL
import Vapor

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String

    init(short: String, long: String) {
        self.short = short
        self.long = long
    }
}

// extension Acronym : Model{
//    typealias Database = SQLiteDatabase
//
//    typealias ID = Int
//
//    public static var idKey: IDKey = \Acronym.id
// }

// Fluent为每个数据库provider提供Model帮助协议，因此您不必指定数据库或ID类型或 key。 SQLiteModel协议必须具有名称为id的可选Int类型的ID，但对于ID为UUID或 String的模型，有SQLiteUUIDModel和SQLiteStringModel协议。如果要⾃定义ID属性名称，则必须遵循标准Model协议
//extension Acronym: SQLiteModel {}
extension Acronym : MySQLModel {}

// 要将模型保存在数据库中，必须为其创建表。 Fluent通过migration完成此操作。
// Migrations允许您对数据库进⾏可靠，可测试，可重现的更改。它们通常⽤于为模型创
// 建database schema或表描述。它们还⽤于将数据输⼊数据库中，或在模型保存后对其
// 进⾏更改。
extension Acronym: Migration {}

extension Acronym: Content {}

extension Acronym: Parameter {}
