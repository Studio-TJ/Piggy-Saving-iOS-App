//
//  Data.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import Foundation
import SwiftUI

struct LastAmountDetail: Codable {
    var amount: Double
    var saved: Int
    
    init() {
        amount = 0
        saved = 0
    }
}

struct LastAmount: Codable {
    var last: LastAmountDetail
    
    init() {
        last = LastAmountDetail()
    }
}

struct Sum: Codable {
    var sum: Double
    
    init() {
        sum = 0
    }
}
