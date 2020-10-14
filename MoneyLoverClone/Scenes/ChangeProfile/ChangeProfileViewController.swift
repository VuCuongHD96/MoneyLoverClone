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
import Kingfisher

class ChangeProfileViewController: UIViewController {
    
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    
    let user = User(name: "minh thang", email: "minhthang09199@gmail.com", avatar: "")
    let storage = Storage.storage().reference()
    let ref = Database.database().reference()
    let tapImage = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tappedImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        getImageData()
        emailTextField.text = user.email
        emailTextField.isUserInteractionEnabled = false
        nameTextField.text = user.name
    }
    
    func tappedImage() {
        tapImage.addTarget(self, action: #selector(handleSelectProfileImageView))
        avatarImage.addGestureRecognizer(tapImage)
        avatarImage.isUserInteractionEnabled = true
    }
    
    func getImageData() {
        ref.child("Users").child("user 01").child("avatarURL").observeSingleEvent(of: .value) { (snapshot) in
            guard let avatarURL = snapshot.value as? String else {
                return
            }
            self.avatarImage.kf.setImage(with: URL(string: avatarURL))
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
                self.ref.child("Users").child("user 01").child("avatarURL").setValue("\(url)")
            })
        })
        let name = nameTextField.text ?? ""
        ref.child("Users").child("user 01").child("name").setValue("\(name)")
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
}





