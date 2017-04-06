//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  Mailbox.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
//

import UIKit

class Mailbox: NSObject {
    let mailboxId: String
    let name: String

    init(mailboxId: String, name: String) {
        self.mailboxId = mailboxId
        self.name = name
    }

    init(_ dictionary: NSDictionary) {
        self.mailboxId = dictionary[Constants.mailboxIdKey] as! String
        self.name = dictionary[Constants.mailboxNameKey] as! String
    }
}
