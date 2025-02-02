import Foundation

struct GenresEndpoint: Endpoint {
    typealias Response = GenresResponse
    
    var path: String {
        "/genre/movie/list"
    }
}

struct GenresResponse: Decodable {
    let genres: [MovieGenre]
} 