//
//  CustomTableViewCell.swift
//  PhotosInKeychain
//
//  Created by Fernando Jinzenji on 2018-11-13.
//  Copyright © 2018 Fernando Jinzenji. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var keychainImageView: UIImageView!
    
    public func setImage(image: UIImage) {
        keychainImageView.image = scaleUIImageToSize(image: image, size: CGSize(width: 184, height: 184))
    }
    
    func scaleUIImageToSize(image: UIImage, size: CGSize) -> UIImage? {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
