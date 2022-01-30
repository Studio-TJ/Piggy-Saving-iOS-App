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
        self.amount = 0
        self.saved = 0
    }
}

struct LastAmount: Codable {
    var last: LastAmountDetail
    
    init() {
        self.last = LastAmountDetail()
    }
}

struct Sum: Codable {
    var sum: Double
    
    init() {
        self.sum = 0
    }
}

struct AllSaving: Codable {
    var date: String
    var amount: Double
    var saved: Int
    
    init() {
        self.date = ""
        self.amount = 0
        self.saved = 0
    }
}
