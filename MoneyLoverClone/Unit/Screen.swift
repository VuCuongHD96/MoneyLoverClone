//
//  Screen.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/28/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

struct Screen {
    static let bounds = UIScreen.main.bounds
    static let width = bounds.size.width
    static let height = bounds.size.height
    static let designWidth: CGFloat = 320
    static let designHeight: CGFloat = 568
    static let ratioWidth = width / designWidth
    static let ratioHeight = height / designHeight
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
}
