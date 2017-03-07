//
//  MailboxView.swift
//  Semaphore
//
//  Created by Samson on 2017-03-03.
//  Copyright © 2017 Samson. All rights reserved.
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
