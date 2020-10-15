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
    @IBOutlet private weak var previousMonthButton: UIButton!
    @IBOutlet private weak var thisMonthButton: UIButton!
    @IBOutlet private weak var nextMonthButton: UIButton!
    @IBOutlet private weak var nodataView: UIView!
    
    // MARK: - Properties
    struct Constant {
        static let heightForHeaderInSection: CGFloat = 50
        static let heightForFooterInSection: CGFloat = 25
        static let heightForRowAt: CGFloat = 55
        static let headerNibName = "HeaderTransactionView"
    }
    var dataManager: DBManager!
    let formatter = DateFormatter()
    let formatterMonthYear = DateFormatter()
    var transactionArray = [Transaction]() 
    var transactionByMonthArray = [TransactionByDay]() {
        didSet {
            tableView.reloadData()
        }
    }
    let today = Date()
    var date = Date()
    var totalMoney = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTransactionData()
        setupBalance()
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
        formatterMonthYear.do {
            $0.locale = Locale(identifier: "vi")
            $0.dateFormat = "MMMM, yyyy"
        }
    }
    
    private func fetchTransactionData() {
        transactionArray = dataManager.fetchTransactions()
        guard var mostRecentDate = transactionArray.first?.date else {
            transactionByMonthArray.removeAll()
            return
        }
        date = mostRecentDate
        if let dateAdded = UserDefaults.standard.value(forKey: "NewDateAdded") as? Date {
            mostRecentDate = dateAdded
            date = dateAdded
        }
        fetchTransactionBy(mostRecentDate)
    }
    
    private func fetchTransactionBy(_ date: Date) {
        let year = date.year
        let month = date.month
        var monthString = "\(month)"
        if month < 10 {
            monthString = "0" + monthString
        }
        if today.year == year && today.month == month {
            nextMonthButton.isEnabled = false
        } else {
            nextMonthButton.isEnabled = true
        }
        thisMonthButton.setTitle("\(monthString)/\(year)", for: .normal)
        let transactionInAMonth = transactionArray.filter {
            $0.date.year == year && $0.date.month == month
        }
        if transactionInAMonth.isEmpty {
            nodataView.isHidden = false
        } else {
            nodataView.isHidden = true
        }
        var transactionDictionary = [String: [Transaction]]()
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
            let date = formatter.date(from: $0) ?? Date()
            let transactionByDay = TransactionByDay(date: date, transactionArray: $1)
            transactionByMonthArray.append(transactionByDay)
        }
        transactionByMonthArray.sort {
            $0.date > $1.date
        }
    }
    
    // MARK: - Views
    private func setupBalance() {
        let totalMoney = transactionArray.reduce(into: 0) {
            switch $1.type {
            case TransactionType.income.rawValue: $0 += $1.money
            case TransactionType.expendsed.rawValue: $0 -= $1.money
            default: break
            }
        }
        navigationItem.title = "Số dư: " + totalMoney.convertToMoneyFormat()
        self.totalMoney = totalMoney
    }
    
    // MARK: - Action
    @IBAction func choiseMonth(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            date = date - 1.months
            fetchTransactionBy(date)
        case 2:
            date = date + 1.months
            fetchTransactionBy(date)
        default:
            break
        }
        UserDefaults.standard.set(date, forKey: "NewDateAdded")
    }

    @IBAction func showMore(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let thisMonth = UIAlertAction(title: "Xem giao dịch của tháng hiện tại", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.fetchTransactionBy(self.today)
            self.date = self.today
            UserDefaults.standard.set(self.date, forKey: "NewDateAdded")
        }
        let fixBlance = UIAlertAction(title: "Chỉnh sửa số dư", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let blanceScreen = BalanceTableViewController.instantiate()
            blanceScreen.money = self.totalMoney
            let navigation = NavigationViewController(rootViewController: blanceScreen)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alert.addAction(thisMonth)
        alert.addAction(fixBlance)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
        let section = indexPath.section
        let row = indexPath.row
        let transactionInADay = transactionByMonthArray[section]
        let transaction = transactionInADay.transactionArray[row]
        let transactionDetail = TransactionDetailTableViewController.instantiate()
        transactionDetail.transaction = transaction
        transactionDetail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(transactionDetail, animated: true)
    }
}
