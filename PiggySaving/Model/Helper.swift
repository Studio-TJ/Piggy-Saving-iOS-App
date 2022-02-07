//
//  Helper.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 01/02/2022.
//

import Foundation
import SwiftUI

struct Moneys {
    let currencys = Locale.isoCurrencyCodes
    
}

let SCREEN_SIZE: CGRect = UIScreen.main.bounds

let CURRENCIES = NSLocale.commonISOCurrencyCodes

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
