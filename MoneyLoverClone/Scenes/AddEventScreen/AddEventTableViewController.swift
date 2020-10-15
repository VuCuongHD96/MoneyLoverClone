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
    @IBOutlet private weak var tableEvent: UITableView!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
    @IBOutlet private weak var iconImage: UIImageView!
    
    let formatter = DateFormatter()
    var imageString = ""
    var database: DBManager!
    var enddate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        tableEvent.delegate = self
        tableEvent.dataSource = self
        setupDate()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        iconImage.isUserInteractionEnabled = true
        iconImage.addGestureRecognizer(tapGestureRecognizer)
        database = DBManager.shared
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dateLabel.textColor = UIColor.black
        if nameTextField.text?.isEmpty ?? false  || dateLabel.text?.isEmpty ?? false {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nameTextField.resignFirstResponder()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let eventIconScreen = EventIconViewController.instantiate()
        eventIconScreen.categoryDidChoise = { [weak self] in
            guard let self = self else { return }
            self.iconImage.image = UIImage(named: $0.image)
            self.imageString = $0.image
        }
        navigationController?.pushViewController(eventIconScreen, animated: true)
    }
    
    private func setupDate() {
        let locale = Locale(identifier: "vi")
        formatter.do {
            $0.dateStyle = .full
            $0.locale = locale
            $0.timeZone = TimeZone(identifier: "vi")
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let name = nameTextField.text ?? ""
        let event = Event(name: name, image: imageString, endDate: enddate)
        database.save(event)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editText(_ sender: Any) {
        nameTextField.textColor = .black
        nameTextField.becomeFirstResponder()
        if nameTextField.text?.isEmpty ?? false || dateLabel.text?.isEmpty ?? false {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
}

extension AddEventTableViewController: ImageDelegate {
    func displayImage(data: String) {
        iconImage.image = UIImage(named: data )
        imageString = data
    }
}

extension AddEventTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 1:
            let calendarScreen = CalendarViewController.instantiate()
            calendarScreen.choiseDateEnum = .future
            navigationController?.pushViewController(calendarScreen, animated: true)
            calendarScreen.passDate = {
                let dateString = self.formatter.string(from: $0)
                self.dateLabel.text = dateString
                self.enddate = $0
            }
        default:
            break
        }
    }
}

extension AddEventTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}

extension AddEventTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.addEvent
}
