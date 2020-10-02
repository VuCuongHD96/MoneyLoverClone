//
//  ChangePassViewController.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/29/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

class ChangePassViewController: UIViewController {

    @IBOutlet private weak var oldPassTextField: UITextField!
    @IBOutlet private weak var newPassTextField: UITextField!
    @IBOutlet private weak var confirmPassTextField: UITextField!
    @IBOutlet private weak var btnSave: UIButton!
    
    var currentPass = ""
    var textPass = ""
    var textNewPass = ""
    var textConfirm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextPlaceHolder()
        print(currentPass)
    }
    
    func setTextPlaceHolder() {
        setTextField(oldPassTextField, input: "Nhập mật khẩu")
        setTextField(newPassTextField, input: "Nhập mật khẩu mới")
        setTextField(confirmPassTextField, input: "Xác nhận lại mật khẩu")
    }
    
    func setTextField(_ textfield: UITextField, input: String) {
        var placeHolder = NSMutableAttributedString()
        let placeHolderText = input
        placeHolder = NSMutableAttributedString(string: placeHolderText, attributes: [.font: UIFont(name: "Helvetica", size: 16)!])
        textfield.attributedPlaceholder = placeHolder
    }

    @IBAction func clickSave(_ sender: Any) {
        textNewPass = newPassTextField.text ?? ""
        textPass = oldPassTextField.text ?? ""
        textConfirm = confirmPassTextField.text ?? ""
        if textPass == currentPass {
            if textNewPass.isEmpty || textConfirm.isEmpty {
                showAlert(message: "Mật khẩu không được để trống")
            } else {
                if textNewPass == textConfirm {
                    currentPass = textNewPass
                    showAlertSuccess()
                } else {
                    showAlert(message: "Mật khẩu không khớp")
                }
            }
        } else {
            showAlert(message: "Nhập sai mật khẩu")
        }
    }
    
    func showAlertSuccess() {
        let alert = UIAlertController(title: "Thông báo", message: "Đổi mật khẩu thành công thành công", preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            alert.dismiss(animated: true, completion: nil)
            let accountScreen = AccountViewController.instantiate()
            self.navigationController?.pushViewController(accountScreen, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Nhắc nhở", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension ChangePassViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.changepass
}
