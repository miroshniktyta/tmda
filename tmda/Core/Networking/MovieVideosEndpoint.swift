//
//  MovieVideosEndpoint.swift
//  tmda
//
//  Created by pc on 04.02.25.
//

import Foundation

struct MovieVideosEndpoint: Endpoint {
    typealias Response = VideoResponse
    
    let movieId: Int
    
    var path: String { "/movie/\(movieId)/videos" }
}
