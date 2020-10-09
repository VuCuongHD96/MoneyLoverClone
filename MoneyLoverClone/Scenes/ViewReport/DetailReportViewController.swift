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
    //MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var typeOfMoneyLabel: UILabel!
    @IBOutlet private weak var moneyLabel: UILabel!
    @IBOutlet private weak var piechart: PieChartView!
    var entries = [ChartDataEntry]()
    var arrCategory = [String]()
    var arrMoneyOfCatergory = [String]()
    var money = 0
    let setMonth = UserDefaults.standard.integer(forKey: "setMonth")
    let typeOfMoney = UserDefaults.standard.string(forKey: "key")
    let transactionType = UserDefaults.standard.string(forKey: "transactionType")
    
    //  MARK: - Properties
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
        setupTableView()
        buildChart()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        DetailTableViewCell.registerCellByNib(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
    //MARK: - SetText Color
    func setMoneyColor() {
        if transactionType == "income" {
            moneyLabel.textColor = .blue
        }
        else {
            moneyLabel.textColor = .red
        }
    }
    //MARK: - Setup PieChart
    func setupPieChart() {
        for index in 0 ..< listTransaction.count {
            if listTransaction[index].date.month == setMonth {
                if listTransaction[index].type == transactionType {
                    money += listTransaction[index].money
                    for i in 0..<listCategory.count{
                        if listTransaction[index].categoryID == listCategory[i].identify{
                            entries.append(PieChartDataEntry(value: Double(listTransaction[index].money), label: listCategory[i].name))
                            arrCategory.append(listCategory[i].name)
                            arrMoneyOfCatergory.append("\(listTransaction[index].money)")
                        }
                    }
                    moneyLabel.text = money.convertToMoneyFormat()
                }
            }
        }
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
extension DetailReportViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DetailTableViewCell.loadCell(tableView) as! DetailTableViewCell
        cell.categoryLabel.text = "\(arrCategory[indexPath.row])"
        cell.moneyOfCategoryLabel.text = "\(arrMoneyOfCatergory[indexPath.row])".convertToMoneyFormat()
        return cell
    }
}
