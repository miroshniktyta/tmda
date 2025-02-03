import Foundation
import Combine

final class MovieDetailsViewModel {
    enum State {
        case loading
        case loaded(MovieDetail)
        case error(NetworkError)
    }
    
    @Published private(set) var state: State = .loading
    
    private let movieService: MovieServiceProtocol
    private let movieId: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(movieService: MovieServiceProtocol, movieId: Int) {
        self.movieService = movieService
        self.movieId = movieId
    }
    
    func loadMovieDetails() {
        state = .loading
        
        movieService.getMovieDetails(id: movieId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .error(error)
                    }
                },
                receiveValue: { [weak self] details in
                    self?.state = .loaded(details)
                }
            )
            .store(in: &cancellables)
    }
} 
