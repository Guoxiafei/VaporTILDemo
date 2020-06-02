//
/**
* @Name: UserController.swift
* @Description:
* @Author: guoxiafei
* @Date: 2020/6/2
* @Copyright: 
*/


import Foundation
import Vapor

struct UserController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api","users")

        usersRoute.post(User.self, use: creatHandler(_:user:))
        usersRoute.get( use: getAllHandler(_:))
        usersRoute.get(User.parameter, use: getHandler(_:))
    }

    func creatHandler(_ req: Request, user:User) throws -> Future<User> {
        return user.save(on: req)
    }

    func getAllHandler(_ req:Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    func getHandler(_ req : Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
}
