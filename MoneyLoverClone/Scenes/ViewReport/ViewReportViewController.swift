//
//  ViewReportViewController.swift
//  MoneyLoverClone
//
//  Created by Tao Trong Nghia on 10/5/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class ViewReportViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet private weak var totalMoneyLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    var date = Date()
    var months = [1,2,3,4,5,6,7,8,9,10,11,12]
    var setMonth = 10
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupTableView()
        tableView.reloadData()
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        MoneyTableViewCell.registerCellByNib(tableView)
        PieChartTableViewCell.registerCellByNib(tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
}

// MARK: - Setup CollectionView
extension ViewReportViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let year = date.year
        if months[indexPath.row] < 10 {
            cell.monthLabel.text = "0\(months[indexPath.row])/\(year)"
        }else {
            cell.monthLabel.text = "\(months[indexPath.row])/\(year)"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        setMonth = months[indexPath.row]
        UserDefaults.standard.set(setMonth, forKey: "setMonth")
        tableView.reloadData()
    }
}
// MARK: - Setup TableView
extension ViewReportViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Số dư"
        }else {
            return "Khoản chi & Khoản thu"
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = MoneyTableViewCell.loadCell(tableView) as! MoneyTableViewCell
            return cell
        }else {
            let cell = PieChartTableViewCell.loadCell(tableView) as! PieChartTableViewCell
            cell.delegate = self
            cell.expenseButton.tag = indexPath.row
            cell.delegate = self
            cell.incomeButton.tag = indexPath.row
            cell.setupPieChart()
            return cell
        }
    }
}
//MARK: - Push Detail ViewReport
extension ViewReportViewController: CellDelegate{
    func showExpense(tag: Int) {
        let expense = "Khoản chi"
        let transactionType = "expendsed"
        UserDefaults.standard.set(expense, forKey: "key")
        UserDefaults.standard.set(transactionType, forKey: "transactionType")
        let viewController = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailReport") as! DetailReportViewController
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    func showIncome(tag: Int) {
        let income = "Khoản thu"
        let transactionType = "income"
        UserDefaults.standard.set(income, forKey: "key")
        UserDefaults.standard.set(transactionType, forKey: "transactionType")
        let viewController = UIStoryboard.init(name: "Report", bundle: Bundle.main).instantiateViewController(identifier: "detailReport") as! DetailReportViewController
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
