//
//  EventViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

class EventViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tblEvent: UITableView!
    var listEvent = [Event]()
    var database: DBManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListEventData()
        tblEvent.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
        tblEvent.dataSource = self
        tblEvent.delegate = self
        let nib = UINib.init(nibName: "EventTableViewCell", bundle: nil)
        tblEvent.register(nib, forCellReuseIdentifier: "cellEvent")
    }
    
    func getListEventData() {
        listEvent.append(Event(idEvent: 1, estimateDay: 12, nameEvent: "Birthday", imgEvent: "icon2", cash: 12000000, inProgress: true, endDate: Date() + TimeInterval(Date().day * 7)))
        listEvent.append(Event(idEvent: 1, estimateDay: 0, nameEvent: "Birthday", imgEvent: "icon2", cash: 12000000, inProgress: true, endDate: Date() + TimeInterval(Date().day * 7)))
        listEvent.append(Event(idEvent: 1, estimateDay: 11, nameEvent: "Birthday", imgEvent: "icon2", cash: 12000000, inProgress: true, endDate: Date() + TimeInterval(Date().day * 7)))
        listEvent.append(Event(idEvent: 1, estimateDay: 10, nameEvent: "Birthday", imgEvent: "icon2", cash: 12000000, inProgress: true, endDate: Date() + TimeInterval(Date().day * 7)))
    }
    
    @IBAction func addEventAction(_ sender: Any) {
        let story = UIStoryboard(name: "AddEvent", bundle: nil)
        guard let addEventView = story.instantiateViewController(identifier: "AddEventTableViewController") as? AddEventTableViewController else {
            return
        }
        let navController = UINavigationController(rootViewController: addEventView)
        addEventView.isModalInPresentation = true
        addEventView.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(navController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellEvent", for: indexPath) as? EventTableViewCell ?? nil
        cell!.imgEvent.image = UIImage.init(named: listEvent[indexPath.row].imgEvent)
        cell!.txtCash.text =  "Đã chi \(String(listEvent[indexPath.row].cash)) VND"
        cell!.txtDateLeft.text = "Còn lại \(String(listEvent[indexPath.row].estimateDay))"
        cell!.txtEvent.text = listEvent[indexPath.row].nameEvent
        
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
func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
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
}
