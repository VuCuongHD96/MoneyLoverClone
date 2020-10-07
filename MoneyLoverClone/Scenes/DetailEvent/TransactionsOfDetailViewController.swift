//
//  DetailEventViewController.swift
//  MoneyLoverClone
//
//  Created by V000232 on 10/2/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

final class TransactionsOfDetailViewController: UIViewController {
    
    @IBOutlet private weak var cardOverView: UIView!
    @IBOutlet private weak var tableview: UITableView!
    
    struct Constant {
        static let numberOfSections = 5
        static let numberOfRowsInSection = 2
        static let heightForFooterInSection: CGFloat = 25
        static let heightForHeaderInSection: CGFloat = 55
        static let headerNibName = "HeaderTransactionView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        tableview.tableFooterView = footerView
    }
    
    func setupData() {
        tableview.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cellType: TransactionCell.self )
        }
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
        cardOverView.backgroundColor = UIColor.white
        cardOverView.layer.cornerRadius = 8
        cardOverView.layer.masksToBounds = false
        cardOverView.layer.shadowOpacity = 0.7
        cardOverView.layer.shadowOffset = CGSize(width: 0, height: 1)
        cardOverView.layer.shadowColor = UIColor.black.cgColor
        tableview.do {
            $0.backgroundColor = UIColor(red: 240/255.0, green: 240/255, blue: 240/255.0, alpha: 1.0)
        }
    }
}

extension TransactionsOfDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerSectionView = Bundle.main.loadNibNamed(Constant.headerNibName, owner: self, options: nil)?.first as? HeaderTransactionView else {
            return UIView()
        }
        return headerSectionView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constant.heightForFooterInSection
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.heightForHeaderInSection
    }
}

extension TransactionsOfDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}

extension TransactionsOfDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.detailEvent
}
