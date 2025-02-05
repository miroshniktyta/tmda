//
//  MovieImageType.swift
//  tmda
//
//  Created by pc on 05.02.25.
//

import Foundation

enum MovieImageType {
    case poster
    case backdrop
    
    var aspectRatio: CGFloat {
        switch self {
        case .poster: return 2.0/3.0  // 2:3
        case .backdrop: return 16.0/9.0  // 16:9
        }
    }
    
    func path(forSize size: MovieImageSize) -> String {
        switch (self, size) {
        case (.poster, .thumbnail): return "w185"
        case (.poster, .medium): return "w500"
        case (.poster, .large): return "w780"
        case (.poster, .original): return "original"
            
        case (.backdrop, .thumbnail): return "w300"
        case (.backdrop, .medium): return "w780"
        case (.backdrop, .large): return "w1280"
        case (.backdrop, .original): return "original"
        }
    }
}
