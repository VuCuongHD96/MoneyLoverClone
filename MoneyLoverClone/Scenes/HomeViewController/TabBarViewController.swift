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
        let user = database.fetchUser()
//        if user == nil {
//            setupWalkThough()
//        }
    }
    
    // MARK: - View
    private func setupView() {
        UITabBar.appearance().do {
            $0.tintColor = .systemGreen
            $0.barTintColor = .white
        }
        delegate = self
    }
    
    // MARK: - Data
    private func setupData() {
        database = DBManager.shared
    }
    
    private func setupWalkThough() {
        let storyBoard = Storyboard.walkThrough
        let walkThoughScreen = WalkThroughViewController.instantiate()
        let pageOne = storyBoard.instantiateViewController(identifier: "PageOne")
        let pageTwo = storyBoard.instantiateViewController(identifier: "PageTwo")
        let pageThree = storyBoard.instantiateViewController(identifier: "PageThree")
        let pageFour = storyBoard.instantiateViewController(identifier: "PageFour")
        let pageFive = storyBoard.instantiateViewController(identifier: "PageFive")
        walkThoughScreen.add(viewController: pageOne)
        walkThoughScreen.add(viewController: pageTwo)
        walkThoughScreen.add(viewController: pageThree)
        walkThoughScreen.add(viewController: pageFour)
        walkThoughScreen.add(viewController: pageFive)
        walkThoughScreen.modalPresentationStyle = .fullScreen
        present(walkThoughScreen, animated: false, completion: nil)
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
