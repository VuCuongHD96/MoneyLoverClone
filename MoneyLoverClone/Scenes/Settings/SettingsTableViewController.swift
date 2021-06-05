//
//  SettingsTableViewController.swift
//  MoneyLoverClone
//
//  Created by Phan Minh Thang on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class SettingsTableViewController: UITableViewController {
    
    // MARK: - Define
    struct Constant {
        static let sectionTitle = "HIỂN THỊ"
        static let numberOfSections = 1
        static let numberOfRowsInSection = 3
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup View
    private func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfRowsInSection
    }
}

extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constant.sectionTitle
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let changeProfileScreen = ChangeProfileViewController.instantiate()
            navigationController?.pushViewController(changeProfileScreen, animated: true)
        case 1:
            print("man hinh sua dinh dang ngay thang")
        case 2:
            print("man hinh chon ngon ngu")
        default: break
        }
    }
}

extension SettingsTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.setting
}
