//
//  CoreManager.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/11/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import CoreData

let coreManager = CoreManager.sharedInstance
final class CoreManager {
    
    static let sharedInstance = CoreManager()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.Keys.AtCinemas.rawValue)
        container.loadPersistentStores(completionHandler: { (persistentStoreDescription, err) in
            
            if let error = err {
                fatalError("Couldn't Load Persistence Store!")
            }
        })
        return container
    }()
    
    func saveMovie(_ movie: Movie)  {
        
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.Movie.CoreMovie.rawValue, in: context) else {
            return
        }
        
        let coreMovie = NSManagedObject(entity: entity, insertInto: context)
        coreMovie.setValue(movie.id, forKey: Constants.Movie.id.rawValue)
        coreMovie.setValue(movie.title, forKey: Constants.Movie.title.rawValue)
        coreMovie.setValue(movie.overview, forKey: Constants.Movie.overview.rawValue)
        coreMovie.setValue(movie.imageUrl, forKey: Constants.Movie.imageUrl.rawValue)
        coreMovie.setValue(movie.rating, forKey: Constants.Movie.rating.rawValue)
        coreMovie.setValue(movie.releaseDate, forKey: Constants.Movie.releaseDate.rawValue)
        
        saveContext()
        
    }
    
    func getMovies() -> [Movie] {
        
        let fetchRequest = NSFetchRequest<CoreMovie>(entityName: Constants.Movie.CoreMovie.rawValue)
        var movies = [Movie]()
        
        do{
            let coreMovies = try context.fetch(fetchRequest)
            for movie in coreMovies {
                movies.append(Movie(entity: movie)!)
            }
            
            return movies
            
        } catch {
            return []
        }
        
    }
    
    func deleteMovie(_ movie: Movie) {
        
        let fetchRequest = NSFetchRequest<CoreMovie>(entityName: Constants.Movie.CoreMovie.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(movie.id)")
        do {
            let movieData = try context.fetch(fetchRequest)
            let toDeleteMovie = movieData[0] as NSManagedObject
            context.delete(toDeleteMovie)
            saveContext()
        } catch {
            print("Error Deleting Book: \(error.localizedDescription)")
        }
        
    }
    
    func isFavorite(_ id: String) -> Bool {
        
        let fetchRequest = NSFetchRequest<CoreMovie>(entityName: Constants.Movie.CoreMovie.rawValue)
        let predicate = NSPredicate(format: "id = %@", id)
        
        fetchRequest.predicate = predicate
        var movie: CoreMovie!
        
        do{
            movie = try context.fetch(fetchRequest).first
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return movie != nil
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
