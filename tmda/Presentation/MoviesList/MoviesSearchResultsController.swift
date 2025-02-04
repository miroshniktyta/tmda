//
//  MoviesSearchResultsController.swift
//  tmda
//
//  Created by pc on 04.02.25.
//

import UIKit
import Combine

final class MoviesSearchResultsController: UITableViewController {
    private let viewModel: MoviesListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
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
        tableView.register(MovieSearchCell.self, forCellReuseIdentifier: MovieSearchCell.reuseIdentifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 88, bottom: 0, right: 0)
    }
    
    private func setupBindings() {
        viewModel.$searchResults
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieSearchCell.reuseIdentifier, for: indexPath) as! MovieSearchCell
        let movie = viewModel.searchResults[indexPath.row]
        cell.configure(with: movie, genres: viewModel.genres(for: movie))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.searchResults[indexPath.row]
        viewModel.showMovieDetails(for: movie)
    }
}
