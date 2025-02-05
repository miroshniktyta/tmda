//
//  Movie.swift
//  tmda
//
//  Created by pc on 02.02.25.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let genreIds: [Int]
    let voteAverage: Double
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    
    func posterURL(size: MovieImageSize) -> URL? {
        MovieImageURL.url(for: posterPath, type: .poster, size: size)
    }
    
    func backdropURL(size: MovieImageSize) -> URL? {
        MovieImageURL.url(for: backdropPath, type: .backdrop, size: size)
    }
    
    var releaseYear: String {
        String(releaseDate.prefix(4))
    }
}
