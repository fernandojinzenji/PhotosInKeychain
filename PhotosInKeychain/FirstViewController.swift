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
    private let keychainHelper = KeychainHelper()
    
    // Array containing uuids used to store images in keychain
    private var imageIdentifiers = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Photos To Keychain"
     
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        imageIdentifiers = KeychainHelper().getImageUuids()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
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
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageData = image.jpegData(compressionQuality: 0.2) {
            
            // generate identifier for image
            let uuid = UUID().uuidString

            // save image in keychain
            keychainHelper.set(imageData, forKey: uuid)
            
            // save images uuid list in keychain
            imageIdentifiers.append(uuid)
            keychainHelper.saveImageUuids(uuids: imageIdentifiers)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        
        // Add image ordered by most recent
        let uuid = imageIdentifiers[imageIdentifiers.count - indexPath.row - 1]
        cell.setImage(image: keychainHelper.getImage(uuid: uuid))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
}
