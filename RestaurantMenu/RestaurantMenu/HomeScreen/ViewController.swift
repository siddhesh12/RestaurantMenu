//
//  ViewController.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    var coreDataStack: DataStack!
    
    var menuGroups:[MenuGroup] = []
    var menuGroupSevice:MenuGroupService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuGroupSevice = MenuGroupService(managedObjectContext: coreDataStack.mainContext,coreDataStack:coreDataStack)
        menuGroupSevice?.insertSampleData()
        getMenuGroups()
    }
    
    deinit {
        menuGroupSevice = nil
    }
    
//     MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController, let destinationVC = navVC.topViewController as? CreateMenuViewController {
            destinationVC.menuGroupDelegate = self
            guard let indexPath = sender as? Int else { return }

            destinationVC.menuGroup = menuGroups[indexPath]
            destinationVC.name = destinationVC.menuGroup?.name
            if let imageData = destinationVC.menuGroup?.image as Data?{
                destinationVC.seletectImage = UIImage(data: imageData)
            }
        }
        else if let destinationVC = segue.destination as? MenuItemViewController{

            destinationVC.coreDataStack = coreDataStack
            guard let indexPath = sender as? Int else { return }
            let menuGroup = menuGroups[indexPath]
            destinationVC.menuGroup = menuGroup
        }
    }
}

// MARK: - Helper methods
extension ViewController {
    func getMenuGroups(){
        guard let menuGroups = menuGroupSevice?.getMenuGroups() else {return}
        self.menuGroups = menuGroups
        menuTableView.reloadData()
    }
}

// MARK: - IBActions
extension ViewController {
    @IBAction func add(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "createVCSegue", sender: nil)
    }
}
    
// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! MenuTableViewCell
        
        let menuGroup = menuGroups[indexPath.row]
        
        cell.nameLabel.text = menuGroup.name
        
        if let imageData = menuGroup.image{
            cell.picture.image = UIImage(data: imageData as Data)
        }
        else{
            cell.picture.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete"){
            (action, indexPath) in
            
            let menuGroup = self.menuGroups[indexPath.row]
            guard let menuGroupService = self.menuGroupSevice else{ return }
            
            menuGroupService.deleteMenuGroup(menuGroup)
            self.menuGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "createVCSegue", sender: indexPath.row)
        }
        
        return [delete, share]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "menuItemSegueID", sender: indexPath.row)
    }
}

// MARK: - createMenuControllerDelegate
extension ViewController: CreateMenuViewControllerGroupDelegate {
    
    func saveClicked(name: String?, image: UIImage?, menuGroup: MenuGroup?) {
        guard let imageData = UIImagePNGRepresentation(image!) else {return }
        
        if let menuGroup = menuGroup {
            menuGroup.name = name!
            menuGroup.image =  imageDataScaledToHeight(imageData, height: 240)
            let _ = menuGroupSevice?.updateGroup(menuGroup)
            getMenuGroups()
        }
        else {
            let _ = menuGroupSevice?.addGroup(name!, image: imageDataScaledToHeight(imageData, height: 240))
            getMenuGroups()
        }
    }
}


