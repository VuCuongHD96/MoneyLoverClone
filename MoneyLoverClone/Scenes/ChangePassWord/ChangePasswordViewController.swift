//
//  ChangePasswordViewController.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 10/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable
import Toast_Swift

class ChangePasswordViewController: UIViewController {
    
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
                view.makeToast("Mật khẩu không được để trống")
            } else {
                if textNewPass == textConfirm {
                    view.makeToast("Đổi mật khẩu thành công")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    view.makeToast("Mật khẩu không khớp")
                }
            }
        } else {
            view.makeToast("Nhập sai mật khẩu")
        }
    }
}

extension ChangePasswordViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.changepass
}
