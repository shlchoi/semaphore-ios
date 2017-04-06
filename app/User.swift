//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  User.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
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
