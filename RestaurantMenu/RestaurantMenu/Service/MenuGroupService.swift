//
//  MenuGroupService.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public final class MenuGroupService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: DataStack
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: DataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

// MARK:- public
extension MenuGroupService {
   
    func insertSampleData() {
        let fetch: NSFetchRequest<MenuGroup> = MenuGroup.fetchRequest()
        let count = try! coreDataStack.mainContext.count(for: fetch)
        if count > 0 {
            return
        }
        let path = Bundle.main.path(forResource: "SampleData", ofType: "plist")
        let dataArray = NSArray(contentsOfFile: path!)!
        
        for dict in dataArray {
            let menuGroup = MenuGroup(context: coreDataStack.mainContext)
            let btDict = dict as! [String: Any]
            menuGroup.name = btDict["name"] as? String
            if let array = btDict["items"] as? [[String:Any]]
            {
                for dict in array
                {
                    let item = MenuItem(context: coreDataStack.mainContext)
                    item.name = dict["name"] as? String
                    item.price = (dict["price"] as? Float)!
                    let imageName = dict["image"] as? String
                    let image = UIImage(named: imageName!)
                    let photoData = UIImagePNGRepresentation(image!)!
                    item.image = photoData
                    if let items  = menuGroup.menuItems?.mutableCopy() as? NSMutableOrderedSet{
                        items.add(item)
                        menuGroup.menuItems = items
                    }
                }
            }
            let imageName = btDict["image"] as? String
            let image = UIImage(named: imageName!)
            let photoData = UIImagePNGRepresentation(image!)!
            menuGroup.image = Data(photoData)
        }
        
        try! coreDataStack.mainContext.save()
    }
    
   
    func getMenuGroups() -> [MenuGroup] {
        let fetchRequest: NSFetchRequest<MenuGroup> = MenuGroup.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.fetchBatchSize = 20
        var results: [MenuGroup]
        do {
            try results = managedObjectContext.fetch(fetchRequest)
        } catch {
            results = []
        }
        
        return results
    }
    func getMenuGroup(name: String) -> MenuGroup? {
        let fetchRequest: NSFetchRequest<MenuGroup> = MenuGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", argumentArray: [name])
        let results: [MenuGroup]?
        do {
            results = try managedObjectContext.fetch(fetchRequest)
        } catch {
            return nil
        }
        return results?.first
    }
    func updateGroup(_ menuGroup: MenuGroup) -> MenuGroup
    {
        coreDataStack.saveContext(menuGroup.managedObjectContext!)
        return menuGroup
    }
    func addGroup(_ name: String, image:Data) -> MenuGroup?
    {
        let group = MenuGroup(context: managedObjectContext)
        group.name = name
        group.image = image
        
        coreDataStack.saveContext(managedObjectContext)
        return group
    }
    public func deleteMenuGroup(_ group:NSManagedObject){
        coreDataStack.mainContext.delete(group)
        coreDataStack.saveContext(managedObjectContext)
    }
}
