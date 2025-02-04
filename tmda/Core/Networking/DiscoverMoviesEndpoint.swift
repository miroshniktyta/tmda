//
//  DiscoverMoviesEndpoint.swift
//  tmda
//
//  Created by pc on 03.02.25.
//

import Foundation

struct DiscoverMoviesEndpoint: Endpoint {
    typealias Response = MovieResponse
    
    let page: Int
    let sortBy: MovieSortOption
    
    var path: String { "/discover/movie" }
    
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "sort_by", value: sortBy.rawValue)
        ]
    }
}
