//
//  FirstViewModel.swift
//  PhotosInKeychain
//
//  Created by Fernando Jinzenji on 2018-11-14.
//  Copyright © 2018 Fernando Jinzenji. All rights reserved.
//

import Foundation
import UIKit

class FirstViewModel {
    
    private let keychain = KeychainHelper()
    private var imageUuids = [String]()
    
    private var cellViewModels = [TableCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var reloadTableViewClosure: (() -> ())?
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    public func loadList() {
        imageUuids = keychain.getImageUuids()
        
        var vms = [TableCellViewModel]()
        for uuid in imageUuids {
            
            vms.append(TableCellViewModel(image: keychain.getImage(uuid: uuid)))
        }
        cellViewModels = vms
    }
    
    public func savePhoto(image: UIImage) {
        
        if let imageData = image.jpegData(compressionQuality: 0.2) {
            
            // generate uuid
            let uuid = UUID().uuidString
            
            // save image in keychain
            keychain.set(imageData, forKey: uuid)
            
            // save image uuid list in keychain
            imageUuids.append(uuid)
            keychain.saveImageUuids(uuids: imageUuids)
            
            // add to cell view model collection
            cellViewModels.append(TableCellViewModel(image: image))
        }
    }
    
    public func getCellViewModel(index: Int) -> TableCellViewModel {
        
        return cellViewModels[index]
    }
}

struct TableCellViewModel {
    let image: UIImage?
}
