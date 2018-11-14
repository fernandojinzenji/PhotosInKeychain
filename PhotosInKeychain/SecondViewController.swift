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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Manage Photos On Keychain"
        
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
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch mode {
        case .Grid:
            let cellSize = collectionView.frame.width / 3
            return CGSize(width: cellSize, height: cellSize)
        case .List:
            let cellSize = collectionView.frame.width
            return CGSize(width: cellSize, height: 100.0)
        }
    }
}

enum CollectionViewMode {
    case Grid
    case List
}
