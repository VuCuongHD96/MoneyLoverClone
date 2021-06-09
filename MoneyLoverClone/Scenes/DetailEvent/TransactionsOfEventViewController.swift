//
//  DetailEventViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 10/2/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class TransactionsOfEventViewController: UIViewController {
    
    @IBOutlet private weak var cardOverView: UIView!
    @IBOutlet private weak var tableview: UITableView!
    @IBOutlet private weak var incomeLabel: UILabel!
    @IBOutlet private weak var expenseLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    
    struct Constant {
        static let numberOfSections = 5
        static let numberOfRowsInSection = 2
        static let heightForFooterInSection: CGFloat = 25
        static let heightForHeaderInSection: CGFloat = 55
        static let headerNibName = "HeaderTransactionView"
    }
    
    var listTransationEvent = [Transaction]() {
        didSet {
            tableview.reloadData()
        }
    }
    var database: DBManager!
    var event = Event()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        setupOverView()
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        tableview.tableFooterView = footerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupData()
        setupView()
        setupOverView()
    }
    
    func setupData() {
        tableview.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: TransactionCell.self )
        }
        database = DBManager.shared
        listTransationEvent = database.fetchTransation(from: event.identify)
    }
    
    private func checkEmptyTransation() {
        if listTransationEvent.isEmpty {
            tableview.isHidden = true
            cardOverView.isHidden = true
            let labelView = UILabel(frame: CGRect(x: 105, y: 420, width: 255, height: 21))
            labelView.text = "Không có giao dịch nào"
            let imageName = "notransaction"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 32, y: 230, width: 320, height: 200)
            view.addSubview(imageView)
            view.addSubview(labelView)
        }
    }
    
    private func setupOverView() {
        var income = 0
        var expense = 0
        listTransationEvent.forEach { transationFromEvent in
            if transationFromEvent.type == TransactionType.income.rawValue {
                income += transationFromEvent.money
            } else if transationFromEvent.type == TransactionType.expendsed.rawValue {
                expense += transationFromEvent.money
            }
        }
        let total = income - expense
        incomeLabel.text = "+\(income.convertToMoneyFormat())"
        expenseLabel.text = "-\(expense.convertToMoneyFormat())"
        totalLabel.text = "\(total.convertToMoneyFormat())"
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
        cardOverView.backgroundColor = UIColor.white
        cardOverView.layer.cornerRadius = 8
        cardOverView.layer.masksToBounds = false
        cardOverView.layer.shadowOpacity = 0.7
        cardOverView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardOverView.layer.shadowColor = UIColor.black.cgColor
        tableview.do {
            $0.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
        }
        checkEmptyTransation()
        title = event.name
    }
}

extension TransactionsOfEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionView = HeaderTransactionView.instantiate()
        return headerSectionView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constant.heightForFooterInSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightForHeaderInSection
    }
}

extension TransactionsOfEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTransationEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        let transactionFromEvent = listTransationEvent[indexPath.row]
        cell.setcontent(data: transactionFromEvent)
        return cell
    }
}

extension TransactionsOfEventViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.detailEvent
}
