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
    var cell = EventTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListEventData()
        checkEventValid()
    }
    
    private func getListEventData() {
        listEvent = database.fetchEvents()
    }
    
    private func checkEventValid() {
        listEvent.forEach { event in
            let endDate =  event.endDate
            let dayLeft = cell.estimateDay(endDate: endDate)
            if dayLeft == 0 {
                updateProcessEvent(status: StatusEventEnum.valid.rawValue, event: event)
            }
        }
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
    
    func updateProcessEvent(status: String, event: Event) {
        let eventUpdate = Event()
        eventUpdate.clone(from: event)
        eventUpdate.status = status
        database?.save(eventUpdate)
        listEvent = database.fetchEvents()
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
    func moveToDetailEventScreen() {
        let story = UIStoryboard(name: "DetailEvent", bundle: nil)
        guard let detailEvent = story.instantiateViewController(identifier: "DetailEventViewController") as? TransactionsOfDetailViewController else {
            print("err")
            return
        }
        self.navigationController?.pushViewController(detailEvent, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get statusEvent
        let event = listEvent[indexPath.row]
        let statusEvent = event.status
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //excute alert
        let checkSheet = UIAlertAction(title: "Đánh dấu hoàn tất ", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if statusEvent == StatusEventEnum.finish.rawValue {
                self.updateProcessEvent(status: StatusEventEnum.apply.rawValue, event: event)
            } else {
                self.updateProcessEvent(status: StatusEventEnum.finish.rawValue, event: event)
            }
        }
        let detailEventSheet = UIAlertAction(title: "Danh sách giao dịch", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.moveToDetailEventScreen()
        }
        let editEventSheet = UIAlertAction(title: "Sửa sự kiện", style: .default) { [weak self] (_) in
            guard let self = self else { return }
        }
        let deleteEventSheet = UIAlertAction(title: "Xóa sự kiện", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
        }
        let cancelSheet = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        
        if statusEvent == StatusEventEnum.finish.rawValue {
            checkSheet.setValue("Đánh dấu chưa hoàn tất", forKey: "title")
        } else if statusEvent == StatusEventEnum.valid.rawValue {
            checkSheet.isEnabled = false
        }
        alert.addAction(checkSheet)
        alert.addAction(detailEventSheet)
        alert.addAction(editEventSheet)
        alert.addAction(deleteEventSheet)
        alert.addAction(cancelSheet)
        present(alert, animated: true, completion: nil)
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
        cell = tableView.dequeueReusableCell(for: indexPath)
        let event = listEvent[indexPath.row]
        cell.setContent(data: event)
        return cell
    }
}
