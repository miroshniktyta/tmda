//
//  MovieSearchCell.swift
//  tmda
//
//  Created by pc on 04.02.25.
//

import UIKit

final class MovieSearchCell: UITableViewCell {
    static let reuseIdentifier = "MovieSearchCell"
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(backdropImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(genresLabel)
        contentView.addSubview(ratingLabel)
        
        backdropImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(90)
            make.width.equalTo(backdropImageView.snp.height).multipliedBy(1/MovieImageType.poster.aspectRatio)
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView)
            make.leading.equalTo(backdropImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(yearLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(backdropImageView)
            make.leading.equalTo(titleLabel)
        }
    }
    
    func configure(with movie: Movie, genres: [String]) {
        titleLabel.text = movie.title
        yearLabel.text = "\(movie.releaseDate.prefix(4))"
        genresLabel.text = genres.joined(separator: " • ")
        ratingLabel.text = "★ \(String(format: "%.1f", movie.voteAverage))"
        
        if let posterURL = movie.backdropURL(size: .thumbnail) {
            backdropImageView.kf.setImage(with: posterURL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backdropImageView.kf.cancelDownloadTask()
        backdropImageView.image = nil
    }
}
