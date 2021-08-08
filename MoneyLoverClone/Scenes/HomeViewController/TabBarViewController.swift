//
//  TabBarViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/29/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Then
import BWWalkthrough
import Reusable

final class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    var database: DBManager!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - View
    private func setupView() {
        UITabBar.appearance().do {
            $0.tintColor = .green
            $0.barTintColor = .white
        }
        delegate = self
    }
    
    // MARK: - Data
    private func setupData() {
        database = DBManager.shared
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[1] {
            let addTransactionScreen = AddTransactionTableViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: addTransactionScreen)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
            return false
        }
        return true
    }
}

