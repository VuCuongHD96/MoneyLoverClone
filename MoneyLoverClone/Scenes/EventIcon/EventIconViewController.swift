//
//  EventIconViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/28/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable
import ViewAnimator

final class EventIconViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties
    struct Constant {
        static let lineSpacing: CGFloat = 40
        static let cellSpacing: CGFloat = 40
    }
    var categoryArray = [Category]() {
        didSet {
            collectionView.reloadData()
        }
    }
    weak var delegate: ImageDelegate?
    typealias Handler = (Category) -> Void
    var categoryDidChoise: Handler?
    var database: DBManager!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cellAnimation()
    }
    
    // MARK: - View
    private func setupView() {
        navigationItem.title = "Chọn Biểu Tượng"
    }
    
    private func cellAnimation() {
        let zoomAnimation = AnimationType.zoom(scale: 0.5)
        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/3)
        UIView.animate(views: collectionView.visibleCells,
                       animations: [rotateAnimation, zoomAnimation],
                       duration: 1)
    }
    
    // MARK: - Data
    private func setupData() {
        database = DBManager.shared
        database.setupCategoryData()
        categoryArray = database.fetchCategorys()
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CategoryIconCell.self)
        }
    }
}

extension EventIconViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboard.eventIcon
}

extension EventIconViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoryIconCell = collectionView.dequeueReusableCell(for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.setContent(data: category)
        return cell
    }
}

extension EventIconViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.cellSpacing
    }
}

extension EventIconViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoryArray[indexPath.row]
        categoryDidChoise?(category)
        navigationController?.popViewController(animated: true)
    }
}
