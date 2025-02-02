//
//  APIConfig.swift
//  tmda
//
//  Created by pc on 02.02.25.
//

import Foundation

enum APIConfig {
    static let baseURL = "https://api.themoviedb.org"
    static let apiKey = "your_api_key"
    static let apiVersion = "/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    static let posterSize = "w500"  // Available sizes: w92, w154, w185, w342, w500, w780, original
    
    static let defaultHeaders: [String: String] = [
        "Authorization": "Bearer \(apiKey)",
        "accept": "application/json"
    ]
}
