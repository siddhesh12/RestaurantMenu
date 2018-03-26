//
//  CreateMenuViewController.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 25/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit

protocol CreateMenuViewControllerGroupDelegate:class {
    func saveClicked(name:String?, image:UIImage?, menuGroup:MenuGroup?)
}
protocol CreateMenuViewControllerItemDelegate:class {
    func saveClicked(name:String!, price:String?, image:UIImage?, menuItem:MenuItem?)
}

class CreateMenuViewController: UIViewController {

    weak var menuGroupDelegate:CreateMenuViewControllerGroupDelegate?
    weak var menuItemDelegate:CreateMenuViewControllerItemDelegate?
    
    @IBOutlet weak var imageTopConstraintWithPriceView: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraintWithTitleView: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var attachButton: UIButton!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    var isMenuGroup:Bool = true
    @IBOutlet weak var removeImage: UIButton!
    
    var price:String?
    var name:String?
    var seletectImage:UIImage?
    var menuGroup:MenuGroup?
    var menuItem:MenuItem?
    
    lazy var imagePicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

// MARK: Internal
extension CreateMenuViewController {
    
    /// Update the user interface.
    func configureView() {
        
        title = isMenuGroup ? "Categories" : "Items"
        imageTopConstraintWithPriceView.isActive = !isMenuGroup
        imageTopConstraintWithTitleView.isActive = isMenuGroup
        nameTextField.text = name
        priceTextField.text = price
        
        guard seletectImage != nil else { return}
        showImageView(true)
    }
    
    func showImageView(_ show:Bool)
    {
        imageView.image = seletectImage
        imageView.alpha = show ? 1:0
        removeImage.alpha = show ? 1:0
        attachButton.alpha = show ? 0:1
    }
    
    func isVerified() -> Bool{
        
        if isMenuGroup{
            guard let name = nameTextField.text, !name.isEmpty, let _ = seletectImage else{
                showError(); return false}
        }
        else{
            guard let name = nameTextField.text, !name.isEmpty, let _ = seletectImage, let price = priceTextField.text, !price.isEmpty, price.isNumber   else{ showError(); return false}
        }
        return true
    }
    func showError(){
        let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        navigationController?.present(alert, animated: true)
    }
}

// MARK: - string helper
extension String {
    var isNumber: Bool {
        return Float(self) != nil
    }
}
// MARK: - IBActions
extension CreateMenuViewController{
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if isVerified(){
            if isMenuGroup {
                menuGroupDelegate?.saveClicked(name: nameTextField.text, image: seletectImage, menuGroup: menuGroup)
            }
            else {
                menuItemDelegate?.saveClicked(name: nameTextField.text, price: priceTextField.text, image: seletectImage, menuItem: menuItem)
            }
            dismiss(animated: true)
        }
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func removeImage(_ sender: UIButton) {
        showImageView(false)
        seletectImage = nil
    }
    @IBAction func attachedButton(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreateMenuViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        
        seletectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        showImageView(true)
        imagePicker.delegate = nil
        imagePicker.dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension CreateMenuViewController: UINavigationControllerDelegate {
    
}

// MARK: - UITextFieldDelegate
extension CreateMenuViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
