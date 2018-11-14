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
    
    public func setImage(image: UIImage?) {
        keychainImageView.image = image
    }
}
