//
//  DetailReportViewController.swift
//  MoneyLoverClone
//
//  Created by Tao Trong Nghia on 10/6/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Charts

class DetailReportViewController: UIViewController, ChartViewDelegate {
    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var typeOfMoneyLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var piechart: PieChartView!
    @IBOutlet private weak var noDataTransactionView: UIView!
    
    // MARK: - Properties
    var entries = [ChartDataEntry]()
    var arrCategory = [String]()
    var arrMoneyOfCatergory = [String]()
    var arrImage = [String]()
    var money = 0
    let setMonth = UserDefaults.standard.integer(forKey: "setMonth")
    let typeOfMoney = UserDefaults.standard.string(forKey: "key")
    let transactionType = UserDefaults.standard.string(forKey: "transactionType")
    var listTransaction = [Transaction]()
    var listCategory = [Category]()
    let manager = DBManager.shared
    var dataManager: DBManager!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        listTransaction = manager.fetchTransactions()
        listCategory = manager.fetchCategorys()
        typeOfMoneyLabel.text = typeOfMoney
        setupPieChart()
        setMoneyColor()
        setupData()
        buildChart()
    }
    // MARK: - Data
    private func setupData() {
        tableView.do {
            tableView.delegate = self
            tableView.dataSource = self
            $0.register(cellType: DetailTableViewCell.self)
        }
    }
    
    // MARK: - SetText Color
    func setMoneyColor() {
        if transactionType == TransactionType.income.rawValue {
            moneyLabel.textColor = .blue
        } else {
            moneyLabel.textColor = .red
        }
    }
    
    // MARK: - Setup PieChart
    func setupPieChart() {
        listTransaction.forEach { transaction in
            if transaction.date.month == setMonth {
                if transaction.type == transactionType {
                    noDataTransactionView.isHidden = true
                    money += transaction.money
                    listCategory.forEach { category in
                        if transaction.categoryID == category.identify {
                            entries.append(PieChartDataEntry(value: Double(transaction.money), label: category.name))
                            arrCategory.append(category.name)
                            arrMoneyOfCatergory.append("\(transaction.money)")
                            arrImage.append(category.image)
                        }
                        setDataPieChart()
                    }
                }
                if transaction.type.isEmpty {
                    noDataTransactionView.isHidden = false
                    entries.removeAll()
                }
                moneyLabel.text = "\(money)".convertToMoneyFormat()
            }
        }
    }
    func setDataPieChart() {
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 22/255, alpha: 1)]
        dataSet.drawValuesEnabled = false
        dataSet.drawIconsEnabled = false
        piechart.data = PieChartData(dataSet: dataSet)
    }

    func buildChart() {
        piechart.chartDescription?.enabled = false
        piechart.drawHoleEnabled = false
        piechart.rotationAngle = 0
        piechart.isUserInteractionEnabled = false
        piechart.delegate = self
        piechart.rotationEnabled = false
        piechart.transparentCircleRadiusPercent = 0
        piechart.drawEntryLabelsEnabled = false
    }
}

extension DetailReportViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.categoryLabel.text = "\(arrCategory[indexPath.row])"
        cell.moneyOfCategoryLabel.text = "\(arrMoneyOfCatergory[indexPath.row])".convertToMoneyFormat()
        cell.categoryImage.image = UIImage(named: arrImage[indexPath.row])
        return cell
    }
}
