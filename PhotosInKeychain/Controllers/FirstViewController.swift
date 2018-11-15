//
//  FirstViewController.swift
//  PhotosInKeychain
//
//  Created by Fernando Jinzenji on 2018-11-13.
//  Copyright © 2018 Fernando Jinzenji. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let imagePicker = UIImagePickerController()
    
    lazy var viewModel: FirstViewModel = {
        return FirstViewModel()
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Photos To Keychain"
     
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        initViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        viewModel.loadList()
    }
    
    func initViewModel() {
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    @IBAction func addPhotoButton(_ sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.getPhoto(type: .camera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.getPhoto(type: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func getPhoto(type: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(type) {
            imagePicker.sourceType = type
            present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension FirstViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            viewModel.savePhoto(image: image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        // Add image ordered by most recent
        let reversedIndex = viewModel.numberOfCells - indexPath.row - 1
        let cellViewModel = viewModel.getCellViewModel(index: reversedIndex)
        
        cell.setImage(image: cellViewModel.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
}
