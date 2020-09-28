//
//  EventIconViewController.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 9/28/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import UIKit
import Reusable

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
    typealias Handler = (Category) -> Void
    var categoryDidChoise: Handler?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategoryData(from: "ExpenseArray")
        collectionView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(cellType: CategoryIconCell.self)
        }
    }
    
    private func fetchCategoryData(from name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let nsDictionary = NSDictionary(contentsOfFile: path) else { return }
        categoryArray = nsDictionary.map {
            let imageString = $0.key as? String ?? ""
            let name = $0.value as? String ?? ""
            let category = Category(image: imageString, name: name)
            return category
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constant.cellSpacing
    }
}

extension EventIconViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoryArray[indexPath.row]
        categoryDidChoise?(category)
    }
}
