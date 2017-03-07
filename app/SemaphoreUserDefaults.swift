//
//  SemaphoreUserDefaults.swift
//  Semaphore
//
//  Created by Samson on 2017-02-17.
//  Copyright © 2017 Samson. All rights reserved.
//

import Foundation

class SemaphoreUserDefaults {
    private static let lastMailboxKey = "lastMailboxId"
    private static let mailboxListKey = "mailboxList"
    private static let mailboxNameMapKey = "mailboxNameMap"
    private static let lastDeliveryTimeKey = "%@_lastDelivery"

    static func getLastMailbox() -> String? {
        let preferences = UserDefaults.standard
        return preferences.string(forKey: lastMailboxKey)
    }

    static func saveLastMailbox(_ mailboxId: String) {
        let preferences = UserDefaults.standard
        preferences.set(mailboxId, forKey: lastMailboxKey)

        preferences.synchronize()
    }

    static func getMailboxList() -> [String] {
        let preferences = UserDefaults.standard
        let mailboxes = preferences.stringArray(forKey: mailboxListKey)
        if let mailboxIds = mailboxes {
            return mailboxIds
        } else {
            return [String]()
        }
    }

    static func getMailboxName(_ mailboxId: String) -> String? {
        let preferences = UserDefaults.standard
        guard let dictionary = preferences.dictionary(forKey: mailboxNameMapKey) else { return nil }

        return dictionary[mailboxId] as? String ?? nil
    }

    static func saveMailboxList(_ mailboxes:[Mailbox]) {
        let preferences = UserDefaults.standard
        var mailboxIds = [String]()
        var dictionary = [String: String]()
        for (mailbox) in mailboxes {
            mailboxIds.append(mailbox.mailboxId)
            dictionary.updateValue(mailbox.name, forKey: mailbox.mailboxId)
        }
        preferences.set(mailboxIds, forKey: mailboxListKey)
        preferences.set(dictionary, forKey: mailboxNameMapKey)
        preferences.synchronize()
    }

    static func getLastDeliveryTime(_ mailboxId: String) -> Int64 {
        let preferences = UserDefaults.standard
        return Int64(preferences.integer(forKey: String(format: lastDeliveryTimeKey, arguments: [mailboxId])))
    }

    static func saveLastDeliveryTime(_ mailboxId: String, timestamp: Int64) {
        let preferences = UserDefaults.standard
        preferences.set(timestamp, forKey: String(format: lastDeliveryTimeKey, arguments: [mailboxId]))

        preferences.synchronize()
    }

    static func getSnapshot(_ mailboxId:String) -> Delivery? {
        let preferences = UserDefaults.standard
        guard let dictionary = preferences.dictionary(forKey: mailboxId) else { return nil }

        return Delivery.init(dictionary as NSDictionary)
    }

    static func saveSnapshot(_ mailboxId: String, snapshot: Delivery) {
        let preferences = UserDefaults.standard
        preferences.set(snapshot.toDictionary(), forKey: mailboxId)

        preferences.synchronize()
    }
}
