//
/**
* @Name: AcronymsController.swift
* @Description:
* @Author: guoxiafei
* @Date: 2020/6/2
* @Copyright: 
*/


import Vapor
import Fluent

struct AcronymsController : RouteCollection {
    func boot(router: Router) throws {
//        router.get("api","acronyms", use: getAllHandler)
        let acronymsRouters = router.grouped("api","acronyms")

        acronymsRouters.get( use: getAllHandler)
//        acronymsRouters.post( use: creatHandle)
        acronymsRouters.post(Acronym.self, use: creatHandler(_:acronym:))
        acronymsRouters.get(Acronym.parameter, use: getHandle)
        acronymsRouters.put(Acronym.parameter, use: updateHandle)
        acronymsRouters.delete(Acronym.parameter, use: deleteHandler(_:))
        acronymsRouters.get("search", use: searchHandler(_:))
        acronymsRouters.get("first", use: getFirstHandler(_:))
        acronymsRouters.get("sorted", use: sortedHandler(_:))
    }

    func getAllHandler(_ req: Request) throws -> Future<[Acronym]> {
        return Acronym.query(on: req).all()
    }

//    func creatHandle(_ req: Request) throws -> Future<Acronym> {
//        return try req.content.decode(Acronym.self)
//            .flatMap(to: Acronym.self) { (acronym) in
//                return acronym.save(on: req)
//        }
//    }

    func creatHandler(_ req: Request, acronym:Acronym) throws -> Future<Acronym> {
        return acronym.save(on: req)
    }

    func getHandle(_ req : Request) throws -> Future<Acronym> {
        return try req.parameters.next(Acronym.self)
    }

    func updateHandle(_ req : Request) throws -> Future<Acronym> {
        return try flatMap(to: Acronym.self,
            req.parameters.next(Acronym.self),
            req.content.decode(Acronym.self)
            ) { (acronym, updateAcroyms) in
                acronym.long = updateAcroyms.long
                acronym.short = updateAcroyms.short
                return acronym.save(on: req)
        }
    }

    func deleteHandler(_ req : Request) throws -> Future<HTTPStatus> {
        return try req
            .parameters
            .next(Acronym.self)
            .delete(on: req)
            .transform(to: .noContent)
    }

    func searchHandler(_ req:Request) throws -> Future<[Acronym]> {
        guard let searchTerm = req.query[String.self,at:"term"] else {
            throw Abort(HTTPStatus.badRequest)
        }

        return Acronym.query(on: req)
            .group(.or) { (or) in
                or.filter(\.short == searchTerm)
                or.filter(\.long == searchTerm)
        }.all()
    }

    func getFirstHandler(_ req: Request) throws -> Future<Acronym> {
        return Acronym.query(on: req)
        .first()
            .unwrap(or: Abort(.notFound))
    }

    func sortedHandler(_ req: Request) -> Future<[Acronym]> {
        return Acronym.query(on: req)
            .sort(\.short, .ascending)
        .all()
    }

}


