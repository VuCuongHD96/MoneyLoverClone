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
        checkEventValid()
    }
    
    private func getListEventData() {
        listEvent = database.fetchEvents()
    }
    
    private func checkEventValid() {
        listEvent.forEach { event in
            let endDate =  event.endDate
            let dayLeft = estimateDay(endDate: endDate)
            if dayLeft == 0 {
                updateProcessEvent(status: StatusEventEnum.valid.rawValue, event: event)
            }
        }
    }
    
    private func estimateDay(endDate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let date1 = calendar.startOfDay(for: now)
        let date2 = calendar.startOfDay(for: endDate)
        let estimateDay = calendar.dateComponents([.day], from: date1, to: date2).day ?? 0
        return estimateDay
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
    

    private func confirmDelete(event: Event) {
        let alert = UIAlertController(title: nil, message: "Xoá sự kiện này?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Xoá", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.database.delete(event)
            self.listEvent = self.database.fetchEvents()
        }
        deleteAction.setValue(UIColor.red, forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addEventAction(_ sender: Any) {
        let story = AddUpdateEventTableViewController.instantiate()

        let navController = UINavigationController(rootViewController: story)
        story.isModalInPresentation = true
        navController.modalPresentationStyle = .fullScreen
        story.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        present(navController, animated: true, completion: nil)
    }
}

extension EventViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.event
}

extension EventViewController: UITableViewDelegate {


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

            let story = TransactionsOfEventViewController.instantiate()
            story.event = event

            self.navigationController?.pushViewController(story, animated: true)
        }
        let editEventSheet = UIAlertAction(title: "Sửa sự kiện", style: .default) { [weak self] (_) in

            guard let self = self else { return }
            let story = AddUpdateEventTableViewController.instantiate()
            let navController = UINavigationController(rootViewController: story)
            story.isModalInPresentation = true
            story.addUpdateEvent = .update(event)
            navController.modalPresentationStyle = .fullScreen
            story.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(navController, animated: true, completion: nil)
        }
        let deleteEventSheet = UIAlertAction(title: "Xóa sự kiện", style: .destructive) { [weak self] (_) in
            guard let self = self else { return }
            self.confirmDelete(event: event)
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
        let cell: EventTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let event = listEvent[indexPath.row]
        cell.setContent(data: event)
        return cell
    }
}
