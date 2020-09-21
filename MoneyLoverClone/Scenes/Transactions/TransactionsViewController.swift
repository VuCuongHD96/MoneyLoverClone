//
//  TransactionsViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/17/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Then
import Reusable

final class TransactionsViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    struct Constant {
        static let numberOfSections = 5
        static let numberOfRowsInSection = 2
        static let heightForHeaderInSection: CGFloat = 55
        static let headerNibName = "HeaderTransactionView"
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }
    
    // MARK: - Data
    private func setupData() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: TransactionCell.self)
        }
    }
    
    // MARK: - Views
    private func setupViews() {
        tabBarItem.selectedImage = UIImage(named: "transactionSelected")?.withRenderingMode(.alwaysOriginal)
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerSectionView = Bundle.main.loadNibNamed(Constant.headerNibName, owner: self, options: nil)?.first as? HeaderTransactionView else {
            return UIView()
        }
        return headerSectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightForHeaderInSection
    }
}
