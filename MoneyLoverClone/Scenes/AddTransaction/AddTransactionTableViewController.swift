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
    @IBOutlet private weak var noteTextField: UITextField!
    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var categoryNameTextField: UITextField!
    
    // MARK: - Properties
    let today = Date()
    let formatter = DateFormatter()
    var segmentIndex = 0
    var category: Category?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Thêm giao dịch"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = "Quay lại"
    }
    
    // MARK: - Views
    private func setupView() {
        let todayDateString = formatter.string(from: today)
        dateLabel.text = todayDateString
        let customKeyboard = NumericKeyboard(target: moneyTextField)
        customKeyboard.doneEdit = { [weak self] in
            guard let self = self else { return }
            self.setupMoneyLabel()
        }
        moneyTextField.inputView = customKeyboard
    }
    
    // MARK: - Data
    private func setupData() {
        let locale = Locale(identifier: "vi")
        formatter.do {
            $0.dateStyle = .full
            $0.locale = locale
        }
    }
    
    private func setupMoneyLabel() {
        let moneyString = moneyTextField.text ?? ""
        moneyTextField.do {
            $0.text = convertToMoneyFormat(moneyString)
            $0.resignFirstResponder()
        }
    }
    
    private func convertToMoneyFormat(_ money: String) -> String {
        let newMoney = money.replacingOccurrences(of: ",", with: "")
        let amount = Double(newMoney) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let nsNumber = NSNumber(value: amount)
        guard let result = numberFormatter.string(from: nsNumber) else { return "" }
        return result
    }
    
    // MARK: - Action
    private func choiseCategory() {
        let categoryScreen = CategoryViewController.instantiate()
        categoryScreen.passCategory = { [weak self] in
            guard let self = self else { return }
            self.categoryImageView.image = UIImage(named: $0.image)
            self.categoryNameTextField.text = $0.name
            self.category = $0
            self.segmentIndex = $1
        }
        categoryScreen.segmentIndex = segmentIndex
        categoryScreen.categorySelected = category
        navigationController?.pushViewController(categoryScreen, animated: true)
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
            guard let dateString = self.dateLabel.text else { return }
            guard let dateFromString = self.formatter.date(from: dateString) else { return }
            let calendarScreen = CalendarViewController.instantiate()
            calendarScreen.date = dateFromString
            calendarScreen.passDate = {
                let dateString = self.formatter.string(from: $0)
                self.dateLabel.text = dateString
            }
            self.navigationController?.pushViewController(calendarScreen, animated: true)
        }
        let cancelSheet = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        alert.addAction(todaySheet)
        alert.addAction(yesterdaySheet)
        alert.addAction(customSheet)
        alert.addAction(cancelSheet)
        present(alert, animated: true, completion: nil)
    }
    
    private func noteHandelAction() {
        let note = noteTextField.text ?? ""
        let noteScreen = NoteViewController.instantiate()
        noteScreen.note = note
        noteScreen.sendNote = {
            if $0 == "" {
                self.noteTextField.text = nil
            }
            self.noteTextField.text = $0
        }
        navigationController?.pushViewController(noteScreen, animated: true)
    }
}

extension AddTransactionTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            choiseCategory()
        case 2:
            noteHandelAction()
        case 3:
            choiseDate {
                self.dateLabel.text = $0
            }
        default:
            print("Wrong Choise")
        }
    }
}
