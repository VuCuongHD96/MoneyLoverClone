//
//  DatePickerViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/21/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

final class DatePickerViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet private weak var datePicker: UIDatePicker!
        
    // MARK: - Properties
    var date = Date()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    // MARK: - Data
    private func setupData() {
        let locale = Locale(identifier: "vi")
        datePicker.do {
            $0.locale = locale
            $0.datePickerMode = .date
        }
        datePicker.date = date
    }
    
    // MARK: - Action
    @IBAction func dataChange(_ sender: UIDatePicker) {
        let getDate = datePicker.date
        self.date = getDate
    }
}
