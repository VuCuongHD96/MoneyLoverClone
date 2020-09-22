//
//  ChangePassViewController.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController {

    @IBOutlet private weak var tfOldPass: UITextField!
    @IBOutlet private weak var tfNewPass: UITextField!
    @IBOutlet private weak var tfConfirmPass: UITextField!
    @IBOutlet private weak var btnSave: UIButton!
    var placeholderLabel : UILabel!
    
    var currentPass: String = ""
    var textPass = ""
    var textNewPass = ""
    var textConfirm = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextPlaceHolder()
    }
    
    func setTextPlaceHolder() {
        setTextField(tfOldPass , input: "Nhập mật khẩu")
        setTextField(tfNewPass , input: "Nhập mật khẩu mới")
        setTextField(tfConfirmPass , input: "Xác nhận lại mật khẩu")
    }
    
    func setTextField(_ textfield : UITextField, input : String ) {
        var placeHolder = NSMutableAttributedString()
        let placeHolderText  = input
        placeHolder = NSMutableAttributedString(string:placeHolderText, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 16)!])
         textfield.attributedPlaceholder = placeHolder
    }
    
    @IBAction func changePass(_ sender: Any) {
        textNewPass = tfNewPass.text ?? ""
        textPass = tfOldPass.text ?? ""
        textConfirm = tfConfirmPass.text ?? ""
        
        if textPass == currentPass {
            if textNewPass.isEmpty || textConfirm.isEmpty {
                showAlert(message: "Mật khẩu không được để trống")
            }
            else {
                if textNewPass == textConfirm {
                    currentPass = textNewPass
                    showAlertSuccess()
                }
                else {
                    showAlert(message: "Mật khẩu không khớp")
                }
            }
        }
        else {
            showAlert(message: "Nhập sai mật khẩu")
        }
    }
    
    func showAlertSuccess() {
        let alert = UIAlertController(title: "Thông báo", message:"Đổi mật khẩu thành công thành công", preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
            alert.dismiss(animated: true, completion: nil)
            guard let vc = self.storyboard?.instantiateViewController(identifier: "AccountViewController") as? AccountViewController else { return  }
            vc.newPass = self.currentPass
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert( message : String ) {
        let alert = UIAlertController(title: "Nhắc nhở", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}


