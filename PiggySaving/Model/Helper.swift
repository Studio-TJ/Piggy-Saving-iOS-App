//
//  Helper.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 01/02/2022.
//

import Foundation
import SwiftUI

let APP_VERSION: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
let APP_BUILD_NUMBER: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
let VERSION_STRING: String = "Piggy Saving " + "v" + APP_VERSION + " (" + APP_BUILD_NUMBER + ")"

var SCREEN_SIZE: CGRect {
    UIScreen.main.bounds
}

var CURRENCY_SYMBOL: String {
    NSLocale.current.currencySymbol!
}

class States: ObservableObject {
    @Published var savingDataChanged: Bool = false
    @Published var mainViewSelection = MainTabItem.SAVINTS_LIST
}

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}

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

private struct PreviewKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isPreview: Bool {
        get { self[PreviewKey.self] }
        set { self[PreviewKey.self] = newValue }
    }
}
