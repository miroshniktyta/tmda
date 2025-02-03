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
    
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Popular Movies"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        viewModel.loadInitialMovies()
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
} 
