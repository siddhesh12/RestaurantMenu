//
//  TestDataStack.swift
//  RestaurantMenuTests
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import RestaurantMenu
import Foundation
import CoreData

class TestDataStack: DataStack {
    
    convenience init() {
        self.init(modelName: "RestaurantMenu")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        self.storeContainer = container
    }
}

