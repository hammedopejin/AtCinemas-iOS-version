//
//  MovieAPI.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/9/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

struct MovieAPI {
    
    static let base = "https://api.themoviedb.org/3/movie/"
    
    static let nowPlaying = "now_playing"
    static let popular = "popular"
    static let topRated = "top_rated"
    
    static let movieTrailers = "/videos"
    static let movieReviews = "/reviews"
    
    static let thumbnailURL = "https://image.tmdb.org/t/p/w500/"
    static let amp = "&"
    static let ques = "?"
    static let apiKey = "api_key=f16d0ec2539e84fb28f16aa91f86f0a2"
    static let pageNo = "?page="
    
    static let trailerThumbnailURL = "http://img.youtube.com/vi/"
    static let trailerThumbnailURLExtension = "/0.jpg"
    static let trailerMovieURL = "https://www.youtube.com/watch?v="
    
    static func getNowPlayingUrl(page: Int) -> String {
        return base + nowPlaying + pageNo + "\(page)" + amp + apiKey
    }
    
    static func getPopularUrl(page: Int) -> String {
        return base + popular + pageNo + "\(page)" + amp + apiKey
    }
    
    static func getTopRatedUrl(page: Int) -> String {
        return base + topRated + pageNo + "\(page)" + amp + apiKey
    }
    
    static func getMovieTrailerUrl(_ movieID: String) -> String {
        return base + movieID + movieTrailers + ques + apiKey
    }
    
    static func getMovieReviewUrl(_ movieID: String) -> String {
        return base + movieID + movieReviews + ques + apiKey
    }
    
    static func getThumbnailUrl(_ path: String) -> String {
        return thumbnailURL + path
    }
    
    static func getTrailerThumbnailURL(_ key: String) -> String {
        return trailerThumbnailURL + key + trailerThumbnailURLExtension
    }
    
    static func getTrailerVideoURL(_ key: String) -> String {
        return trailerMovieURL + key
    }
    
}
