//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  SemaphoreDatabase.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
//

import SQLite


class SemaphoreDatabase {

    static let mailboxes = Table(Constants.tableMailboxes)
    static let deliveries = Table(Constants.tableDeliveries)

    static let mailboxId = Expression<String>(Constants.columnMailboxId)
    static let mailboxName = Expression<String>(Constants.columnMailboxName)
    static let timestamp = Expression<Int64>(Constants.columnTimestamp)
    static let letters = Expression<Int64>(Constants.columnLetters)
    static let magazines = Expression<Int64>(Constants.columnMagazines)
    static let newspapers = Expression<Int64>(Constants.columnNewspapers)
    static let parcels = Expression<Int64>(Constants.columnParcels)

    private static let deliveryQuery = "SELECT timestamp, SUM(letters), SUM(magazines), SUM(newspapers), SUM(parcels) FROM deliveries WHERE mailbox_id='%@' AND timestamp >= %@ AND NOT (letters = 0 AND magazines = 0 and newspapers = 0 and parcels = 0) GROUP BY date(timestamp, 'unixepoch', 'localtime') ORDER BY timestamp DESC;"

    static func create() {
        let db = getDatabaseConnection()

        try! db.run(self.mailboxes.create(ifNotExists: true) { t in
            t.column(self.mailboxId, primaryKey: true)
            t.column(self.mailboxName)
        })

        try! db.run(self.deliveries.create(ifNotExists: true) { t in
            t.column(self.mailboxId)
            t.column(self.timestamp)
            t.column(self.letters, defaultValue: 0)
            t.column(self.magazines, defaultValue: 0)
            t.column(self.newspapers, defaultValue: 0)
            t.column(self.parcels, defaultValue: 0)
            t.primaryKey(self.mailboxId, self.timestamp)
        })
    }

    static func queryMailboxes() -> [Mailbox] {
        let db = getDatabaseConnection()

        var mailboxList: [Mailbox] = []
        for cursor in try! db.prepare(self.mailboxes) {
            mailboxList.append(Mailbox(mailboxId: cursor[self.mailboxId],
                                       name: cursor[self.mailboxName]))
        }

        return mailboxList
    }

    static func insertMailbox(_ mailbox: Mailbox){
        let db = getDatabaseConnection()
        let insert = self.mailboxes.insert(or: .ignore,
                                           self.mailboxId <- mailbox.mailboxId,
                                           self.mailboxName <- mailbox.name)
        try! db.run(insert)
    }

    static func queryDeliveries(_ mailboxId: String) -> [Delivery] {
        let db = getDatabaseConnection()
        var deliveries: [Delivery] = []

        let date = Calendar.current.date(byAdding: .day, value: -30, to: Date())

        let query = String(format:deliveryQuery, mailboxId, date!.timestamp)
        for cursor in try! db.prepare(query) {
            deliveries.append(Delivery(timestamp: cursor[0] as! Int64,
                                       letters: cursor[1] as! Int64,
                                       magazines: cursor[2] as! Int64,
                                       newspapers: cursor[3] as! Int64,
                                       parcels: cursor[4] as! Int64))
        }

        return deliveries
    }


    static func queryDeliveriesV2(_ mailboxId: String) -> [Delivery] {
        let db = getDatabaseConnection()
        let letterSum = self.letters.sum
        let magazineSum = self.magazines.sum
        let newspaperSum = self.newspapers.sum
        let parcelSum = self.parcels.sum

        var deliveryList: [Delivery] = []

        let query = self.deliveries.select(self.timestamp, letterSum, magazineSum, newspaperSum, parcelSum)
            .where(self.mailboxId == mailboxId)
            .order(self.timestamp.desc)
            .group(Expression<Date>(self.timestamp))

        for cursor in try! db.prepare(query) {
            let delivery = Delivery(timestamp: cursor[self.timestamp],
                                    letters: cursor[letterSum] ?? 0,
                                    magazines: cursor[magazineSum] ?? 0,
                                    newspapers: cursor[newspaperSum] ?? 0,
                                    parcels: cursor[parcelSum] ?? 0)

            if (delivery.total > 0) {
                deliveryList.append(delivery)
            }
        }

        return deliveryList
    }

    static func insertDelivery(mailboxId: String, delivery: Delivery) {
        let db = getDatabaseConnection()
        let insert = self.deliveries.insert(or: .ignore,
                                            self.mailboxId <- mailboxId,
                                            self.timestamp <- delivery.timestamp,
                                            self.letters <- delivery.letters,
                                            self.magazines <- delivery.magazines,
                                            self.newspapers <- delivery.newspapers,
                                            self.parcels <- delivery.parcels)
        try! db.run(insert)
    }


    private static func getDatabaseConnection() -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return try! Connection("\(path)/\(Constants.database)")
    }
}
