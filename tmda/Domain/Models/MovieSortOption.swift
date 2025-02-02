//
//  MovieSortOption.swift
//  tmda
//
//  Created by pc on 03.02.25.
//

import Foundation

enum MovieSortOption: String, CaseIterable {
    case popularityDesc = "popularity.desc"
    case popularityAsc = "popularity.asc"
    case releaseDateDesc = "primary_release_date.desc"
    case releaseDateAsc = "primary_release_date.asc"
    case ratingDesc = "vote_average.desc"
    case ratingAsc = "vote_average.asc"
    
    var title: String {
        switch self {
        case .popularityDesc: return "Popularity (High to Low)"
        case .popularityAsc: return "Popularity (Low to High)"
        case .releaseDateDesc: return "Release Date (Newest)"
        case .releaseDateAsc: return "Release Date (Oldest)"
        case .ratingDesc: return "Rating (High to Low)"
        case .ratingAsc: return "Rating (Low to High)"
        }
    }
}
