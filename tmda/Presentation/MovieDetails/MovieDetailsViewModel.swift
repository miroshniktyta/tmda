import Foundation
import Combine

final class MovieDetailsViewModel {
    enum State {
        case loading
        case loaded(MovieDetail)
        case error(NetworkError)
    }
    
    @Published private(set) var state: State = .loading
    @Published private(set) var trailer: Video?
    
    private let movieService: MovieServiceProtocol
    private let movieId: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(movieService: MovieServiceProtocol, movieId: Int) {
        self.movieService = movieService
        self.movieId = movieId
    }
    
    func loadMovieDetails() {
        state = .loading
        
        Publishers.Zip(
            movieService.getMovieDetails(id: movieId),
            movieService.getMovieVideos(id: movieId)
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .error(error)
                }
            },
            receiveValue: { [weak self] movieDetail, videos in
                self?.state = .loaded(movieDetail)
                self?.trailer = videos.results.first { $0.isYouTubeTrailer }
            }
        )
        .store(in: &cancellables)
    }
} 
