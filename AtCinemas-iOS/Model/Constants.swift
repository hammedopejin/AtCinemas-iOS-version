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
        case hash = "hash"
        case movies = "movies"
    }
    
    enum Urls: String {
        case privacyPolicy = "https://docs.google.com/document/d/e/2PACX-1vSkGainGErlD4djUcLFtpKq-siYepTPpwBSaqRmyaNbSiOrA7KQV2nlh4RRFjVNblAChaFQRPo9Ii4d/pub"
        case terms_Conditions = "https://docs.google.com/document/d/e/2PACX-1vQ2DILBJ5ecmv7c0ORT8KNc402Id9jW4FPPd2HqvrQLYMnKm2ah9Pbj04PK6v7SqIxQUC6cxLTPA29E/pub"
    }
    
}
