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

protocol CellDelegate: class {
    func showExpense(tag: Int)
    func showIncome(tag: Int)
}
class PieChartTableViewCell: BaseTableCell, ChartViewDelegate {
    
     //  MARK: - Outlet
    @IBOutlet private weak var expensePieChart: PieChartView!
    @IBOutlet private weak var incomePieChart: PieChartView!
    weak var delegate: CellDelegate?
    @IBOutlet weak var moneyExpenseLabel: UILabel!
    @IBOutlet weak var moneyIncomeLabel: UILabel!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    var moneyOfExpense = 0
    var moneyOfIncome = 0
    var entriesExpense = [ChartDataEntry]()
    var entriesIncome = [ChartDataEntry]()
    
    //  MARK: - Properties
    var listTransaction = [Transaction]()
    var listCategory = [Category]()
    let manager = DBManager.shared
    var dataManager: DBManager!
    var setMonth = 0
    
    //  MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        listTransaction = manager.fetchTransactions()
        listCategory = manager.fetchCategorys()
        buildChart()
        setupPieChart()
    }
    //MARK: - Setup PieChart
    func setupPieChart() {
        setMonth = UserDefaults.standard.integer(forKey: "setMonth")
        entriesExpense.removeAll()
        entriesIncome.removeAll()
        moneyOfExpense = 0
        moneyOfIncome = 0
        for index in 0 ..< listTransaction.count {
            if listTransaction[index].date.month == setMonth {
                if listTransaction[index].type == "expendsed" {
                    moneyOfExpense += listTransaction[index].money
                    for i in 0..<listCategory.count{
                        if listTransaction[index].categoryID == listCategory[i].identify{
                            entriesExpense.append(PieChartDataEntry(value: Double(listTransaction[index].money), label: listCategory[i].name))
                        }
                    }
                    setDataExpensePieChart()
                    moneyExpenseLabel.text = moneyOfExpense.convertToMoneyFormat()
                }else if listTransaction[index].type == "income"{
                    moneyOfIncome += listTransaction[index].money
                    for i in 0..<listCategory.count{
                        if listTransaction[index].categoryID == listCategory[i].identify{
                            entriesIncome.append(PieChartDataEntry(value: Double(listTransaction[index].money), label: listCategory[i].name))
                        }
                    }
                    setDataIncomePieChart()
                    moneyIncomeLabel.text = moneyOfIncome.convertToMoneyFormat()
                }
            }
        }
    }
    //MARK: Set DataPieChart
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
    func setDataIncomePieChart(){
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
    //MARK: Build Chart
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
