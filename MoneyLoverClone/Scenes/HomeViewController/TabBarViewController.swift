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
        delegate = self
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[1] {
            let addTransactionScreen = AddTransactionTableViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: addTransactionScreen)
            present(navigationController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
