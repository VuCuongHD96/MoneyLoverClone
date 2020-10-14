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
    var transaction: Transaction!
    let today = Date()
    var addUpdateTransactionEnum = AddUpdateTransactionEnum.add
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
        setupChoiseEnum()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataIsValid()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        moneyTextField.resignFirstResponder()
    }
    
    // MARK: - Views
    private func setupView() {
        let customKeyboard = NumericKeyboard(target: moneyTextField)
        customKeyboard.doneEdit = { [weak self] in
            guard let self = self else { return }
            self.hideKeyBoard()
        }
        moneyTextField.inputView = customKeyboard
        saveButton.do {
            $0.isEnabled = false
            $0.setTitleTextAttributes([.underlineStyle: 1], for: .normal)
            $0.target = self
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
        moneyTextField.do {
            $0.addTarget(self, action: #selector(dataIsValid), for: .editingDidEnd)
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        database = DBManager.shared
        transaction = Transaction()
    }
    
    private func setupChoiseEnum() {
        switch addUpdateTransactionEnum {
        case .add:
            prepareForAdd()
        case .update(let transaction):
            prepareForUpdate()
            setupTransactionData(transaction)
            self.transaction.clone(from: transaction)
        }
    }
    
    private func prepareForAdd() {
        navigationItem.title = "Thêm giao dịch"
        saveButton.action = #selector(saveAction)
        let todayDateString = formatter.string(from: today)
        dateLabel.text = todayDateString
    }
    
    private func prepareForUpdate() {
        navigationItem.title = "Sửa giao dịch"
        navigationItem.rightBarButtonItem?.title = "Cập nhật"
        saveButton.action = #selector(updateTransaction)
    }
    
    private func setupTransactionData(_ transaction: Transaction) {
        let categoryFetch = database.fetchCategory(from: transaction.categoryID)
        categoryImageView.image = UIImage(named: categoryFetch.image)
        categoryNameTextField.text = categoryFetch.name
        moneyTextField.text = transaction.money.convertToEditFormat()
        dateLabel.text = formatter.string(from: transaction.date)
        date = transaction.date
        noteTextField.text = transaction.note
        guard let idEvent = transaction.idEvent else { return }
        event = database.fetchObject(from: idEvent)
        eventImageView.image = UIImage(named: event.image)
        eventNameTextField.text = event.name
    }
    
    private func hideKeyBoard() {
        moneyTextField.do {
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
    
    // MARK: - Action
    private func choiseCategory() {
        let categoryScreen = CategoryViewController.instantiate()
        categoryScreen.passCategory = { [weak self] in
            guard let self = self else { return }
            self.categoryImageView.image = UIImage(named: $0.image)
            self.categoryNameTextField.text = $0.name
            self.transaction.categoryID = $0.identify
            self.transaction.type = $0.transactionType
        }
        categoryScreen.categorySelected = category
        navigationController?.pushViewController(categoryScreen, animated: true)
    }
    
    private func choiseDate(completeChoice: @escaping (Date) -> Void) {
        moneyTextField.resignFirstResponder()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let todaySheet = UIAlertAction(title: "Hôm nay", style: .default) { [weak self] _ in
            guard let self = self else { return }
            completeChoice(self.today)
        }
        let yesterdaySheet = UIAlertAction(title: "Hôm qua", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            let yesterday = self.today - 1.days
            completeChoice(yesterday)
        }
        let customSheet = UIAlertAction(title: "Tùy chọn", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            let calendarScreen = CalendarViewController.instantiate()
            calendarScreen.choiseDateEnum = .past
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
        let note = noteTextField.text
        let noteScreen = NoteViewController.instantiate()
        noteScreen.note = note
        noteScreen.sendNote = {
            self.noteTextField.text = $0
            self.transaction.note = $0
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
            self.transaction.idEvent = $0.identify
        }
        navigationController?.pushViewController(choiseEventScreen, animated: true)
    }
    
    @objc private func updateTransaction() {
        let transactionToUpdate = Transaction()
        transactionToUpdate.clone(from: transaction)
        database.save(transactionToUpdate)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveAction() {
        let transactionToSave = Transaction()
        transactionToSave.clone(from: transaction)
        database.save(transactionToSave)
        UserDefaults.standard.set(transaction.date, forKey: "NewDateAdded")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange() {
        guard let text = moneyTextField.text?.convertToEditFormat() else { return }
        moneyTextField.text = text
        transaction.money = text.convertToInt()
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
            choiseDate { [weak self] in
                guard let self = self else { return }
                self.date = $0
                let dateString = self.formatter.string(from: $0)
                self.dateLabel.text = dateString
                self.transaction.date = $0
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
