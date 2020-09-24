//
//  PlanningTableViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit

class PlanningTableViewController: UITableViewController {

    @IBOutlet private var tblPlanning: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPlanning.dataSource = self
        tblPlanning.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.section == 1 {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
