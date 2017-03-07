//
//  MailboxItemView.swift
//  app
//
//  Created by Samson on 2017-03-03.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit

class MailboxItemView: UIView {

    @IBOutlet weak var textView: UILabel!

    func setTextAndUpdateVisibility(_ text: String?) {
        self.textView.text = text
        self.isHidden = text == nil
    }
}
