//
//  GoalSettingResultView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingResultView: View {
    @ObservedObject var configs: ConfigStore
    
    var maximalDayValue: Double {
        Double(Calendar.current.numberOfDaysBetweenExclStartingDate(Date(), and: configs.configs.endDate!)) * configs.configs.minimalUnit
    }
    
    var sumAfterEndDate: Double {
        ((configs.configs.minimalUnit + maximalDayValue) * Double(Calendar.current.numberOfDaysBetweenExclStartingDate(Date(), and: configs.configs.endDate!))) / 2
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Everyday you need to save between")
                    .font(Fonts.BODY_CHINESE_NORMAL)
                Spacer()
            }
            HStack {
                Spacer(minLength: SCREEN_SIZE.width * 0.1)
                Text(CURRENCY_SYMBOL
                     + String(configs.configs.minimalUnit)
                     + " ~ "
                     + CURRENCY_SYMBOL
                     + String(format: "%.2f", maximalDayValue))
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer()
            }
            HStack {
                Text("Till the end date you will have")
                    .font(Fonts.BODY_CHINESE_NORMAL)
                Spacer()
            }
            .padding(.top, SCREEN_SIZE.height * 0.02)
            HStack {
                Spacer(minLength: SCREEN_SIZE.width * 0.1)
                Text(CURRENCY_SYMBOL
                     + String(format: "%.2f", sumAfterEndDate))
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer()
            }
        }
    }
}

struct GoalSettingResultView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore(placeholder: true)
        GoalSettingResultView(configs: configConst)
            .previewLayout(.sizeThatFits)
    }
}
