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
    let today = Date()
    let formatter = DateFormatter()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    // MARK: - Views
    private func setupView() {
        let todayDateString = formatter.string(from: today)
        dateLabel.text = todayDateString
    }
    
    // MARK: - Data
    private func setupData() {
        let locale = Locale(identifier: "vi")
        formatter.do {
            $0.dateStyle = .full
            $0.locale = locale
        }
    }
    
    private func pickDate() {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let datePickerViewController = DatePickerViewController()
        datePickerViewController.date = formatter.date(from: dateLabel.text ?? "") ?? today
        datePickerViewController.preferredContentSize = datePickerViewController.view.bounds.size
        alertController.setValue(datePickerViewController, forKey: "contentViewController")
        let somethingAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let date = datePickerViewController.date
            let dateString = self.formatter.string(from: date)
            self.dateLabel.text = dateString
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func choiseDate(completeChoice: @escaping (String) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let todaySheet = UIAlertAction(title: "Hôm nay", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            let resultDate = self.formatter.string(from: self.today)
            completeChoice(resultDate)
        }
        let yesterdaySheet = UIAlertAction(title: "Hôm qua", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            let resultDate = self.formatter.string(from: self.today - 1.days)
            completeChoice(resultDate)
        }
        let customSheet = UIAlertAction(title: "Tùy chọn", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.pickDate()
        }
        let cancelSheet = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        alert.addAction(todaySheet)
        alert.addAction(yesterdaySheet)
        alert.addAction(customSheet)
        alert.addAction(cancelSheet)
        present(alert, animated: true, completion: nil)
    }
}

extension AddTransactionTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            print("Choise Category")
        case 2:
            print("Go to note")
        case 3:
            choiseDate {
                self.dateLabel.text = $0
            }
        default:
            print("Wrong Choise")
        }
    }
}
