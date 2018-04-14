import Vapor

struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("api", "categories")
        
        categoriesRoute.post(Category.self, use: createHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(Category.parameter, use: getHandler)
        categoriesRoute.get(Category.parameter, "acronyms", use: getAcronymsHandler)
    }
    
    //POST
    func createHandler(_ req: Request, category: Category) throws -> Future<Category> {
        return category.save(on: req)
    }
    
    //GET
    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    //GET SINGLE
    func getHandler(_ req: Request) throws -> Future<Category> {
        return try req.parameter(Category.self)
    }
    
    //GET ACRONYM SIBLINGS
    func getAcronymsHandler(_ req: Request) throws -> Future<[Acronym]> {
        return try req.parameter(Category.self).flatMap(to: [Acronym].self) { category in
            try category.acronyms.query(on: req).all()
        }
    }
}
