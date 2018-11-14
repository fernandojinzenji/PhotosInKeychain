//
//  ListCollectionViewCell.swift
//  PhotosInKeychain
//
//  Created by Fernando Jinzenji on 2018-11-13.
//  Copyright © 2018 Fernando Jinzenji. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var imageMetadata: UILabel!
    
    public func setImage(image: UIImage?) {
        listImageView.image = image
    }
}
