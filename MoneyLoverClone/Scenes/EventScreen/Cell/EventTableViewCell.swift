//
//  EventTableViewCell.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class EventTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var dateLeftLabel: UILabel!
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var cashLabel: UILabel!
    @IBOutlet private weak var eventLabel: UILabel!
    
    var cashEvent = 0
    var database: DBManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupData()
    }
    
    private func setupView() {
        cardView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
        cardView.layer.cornerRadius = 8
        cardView.layer.masksToBounds = false
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func setupData() {
        database = DBManager.shared
    }
    
    private func expenseEvent(idEvent: String) -> Int {
        guard let listTransationEvent = database?.fetchTransation(from: idEvent) else {
            return 0
        }
        listTransationEvent.forEach { transationFromEvent in
            if transationFromEvent.type == TransactionType.expendsed.rawValue {
                cashEvent -= transationFromEvent.money
            } else {
                cashEvent += transationFromEvent.money
            }
        }
        return cashEvent
    }
    
    private func estimateDay(endDate: Date) -> Int {
        let now = Date()
        let estimateDay = Calendar.current.dateComponents([.day], from: now, to: endDate ).day ?? 0
        return estimateDay
    }
    
    func setContent(data: Event) {
        let idevent = data.identify
        let cash = expenseEvent(idEvent: idevent)
        let dateLeft = estimateDay(endDate: data.endDate)
        cashLabel.do {
            if cash <= 0 {
                $0.text = "Đã chi \((cash*(-1)).convertToMoneyFormat()) VND"
            } else {
                $0.text = "Đã thu \(cash.convertToMoneyFormat()) VND"
            }
        }
        dateLeftLabel.text = "Còn lại \(String(dateLeft)) ngày"
        eventImage.image = UIImage(named: data.image)
        eventLabel.text = data.name
    }
}
