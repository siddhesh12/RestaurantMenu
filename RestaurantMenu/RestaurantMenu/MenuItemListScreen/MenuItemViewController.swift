//
//  MenuItemViewController.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import CoreData
class MenuItemViewController: UIViewController {

    var coreDataStack: DataStack!
    
    var menuGroup: MenuGroup?
    var menuItemService:MenuItemService?
    
    @IBOutlet weak var menuItemTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuItemService = MenuItemService(managedObjectContext: coreDataStack.mainContext,coreDataStack:coreDataStack)
        menuItemTableView.reloadData()
    }
    deinit {
        menuItemService = nil
    }
    
// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let navVC = segue.destination as? UINavigationController, let destinationVC = navVC.topViewController as? CreateMenuViewController else { return }

        destinationVC.menuItemDelegate = self
        destinationVC.isMenuGroup = false
        guard let indexPath = sender as? Int, let item = menuGroup?.menuItems?[indexPath] as? MenuItem else { return }

        destinationVC.menuItem = item
        destinationVC.name = item.name
        destinationVC.price = "\(item.price)"
        if let imageData = item.image{
            destinationVC.seletectImage = UIImage(data: imageData)
        }
    }
}

// MARK: - IBActions
extension MenuItemViewController {
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "createVCFromItemsSegueID", sender: nil)
    }
}

// MARK: UITableViewDataSource
extension MenuItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuGroup!.menuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! MenuTableViewCell
        
        guard let menuItem = menuGroup?.menuItems?[indexPath.row] as? MenuItem else {return cell }
        
        cell.nameLabel.text = menuItem.name
        cell.priceLabel.text = "$\(menuItem.price)"
        if let imageData = menuItem.image{
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
            
            guard let menuItem = self.menuGroup!.menuItems?[indexPath.row] as? MenuItem else{ return }

            self.coreDataStack.mainContext.delete(menuItem)
            do {
                try self.coreDataStack.mainContext.save()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error as NSError {
                print("Saving error: \(error), description: \(error.userInfo)")
            }
        }
        
        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "createVCFromItemsSegueID", sender: indexPath.row)
        }
        
        return [delete, share]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITableViewDelegate
extension MenuItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - createMenuControllerDelegate
extension MenuItemViewController: CreateMenuViewControllerItemDelegate {
    
    func saveClicked(name: String!, price: String?, image: UIImage?, menuItem: MenuItem?) {
        guard let imageData = UIImagePNGRepresentation(image!) else {return }
        if let menuItem = menuItem {
            menuItem.name = name!
            menuItem.price = Float(price!)!
            menuItem.image =  imageDataScaledToHeight(imageData, height: 240)
            _ = menuItemService?.updateMenuItem(menuItem)
            menuItemTableView.reloadData()
        }
        else {
            let _ = menuItemService?.addItem(name!, price: price!, image: imageDataScaledToHeight(imageData, height: 240), menuGroup: menuGroup!)
            menuItemTableView.reloadData()
        }
    }
}



