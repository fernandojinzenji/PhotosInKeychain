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
    
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Add Photos To Keychain"
     
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
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
            
            images.append(image)
            
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
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        // Add image ordered by most recent
        cell.setImage(image: images[images.count - indexPath.row - 1])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width - 16.0
    }
}
