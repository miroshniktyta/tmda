//
//  MovieEndpoint.swift
//  tmda
//
//  Created by pc on 02.02.25.
//

import Foundation

struct PopularMoviesEndpoint: Endpoint {
    let page: Int
    
    typealias Response = MovieResponse
    
    var path: String {
        "/movie/popular"
    }
    
    var queryItems: [URLQueryItem]? {
        .init([
            URLQueryItem(name: "page", value: "\(page)"),
        ])
    }
}
