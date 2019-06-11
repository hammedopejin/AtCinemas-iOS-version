//
//  Movie.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/9/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

struct MovieResults: Decodable {
    let results: [Movie]
}

class Movie: Decodable {
    
    let id: Int64
    let title: String
    let overview: String
    let imageUrl: String
    let rating: Double
    let releaseDate: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case imageUrl = "poster_path"
        case rating = "vote_average"
        case releaseDate = "release_date"
    }

}
