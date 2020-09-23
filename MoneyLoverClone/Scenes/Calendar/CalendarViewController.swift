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

final class CalendarViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var calendar: FSCalendar!
    
    // MARK: - Properties
    typealias Handler = (Date) -> Void
    var passDate: Handler?
    var date = Date()
    
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
        calendar.select(date, scrollToDate: true)
    }
    
    // MARK: - Action
    @IBAction func showTodayAction(_ sender: Any) {
        calendar.select(Date(), scrollToDate: true)
    }
}

extension CalendarViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        passDate?(date)
        navigationController?.popViewController(animated: true)
    }
}

extension CalendarViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.calendar
}
