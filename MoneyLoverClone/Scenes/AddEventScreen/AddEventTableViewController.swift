//
//  AddEventTableViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import SwiftDate
import Reusable

class AddEventTableViewController: UITableViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var dateLabel: UITextField!
    @IBOutlet private weak var tblAddEvent: UITableView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var imgIcon: UIImageView!
    
    let formatter = DateFormatter()
    let formattershort = DateFormatter()
    var imgString = ""
    var database: DBManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAddEvent.delegate = self
        tblAddEvent.dataSource = self
        setupDate()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgIcon.isUserInteractionEnabled = true
        imgIcon.addGestureRecognizer(tapGestureRecognizer)
        database = DBManager.shared
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if nameTextField.text?.isEmpty ?? false  || dateLabel.text == "Ngày kết thúc" || nameTextField.text == "Tên" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let eventIconScreen = EventIconViewController.instantiate()
        eventIconScreen.categoryDidChoise = { [weak self] in
            guard let self = self else { return }
            self.imgIcon.image = UIImage(named: $0.image)
            self.imgString = $0.image
        }
        navigationController?.pushViewController(eventIconScreen, animated: true)
    }
    
    private func setupDate() {
        let locale = Locale(identifier: "vi")
        formattershort.do {
            $0.dateFormat = "yyyy-MM-dd"
            $0.locale = locale
            $0.timeZone = TimeZone(secondsFromGMT: 7)
        }
        formatter.do {
            $0.dateStyle = .full
            $0.locale = locale
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func estimateDay(endDate: Date) -> Int {
        let now = Date()
        let nowString = formattershort.string(from: now)
        let dateNowFormater = formattershort.date(from: nowString)
        let estimateDay = Calendar.current.dateComponents([.day], from: dateNowFormater ?? now, to: endDate ).day ?? 0
        return estimateDay
    }
    
    @IBAction func btnSave(_ sender: Any) {
        let name = nameTextField.text ?? ""
        guard let date = formatter.date(from: dateLabel.text ?? "") else { return }
        let event = Event(name: name, image: imgString, endDate: date)
        database.save(event)
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 1:
            let calendarScreen = CalendarViewController.instantiate()
            calendarScreen.choiseDateEvent = true
            navigationController?.pushViewController(calendarScreen, animated: true)
            calendarScreen.passDate = {
                let dateString = self.formatter.string(from: $0)
                self.dateLabel.text = dateString
            }
        default:
            print("")
        }
    }
    
    @IBAction func editText(_ sender: Any) {
        nameTextField.textColor = .black
        if nameTextField.text?.isEmpty ?? false || dateLabel.text?.isEmpty == true {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}

extension AddEventTableViewController: ImageDelegate {
    func displayImage(data: String) {
        imgIcon.image = UIImage(named: data )
        imgString = data
    }
}

extension AddEventTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.addEvent
}
