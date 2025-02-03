import Foundation
import Combine

protocol MovieServiceProtocol {
    func getPopularMovies(page: Int) -> AnyPublisher<MovieResponse, NetworkError>
    func getGenres() -> AnyPublisher<GenresResponse, NetworkError>
    func getMovieDetails(id: Int) -> AnyPublisher<MovieDetail, NetworkError>
}

final class MovieService: MovieServiceProtocol {
    private let client: HTTPClientProtocol
    
    init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    func getPopularMovies(page: Int) -> AnyPublisher<MovieResponse, NetworkError> {
        Future { promise in
            Task {
                let result = await self.client.sendRequest(endpoint: PopularMoviesEndpoint(page: page))
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getGenres() -> AnyPublisher<GenresResponse, NetworkError> {
        Future { promise in
            Task {
                let result = await self.client.sendRequest(endpoint: GenresEndpoint())
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getMovieDetails(id: Int) -> AnyPublisher<MovieDetail, NetworkError> {
        Future { promise in
            Task {
                let result = await self.client.sendRequest(endpoint: MovieDetailsEndpoint(movieId: id))
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
} 
