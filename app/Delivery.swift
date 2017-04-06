//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  Delivery.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
//

import UIKit

open class Delivery: NSObject {

    let timestamp: Int64
    let letters: Int64
    let magazines: Int64
    let newspapers: Int64
    let parcels: Int64
    let categorising: Bool
    
    var total: Int64 {
        return letters + magazines + newspapers + parcels
    }

    init(timestamp: Int64, letters: Int64 = 0, magazines: Int64 = 0, newspapers: Int64 = 0, parcels: Int64 = 0, categorising: Bool = false) {
        self.timestamp = timestamp
        self.letters = letters
        self.magazines = magazines
        self.newspapers = newspapers
        self.parcels = parcels
        self.categorising = categorising
    }
    
    init(_ dictionary: NSDictionary) {
        self.timestamp = dictionary[Constants.deliveryTimestampKey] as? Int64 ?? 0
        self.letters = dictionary[Constants.deliveryLettersKey] as? Int64 ?? 0
        self.magazines = dictionary[Constants.deliveryMagazinesKey] as? Int64 ?? 0
        self.newspapers = dictionary[Constants.deliveryNewspapersKey] as? Int64 ?? 0
        self.parcels = dictionary[Constants.deliveryParcelsKey] as? Int64 ?? 0
        self.categorising = dictionary[Constants.deliveryCategorisingKey] as? Bool ?? false
    }

    func toDictionary() -> Dictionary<String, Any> {
        var dictionary = [String: Any]()
        dictionary.updateValue(timestamp, forKey: Constants.deliveryTimestampKey)
        dictionary.updateValue(letters, forKey: Constants.deliveryLettersKey)
        dictionary.updateValue(magazines, forKey: Constants.deliveryMagazinesKey)
        dictionary.updateValue(newspapers, forKey: Constants.deliveryNewspapersKey)
        dictionary.updateValue(parcels, forKey: Constants.deliveryParcelsKey)
        dictionary.updateValue(categorising, forKey: Constants.deliveryCategorisingKey)

        return dictionary
    }
}
