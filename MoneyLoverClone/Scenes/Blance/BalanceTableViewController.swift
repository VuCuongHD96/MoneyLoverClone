//
//  BalanceTableViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/12/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Then
import Reusable

final class BalanceTableViewController: UITableViewController {

    // MARK: - Outlet
    @IBOutlet private weak var cancelButton: UIBarButtonItem!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var moneyTextField: UITextField!
    
    // MARK: - Define
    typealias AttributedStringType = [NSAttributedString.Key: Any]
    
    // MARK: - Properties
    var money = 0
    let today = Date()
    var transaction = Transaction()
    var database: DBManager!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    // MARK: - View
    private func setupView() {
        let attributeButton: AttributedStringType = [.underlineStyle: 1, .foregroundColor: UIColor.systemGreen]
        saveButton.do {
            $0.isEnabled = false
            $0.setTitleTextAttributes(attributeButton, for: .normal)
        }
        cancelButton.do {
            $0.setTitleTextAttributes(attributeButton, for: .normal)
        }
        moneyTextField.do {
            $0.becomeFirstResponder()
            $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    // MARK: - Data
    private func setupData() {
        database = DBManager.shared
        moneyTextField.text = money.convertToEditFormat()
    }

    private func createTransaction() {
        guard let nowBlance = moneyTextField.text?.convertToInt() else { return }
        var category = Category()
        var moneyTransaction = 0
        if nowBlance < money {
            category = database.fetchCategoryBy(name: TransactionType.expendsed.rawValue)
            moneyTransaction = money - nowBlance
        } else {
            category = database.fetchCategoryBy(name: TransactionType.income.rawValue)
            moneyTransaction = nowBlance - money
        }
        transaction.money = moneyTransaction
        transaction.categoryID = category.identify
        transaction.type = category.transactionType
        transaction.note = "Điều chỉnh số dư"
        transaction.date = today
    }
    
    // MARK: - Action
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        createTransaction()
        database.save(transaction)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange() {
        let text = moneyTextField.text?.convertToEditFormat()
        moneyTextField.text = text
        let newMoney = text?.convertToInt() ?? 0
        if money == newMoney {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}

extension BalanceTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.blance
}
