//
//  PlanningTableViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Then

final class PlanningTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
        }
    } 
}

extension PlanningTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let viewcontroller = EventViewController.instantiate()
            navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
}
