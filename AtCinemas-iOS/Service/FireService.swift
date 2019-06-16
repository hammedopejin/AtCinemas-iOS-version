//
//  FireService.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/15/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

let fireService = FireService.shared

final class FireService {
    
    static let shared = FireService()
    private init() {}
    
    let uid = Auth.auth().currentUser?.uid
    lazy var userRef = Database.database().reference(withPath: uid ?? Constants.Keys.user.rawValue)
    lazy var movieRef = userRef.child(Constants.Keys.movies.rawValue)
    
    //MARK: Add
    func add(_ movie: Movie) {
        
        movieRef.child("\(movie.id)").setValue(movie.toDictionary)
        
        print("Added Movie: \(movie.title) to cart")
    }
    
    //MARK: Delete
    func remove(_ movie: Movie) {
        
        movieRef.child("\(movie.id)").removeValue()
        
        print("Removed Movie: \(movie.title) from cart")
        
    }
    
    //MARK: Load
    func get(_ completion: @escaping MovieHandler) {
        
        var movies = [Movie]()
        
        
        movieRef.observeSingleEvent(of: .value) { snapshot in
            
            if !snapshot.exists() {
                completion([], MovieError.noMovie("No movie in cart"))
                return
            }
            
            for snap in snapshot.children {
                
                let data: DataSnapshot = snap as! DataSnapshot
                
                guard let movie = Movie(snapshot: data) else {
                    continue
                }
                
                movies.append(movie)
                
            }
            
            completion(movies, nil)
        }
    }
    
}
