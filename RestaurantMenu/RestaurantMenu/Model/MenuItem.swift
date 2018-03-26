//
//  MenuItem.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import CoreData

class MenuItem: NSManagedObject {

}

extension MenuItem {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItem> {
        return NSFetchRequest<MenuItem>(entityName: "MenuItem")
    }
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var menuGroup: MenuGroup?
    
}

