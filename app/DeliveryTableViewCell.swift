//
//  DeliveryTableViewCell.swift
//  Semaphore
//
//  Created by Samson on 2017-03-02.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit

class DeliveryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var amountText: UILabel!
    @IBOutlet weak var timelineImageView: UIImageView!
    @IBOutlet weak var expandIcon: UIImageView!

    @IBOutlet weak var expandedView: UIView!

    @IBOutlet weak var letterView: MailboxItemView!
    @IBOutlet weak var magazineView: MailboxItemView!
    @IBOutlet weak var newspaperView: MailboxItemView!
    @IBOutlet weak var parcelView: MailboxItemView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func reset() {
        letterView.setTextAndUpdateVisibility(nil)
        magazineView.setTextAndUpdateVisibility(nil)
        newspaperView.setTextAndUpdateVisibility(nil)
        parcelView.setTextAndUpdateVisibility(nil)

        dateText.text = nil
        amountText.text = nil
        timelineImageView.image = nil
        expandedView.isHidden = true
    }

    func expand() {
        expandedView.isHidden = false
        expandIcon.image = #imageLiteral(resourceName: "ic_collapse")
    }

    func collapse() {
        expandedView.isHidden = true
        expandIcon.image = #imageLiteral(resourceName: "ic_expand")
    }
}
