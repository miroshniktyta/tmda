import UIKit
import Combine
import SnapKit

final class MoviesListViewController: UIViewController {
    private let viewModel: MoviesListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        return refresh
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.tableFooterView = spinner
        table.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        table.backgroundColor = .systemBackground
        table.refreshControl = refreshControl
        return table
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(showSortOptions)
        )
    }()
    
    private let searchController: UISearchController
    
    init(viewModel: MoviesListViewModel) {
        let searchResultsController = MoviesSearchResultsController(viewModel: viewModel)
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupNavigationHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Popular Movies"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search movies..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setupBindings() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleStateChange(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleStateChange(_ state: MoviesListViewModel.State) {
        switch state {
        case .loading:
            spinner.startAnimating()
        case .loaded:
            spinner.stopAnimating()
            refreshControl.endRefreshing()
        case .error(let error):
            spinner.stopAnimating()
            refreshControl.endRefreshing()
            showError(error)
        case .reachedEnd:
            spinner.stopAnimating()
            refreshControl.endRefreshing()
        }
    }
    
    private func showError(_ error: NetworkError) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func handlePullToRefresh() {
        viewModel.resetAndRefetch()
    }
    
    @objc private func showSortOptions() {
        let alert = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        
        MovieSortOption.allCases.forEach { option in
            let action = UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.viewModel.setSortOption(option)
            }
            
            if option == viewModel.currentSortOption {
                action.setValue(true, forKey: "checked")
            }
            
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func setupNavigationHandler() {
        viewModel.onMovieSelected = { [weak self] movieId in
            guard let self = self else { return }
            
            let detailsViewModel = MovieDetailsViewModel(movieService: viewModel.movieService, movieId: movieId)
            let detailsVC = MovieDetailsViewController(viewModel: detailsViewModel)
            self.navigationController?.pushViewController(detailsVC, animated: true)
//            self.searchController.dismiss(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: indexPath) as! MovieCell
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie, genres: viewModel.genres(for: movie))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = tableView.bounds.width - 32
        return width * 0.6
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = tableView.numberOfRows(inSection: 0) - 3
        if indexPath.row == lastRow {
            viewModel.loadMoreMoviesIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        let detailsViewModel = MovieDetailsViewModel(movieService: viewModel.movieService, movieId: movie.id) // TODO: consider separate service
        let detailsVC = MovieDetailsViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.searchQuery = query
    }
} 
