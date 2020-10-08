//
//  UIView+.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/7/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map(UIColor.init)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
