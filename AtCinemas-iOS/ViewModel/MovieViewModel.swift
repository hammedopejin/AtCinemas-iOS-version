//
//  MovieViewModel.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/10/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

protocol MovieViewModelDelegate: class {
    func updateView()
}

class MovieViewModel {
    
    weak var delegate: MovieViewModelDelegate?
    
    var movies = [Movie]() {
        didSet {
            delegate?.updateView()
        }
    }
    
    func getNowPlayingMovies() {
        
        movieService.get(movies: Constants.Keys.nowPlaying.rawValue) {[unowned self] movies, err in
            
            if let error = err {
                   print("Error getting movies: \(error.localizedDescription)")
                return
            }
            self.movies = movies
            
        }
    }
}
