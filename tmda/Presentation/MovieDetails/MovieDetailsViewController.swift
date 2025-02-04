import UIKit
import Combine

final class MovieDetailsViewController: UIViewController {
    private let viewModel: MovieDetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentView = UIView()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let yearCountryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private let ratingContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let playButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(systemName: "play.circle")
        configuration.imagePadding = 8
        configuration.title = "Watch Trailer"
        
        let button = UIButton(configuration: configuration)
        button.isHidden = true
        return button
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(viewModel: MovieDetailsViewModel) {
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
        viewModel.loadMovieDetails()
        playButton.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(loadingIndicator)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearCountryLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(overviewLabel)
        
        ratingContainer.addArrangedSubview(starImageView)
        ratingContainer.addArrangedSubview(ratingLabel)
        
        ratingStackView.addArrangedSubview(playButton)
        ratingStackView.addArrangedSubview(UIView())
        ratingStackView.addArrangedSubview(ratingContainer)
        
        contentView.addSubview(ratingStackView)
                
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let posterRatio: CGFloat = 1.4
        posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(posterImageView.snp.width).multipliedBy(posterRatio)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        yearCountryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(yearCountryLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
        
        viewModel.$trailer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] trailer in
                self?.playButton.isHidden = trailer == nil
            }
            .store(in: &cancellables)
    }
    
    private func handleState(_ state: MovieDetailsViewModel.State) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
            scrollView.isHidden = true
        case .loaded(let movie):
            loadingIndicator.stopAnimating()
            scrollView.isHidden = false
            updateUI(with: movie)
        case .error(let error):
            loadingIndicator.stopAnimating()
            scrollView.isHidden = true
            showError(error)
        }
    }
    
    private func showError(_ error: NetworkError) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.loadMovieDetails()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func updateUI(with movie: MovieDetail) {
        title = movie.title
        titleLabel.text = movie.title
        yearCountryLabel.text = "\(movie.releaseDate.prefix(4)) • \(movie.originalLanguage.uppercased())"
        genresLabel.text = movie.genres.map { $0.name }.joined(separator: " • ")
        ratingLabel.text = String(format: "%.1f", movie.voteAverage)
        overviewLabel.text = movie.overview
        
        if let posterURL = movie.posterURL {
            posterImageView.kf.setImage(with: posterURL)
        }
    }
    
    @objc private func handlePlayButton() {
        guard let trailer = viewModel.trailer else { return }
        
        // Try to open YouTube app first
        if let appURL = trailer.youtubeAppURL,
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        }
        // Fallback to web URL
        else if let webURL = trailer.youtubeWebURL {
            UIApplication.shared.open(webURL)
        }
    }
} 
