//
//  CategoryViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class CategoryViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segment: UISegmentedControl!
    
    // MARK: - Properties
    struct Constant {
        static let heightForRowAt: CGFloat = 50
    }
    var categoryArray = [Category]()
    var categoryArraySelected = [Category]() {
        didSet {
            tableView.reloadData()
        }
    }
    typealias Handler = (Category) -> Void
    var passCategory: Handler?
    var categorySelected: Category?
    var database: DBManager!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }
    
    // MARK: - Views
    private func setupViews() {
        segment.do {
            $0.layer.borderWidth = 1
            $0.selectedSegmentTintColor = .green
            $0.layer.borderColor = UIColor.green.cgColor
            $0.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            $0.setTitleTextAttributes([.foregroundColor: UIColor.systemGreen], for: .normal)
            $0.backgroundColor = .white
        }
        navigationItem.title = "Chọn nhóm"
    }
    
    // MARK: - Data
    private func setupData() {
        database = DBManager.shared
        database.setupCategoryData()
        categoryArray = database.fetchCategorys()
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CategoryCell.self)
        }
        choiseCategory(segment)
        if categorySelected != nil {
            guard let transactionType = categorySelected?.transactionType else {
                return
            }
            switch transactionType {
            case TransactionType.expendsed.rawValue:
                segment.selectedSegmentIndex = 0
            case TransactionType.income.rawValue:
                segment.selectedSegmentIndex = 1
            default:
                break
            }
            choiseCategory(segment)
        }
    }
    
    // MARK: - Action
    @IBAction func choiseCategory(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            categoryArraySelected = categoryArray.filter {
                $0.transactionType == TransactionType.expendsed.rawValue
            }
        case 1:
            categoryArraySelected = categoryArray.filter {
                $0.transactionType == TransactionType.income.rawValue
            }
        default:
            break
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArraySelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(for: indexPath)
        let category = categoryArraySelected[indexPath.row]
        cell.setContent(data: category)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryArraySelected[indexPath.row]
        passCategory?(category)
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.category
}
