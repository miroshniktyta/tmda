//
//  MovieDetail.swift
//  tmda
//
//  Created by pc on 02.02.25.
//

import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let adult: Bool
    let video: Bool
    let originalLanguage: String
    let genres: [MovieGenre]
    let runtime: Int?
    let status: String
    let tagline: String?
    let budget: Int
    let revenue: Int
    let homepage: String?
    
    func posterURL(size: MovieImageSize) -> URL? {
        MovieImageURL.url(for: posterPath, type: .poster, size: size)
    }
    
    func backdropURL(size: MovieImageSize) -> URL? {
        MovieImageURL.url(for: backdropPath, type: .backdrop, size: size)
    }
}
