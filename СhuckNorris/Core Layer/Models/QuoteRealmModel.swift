//
//  QuoteRealmModel.swift
//  СhuckNorris
//
//  Created by Matsulenko on 12.09.2023.
//

import Foundation
import RealmSwift

final class QuoteObject: Object {
    @Persisted var id: String
    @Persisted var value: String
    @Persisted var downloadedAt: String
    @Persisted var categories = List<String>()
    
    override class func primaryKey() -> String? {
        "id"
    }
    
    convenience init(quote: Quote) {
        self.init()
        id = quote.id
        value = quote.value
        downloadedAt = quote.downloadedAtInString
        for i in quote.categories {
            categories.append(i)
        }
    }
}

final class QuoteCategory: Object {
    @Persisted var name: String = ""
    
    override class func primaryKey() -> String? {
        "name"
    }
    
    convenience init(category: Category) {
        self.init()
        name = category.name
    }
}
