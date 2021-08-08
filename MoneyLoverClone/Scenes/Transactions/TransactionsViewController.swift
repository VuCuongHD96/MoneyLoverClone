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
import ViewAnimator

final class TransactionsViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var previousMonthButton: UIButton!
    @IBOutlet private weak var thisMonthButton: UIButton!
    @IBOutlet private weak var nextMonthButton: UIButton!
    @IBOutlet private weak var nodataView: UIView!
    
    // MARK: - Define
    struct Constant {
        static let heightForHeaderInSection: CGFloat = 50
        static let heightForFooterInSection: CGFloat = 25
        static let heightForRowAt: CGFloat = 55
    }
    
    // MARK: - Properties
    var dataManager = DBManager.shared
    var sectionModelArray = [TransactionSectionModel]() {
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
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTransactionData(from: today)
    }
    
    private func setupView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: TransactionCell.self)
        }
    }

    // MARK: - Data
    private func setupData() {
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
        setupBalance()
        setupMonthTitle(date: date)
    }
    
    // MARK: - Views
    private func setupBalance() {
        let totalMoney = sectionModelArray.map {
            $0.headerData
        }.map {
            $0.money
        }.reduce(0, +)
        navigationItem.title = "Số dư: " + totalMoney.convertToMoneyFormat()
    }
    
    private func cellAnimation() {
        let fromAnimation = AnimationType.vector(CGVector(dx: 30, dy: 0))
        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        UIView.animate(views: tableView.visibleCells,
                       animations: [fromAnimation, zoomAnimation], delay: 0.2)
    }
    
    private func setupMonthTitle(date: Date) {
        var previousMonthTitle = ""
        var thisMonthTitle = ""
        var nextMonthTitle = ""
        nextMonthButton.isEnabled = true
        
        if today.isThisMonth(with: date) {
            previousMonthTitle = "Tháng trước"
            thisMonthTitle = "Tháng này"
            nextMonthButton.isEnabled = false
        }
        
        if date.isPreviousMonth() {
            let previousMonth = date - 1.months
            previousMonthTitle = "\(previousMonth.month) / \(previousMonth.year)"
            thisMonthTitle = "Tháng trước"
            nextMonthTitle = "Tháng này"
        }
        
        if date.isPast() {
            let previousMonth = date - 1.months
            previousMonthTitle = "\(previousMonth.month) / \(previousMonth.year)"
            thisMonthTitle = "\(date.month) / \(date.year)"
            let nextMonth = date + 1.months
            nextMonthTitle = "\(nextMonth.month) / \(nextMonth.year)"
        }

        previousMonthButton.setTitle(previousMonthTitle, for: .normal)
        thisMonthButton.setTitle(thisMonthTitle, for: .normal)
        nextMonthButton.setTitle(nextMonthTitle, for: .normal)
    }
    
    // MARK: - Create Action
    private func gotoFindScreen() {
        let viewController = FindTransactionViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func createFindTransactionAlertAction() -> UIAlertAction {
        let findTransactionAlertAction = UIAlertAction(title: "Tìm giao dịch", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.gotoFindScreen()
        }
        return findTransactionAlertAction
    }
    
    // MARK: - Do Action
    @IBAction func choiseMonth(_ sender: UIButton) {
        if sender == previousMonthButton {
            date = date - 1.months
        } else {
            date = date + 1.months
        }
        fetchTransactionData(from: date)
    }

    @IBAction func showMore(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let thisMonth = UIAlertAction(title: "Xem giao dịch của tháng hiện tại", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.fetchTransactionData(from: self.today)
            self.date = self.today
            UserDefaults.standard.set(self.date, forKey: "NewDateAdded")
        }
        let fixBlance = UIAlertAction(title: "Chỉnh sửa số dư", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let blanceScreen = BalanceTableViewController.instantiate()
            blanceScreen.money = self.totalMoney
            let navigation = UINavigationController(rootViewController: blanceScreen)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        }
        let findTransaction = createFindTransactionAlertAction()
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alert.addAction(thisMonth)
        alert.addAction(fixBlance)
        alert.addAction(findTransaction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    } 
}

extension TransactionsViewController: UITableViewDataSource {
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

extension TransactionsViewController: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let sectionData = sectionModelArray[section]
        let transactionArray = sectionData.transactionArray
        let transactionData = transactionArray[row]
        
        let transactionDetail = TransactionDetailTableViewController.instantiate()
        transactionDetail.transaction = transactionData
        transactionDetail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(transactionDetail, animated: true)
    }
}
