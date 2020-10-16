//
//  ChoiseEventTableViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/1/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class ChoiseEventTableViewController: UITableViewController {
    
    // MARK: - Properties
    struct Constant {
        static let cellHeight: CGFloat = 50
        static let numberOfSection = 2
    }
    var eventArray = [Event]() {
        didSet {
            tableView.reloadData()
        }
    }
    typealias Handler = (Event) -> Void
    var eventDidChoise: Handler?
    var database: DBManager!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventArray = database.fetchEvents()
    }
    
    // MARK: - Data
    private func setupData() {
        tableView.do {
            $0.register(cellType: ChoiseEventCell.self)
            $0.register(cellType: AddEventCell.self)
        }
        database = DBManager.shared
    }
    
    // MARK: - View
    private func setupView() {
        navigationItem.title = "Chọn Sự Kiện"
    }
}

// MARK: - TableView Datasource
extension ChoiseEventTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.numberOfSection
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return eventArray.count
        case 1:
            return 1
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: ChoiseEventCell = tableView.dequeueReusableCell(for: indexPath)
            let event = eventArray[indexPath.row]
            cell.setContent(data: event)
            return cell
        case 1:
            let addCell: AddEventCell = tableView.dequeueReusableCell(for: indexPath)
            return addCell
        default:
            break
        }
        return UITableViewCell()
    }
}

extension ChoiseEventTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.cellHeight
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let event = eventArray[indexPath.row]
            eventDidChoise?(event)
            navigationController?.popViewController(animated: true)
        case 1:
            let addEventScreen = AddUpdateEventTableViewController.instantiate()
            let navigationController = UINavigationController(rootViewController: addEventScreen)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension ChoiseEventTableViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.choiseEvent
}
