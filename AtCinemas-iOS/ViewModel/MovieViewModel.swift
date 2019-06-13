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
    private var isRequesting = false
    private var lastRequestedPage = 0
    var filteredMovies = [Movie]()
    var currentMovie: Movie!
    
    var movies = [Movie]() {
        didSet {
            delegate?.updateView()
        }
    }
    
    var reviews = [Review]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.ReviewNotification, object: nil)
        }
    }
    
    var trailers = [Trailer]() {
        didSet {
            NotificationCenter.default.post(name: Notification.Name.TrailerNotification, object: nil)
        }
    }
    
    //MARK: Service
    func requestMoreData(by: String) {
        if isRequesting || lastRequestedPage >= 40 {
            return
        }
        
        isRequesting =  true
        lastRequestedPage += 1
        
        movieService.get(movies: Constants.Keys.nowPlaying.rawValue, page: lastRequestedPage) {[unowned self] movies, err in
            
            if let error = err {
                print("Error getting movies: \(error.localizedDescription)")
                self.isRequesting = false
                return
            }
            print("No of movies returned \(movies.count)")
            
            self.isRequesting = false
            self.movies.append(contentsOf: movies)
            print("Total No of movies: \(self.movies.count)")
            
        }
    }
    
    func getReviews(id: String) {
        movieService.get(reviews: id) { [unowned self] reviews, err  in
            
            if let error = err {
                print("Error getting reviews: \(error.localizedDescription)")
                return
            }
            self.reviews = reviews
            print("No of reviews returned \(reviews.count)")
            
        }
    }
    
    func getTrailers(id: String) {
        movieService.get(trailers: id) { [unowned self] trailers, err  in
            
            if let error = err {
                print("Error getting trailers: \(error.localizedDescription)")
                return
            }
            self.trailers = trailers
            print("No of trailers returned \(trailers.count)")
            
        }
    }
    
}
