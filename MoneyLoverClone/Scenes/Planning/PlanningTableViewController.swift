//
//  PlanningTableViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class PlanningTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let eventScreen = EventViewController.instantiate()
            navigationController?.pushViewController(eventScreen, animated: true)
        }
    }
}
