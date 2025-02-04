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
    @Published private(set) var currentSortOption: MovieSortOption = .popularityDesc
    
    let movieService: MovieServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    private var genres: [MovieGenre] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
        fetchInitialData()
    }
    
    func setSortOption(_ option: MovieSortOption) {
        guard option != currentSortOption else { return }
        currentSortOption = option
        resetAndRefetch()
    }
    
    func fetchInitialData() {
        state = .loading
        currentPage = 1
        movies = []
        
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
                    self?.fetchMovies()
                }
            )
            .store(in: &cancellables)
    }
    
    private func resetAndRefetch() {
        currentPage = 1
        movies = []
        fetchMovies()
    }
    
    func loadMoreMoviesIfNeeded() {
        guard case .loaded = state, currentPage < totalPages else { return }
        state = .loading
        fetchMovies()
    }
    
    private func fetchMovies() {
        movieService.discoverMovies(page: currentPage, sortBy: currentSortOption)
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
                    self.state = self.currentPage >= self.totalPages ? .reachedEnd : .loaded
                }
            )
            .store(in: &cancellables)
    }
    
    func genres(for movie: Movie) -> [String] {
        movie.genreIds.compactMap { id in
            genres.first { $0.id == id }?.name
        }
    }
} 
