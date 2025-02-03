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
    let posterPath: String?
    let genreIds: [Int]
    let voteAverage: Double
    let releaseDate: String
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var releaseYear: String {
        String(releaseDate.prefix(4))
    }
}
