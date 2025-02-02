//
//  Video.swift
//  tmda
//
//  Created by pc on 04.02.25.
//

import Foundation

struct Video: Decodable {
    let key: String
    let site: String
    let type: String
    
    var isYouTubeTrailer: Bool {
        type == "Trailer" && site == "YouTube"
    }
    
    var youtubeAppURL: URL? {
        URL(string: "youtube://\(key)")
    }
    
    var youtubeWebURL: URL? {
        URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}
