//
//  FindTransactionViewController.swift
//  MoneyLoverClone
//
//  Created by admin on 8/8/21.
//  Copyright © 2021 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class FindTransactionViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Do Action
    @IBAction func closeAction(_ sender: Any) {
        
    }
}

extension FindTransactionViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.findTransaction
}
