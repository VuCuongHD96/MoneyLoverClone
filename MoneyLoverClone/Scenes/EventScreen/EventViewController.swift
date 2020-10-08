//
//  EventViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

class EventViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct Constant {
        static let heigtforrow: CGFloat = 95
        static let namecell = "EventTableViewCell"
    }
    
    var listEvent = [Event]()
    var database: DBManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListEventData()
        tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib.init(nibName: Constant.namecell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellEvent")
    }
    
    func getListEventData() {
//        let event = Event(idEvent: 1, estimateDay: 12, nameEvent: "Birthday", imgEvent: "icon2", cash: 12000000, inProgress: true, endDate: Date() + TimeInterval(Date().day * 7))
//        for _ in 1...10 {
//            listEvent.append(event)
//        }
    }
    
    @IBAction func addEventAction(_ sender: Any) {
        let story = UIStoryboard(name: "AddEvent", bundle: nil)
        guard let addEventView = story.instantiateViewController(identifier: "AddEventTableViewController") as? AddEventTableViewController else {
            return
        }
        let navController = UINavigationController(rootViewController: addEventView)
        addEventView.isModalInPresentation = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEvent", for: indexPath) as? EventTableViewCell ?? nil
//        cell!.imgEvent.image = UIImage.init(named: listEvent[indexPath.row].imgEvent)
//        cell!.txtCash.text =  "Đã chi \(String(listEvent[indexPath.row].cash)) VND"
//        cell!.txtDateLeft.text = "Còn lại \(String(listEvent[indexPath.row].estimateDay))"
        cell!.cardView.backgroundColor = UIColor.white
        cell!.contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
        cell!.cardView.layer.cornerRadius = 8
        cell!.cardView.layer.masksToBounds = false
        cell!.cardView.layer.shadowOpacity = 0.5
        cell!.cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell!.cardView.layer.shadowColor = UIColor.black.cgColor
        return cell!
    }
}
