//
//  Persistence.swift
//  Appverse
//
//  Created by tejas bhuwania on 23/3/21.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let preloadedImage = UIImage(named: "cafe-1")
        let pickedImage = preloadedImage?.jpegData(compressionQuality: 1.0)
        let saveImage = ImgCore(context: viewContext)
        saveImage.img = pickedImage
        saveImage.album = "Main"
        for _ in 0..<1 {
            let newItem = Albums(context: viewContext)
            newItem.name = "Main"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Appverse")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
