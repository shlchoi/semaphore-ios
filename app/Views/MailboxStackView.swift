//
//  Semaphore - iOS
//  iOS application accompanying Semaphore
//  See https://shlchoi.github.io/semaphore/ for more information about Semaphore
//
//  MailboxStackView.swift
//  Copyright © 2017 Samson H. Choi
//
//  See https://github.com/shlchoi/semaphore-ios/blob/master/LICENSE for license information
//
import UIKit

class MailboxStackView: UIStackView {

    @IBOutlet weak var letterView: MailboxItemView!
    @IBOutlet weak var magazineView: MailboxItemView!
    @IBOutlet weak var newspaperView: MailboxItemView!
    @IBOutlet weak var parcelView: MailboxItemView!

    @IBOutlet weak var emptyMailboxText: UILabel!
    @IBOutlet weak var categorisingMailboxView: UIView!
}
