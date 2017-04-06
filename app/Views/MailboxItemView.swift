//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  MailboxItemView.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
//

import UIKit

class MailboxItemView: UIView {

    @IBOutlet weak var textView: UILabel!

    func setTextAndUpdateVisibility(_ text: String?) {
        self.textView.text = text
        self.isHidden = text == nil
    }
}
