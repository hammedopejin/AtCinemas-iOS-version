//
//  Review.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/9/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

struct ReviewResults: Decodable {
    let results: ReviewInfo
}

struct ReviewInfo: Decodable {
    let reviews: [Review]
}

class Review: Decodable {
    
    let id : String
    let author: String
    let content: String
    let url: String
    
}
