import Foundation
import Combine

protocol MovieServiceProtocol {
    func getPopularMovies(page: Int) -> AnyPublisher<MovieResponse, NetworkError>
    func getGenres() -> AnyPublisher<GenresResponse, NetworkError>
    func getMovieDetails(id: Int) -> AnyPublisher<MovieDetail, NetworkError>
    func discoverMovies(page: Int, sortBy: MovieSortOption) -> AnyPublisher<MovieResponse, NetworkError>
    func searchMovies(query: String, page: Int) -> AnyPublisher<MovieResponse, NetworkError>
    func getMovieVideos(id: Int) -> AnyPublisher<VideoResponse, NetworkError>
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
    
    func discoverMovies(page: Int, sortBy: MovieSortOption) -> AnyPublisher<MovieResponse, NetworkError> {
        Future { promise in
            Task {
                let endpoint = DiscoverMoviesEndpoint(page: page, sortBy: sortBy)
                let result = await self.client.sendRequest(endpoint: endpoint)
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
    
    func searchMovies(query: String, page: Int) -> AnyPublisher<MovieResponse, NetworkError> {
        Future { promise in
            Task {
                let result = await self.client.sendRequest(endpoint: SearchMoviesEndpoint(query: query, page: page))
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
    
    func getMovieVideos(id: Int) -> AnyPublisher<VideoResponse, NetworkError> {
        Future { promise in
            Task {
                let result = await self.client.sendRequest(endpoint: MovieVideosEndpoint(movieId: id))
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
