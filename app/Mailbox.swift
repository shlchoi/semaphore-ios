//
//  Mailbox.swift
//  Semaphore
//
//  Created by Samson on 2017-02-19.
//  Copyright © 2017 Samson. All rights reserved.
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
