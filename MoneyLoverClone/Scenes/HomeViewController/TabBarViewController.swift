//
//  TabBarViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/29/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Then

final class TabBarViewController: UITabBarController {

    // MARK: - Outlet
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - View
    private func setupView() {
        UITabBar.appearance().do {
            $0.tintColor = .systemGreen
            $0.barTintColor = .white
        }
    }
}
