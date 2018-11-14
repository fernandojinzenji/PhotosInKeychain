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
        
        getMetaData(forImage: image!) // don't bring useful information
    }
}

func getMetaData(forImage image: UIImage) {
    guard let data = image.jpegData(compressionQuality: 0.2),
        let source = CGImageSourceCreateWithData(data as CFData, nil) else { return}
    
    if let type = CGImageSourceGetType(source) {
        print("type: \(type)")
    }
    
    if let properties = CGImageSourceCopyProperties(source, nil) {
        print("properties - \(properties)")
    }
    
    let count = CGImageSourceGetCount(source)
    print("count: \(count)")
    
    for index in 0..<count {
        if let metaData = CGImageSourceCopyMetadataAtIndex(source, index, nil) {
            print("all metaData[\(index)]: \(metaData)")
            
            let typeId = CGImageMetadataGetTypeID()
            print("metadata typeId[\(index)]: \(typeId)")
            
            
            if let tags = CGImageMetadataCopyTags(metaData) as? [CGImageMetadataTag] {
                
                print("number of tags - \(tags.count)")
                
                for tag in tags {
                    
                    let tagType = CGImageMetadataTagGetTypeID()
                    if let name = CGImageMetadataTagCopyName(tag) {
                        print("name: \(name)")
                    }
                    if let value = CGImageMetadataTagCopyValue(tag) {
                        print("value: \(value)")
                    }
                    if let prefix = CGImageMetadataTagCopyPrefix(tag) {
                        print("prefix: \(prefix)")
                    }
                    if let namespace = CGImageMetadataTagCopyNamespace(tag) {
                        print("namespace: \(namespace)")
                    }
                    if let qualifiers = CGImageMetadataTagCopyQualifiers(tag) {
                        print("qualifiers: \(qualifiers)")
                    }
                    print("-------")
                }
            }
        }
        
        if let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) {
            print("properties[\(index)]: \(properties)")
        }
    }
}
