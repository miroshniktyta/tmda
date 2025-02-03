import Foundation
import Combine

final class MoviesListViewModel {
    enum State {
        case loading
        case loaded
        case error(NetworkError)
        case reachedEnd
    }
    
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var state: State = .loading
    
    let movieService: MovieServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    private var genres: [MovieGenre] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
        loadInitialMovies()
    }
    
    func loadInitialMovies() {
        currentPage = 1
        movies = []
        state = .loading
        
        movieService.getGenres()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .error(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.genres = response.genres
                    self?.loadMovies()
                }
            )
            .store(in: &cancellables)
    }
    
    func loadMoreMoviesIfNeeded() {
        guard case .loaded = state, currentPage < totalPages else { return }
        state = .loading
        loadMovies()
    }
    
    private func loadMovies() {
        movieService.getPopularMovies(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .error(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.movies += response.results
                    self.currentPage += 1
                    self.totalPages = response.totalPages
                    
                    if self.currentPage >= self.totalPages {
                        self.state = .reachedEnd
                    } else {
                        self.state = .loaded
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func genres(for movie: Movie) -> [String] {
        movie.genreIds.compactMap { id in
            genres.first { $0.id == id }?.name
        }
    }
    
    func showMovieDetails(_ movie: Movie) {
        // TODO: Implement navigation to movie details
    }
} 
