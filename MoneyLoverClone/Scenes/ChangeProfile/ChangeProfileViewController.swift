//
//  ChangeProfileViewController.swift
//  MoneyLoverClone
//
//  Created by Phan Minh Thang on 10/9/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import RealmSwift

class ChangeProfileViewController: UIViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    let user = User(name: "minh thang", email: "minhthang09199@gmail.com", avatar: "")
    private let storage = Storage.storage().reference()
    let ref = Database.database().reference()
    let tapImage = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func tappedImage() {
        tapImage.addTarget(self, action: #selector(handleSelectProfileImageView))
        avatarImage.addGestureRecognizer(tapImage)
        avatarImage.isUserInteractionEnabled = true
    }
    
    
    func getData() {
        ref.child("Users").child("user 01").child("avatarURL").observeSingleEvent(of: .value) { (snapshot) in
            guard let avatarURL = snapshot.value as? String else {
                return
            }
            let imageURL = URL(string: avatarURL)
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL!) else {
                    return
                }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.avatarImage.image = image
                }
            }
        }
    }
    
    @IBAction func saveProfile(_ sender: Any) {
        guard let imageData = avatarImage.image?.pngData() else {
            return
        }
        storage.child("images/\(user.email)file.png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("failed to upload")
                return
            }
            self.storage.child("images/\(self.user.email)file.png").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                print(url)
                self.ref.child("Users").child("user 01").setValue(["avatarURL" : "\(url)"])
            })
        })
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChangeProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker : UIImage?
        if let editedImage  = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            avatarImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    //    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        picker.dismiss(animated: true, completion: nil)
    //        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
    //            return
    //        }
    //        guard let imageData = image.pngData() else {
    //            return
    //        }
    //        storage.child("images/file.png").putData(imageData, metadata: nil, completion: { _, error in
    //            guard error == nil else {
    //                print("failed to upload")
    //                return
    //            }
    //            self.storage.child("images/file.png").downloadURL(completion: { url, error in
    //                guard let url = url, error == nil else {
    //                    return
    //                }
    //                let urlString = url.absoluteString
    //                DispatchQueue.main.async {
    //                    self.avatarImage.image = image
    //                }
    //                print("Download url: \(urlString)")
    //                UserDefaults.standard.set(urlString, forKey: "url")
    //            })
    //        })
    //    }
}









