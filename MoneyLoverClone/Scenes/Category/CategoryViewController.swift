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
    var revenueArray = [ Category]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    // MARK: - Data
    private func setupData() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CategoryCell.self)
        }
        fetchRevenueData()
    }
    
    private func fetchRevenueData() {
        guard let path = Bundle.main.path(forResource: "RevenueArray", ofType: "plist"),
            let nsDictionary = NSDictionary(contentsOfFile: path) else {
            return
        }
        nsDictionary.forEach {
            let imageString = $0.key as? String ?? ""
            let name = $0.value as? String ?? ""
            let category = Category(image: imageString, name: name)
            revenueArray.append(category)
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return revenueArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(for: indexPath)
        let category = revenueArray[indexPath.row]
        cell.setContent(data: category)
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightForRowAt
    }
}

extension CategoryViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.category
}
