//
//  Trailer.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/9/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

struct TrailerResults: Decodable {
    let results: [Trailer]
}

class Trailer: Decodable {
    
    let key: String
    let name: String
}
