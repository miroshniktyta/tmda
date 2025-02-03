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
    let genreIds: [Int]
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: APIConfig.imageBaseURL + APIConfig.posterSize + posterPath)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: APIConfig.imageBaseURL + APIConfig.posterSize + backdropPath)
    }
}
