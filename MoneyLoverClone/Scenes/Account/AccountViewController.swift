//
//  AccountViewController.swift
//  MoneyLoverClone
//
//  Created by nguyen viet hoang on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

final class AccountViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var accountImg: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var gmailLable: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Define
    struct Constant {
        static let heighForFooter: CGFloat = 45
        static let section = 2
    }
    
    // MARK: - Property
    var sectionArray = [AccountSectionModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    var pass = "123"
    var database = DBManager.shared
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTableView()
    }
    
    // MARK: - Data
    private func setupData() {
        setupDataTableView()
    }
    
    private func setupDataTableView() {
        let cellModelDataOne = [
            AccountCellModel(image: "group", name: "Nhóm"),
            AccountCellModel(image: "setting", name: "Cài đặt")
        ]
        let cellModelDataTwo = [
            AccountCellModel(image: "changepass", name: "Đổi mật khẩu"),
            AccountCellModel(image: "logout", name: "Đăng xuất")
        ]
        let sectionDataOne = AccountSectionModel(array: cellModelDataOne)
        let sectionDataTwo = AccountSectionModel(array: cellModelDataTwo)
        sectionArray = [sectionDataOne, sectionDataTwo]
    }
    
    // MARK: - View
    private func setupTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: AccountTableViewCell.self)
            $0.isScrollEnabled = false
        }
        
        let user = database.fetchUser()
        guard let avatar = user?.avatar,
            let url = URL(string: avatar) else {
            return
        }
        accountImg.sd_setImage(with: url, completed: nil)
        nameLabel.text = user?.name
        gmailLable.text = user?.email
        accountImg.layer.cornerRadius = 50
        gmailLable.textColor = .lightGray
        
        setupDataTableView()
    }
    
    // MARK: - Action
    private func logout() {
        let alert = UIAlertController(title: "Nhắc nhở", message: "Bạn có chắc muốn đăng xuất khỏi thiết bị này?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        let logoutAction = UIAlertAction(title: "Đăng xuất", style: .default, handler: { _ in
        })
        alert.addAction(logoutAction)
        present(alert, animated: true)
    }
}

extension AccountViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = sectionArray[section]
        let array = sectionData.array
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let sectionData = sectionArray[section]
        let array = sectionData.array
        
        let item = array[row]
        
        let cell: AccountTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setContent(data: item)
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constant.heighForFooter
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
         
        switch section {
        case 0:
            switch row {
            case 0:
                print("Man hinh nhom")
            case 1:
                let settingScreen = SettingsTableViewController.instantiate()
                settingScreen.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(settingScreen, animated: true)
            default :
                break
            }
        case 1:
            switch row {
            case 0:
                let changePass = ChangePasswordViewController.instantiate()
                changePass.currentPass = pass
                changePass.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(changePass, animated: true)
            case 1:
                logout()
            default :
                break
            }
        default: break
        }
    }
}

extension AccountViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.account
}
