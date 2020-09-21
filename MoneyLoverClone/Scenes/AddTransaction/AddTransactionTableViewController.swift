//
//  AddTransactionTableViewController.swift
//  MoneyLoverClone
//
//  Created by KIMOCHI on 9/19/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import SwiftDate
import Then

final class AddTransactionTableViewController: UITableViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Properties
    let date = Date()
    let formatter = DateFormatter()
    var datePicker = UIDatePicker()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }

    // MARK: - Views
    private func setupView() {
        navigationItem.title = "Thêm giao dịch"
        tabBarItem.image = UIImage(named: "Add")
    }
    
    // MARK: - Data
    private func setupData() {
        let locale = Locale(identifier: "vi")
        datePicker.do {
            $0.locale = locale
            $0.datePickerMode = .date
            $0.frame = CGRect(x: 0, y: 15, width: 300, height: 200)
        }
        formatter.do {
            $0.dateStyle = .full
            $0.locale = locale
        }
    }
    
    private func choiseDate(completeChoice: @escaping (String) -> ()) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let todaySheet = UIAlertAction(title: "Hôm nay", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            let resultDate = self.formatter.string(from: self.date)
            completeChoice(resultDate)
        }
        let yesterdaySheet = UIAlertAction(title: "Hôm qua", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            let resultDate = self.formatter.string(from: self.date - 1.days)
            completeChoice(resultDate)
        }
        let customSheet = UIAlertAction(title: "Tùy chọn", style: .default) { [weak self] (_) in
            guard let self = self else { return }
    
            
            let alertController = UIAlertController(title: "", message: nil, preferredStyle: UIAlertController.Style.alert)
            alertController.view.addSubview(self.datePicker)
            alertController.preferredContentSize = self.datePicker.bounds.size
            let somethingAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(somethingAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion:{})
           
        }
        let cancelSheet = UIAlertAction(title: "Hủy bỏ", style: .cancel, handler: nil)
        alert.addAction(todaySheet)
        alert.addAction(yesterdaySheet)
        alert.addAction(customSheet)
        alert.addAction(cancelSheet)
        present(alert, animated: true, completion: nil)
    }
}

extension AddTransactionTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            choiseDate {
                self.dateLabel.text = $0
            }
        }
    }
}

extension AddTransactionTableViewController {
    
}
