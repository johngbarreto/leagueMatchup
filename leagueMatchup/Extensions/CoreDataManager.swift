//
//  CoreDataManager.swift
//  leagueMatchup
//
//  Created by João Gabriel Lavareda Ayres Barreto on 03/06/24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {} // Singleton 
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "MatchupCDModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load store: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

