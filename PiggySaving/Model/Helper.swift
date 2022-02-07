//
//  Helper.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 01/02/2022.
//

import Foundation
import SwiftUI

enum Currency: Int32, Identifiable, CaseIterable {
    case chineseYuan = 1
    case euro = 2
    case usDollar = 3
    
    case undefined = 0
    
    var id: Int32 { self.rawValue }
    
    var displayName: String {
        switch self {
        case.chineseYuan:
            return NSLocalizedString("Chinese Yuan", comment: "Chinese Yuan")
        case.euro:
            return NSLocalizedString("Euro", comment: "Euro")
        case.usDollar:
            return NSLocalizedString("US Dollar", comment: "US Dollar")
            
        default:
            return NSLocalizedString("Undefined", comment: "Undefined")
        }
    }
    
    var currencyUnit: String {
        switch self {
        case.chineseYuan:
            return NSLocalizedString("Yuan", comment: "Chinese Yuan unit")
        case.euro:
            return NSLocalizedString("Euro", comment: "Euro unit")
        case.usDollar:
            return NSLocalizedString("Dollar", comment: "US Dollar unit")
            
        default:
            return NSLocalizedString("Undefined", comment: "Undefined")
        }
    }
}

let SCREEN_SIZE: CGRect = UIScreen.main.bounds

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
