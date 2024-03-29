//
//  Movie.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/9/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import CoreData
import FirebaseDatabase

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
    
    init?(entity: NSManagedObject) {
        guard let id = entity.value(forKey: Constants.Movie.id.rawValue) as? Int64, let title = entity.value(forKey: Constants.Movie.title.rawValue) as? String, let overview = entity.value(forKey: Constants.Movie.overview.rawValue) as? String, let imageUrl = entity.value(forKey: Constants.Movie.imageUrl.rawValue) as? String, let rating = entity.value(forKey: Constants.Movie.rating.rawValue) as? Double, let releaseDate = entity.value(forKey: Constants.Movie.releaseDate.rawValue) as? String else {
            return nil
        }
        
        self.id = id
        self.title = title
        self.overview = overview
        self.imageUrl = imageUrl
        self.rating = rating
        self.releaseDate = releaseDate
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let value = snapshot.value as? [String : Any] else {
            return nil
        }
        
        let stringId = value[Constants.Movie.id.rawValue] as! String
        
        self.id = Int64(stringId)!
        self.title = value[Constants.Movie.title.rawValue] as! String
        self.overview = value[Constants.Movie.overview.rawValue] as! String
        self.imageUrl = value[Constants.Movie.imageUrl.rawValue] as! String
        
        let stringRating = value[Constants.Movie.rating.rawValue] as! String
        self.rating = Double(stringRating)!
        
        self.releaseDate = value[Constants.Movie.releaseDate.rawValue] as! String
    }

}
