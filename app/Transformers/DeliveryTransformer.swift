//
//  DeliveryTransformer.swift
//  app
//
//  Created by Samson on 2017-03-03.
//  Copyright © 2017 Samson. All rights reserved.
//

import UIKit

class DeliveryTransformer {

    static let formatter = DateFormatter()

    static func toViewModel(_ delivery: Delivery?, position: Int) -> DeliveryViewModel {
        let viewModel = DeliveryViewModel()

        guard let delivery = delivery else {
            viewModel.totalItems = 0
            return viewModel
        }
        formatter.dateFormat = "MMM dd"

        if delivery.letters > 0 {
            viewModel.letterText = String.localizedStringWithFormat(NSLocalizedString("letters_text", comment: ""), delivery.letters)
        }
        if delivery.magazines > 0 {
            viewModel.magazineText = String.localizedStringWithFormat(NSLocalizedString("magazines_text", comment: ""), delivery.magazines)
        }
        if delivery.newspapers > 0 {
            viewModel.newspaperText = String.localizedStringWithFormat(NSLocalizedString("newspapers_text", comment: ""), delivery.newspapers)
        }
        if delivery.parcels > 0 {
            viewModel.parcelText = String.localizedStringWithFormat(NSLocalizedString("parcels_text", comment: ""), delivery.parcels)
        }

        viewModel.totalItems = delivery.total
        viewModel.isCategorising = delivery.categorising

        viewModel.amountText = String.localizedStringWithFormat(NSLocalizedString("amount_text", comment: ""), delivery.total)
        viewModel.dateText = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(delivery.timestamp)))

        if position == 0 {
            viewModel.timelineImage = #imageLiteral(resourceName: "ic_timeline_cap")
        } else {
            viewModel.timelineImage = #imageLiteral(resourceName: "ic_timeline")
        }
        
        return viewModel
    }

}
