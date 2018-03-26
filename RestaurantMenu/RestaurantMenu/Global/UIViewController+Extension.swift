//
//  UIImage+Extension.swift
//  RestaurantMenu
//
//  Created by Siddhesh Mahadeshwar on 26/03/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func imageDataScaledToHeight(_ imageData: Data, height: CGFloat) -> Data {
        
        let image = UIImage(data: imageData)!
        let oldHeight = image.size.height
        let scaleFactor = height / oldHeight
        let newWidth = image.size.width * scaleFactor
        let newSize = CGSize(width: newWidth, height: height)
        let newRect = CGRect(x: 0, y: 0, width: newWidth, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImageJPEGRepresentation(newImage!, 0.8)!
    }
}

