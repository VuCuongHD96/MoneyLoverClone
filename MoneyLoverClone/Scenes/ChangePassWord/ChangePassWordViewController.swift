//
//  ChangePassWordViewController.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 10/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable
class ChangePassWordViewController: UIViewController {

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
                    showToast(message: "Mật khẩu không được để trống")
                } else {
                    if textNewPass == textConfirm {
                        currentPass = textNewPass
                        showToast(message: "Đổi mật khẩu thành công thành công")
                    } else {
                        showToast(message: "Mật khẩu không khớp")
                    }
                }
            } else {
                showToast(message: "Nhập sai mật khẩu")
            }
        }
     
}

extension ChangePassWordViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.changepass
}

extension ChangePassWordViewController {
    func showToast(message: String) {
        let toastLable = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 150, y: self.view.frame.height - 100, width: 300, height: 40))
        toastLable.text = message
        toastLable.textAlignment = .center
        toastLable.font = UIFont.systemFont(ofSize: 16)
        toastLable.textColor = UIColor.white
        toastLable.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLable.layer.cornerRadius = 10
        toastLable.clipsToBounds = true
        view.addSubview(toastLable)
        UIView.animate(withDuration: 4.0, delay: 1.0, options: .curveEaseInOut, animations: {
            toastLable.alpha = 0
        }) {(isCompleted) in
            toastLable.removeFromSuperview()
        }
    }
}
