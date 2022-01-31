//
//  Data.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import Foundation
import SwiftUI

struct LastSavingAmount: Codable {
    var amount: Double
    var saved: Int
    
    init() {
        self.amount = 0
        self.saved = 0
    }
}

struct Sum: Codable {
    var sum: Double
    
    init() {
        self.sum = 0
    }
}


struct Saving: Codable, Identifiable {
    let id = UUID().uuidString
    var date: String
    var amount: Double
    var saved: Int
    
    var isSaved: Bool {
        return saved == 1 ? true : false
    }
    
    enum CodingKeys: CodingKey {
        case date
        case amount
        case saved
    }
    
    var dateFormatted: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self.date) ?? Date()
    }
    
    init() {
        self.date = "2000-01-01"
        self.amount = 1
        self.saved = 1
    }
}
