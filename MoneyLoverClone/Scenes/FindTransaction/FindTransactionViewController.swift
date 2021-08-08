//
//  FindTransactionViewController.swift
//  MoneyLoverClone
//
//  Created by admin on 8/8/21.
//  Copyright © 2021 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class FindTransactionViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Define
    struct Constant {
        static let heightForHeaderInSection: CGFloat = 50
        static let heightForFooterInSection: CGFloat = 25
        static let heightForRowAt: CGFloat = 55
    }
    
    // MARK: - Property
    let dataManager = DBManager.shared
    let today = Date()
    var sectionModelArray = [TransactionSectionModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    private func fetchTransactionData(from date: Date) {
        let transactionArray = dataManager.fetchTransactions().filter {
            $0.date.month == date.month && $0.date.year == date.year
        }
        
        let transactionDictionary = Dictionary(grouping: transactionArray, by: { $0.dateString })
        sectionModelArray = transactionDictionary.map { dictionary -> TransactionSectionModel in
            let date = dictionary.key
            let transactionArray = dictionary.value
            let money = transactionArray.map { transaction -> Int in
                if transaction.type == TransactionType.income.rawValue {
                    return transaction.money
                } else {
                    return -transaction.money
                }
            }.reduce(0, +)
            let headerData = TransactionHeaderModel(dateString: date, money: money)
            return TransactionSectionModel(headerData: headerData, transactionArray: transactionArray)
        }
        sectionModelArray = sectionModelArray.sorted(by: >)
    }
    
    // MARK: - Do Action
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FindTransactionViewController: ViewControllerType {
    func setupView() {
        let view = UIView()
        view.backgroundColor = .red
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 0)
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: TransactionCell.self)
            $0.separatorStyle = .none
            $0.tableHeaderView = view
        }
        searchBar.placeholder = "Tìm theo #nhãn, nhóm, v,v..."
    }
    
    func setupData() {
        fetchTransactionData(from: today)
    }
}

// MARK: - TableView DataSource
extension FindTransactionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = sectionModelArray[section]
        let transactionArray = sectionData.transactionArray
        return transactionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        let sectionData = sectionModelArray[section]
        let transactionArray = sectionData.transactionArray
        let transactionData = transactionArray[row]
        
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setcontent(data: transactionData)
        return cell
    }
}

extension FindTransactionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = sectionModelArray[section]
        let headerData = sectionData.headerData
        
        let header = HeaderTransactionView.instantiate()
        header.setContent(data: headerData)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constant.heightForFooterInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightForRowAt
    }
}

extension FindTransactionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.findTransaction
}
