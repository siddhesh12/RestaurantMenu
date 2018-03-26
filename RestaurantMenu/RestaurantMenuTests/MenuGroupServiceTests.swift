//
//  MenuGroupServiceTests.swift
//  RestaurantMenuTests
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import CoreData
@testable import RestaurantMenu
class MenuGroupServiceTests: XCTestCase {
    
    var menuGroupService: MenuGroupService!
    var coreDataStack: DataStack!
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = TestDataStack()
        menuGroupService = MenuGroupService(
            managedObjectContext: coreDataStack.mainContext,
            coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        
        coreDataStack = nil
        menuGroupService = nil
    }
    
    func testRootContextIsSavedAfterAddingMenu() {
        let derivedContext = coreDataStack.backgroundContext()
        menuGroupService = MenuGroupService(managedObjectContext: derivedContext,
                                            coreDataStack: coreDataStack)
        
        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.mainContext) {
                notification in
                return true
        }
        
        derivedContext.perform {
            let menuGroup = self.menuGroupService.addGroup("Apple pie", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
            XCTAssertNotNil(menuGroup)
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testAddMenuGroup()
    {
        let menuGroup = menuGroupService.addGroup("Siddhesh", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        XCTAssertNotNil(menuGroup, "Camper should not be nil")
        XCTAssertTrue(menuGroup?.name == "Siddhesh")
        XCTAssertNotNil(menuGroup?.image)
    }
    
    func testGetMenuGroupNoGroups(){
        let menuGroup = menuGroupService.getMenuGroup(name: "Pan Cake")
        XCTAssertNil(menuGroup, "No MenuGroup should be returned")
    }
    
    func testGetMenuGroupWithMatchingName(){
        _ = self.menuGroupService.addGroup("Apple pie", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        let menuGroup = menuGroupService.getMenuGroup(name: "Apple pie")
        XCTAssertNotNil(menuGroup, "MenuGroup should be returned")
    }
    
    func testGetMenuGroupWithNoMatchingName(){
        _ = self.menuGroupService.addGroup("Apple pie", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        let menuGroup = menuGroupService.getMenuGroup(name: "Pan Cake")
        XCTAssertNil(menuGroup, "No MenuGroup should be returned")
    }
    
    func testGetMenuGroupsNoGroups(){
        let groups = menuGroupService.getMenuGroups()
        XCTAssertTrue(groups.count == 0, "There should be no MenuGroup")
    }
    
    func testGetMenuGroupsOneGroup(){
        _ = self.menuGroupService.addGroup("Apple pie", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        let groups = menuGroupService.getMenuGroups()
        XCTAssertTrue(groups.count == 1, "There should be one MenuGroup")
    }
    
    func testGetMenuGroupsMultipleGroup(){
        _ = self.menuGroupService.addGroup("Apple pie", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        _ = self.menuGroupService.addGroup("Pan cakes", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        _ = self.menuGroupService.addGroup("Juice", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        
        let groups = menuGroupService.getMenuGroups()
        XCTAssertTrue(groups.count == 3, "There should be 3 MenuGroup")
    }
    
    func testDeleteMenuGroup(){
        _ = self.menuGroupService.addGroup("Apple pie", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        
        var fetchedMenuGroup = menuGroupService.getMenuGroup(name: "Apple pie")
        XCTAssertNotNil(fetchedMenuGroup, "Menu group should exist")
        
        menuGroupService.deleteMenuGroup(fetchedMenuGroup!)
        
        fetchedMenuGroup = menuGroupService.getMenuGroup(name: "Apple pie")
        XCTAssertNil(fetchedMenuGroup, "Group shouldn't exist")
    }
    
    func testEditMenuGroup(){
        _ = self.menuGroupService.addGroup("Apple pie", image: UIImagePNGRepresentation(UIImage(named: "cross")!)!)
        
        let fetchedMenuGroup = menuGroupService.getMenuGroup(name: "Apple pie")
        XCTAssertNotNil(fetchedMenuGroup, "Menu group should exist")
        
        fetchedMenuGroup?.name = "Pan Cake"
        
        let fetchedMenuUpdatedGroup = menuGroupService.updateGroup(fetchedMenuGroup!)
        XCTAssertTrue(fetchedMenuUpdatedGroup.name == "Pan Cake")
        
        let menuGroup = menuGroupService.getMenuGroup(name: "Pan Cake")
        XCTAssertNotNil(menuGroup, " MenuGroup should be returned")
        
    }
}

