//
//  EventViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class EventViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Constant {
        static let heigtforrow: CGFloat = 95
    }
    
    var listEvent = [Event]() {
        didSet {
            tableView.reloadData()
        }
    }
    var database: DBManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListEventData()
    }
    
    private func getListEventData() {
        listEvent = database.fetchEvents()
    }
    
    private func setupView() {
        tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
    }
    
    private func setupData() {
        database = DBManager.shared
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: EventTableViewCell.self )
        }
    }
    
    @IBAction func addEventAction(_ sender: Any) {
        let story = UIStoryboard(name: "AddEvent", bundle: nil)
        guard let addEventView = story.instantiateViewController(identifier: "AddEventTableViewController") as? AddEventTableViewController else {
            return
        }
        let navController = UINavigationController(rootViewController: addEventView)
        addEventView.isModalInPresentation = true
        navController.modalPresentationStyle = .fullScreen
        addEventView.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        present(navController, animated: true, completion: nil)
    }
}

extension EventViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.event
}

extension EventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "DetailEvent", bundle: nil)
        guard let detailEvent = story.instantiateViewController(identifier: "DetailEventViewController") as? TransactionsOfDetailViewController else {
            print("err")
            return
        }
        navigationController?.pushViewController(detailEvent, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heigtforrow
    }
}

extension EventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listEvent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let event = listEvent[indexPath.row]
        cell.setContent(data: event)
        return cell
    }
}
