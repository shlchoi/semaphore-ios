//
//  TimeInterval.swift
//  Semaphore
//
//  Created by Samson on 2017-02-19.
//  Copyright © 2017 Samson. All rights reserved.
//

import Foundation

extension Date {
    var timestamp: String {
        return String(format: "%d", Int64(timeIntervalSince1970))
    }
}
