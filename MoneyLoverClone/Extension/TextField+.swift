//
//  TextField+.swift
//  MoneyLoverClone
//
//  Created by Cuong on 6/5/21.
//  Copyright © 2021 Vu Xuan Cuong. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addDoneButton(with action: Selector = #selector(UIView.endEditing(_:))) {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneAction = UIBarButtonItem(title: "Done", style: .done, target: self, action: action)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(doneAction)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    private func hideKeyBoard() {
        self.resignFirstResponder()
    }
}
