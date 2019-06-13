//
//  MovieService.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/9/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

enum MovieError: Error {
    case badURLPath(String)
}

typealias MovieHandler =  ([Movie], Error?) -> Void
typealias TrailerHandler = ([Trailer], Error?) -> Void
typealias ReviewHandler = ([Review], Error?) -> Void

let movieService = MovieService.shared

final class MovieService {
    
    static let shared = MovieService()
    private init() {}
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        return URLSession(configuration: config)
    }()
    
    //MARK: movies
    func get(movies by: String, page: Int, completion: @escaping MovieHandler) {
        
        var urlString = String()
        
        switch by {
        case Constants.Keys.nowPlaying.rawValue:
            urlString = MovieAPI.getNowPlayingUrl(page: page)
            break
        case Constants.Keys.popular.rawValue:
            urlString = MovieAPI.getPopularUrl(page: page)
            break
        default:
            urlString = MovieAPI.getTopRatedUrl(page: page)
            break
        }
        
        guard let finalURL = URL(string: urlString) else {
            completion([], MovieError.badURLPath("Bad Url Path"))
            return
        }
        
        session.dataTask(with: finalURL) { (dat, _, err) in
            
            if let error = err {
                completion([], error)
                return
            }
            
            if let data = dat {
                do {
                    let response = try JSONDecoder().decode(MovieResults.self, from: data)
                    let movies = response.results
                    completion(movies, nil)
                } catch let error {
                    completion([], error)
                }
            }
            
        }.resume()
        
    }
    
    //MARK: trailers
    func get(trailers with: String, completion: @escaping TrailerHandler) {
        
        let urlString = MovieAPI.getMovieTrailerUrl(with)
        
        guard let finalURL = URL(string: urlString) else {
            completion([],MovieError.badURLPath("Bad Url Path"))
            return
        }
        
        session.dataTask(with: finalURL) { (dat, _, err) in
            
            if let error = err {
                completion([], error)
                return
            }
            
            if let data = dat {
                do {
                    let response = try JSONDecoder().decode(TrailerResults.self, from: data)
                    let trailers = response.results
                    completion(trailers, nil)
                } catch let error {
                    completion([], error)
                }
            }
        }.resume()
    }
    
    //MARK: reviews
    func get(reviews with: String, completion: @escaping ReviewHandler) {
        
        let urlString = MovieAPI.getMovieReviewUrl(with)
        
        guard let finalURL = URL(string: urlString) else {
            completion([], MovieError.badURLPath("Bad Url Path"))
            return
        }
        
        session.dataTask(with: finalURL) { (dat, _, err) in
            
            if let error = err {
                completion([], error)
                return
            }
            
            if let data = dat {
                do {
                    let response = try JSONDecoder().decode(ReviewResults.self, from: data)
                    let reviews = response.results
                    completion(reviews, nil)
                } catch let error {
                    completion([], error)
                }
            }
        }.resume()
    }
    
}
