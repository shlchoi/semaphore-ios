//
//  DeliveryViewModel.swift
//  Semaphore
//
//  Created by Samson on 2017-03-03.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit

class DeliveryViewModel: NSObject {

    var letterText: String?
    var magazineText: String?
    var newspaperText: String?
    var parcelText: String?
    var totalItems: Int64?
    var isCategorising: Bool?

    var dateText: String?
    var amountText: String?
    var timelineImage: UIImage?

    func bind(_ cell: DeliveryTableViewCell) {
        cell.letterView.setTextAndUpdateVisibility(self.letterText)
        cell.magazineView.setTextAndUpdateVisibility(self.magazineText)
        cell.newspaperView.setTextAndUpdateVisibility(self.newspaperText)
        cell.parcelView.setTextAndUpdateVisibility(self.parcelText)

        cell.dateText.text = self.dateText
        cell.amountText.text = self.amountText
        cell.timelineImageView.image = self.timelineImage
    }

    func bind(currentView: MailboxStackView) {
        currentView.letterView.setTextAndUpdateVisibility(self.letterText)
        currentView.magazineView.setTextAndUpdateVisibility(self.magazineText)
        currentView.newspaperView.setTextAndUpdateVisibility(self.newspaperText)
        currentView.parcelView.setTextAndUpdateVisibility(self.parcelText)

        currentView.categorisingMailboxView.isHidden = !self.isCategorising!
        currentView.emptyMailboxText.isHidden = self.isCategorising! || self.totalItems! > 0

    }

}
