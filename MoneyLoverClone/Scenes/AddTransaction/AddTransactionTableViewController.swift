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
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var eventNameTextField: UITextField!
    
    // MARK: - Define
    struct Constant {
        static let eventDefaultImage = "event"
    }
    
    // MARK: - Properties
    var category = Category() {
        didSet {
            setupCategory()
        }
    }
    var date = Date() {
        didSet {
            setupDate()
        }
    }
    var event = Event() {
        didSet {
            setupEvent()
        }
    }
    let formatter = DateFormatter()
    var database = DBManager.shared
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
    
    // MARK: - Views
    private func setupView() {
        moneyTextField.do {
            $0.keyboardType = .numberPad
            $0.addDoneButton()
            $0.delegate = self
        }
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
    }
    
    private func setupCategory() {
        categoryImageView.image = UIImage(named: category.image)
        categoryNameTextField.text = category.name
    }
    
    private func setupDate() {
        let dateString = formatter.string(from: date)
        dateLabel.text = dateString
    }
    
    private func setupEvent() {
        eventImageView.image = UIImage(named: event.image) ?? UIImage(named: Constant.eventDefaultImage)
        eventNameTextField.text = event.name
    }
    
    private func setupChoiseEnum() {
        switch addUpdateTransactionEnum {
        case .add:
            prepareForAdd()
        case .update(let transaction):
            prepareForUpdate(transaction)
            setupTransactionData(transaction)
            self.transaction = transaction
        }
    }
    
    private func prepareForAdd() {
        navigationItem.title = "Thêm giao dịch"
        saveButton.action = #selector(saveAction)
        let todayDateString = formatter.string(from: today)
        dateLabel.text = todayDateString
    }
    
    private func prepareForUpdate(_ transaction: Transaction) {
        navigationItem.title = "Sửa giao dịch"
        navigationItem.rightBarButtonItem?.title = "Cập nhật"
        saveButton.action = #selector(setupUpdateAction)
    }
    
    @objc func moveToNextTextField(sender: Timer) {
        guard let abc = sender.userInfo as? [String: Any] else {
            return
        }
        guard let data = abc["transaction"] as? Transaction else { return }
        print("đây là dữ liệu: = ", data)
    }

    private func setupTransactionData(_ transaction: Transaction) {
        let categoryFetch = database.fetchCategory(from: transaction.categoryID)
        category = categoryFetch
        moneyTextField.text = transaction.money.convertToEditFormat()
        date = transaction.date
        noteTextField.text = transaction.note
        guard let idEvent = transaction.idEvent else { return }
        let eventFetch = database.fetchEvent(from: idEvent)
        event = eventFetch
    }
    
    @objc private func dataIsValid() {
        if moneyTextField.text == "0" || categoryNameTextField.text?.isEmpty == true {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    private func getTransaction() -> Transaction {
        let moneyString = moneyTextField.text ?? "0"
        let moneyNumber = moneyString.convertToInt()
        let categoryID = category.identify
        let transactionType = category.transactionType
        let noteString = noteTextField.text ?? ""
        
        let transaction = Transaction()
        transaction.money = moneyNumber
        transaction.categoryID = categoryID
        transaction.type = transactionType
        transaction.note = noteString
        transaction.date = date
        transaction.idEvent = event.identify
        
        return transaction
    }
    
    // MARK: - Action
    private func choiseCategory() {
        let categoryScreen = CategoryViewController.instantiate()
        categoryScreen.passCategory = { [weak self] in
            guard let self = self else { return }
            self.category = $0
        }
        categoryScreen.categorySelected = category
        navigationController?.pushViewController(categoryScreen, animated: true)
    }
    
    private func choiseDate(completeChoice: @escaping (Date) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let todaySheet = UIAlertAction(title: "Hôm nay", style: .default) { [weak self] _ in
            guard let self = self else { return }
            completeChoice(self.today)
        }
        let yesterdaySheet = UIAlertAction(title: "Hôm qua", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let yesterday = self.today - 1.days
            completeChoice(yesterday)
        }
        let customSheet = UIAlertAction(title: "Tùy chọn", style: .default) { [weak self] _ in
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
        }
        navigationController?.pushViewController(noteScreen, animated: true)
    }
    
    private func choiseEvent() {
        let choiseEventScreen = ChoiseEventTableViewController.instantiate()
        choiseEventScreen.eventDidChoise = { [weak self] in
            guard let self = self else { return }
            self.event = $0
        }
        navigationController?.pushViewController(choiseEventScreen, animated: true)
    }
    
    @objc private func setupUpdateAction() {
        let transactionToUpdate = getTransaction()
        transactionToUpdate.identify = transaction.identify
        database.save(transactionToUpdate)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveAction() {
        let currentTransaction = getTransaction()
        let transactionToSave = Transaction()
        transactionToSave.clone(from: currentTransaction)
        database.save(transactionToSave)
//        UserDefaults.standard.set(transaction.date, forKey: "NewDateAdded")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange() {
        guard let text = moneyTextField.text?.convertToEditFormat() else { return }
        moneyTextField.text = text
//        transaction.money = text.convertToInt()
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
            }
        case 4:
            choiseEvent()
        default:
            print("Wrong Choise")
        }
        
        moneyTextField.resignFirstResponder()
    }
}

extension AddTransactionTableViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            textField.text = "0"
        }
    }
}

extension AddTransactionTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.addTransaction
}
