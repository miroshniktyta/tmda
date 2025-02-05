//
//  MovieImageURL.swift
//  tmda
//
//  Created by pc on 05.02.25.
//

import Foundation

struct MovieImageURL {
    private static let baseURL = "https://image.tmdb.org/t/p"
    
    static func url(for path: String?, type: MovieImageType, size: MovieImageSize) -> URL? {
        guard let path = path else { return nil }
        let sizePath = type.path(forSize: size)
        return URL(string: "\(baseURL)/\(sizePath)\(path)")
    }
}
