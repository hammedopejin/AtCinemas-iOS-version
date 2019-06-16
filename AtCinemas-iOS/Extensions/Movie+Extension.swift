//
//  Movie+Extension.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/15/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

extension Movie {
    
    var toDictionary: [String: String] {
        return [Constants.Movie.id.rawValue : "\(self.id)", Constants.Movie.title.rawValue : self.title, Constants.Movie.overview.rawValue : self.overview, Constants.Movie.imageUrl.rawValue : self.imageUrl, Constants.Movie.rating.rawValue: "\(self.rating)", Constants.Movie.releaseDate.rawValue : self.releaseDate]
    }
   
}
