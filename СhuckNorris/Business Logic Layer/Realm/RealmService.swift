//
//  RealmService.swift
//  СhuckNorris
//
//  Created by Matsulenko on 12.09.2023.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func realmConfiguration() -> Realm
    func saveQuote(_ quote: Quote)
    func saveCategory(_ quoteCategory: Category)
    func fetchQuotes() -> Results<QuoteObject>
    func fetchCategories() -> Results<QuoteCategory>
}

final class RealmService: RealmServiceProtocol {
    
    static let shared: RealmService = {
        let instance = RealmService()
        
        return instance
    }()
    
    private func getKey() -> Data {
        // Взято отсюда: https://www.mongodb.com/docs/realm/sdk/swift/realm-files/encrypt-a-realm/
        
        // Identifier for our keychain entry - should be unique for your application
        let keychainIdentifier = "io.Realm.EncryptionExampleKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            // swiftlint:disable:next force_cast
            return dataTypeRef as! Data
        }
        // No pre-existing key from this application, so generate a new one
        // Generate a random encryption key
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        return key
    }
    
    func realmConfiguration() -> Realm {
        let config = Realm.Configuration(encryptionKey: getKey())
        
        do {
            let realm = try Realm(configuration: config)
            
            return realm
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func saveQuote(_ quote: Quote) {
        let realm = realmConfiguration()
        let handler: () -> Void = {
            realm.create(QuoteObject.self, value: quote.keyedValues, update: .modified)
        }
        
        if realm.isInWriteTransaction {
            handler()
            print("isInWriteTransaction")
        } else {
            do {
                try realm.write {
                    handler()
                    print("✅written")
                }
            } catch {
                fatalError()
            }
        }
        
        for i in quote.categories {
            saveCategory(Category(quoteCategory: i))
        }
    }
    
    func saveCategory(_ quoteCategory: Category) {
        let realm = realmConfiguration()
        let handler: () -> Void = {
            realm.create(QuoteCategory.self, value: quoteCategory.keyedValues, update: .modified)
        }
        
        if realm.isInWriteTransaction {
            handler()
            print("isInWriteTransaction")
        } else {
            do {
                try realm.write {
                    handler()
                    print("✅category is added")
                }
            } catch {
                fatalError()
            }
        }
    }
    
    //настроить шифрование
    // внедрить шифрование
    func fetchQuotes() -> Results<QuoteObject> {
        let realm = realmConfiguration()
        let objects = realm.objects(QuoteObject.self).sorted(byKeyPath: "downloadedAt", ascending: false)
        
        return objects
    }
    
    func fetchCategories() -> Results<QuoteCategory> {
        let realm = realmConfiguration()
        let objects = realm.objects(QuoteCategory.self).sorted(byKeyPath: "name")
        
        return objects
    }
}
