//
//  MovieDetailEndpoint.swift
//  tmda
//
//  Created by pc on 03.02.25.
//

import Foundation

struct MovieDetailsEndpoint: Endpoint {
    
    let movieId: Int
    
    typealias Response = MovieDetail
    
    var path: String {
        "/movie/\(movieId)"
    }
}
