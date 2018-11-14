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
    
    let imagePicker = UIImagePickerController()
    
    var imageIdentifiers = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Photos To Keychain"
     
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        if let hasImageUuidList = KeychainHelper().getData("Photos") {
        
            do {
                if let ids = try  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(hasImageUuidList) as? [String] {
                    
                    imageIdentifiers = ids
                }
            }
            catch {
                print("got it")
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
            
            // save to keychain
            do {
                // generate identifier for image
                let uuid = UUID().uuidString

                let keychain = KeychainHelper()
                
                // save image in keychain
                keychain.set(image.jpegData(compressionQuality: 1.0)!, forKey: uuid)
                
                // save array in keychain
                imageIdentifiers.append(uuid)
                let archive = try NSKeyedArchiver.archivedData(withRootObject: imageIdentifiers, requiringSecureCoding: false)
                KeychainHelper().set(archive, forKey: "Photos")
            }
            catch {
                print("error saving photos in keychain")
            }
            
            
            tableView.reloadData()
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        // Add image ordered by most recent
        let image = UIImage(data: KeychainHelper().getData(imageIdentifiers[imageIdentifiers.count - indexPath.row - 1])!)
        cell.setImage(image: image!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
}
