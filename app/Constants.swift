//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  Constants.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
//

import Foundation

struct Constants {

    static let userIdKey = "userId"
    static let userFirstNameKey = "firstName"
    static let userLastNameKey = "lastName"
    static let userMailboxesKey = "mailboxes"

    static let mailboxIdKey = "mailboxId"
    static let mailboxNameKey = "name"

    static let deliveryTimestampKey = "timestamp"
    static let deliveryLettersKey = "letters"
    static let deliveryMagazinesKey = "magazines"
    static let deliveryNewspapersKey = "newspapers"
    static let deliveryParcelsKey = "parcels"
    static let deliveryCategorisingKey = "categorising"

    static let database = "semaphore.sqlite3"

    static let tableDeliveries = "deliveries"
    static let tableMailboxes = "mailboxes"

    static let columnMailboxId = "mailbox_id"
    static let columnMailboxName = "name"
    static let columnTimestamp = "timestamp"
    static let columnLetters = "letters"
    static let columnMagazines = "magazines"
    static let columnNewspapers = "newspapers"
    static let columnParcels = "parcels"

    static let deliveriesGroupBy = "date(timestamp, 'unixepoch', 'localtime')"
}
