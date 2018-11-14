//
//  SecondViewController.swift
//  PhotosInKeychain
//
//  Created by Fernando Jinzenji on 2018-11-13.
//  Copyright © 2018 Fernando Jinzenji. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var mode = CollectionViewMode.Grid
    private let keychainHelper = KeychainHelper()
    
    
    // Array containing uuids used to store images in keychain
    private var imageIdentifiers = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Manage Photos In Keychain"
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed(_:)))
        longPress.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        imageIdentifiers = KeychainHelper().getImageUuids()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func viewTypeChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            mode = .Grid
        default:
            mode = .List
        }
        
        self.collectionView.reloadData()
    }
    
    @objc private func imageLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            let point = sender.location(in: collectionView)
            
            guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
            
            // remove image
            let uuid = imageIdentifiers[indexPath.item]
            keychainHelper.delete(uuid)
            
            // update image uuid list
            imageIdentifiers.remove(at: indexPath.item)
            keychainHelper.saveImageUuids(uuids: imageIdentifiers)
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        keychainHelper.clear()
        imageIdentifiers = []
    }
    
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageIdentifiers.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch mode {
        case .Grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! GridCollectionViewCell
            cell.setImage(image: keychainHelper.getImage(uuid: imageIdentifiers[indexPath.row]))
            return cell
        case .List:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
            cell.setImage(image: keychainHelper.getImage(uuid: imageIdentifiers[indexPath.row]))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch mode {
        case .Grid:
            let cellSize = collectionView.frame.width / 3
            return CGSize(width: cellSize, height: cellSize)
        case .List:
            let cellSize = collectionView.frame.width
            return CGSize(width: cellSize, height: 80.0)
        }
    }
}

public enum CollectionViewMode {
    case Grid
    case List
}
