//
//  Quote.swift
//  СhuckNorris
//
//  Created by Matsulenko on 09.09.2023.
//

import Foundation

struct Quote: Decodable {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter
    }()
    
    var categories: [String]
    let createdAt: String
    let iconUrl: String
    let id: String
    let updatedAt: String
    let url: String
    let value: String
    let downloadedAt: Date
    
    var downloadedAtInString: String {
        Self.dateFormatter.string(from: downloadedAt)
    }
    
    var keyedValues: [String: Any] {
        [
            "id": id,
            "value": value,
            "downloadedAt": downloadedAtInString,
            "categories": categories
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case categories
        case createdAt = "created_at"
        case iconUrl = "icon_url"
        case id
        case updatedAt = "updated_at"
        case url
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.categories = try container.decode([String].self, forKey: .categories)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.iconUrl = try container.decode(String.self, forKey: .iconUrl)
        self.id = try container.decode(String.self, forKey: .id)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.url = try container.decode(String.self, forKey: .url)
        self.value = try container.decode(String.self, forKey: .value)
        self.downloadedAt = Date()
    }
    
    init(quoteObject: QuoteObject) {
        id = quoteObject.id
        value = quoteObject.value
        createdAt = ""
        categories = []
        iconUrl = ""
        updatedAt = ""
        url = ""
        for i in quoteObject.categories {
            categories.append(i)
        }
        downloadedAt = Self.dateFormatter.date(from: quoteObject.downloadedAt) ?? Date()
    }
}
