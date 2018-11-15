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
    
    lazy var viewModel: SecondViewModel = {
        return SecondViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Manage Photos In Keychain"
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(imageLongPressed(_:)))
        longPress.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPress)
        
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        viewModel.loadList()
    }
    
    func initViewModel() {
        
        viewModel.reloadCollectionViewClosure = { [weak self] () in
        
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
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
            
            viewModel.delete(index: indexPath.item)
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.clearAll()
    }
    
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfCells
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellViewModel = viewModel.getCellViewModel(index: indexPath.item)
        
        switch mode {
        case .Grid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! GridCollectionViewCell
            
            cell.setImage(image: cellViewModel.image)
            return cell
        case .List:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
            
            cell.setImage(image: cellViewModel.image)
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
