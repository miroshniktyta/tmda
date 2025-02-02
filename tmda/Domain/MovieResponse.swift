//
//  MovieRespones.swift
//  tmda
//
//  Created by pc on 02.02.25.
//

import Foundation

struct MovieResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
}
