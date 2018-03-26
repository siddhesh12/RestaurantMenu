//
//  MenuItemService.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation
import CoreData

public final class MenuItemService {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: DataStack
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: DataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

extension MenuItemService {
    
    func updateMenuItem(_ menuItem: MenuItem) -> MenuItem
    {
        coreDataStack.saveContext(menuItem.managedObjectContext!)
        return menuItem
    }
    func addItem(_ name: String, price: String, image:Data, menuGroup: MenuGroup) -> MenuItem
    {
        let item = MenuItem(context: menuGroup.managedObjectContext!)
        item.name = name
        item.price = Float(price)!
        item.image = image
        
        if let items  = menuGroup.menuItems?.mutableCopy() as? NSMutableOrderedSet{
            items.add(item)
            menuGroup.menuItems = items
        }
        coreDataStack.saveContext(managedObjectContext)
        return item
    }
    public func deleteMenuItem(_ item:NSManagedObject){
        item.managedObjectContext!.delete(item)
        coreDataStack.saveContext(item.managedObjectContext!)
    }
}
