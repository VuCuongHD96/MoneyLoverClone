//
//  AddEventTableViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class AddEventTableViewController: UITableViewController {
    
    @IBOutlet var tblAddEvent: UITableView!
    
    @IBOutlet private weak var btnLuu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAddEvent.delegate = self
        tblAddEvent.dataSource = self
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        switch row {
        case 0:
             let calendarScreen = CalendarViewController.instantiate()
             self.navigationController?.pushViewController(calendarScreen, animated: true)
        case 1:
        case 2:
        default:
            print("error")
        }
    }
}
