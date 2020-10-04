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
import SwiftDate

final class TransactionsViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    struct Constant {
        static let heightForHeaderInSection: CGFloat = 50
        static let heightForFooterInSection: CGFloat = 25
        static let heightForRowAt: CGFloat = 55
        static let headerNibName = "HeaderTransactionView"
    }
    var dataManager: DBManager!
    let formatter = DateFormatter()
    var transactionArray = [Transaction]()
    var transactionByMonthArray = [TransactionByDay]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTransactionData()
    }
    
    // MARK: - Data
    private func setupData() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: TransactionCell.self)
        }
        dataManager = DBManager.shared
        formatter.do {
            $0.dateStyle = .full
            $0.locale = Locale(identifier: "vi")
        }
    }
    
    private func fetchTransactionData() {
        transactionArray = dataManager.fetchTransactions()
        if transactionArray.count == 0 {
            return
        }
        let mostRecentDate = transactionArray[0].date
        fetchTransactionBy(mostRecentDate)
    }
    
    private func fetchTransactionBy(_ date: Date) {
        let year = date.year
        let month = date.month
        let transactionInAMonth = transactionArray.filter {
            $0.date.year == year && $0.date.month == month
        }
        var transactionDictionary = Dictionary<String, [Transaction]>()
        transactionInAMonth.forEach {
            let date = $0.date
            let dateString = formatter.string(from: date)
            if transactionDictionary.keys.contains(dateString) == false {
                transactionDictionary[dateString] = [$0]
            } else {
                transactionDictionary[dateString]?.append($0)
            }
        }
        transactionByMonthArray.removeAll()
        transactionDictionary.forEach {
            let transactionByDay = TransactionByDay(dateString: $0, transactionArray: $1)
            transactionByMonthArray.append(transactionByDay)
        }
        transactionByMonthArray.sort {
            let dateOne = formatter.date(from: $0.dateString)
            let dateTwo = formatter.date(from: $1.dateString)
            return dateOne! > dateTwo!
        }
    }
    
    // MARK: - Views
    private func setupViews() {
        navigationItem.title = "Sổ giao dịch"
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionByMonthArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionByMonthArray[section].transactionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        let transaction = transactionByMonthArray[indexPath.section].transactionArray[indexPath.row]
        cell.setcontent(data: transaction)
        return cell
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = Bundle.main.loadNibNamed(Constant.headerNibName, owner: self, options: nil)?.first as? HeaderTransactionView else {
            return UIView()
        }
        let headerData = transactionByMonthArray[section]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transactionDetail = TransactionDetailTableViewController.instantiate()
        navigationController?.pushViewController(transactionDetail, animated: true)
    }
}
