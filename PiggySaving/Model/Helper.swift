//
//  Helper.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 01/02/2022.
//

import Foundation
import SwiftUI

let SCREEN_SIZE: CGRect = UIScreen.main.bounds

let CURRENCY_SYMBOL: String = NSLocale.current.currencySymbol!

extension Calendar {
     func numberOfDaysBetweenExclStartingDate(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}

struct Fonts {
    static var TITLE_SEMIBOLD: Font {
        return Font.custom("PingFangSC-Semibold", size: 34)
    }
    
    static var BODY_CHINESE_NORMAL: Font {
        return Font.custom("PingFangSC-Regular", size: 16)
    }
    
    static var CAPTION: Font {
        return Font.custom("PingFangSC-Regular", size: 11)
    }
}
