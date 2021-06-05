//
//  CalendarViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/23/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import FSCalendar
import Reusable
import Toast_Swift

final class CalendarViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var calendar: FSCalendar!
    @IBOutlet private weak var todayButton: UIBarButtonItem!
    
    // MARK: - Define
    typealias Handler = (Date) -> Void
    
    // MARK: - Properties
    var passDate: Handler?
    var date = Date()
    var choiseDateEnum = ChoiseDateEnum.past
    let today = Date()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    private func setupData() {
        calendar.delegate = self
    }
    
    // MARK: - Views
    private func setupViews() {
        calendar.do {
            $0.select(date, scrollToDate: true)
            $0.locale = Locale(identifier: "vi")
            $0.scrollDirection = .vertical
            $0.firstWeekday = 2
        }
        todayButton.setTitleTextAttributes([.underlineStyle: 1], for: .normal)
    }
    
    // MARK: - Action
    @IBAction func showTodayAction(_ sender: Any) {
        calendar.select(today, scrollToDate: true)
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        switch choiseDateEnum {
        case .future where date < today:
            view.makeToast("Ngày kết thúc không thể là ngày trong quá khứ")
            return
        case .past where date > today:
            view.makeToast("Giao dịch phải được thực hiện trong quá khứ & hiện tại")
            return
        case .future: break
        case .past: break
        }
        passDate?(date)
        navigationController?.popViewController(animated: true)
    }
}

extension CalendarViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.calendar
}
