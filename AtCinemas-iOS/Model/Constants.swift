//
//  Constants.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/9/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation


struct Constants {
    
    
    enum Movie: String {
            case CoreMovie
            case id
            case title
            case overview
            case imageUrl
            case rating
            case releaseDate
    }
        
  
    
    enum Keys: String {
        case nowPlaying
        case popular
        case topRated
        case AtCinemas = "AtCinemas_iOS"
    } 
    
}
