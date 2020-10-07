//
//  DBManager.swift
//  MoneyLoverClone
//
//  Created by Vu Xuan Cuong on 10/2/20.
//  Copyright © 2020 Vu Xuan Cuong. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    // MARK: - Setup Database
    static let shared = DBManager()
    private var database: Realm!
    
    private init() {
        database = try? Realm()
    }
    
    func delete<T: Object>(_ object: T) {
        try? database.write {
            database.delete(object)
        }
    }
    
    func save<T: Object>(_ object: T) {
        try? database?.write {
            database?.add(object, update: .all)
        }
    }
    
    func fetchObject<T: Object>(from identify: String) -> T {
        let result = database.objects(T.self).filter("identify == %@", identify)
        guard let object = result.first else {
            return T()
        }
        return object
    }
    
    // MARK: - Transaction
    func fetchTransactions() -> [Transaction] {
        guard var arrayResult = database?.objects(Transaction.self) else {
            return [Transaction]()
        }
        arrayResult = arrayResult.sorted(byKeyPath: "date", ascending: false)
        return Array(arrayResult)
    }
    
    // MARK: - Category
    func fetchCategory(from identify: String) -> Category {
        let result = database.objects(Category.self).filter("identify == %@", identify)
        guard let category = result.first else {
            return Category()
        }
        return category
    }
    
    func fetchCategorys() -> [Category] {
        guard let arrayResult = database?.objects(Category.self),
            arrayResult.isEmpty != true else {
            setupCategoryData()
            return fetchCategorys()
        }
        return Array(arrayResult)
    }
    
    func setupCategoryData() {
        saveCategoryToRealm(from: "ExpenseArray", type: "expendsed")
        saveCategoryToRealm(from: "RevenueArray", type: "income")
    }
    
    private func saveCategoryToRealm(from name: String, type: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist"),
            let categoryDictionary = NSDictionary(contentsOfFile: path) else { return }
        categoryDictionary.forEach {
            let categoryImage = $0.key as? String ?? ""
            let categoryName = $0.value as? String ?? ""
            let category = Category(image: categoryImage, name: categoryName, transactionType: type)
            self.save(category)
        }
    }
    
}
