//
//  EventTableViewCell.swift
//  MoneyLoverClone
//
//  Created by V000232 on 9/22/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

class EventTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var dateLeftLabel: UILabel!
    @IBOutlet private weak var eventImage: UIImageView!
    @IBOutlet private weak var cashLabel: UILabel!
    @IBOutlet private weak var eventLabel: UILabel!
    @IBOutlet private weak var checkEventImageView: UIImageView!
    @IBOutlet private weak var checkEventLabel: UILabel!
    
    var cashEvent = 0
    var database: DBManager!
    
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
    
    func finishStatus() {
        checkEventLabel.do {
            $0.text = "Đã hoàn thành"
            $0.textColor = UIColor.green
        }
        checkEventImageView.do {
            $0.image = UIImage.init(named: "checked")
        }
    }
    
    func applyStatus() {
        checkEventLabel.do {
            $0.text = "Đang áp dụng"
            $0.textColor = UIColor.purple
        }
        checkEventImageView.do {
            $0.image = UIImage.init(named: "icons8-process-40")
        }
    }
    
    func validStatus() {
        checkEventLabel.do {
            $0.text = "Đã hết hạn"
            $0.textColor = UIColor.red
        }
        checkEventImageView.do {
            $0.alpha = 0
        }
    }
    
    private func expenseEvent(idEvent: String) -> Int {
        cashEvent = 0
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
    
    func estimateDay(endDate: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let date1 = calendar.startOfDay(for: now )
        let date2 = calendar.startOfDay(for: endDate )
        let estimateDay = calendar.dateComponents([.day], from: date1, to: date2 ).day ?? 0
        return estimateDay
    }
    
    func setContent(data: Event) {
        let idevent = data.identify
        let cash = expenseEvent(idEvent: idevent)
        let dateLeft = estimateDay(endDate: data.endDate)
        let status = data.status
        if status == StatusEventEnum.valid.rawValue {
            validStatus()
        } else if status == StatusEventEnum.finish.rawValue {
            finishStatus()
        } else if status == StatusEventEnum.apply.rawValue {
            applyStatus()
        }
        cashLabel.do {
            if cash <= 0 {
                $0.text = "Đã chi \((cash*(-1)).convertToMoneyFormat()) VND"
            } else {
                $0.text = "Đã thu \(cash.convertToMoneyFormat()) VND"
            }
        }
        dateLeftLabel.do {
            if dateLeft < 0 {
                $0.text = "Còn lại 0 ngày"
            } else {
                $0.text = "Còn lại \(String(dateLeft)) ngày"
            }
        }
        eventImage.image = UIImage(named: data.image)
        eventLabel.text = data.name
        
    }
}
