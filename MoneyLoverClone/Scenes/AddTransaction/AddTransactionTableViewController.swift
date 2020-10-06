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

class AddTransactionTableViewController: UITableViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var noteTextField: UITextField!
    @IBOutlet private weak var moneyTextField: UITextField!
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var categoryNameTextField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var eventNameTextField: UITextField!
    
    // MARK: - Properties
    var category = Category()
    var date = Date()
    var event: Event!
    let formatter = DateFormatter()
    var database: DBManager!
    var transaction: Transaction?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataIsValid()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupMoneyLabel()
        moneyTextField.resignFirstResponder()
    }
    
    // MARK: - Views
    private func setupView() {
        navigationItem.title = "Thêm giao dịch"
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
        let todayDateString = formatter.string(from: date)
        dateLabel.text = todayDateString
        moneyTextField.addTarget(self, action: #selector(dataIsValid), for: .editingDidEnd)
        database = DBManager.shared
        if transaction != nil {
            prepareForUpdate()
        }
    }
    
    private func prepareForUpdate() {
        navigationItem.title = "Sửa giao dịch"
        saveButton.action = #selector(updateTransaction)
        navigationItem.rightBarButtonItem?.title = "Cập nhật"
        setupTransactionData()
    }
    
    private func setupTransactionData() {
        guard var transaction = transaction else {
            return
        }
        transaction = database.fetchObject(from: transaction.identify)
        let categoryFetch = database.fetchCategory(from: transaction.categoryID)
        self.category = categoryFetch
        categoryImageView.image = UIImage(named: categoryFetch.image)
        categoryNameTextField.text = categoryFetch.name
        moneyTextField.text = String(transaction.money).convertToMoneyFormat()
        dateLabel.text = formatter.string(from: transaction.date)
        date = transaction.date
        noteTextField.text = transaction.note
        guard let idEvent = transaction.idEvent else { return }
        event = database.fetchObject(from: idEvent)
        eventImageView.image = UIImage(named: event.image)
        eventNameTextField.text = event.name
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
        if event == nil {
            return Transaction(money: money, categoryID: category.identify, note: note, date: date, transactionType: category.transactionType)
        }
        return Transaction(money: money, categoryID: category.identify, note: note, date: date, idEvent: event.identify, transactionType: category.transactionType)
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
        choiseEventScreen.eventDidChoise = { [weak self] in
            guard let self = self else { return }
            self.eventImageView.image = UIImage(named: $0.image)
            self.eventNameTextField.text = $0.name
            self.event = $0
        }
        navigationController?.pushViewController(choiseEventScreen, animated: true)
    }
    
    @objc private func updateTransaction() {
        guard let transaction = transaction else {
            return
        }
        let transactionToUpdate = getTransaction()
        transactionToUpdate.identify = transaction.identify 
        database.save(transactionToUpdate)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveAction(_ sender: Any) {
        let transaction = getTransaction()
        database.save(transaction)
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
