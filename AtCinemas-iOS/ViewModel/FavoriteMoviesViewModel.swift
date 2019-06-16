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
    func showUpdateAlert()
}

class FavoriteMoviesViewModel {
    
    weak var delegate: FavoriteMoviesViewModelDelegate?
    
    var favoriteMovies = [Movie]() {
        didSet {
            delegate?.updateView()
            delegate?.showUpdateAlert()
        }
    }
    
    func get() {
        favoriteMovies = coreManager.getMovies()
    }
    
}
