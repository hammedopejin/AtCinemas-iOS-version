//
//  FavoriteMoviesViewModel.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/12/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit

protocol FavoriteMoviesViewModelDelegate: class {
    func updateView()
}

class FavoriteMoviesViewModel {
    
    weak var delegate: FavoriteMoviesViewModelDelegate?
    var currentMovie: Movie!
    
    var favoriteMovies = [Movie]() {
        didSet {
            delegate?.updateView()
        }
    }
    
    func get() {
        favoriteMovies = coreManager.getMovies()
    }
    
}
