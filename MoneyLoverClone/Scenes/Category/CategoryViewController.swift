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
    var categoryArray = [Category]() {  
        didSet {
            tableView.reloadData()
        }
    }
    typealias Handler = (Category, Int) -> Void
    var passCategory: Handler?
    var segmentIndex: Int! = nil
    var categorySelected: Category! = nil
    
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
        }
        navigationItem.title = "Chọn nhóm"
    }
    
    // MARK: - Data
    private func setupData() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CategoryCell.self)
        }
        segment.selectedSegmentIndex = segmentIndex
        choiseCategory(segment)
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
    
    // MARK: - Action
    @IBAction func choiseCategory(_ sender: UISegmentedControl) {
        categoryArray.removeAll()
        let selectedIndex = sender.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            fetchCategoryData(from: "ExpenseArray")
        case 1:
            fetchCategoryData(from: "RevenueArray")
        default:
            break
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(for: indexPath)
        let category = categoryArray[indexPath.row]
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
        let category = categoryArray[indexPath.row]
        passCategory?(category, segment.selectedSegmentIndex)
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.category
}
