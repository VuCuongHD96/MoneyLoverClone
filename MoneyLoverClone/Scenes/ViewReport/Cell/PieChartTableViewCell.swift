//
//  PieChartTableViewCell.swift
//  MoneyLoverClone
//
//  Created by Tao Trong Nghia on 10/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Charts
import Reusable
import SwiftDate

class PieChartTableViewCell: UITableViewCell, NibReusable, ChartViewDelegate {
    
     // MARK: - Outlet
    @IBOutlet private weak var expensePieChart: PieChartView!
    @IBOutlet private weak var incomePieChart: PieChartView!
    @IBOutlet private weak var moneyExpenseLabel: UILabel!
    @IBOutlet private weak var moneyIncomeLabel: UILabel!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    @IBOutlet private weak var noDataExpenseLabel: UILabel!
    @IBOutlet private weak var noDataIncomeLabel: UILabel!
    
    // MARK: - Properties
    var moneyOfExpense = 0
    var moneyOfIncome = 0
    var entriesExpense = [ChartDataEntry]()
    var entriesIncome = [ChartDataEntry]()
    var listTransaction = [Transaction]()
    var listCategory = [Category]()
    let manager = DBManager.shared
    var dataManager: DBManager!
    var setMonth = 0
    weak var delegate: CellDelegate?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        listTransaction = manager.fetchTransactions()
        listCategory = manager.fetchCategorys()
        buildChart()
        setupPieChart()
    }
    
    // MARK: - Setup PieChart
    func setupPieChart() {
        setMonth = UserDefaults.standard.integer(forKey: "setMonth")
        entriesExpense.removeAll()
        entriesIncome.removeAll()
        moneyOfExpense = 0
        moneyOfIncome = 0
        moneyExpenseLabel.text = "\(moneyOfExpense)"
        moneyIncomeLabel.text = "\(moneyOfIncome)"
        setNoDataPieChart()
        listTransaction.forEach { transaction in
            if transaction.date.month == setMonth {
                if transaction.type == TransactionType.expendsed.rawValue {
                    noDataExpenseLabel.isHidden = true
                    moneyOfExpense += transaction.money
                    listCategory.forEach { category in
                        if transaction.categoryID == category.identify {
                            entriesExpense.append(PieChartDataEntry(value: Double(transaction.money), label: category.name))
                        }
                    }
                    setDataExpensePieChart()
                    moneyExpenseLabel.text = moneyOfExpense.convertToMoneyFormat()
                }
                if transaction.type == TransactionType.income.rawValue {
                    noDataIncomeLabel.isHidden = true
                    moneyOfIncome += transaction.money
                    listCategory.forEach { category in
                        if transaction.categoryID == category.identify {
                            entriesIncome.append(PieChartDataEntry(value: Double(transaction.money), label: category.name))
                        }
                    }
                    setDataIncomePieChart()
                    moneyIncomeLabel.text = moneyOfIncome.convertToMoneyFormat()
                }
            }
        }
    }
    
    // MARK: Set DataPieChart
    func setDataExpensePieChart() {
        let dataPiechartExpense = PieChartDataSet(entries: entriesExpense, label: "")
        dataPiechartExpense.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 22/255, alpha: 1)]
        dataPiechartExpense.drawValuesEnabled = false
        dataPiechartExpense.drawIconsEnabled = false
        expensePieChart.data = PieChartData(dataSet: dataPiechartExpense)
    }
    
    func setDataIncomePieChart() {
        let dataPiechartIncome = PieChartDataSet(entries: entriesIncome, label: "")
        dataPiechartIncome.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 22/255, alpha: 1)]
        dataPiechartIncome.drawValuesEnabled = false
        dataPiechartIncome.drawIconsEnabled = false
        incomePieChart.data = PieChartData(dataSet: dataPiechartIncome)
    }
    func setNoDataPieChart() {
        noDataExpenseLabel.isHidden = false
        noDataIncomeLabel.isHidden = false
        let dataPiechartExpense = PieChartDataSet(entries: entriesExpense, label: "")
        let dataPiechartIncome = PieChartDataSet(entries: entriesIncome, label: "")
        expensePieChart.data = PieChartData(dataSet: dataPiechartExpense)
        incomePieChart.data = PieChartData(dataSet: dataPiechartIncome)
    }
    
    // MARK: Build Chart
    func buildChart() {
        incomePieChart.chartDescription?.enabled = false
        incomePieChart.drawHoleEnabled = false
        incomePieChart.rotationAngle = 0
        incomePieChart.isUserInteractionEnabled = false
        incomePieChart.delegate = self
        incomePieChart.rotationEnabled = false
        incomePieChart.transparentCircleRadiusPercent = 0
        incomePieChart.drawEntryLabelsEnabled = false
        expensePieChart.chartDescription?.enabled = false
        expensePieChart.drawHoleEnabled = false
        expensePieChart.rotationAngle = 0
        expensePieChart.isUserInteractionEnabled = false
        expensePieChart.delegate = self
        expensePieChart.rotationEnabled = false
        expensePieChart.transparentCircleRadiusPercent = 0
        expensePieChart.drawEntryLabelsEnabled = false
    }
    
    @IBAction func clickKhoanchi(_ sender: UIButton) {
        delegate?.showExpense(tag: sender.tag)
    }
    @IBAction func clickKhoanthu(_ sender: UIButton) {
        delegate?.showIncome(tag: sender.tag)
    }
}
