//
//  SearchMoviesEndpoint.swift
//  tmda
//
//  Created by pc on 04.02.25.
//

import Foundation

struct SearchMoviesEndpoint: Endpoint {
    typealias Response = MovieResponse
    
    let query: String
    let page: Int
    
    var path: String { "/search/movie" }
    
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]
    }
}
