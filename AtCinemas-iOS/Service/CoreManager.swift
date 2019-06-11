//
//  CoreManager.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/11/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import UIKit
import CoreData


final class CoreManager {
    
    static let shared = CoreManager()
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
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.Keys.CoreMovie.rawValue, in: context) else {
            return
        }
        
        let coreMovie = NSManagedObject(entity: entity, insertInto: context)
        
    }
    
    private func savecontext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}
