//
//  ChoiseEventTableViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/1/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

final class ChoiseEventTableViewController: UITableViewController {
    
    // MARK: - Properties
    struct Constant {
        static let cellHeight: CGFloat = 50
    }
    var categoryArray = [Category]()
    typealias Handler = (Category) -> Void
    var passData: Handler?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    // MARK: - Data
    private func setupData() {
        tableView.do {
            $0.register(cellType: CategoryCell.self)
            $0.register(cellType: AddEventCell.self)
        }
        fetchCategoryData(from: "RevenueArray")
    }
    
    private func fetchCategoryData(from name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let nsDictionary = NSDictionary(contentsOfFile: path) else { return }
        categoryArray = nsDictionary.map {
            let imageString = $0.key as? String ?? ""
            let name = $0.value as? String ?? ""
            let category = Category(image: imageString, name: name)
            return category
        }
    }
    
    // MARK: - View
    private func setupView() {
        navigationItem.title = "Chọn sự kiện"
    }
}

// MARK: - TableView Datasource
extension ChoiseEventTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return categoryArray.count
        case 1:
            return 1
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: CategoryCell = tableView.dequeueReusableCell(for: indexPath)
            let category = categoryArray[indexPath.row]
            cell.setContent(data: category)
            return cell
        case 1:
            let addCell: AddEventCell = tableView.dequeueReusableCell(for: indexPath)
            return addCell
        default:
            break
        }
        return UITableViewCell()
    }
}

extension ChoiseEventTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let category = categoryArray[indexPath.row]
            passData?(category)
        case 1:
            let addEventScreen = AddEventTableViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: addEventScreen)
            present(navigationController, animated: true, completion: nil)
        default:
            break
        }
    }
}
