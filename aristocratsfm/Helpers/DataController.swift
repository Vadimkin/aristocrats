//
//  DataController.swift
//  temp
//
//  Created by Vadim Klimenko on 06.11.2020.
//

import CoreData

struct DataController {
    static let shared = DataController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        return self.container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Aristocrats")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection
                   when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func insertFavoriteTrack(track: AristocratsTrack) throws {
        let newFavorite = Favorite(context: self.context)

        newFavorite.uuid = UUID()
        newFavorite.artist = track.artist
        newFavorite.song = track.song
        newFavorite.createdAt = Date()

        try context.save()
    }

    func delete(favorite: Favorite) throws {
        context.delete(favorite)

        try context.save()
    }
}
