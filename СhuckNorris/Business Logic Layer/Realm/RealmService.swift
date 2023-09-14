//
//  RealmService.swift
//  СhuckNorris
//
//  Created by Matsulenko on 12.09.2023.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func saveQuote(_ quote: Quote)
    func saveCategory(_ quoteCategory: Category)
    func fetchQuote()
}

final class RealmService: RealmServiceProtocol {
    func saveQuote(_ quote: Quote) {
        do {
            let realm = try Realm()
            let handler: () -> Void = {
                realm.create(QuoteObject.self, value: quote.keyedValues, update: .modified)
            }
            
            if realm.isInWriteTransaction {
                handler()
                print("isInWriteTransaction")
            } else {
                try realm.write {
                    handler()
                    print("✅written")
                }
            }
        } catch {
            fatalError()
        }
        
        for i in quote.categories {
            saveCategory(Category(quoteCategory: i))
        }
    }
    
    func saveCategory(_ quoteCategory: Category) {
        do {
            let realm = try Realm()
            
            let handler: () -> Void = {
                realm.create(QuoteCategory.self, value: quoteCategory.keyedValues, update: .modified)
            }
            
            if realm.isInWriteTransaction {
                handler()
                print("isInWriteTransaction")
            } else {
                try realm.write {
                    handler()
                    print("✅category is added")
                }
            }
        } catch {
            fatalError()
        }
    }
    
    func fetchQuote() {
        
    }
    
    
}
