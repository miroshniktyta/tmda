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
    @Published private(set) var searchResults: [Movie] = []
    @Published var searchQuery: String = ""

    let movieService: MovieServiceProtocol
    private var currentPage = 1
    private var totalPages = 1
    private var genres: [MovieGenre] = []
    private var cancellables = Set<AnyCancellable>()
    
    var onMovieSelected: ((Int) -> Void)?  // movieId as parameter
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
        setupSearchBinding()
        fetchInitialData()
    }
    
    func setSortOption(_ option: MovieSortOption) {
        guard option != currentSortOption else { return }
        currentSortOption = option
        resetAndRefetch()
    }
    
    private func fetchInitialData() {
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
    
    func resetAndRefetch() {
        currentPage = 1
        movies = []
        fetchMovies()
    }
    
    func loadMoreMoviesIfNeeded() {
        guard case .loaded = state, currentPage < totalPages else { return }
        fetchMovies()
    }
    
    private func fetchMovies() {
        state = .loading
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

    private func setupSearchBinding() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { query -> AnyPublisher<MovieResponse, NetworkError> in
                guard !query.isEmpty else {
                    return Empty()
                        .setFailureType(to: NetworkError.self)
                        .eraseToAnyPublisher()
                }
                return self.movieService.searchMovies(query: query, page: 1)
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.state = .error(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.searchResults = response.results
                }
            )
            .store(in: &cancellables)
    }
    
    func showMovieDetails(for movie: Movie) {
        onMovieSelected?(movie.id)
    }
}
