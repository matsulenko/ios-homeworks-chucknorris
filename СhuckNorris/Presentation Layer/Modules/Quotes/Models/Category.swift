//
//  Category.swift
//  СhuckNorris
//
//  Created by Matsulenko on 13.09.2023.
//

import Foundation

struct Category {
    let name: String
    
    var keyedValues: [String: Any] {
        [
            "name": name,
        ]
    }
    
    init(quoteCategory: String) {
        name = quoteCategory
    }
}
