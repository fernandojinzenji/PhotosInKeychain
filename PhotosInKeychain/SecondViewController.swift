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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed(_:)))
        longPress.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPress)
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
            
            let indexPath = collectionView.indexPathForItem(at: point)
            
            print(indexPath?.row)
        }
    }
    
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        switch mode {
        case .Grid:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! GridCollectionViewCell
        case .List:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
        }
        
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

public enum CollectionViewMode {
    case Grid
    case List
}
