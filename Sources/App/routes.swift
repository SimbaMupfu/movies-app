import Vapor

func routes(_ app: Application) throws {
    //create a movie
    app.post("movies") { req async throws in
        let movie = try req.content.decode(Movie.self)
        try await movie.save(on: req.db)
        return movie
    }
    
    app.get("movies") { req async throws in
        let movies = try await Movie.query(on: req.db)
            .all()
        return movies
    }
    
    app.get("movies", ":id") { req async throws in
        guard let movie = try await Movie.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.badRequest)
        }
        return movie
    }
}
