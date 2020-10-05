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
import Reusable

final class AddTransactionTableViewController: UITableViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var noteTextField: UITextField!
    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var categoryNameTextField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    
    // MARK: - Properties
    var category = Category()
    var date = Date()
    let formatter = DateFormatter()
    var dataManager: DBManager!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Thêm giao dịch"
        dataIsValid()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = "Quay lại"
        setupMoneyLabel()
        moneyTextField.resignFirstResponder()
    }
    
    // MARK: - Views
    private func setupView() {
        let todayDateString = formatter.string(from: date)
        dateLabel.text = todayDateString
        let customKeyboard = NumericKeyboard(target: moneyTextField)
        customKeyboard.doneEdit = { [weak self] in
            guard let self = self else { return }
            self.setupMoneyLabel()
        }
        moneyTextField.inputView = customKeyboard
        saveButton.do {
            $0.isEnabled = false
            $0.setTitleTextAttributes([.underlineStyle: 1], for: .normal)
        }
        cancelButton.do {
            $0.setTitleTextAttributes([.underlineStyle: 1], for: .normal)
        }
    }
    
    // MARK: - Data
    private func setupData() {
        let locale = Locale(identifier: "vi")
        formatter.do {
            $0.dateStyle = .full
            $0.locale = locale
        }
        moneyTextField.addTarget(self, action: #selector(dataIsValid), for: .editingDidEnd)
        dataManager = DBManager.shared
    }
    
    private func setupMoneyLabel() {
        let moneyString = moneyTextField.text ?? ""
        moneyTextField.do {
            $0.text = moneyString.convertToMoneyFormat()
            $0.resignFirstResponder()
        }
    }

    @objc private func dataIsValid() {
        guard let moneyText = moneyTextField.text, let categoryName = categoryNameTextField.text, moneyText != "0", categoryName != ""
         else {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    
    private func getTransaction() -> Transaction {
        let money = moneyTextField.text?.convertToInt() ?? 0
        let note = noteTextField.text
        let dateSelected = date
        return Transaction(money: money, categoryID: category.identify, note: note, date: dateSelected, idEvent: nil, transactionType: category.transactionType)
    }
    
    // MARK: - Action
    private func choiseCategory() {
        let categoryScreen = CategoryViewController.instantiate()
        categoryScreen.passCategory = { [weak self] in
            guard let self = self else { return }
            self.categoryImageView.image = UIImage(named: $0.image)
            self.categoryNameTextField.text = $0.name
            self.category = $0
        }
        categoryScreen.categorySelected = category
        navigationController?.pushViewController(categoryScreen, animated: true)
    }
    
    private func choiseDate(completeChoice: @escaping (Date) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let todaySheet = UIAlertAction(title: "Hôm nay", style: .default) { _ in
            let today = Date()
            completeChoice(today)
        }
        let yesterdaySheet = UIAlertAction(title: "Hôm qua", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            completeChoice(self.date - 1.days)
        }
        let customSheet = UIAlertAction(title: "Tùy chọn", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            let calendarScreen = CalendarViewController.instantiate()
            calendarScreen.date = self.date
            calendarScreen.passDate = {
                completeChoice($0)
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
    
    private func choiseEvent() {
        let choiseEventScreen = ChoiseEventTableViewController.instantiate()
        navigationController?.pushViewController(choiseEventScreen, animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let transaction = getTransaction()
        dataManager.saveTransaction(transaction)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddTransactionTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            moneyTextField.becomeFirstResponder()
        case 1:
            choiseCategory()
        case 2:
            noteHandelAction()
        case 3:
            choiseDate {
                self.date = $0
                let dateString = self.formatter.string(from: $0)
                self.dateLabel.text = dateString
            }
        case 4:
            choiseEvent()
        default:
            print("Wrong Choise")
        }
    }
}

extension AddTransactionTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.addTransaction
}
