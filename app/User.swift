//
//  User.swift
//  Semaphore
//
//  Created by Samson on 2017-02-15.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit

class User: NSObject {
    let userId: String
    let firstName: String?
    let lastName: String?
    let mailboxes: NSDictionary?
    
    init(userId: String, firstName: String = "", lastName: String = "", mailboxes: NSDictionary?) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.mailboxes = mailboxes;
    }

    init(_ dictionary: NSDictionary) {
        self.userId = dictionary[Constants.userIdKey] as! String
        self.firstName = dictionary[Constants.userFirstNameKey] as? String
        self.lastName = dictionary[Constants.userLastNameKey] as? String
        self.mailboxes = dictionary[Constants.userMailboxesKey] as? NSDictionary
    }
}
