//
//  SecondViewModel.swift
//  PhotosInKeychain
//
//  Created by Fernando Jinzenji on 2018-11-14.
//  Copyright © 2018 Fernando Jinzenji. All rights reserved.
//

import Foundation
import UIKit

class SecondViewModel {
    
    private let keychain = KeychainHelper()
    private var imageUuids = [String]()
    
    private var cellViewModels = [CollectionCellViewModel]() {
        didSet {
            self.reloadCollectionViewClosure?()
        }
    }
    var reloadCollectionViewClosure: (() -> ())?
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    public func loadList() {
        imageUuids = keychain.getImageUuids()
        
        var vms = [CollectionCellViewModel]()
        for uuid in imageUuids {
            
            vms.append(CollectionCellViewModel(image: keychain.getImage(uuid: uuid)))
        }
        cellViewModels = vms
    }
    
    public func getCellViewModel(index: Int) -> CollectionCellViewModel {
        
        return cellViewModels[index]
    }
    
    public func delete(index: Int) {
        
        // remove image
        let uuid = imageUuids[index]
        keychain.delete(uuid)
        
        // update image uuid list
        imageUuids.remove(at: index)
        keychain.saveImageUuids(uuids: imageUuids)
        
        // update cell view models
        cellViewModels.remove(at: index)
    }
    
    public func clearAll() {
        keychain.clear()
        imageUuids = []
        cellViewModels = []
    }
}

struct CollectionCellViewModel {
    
    let image: UIImage?
}
