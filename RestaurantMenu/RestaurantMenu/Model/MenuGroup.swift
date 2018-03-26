//
//  MenuGroup.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import CoreData

class MenuGroup: NSManagedObject {

}
extension MenuGroup{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuGroup> {
        return NSFetchRequest<MenuGroup>(entityName: "MenuGroup")
    }
    
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var menuItems: NSOrderedSet?
}
