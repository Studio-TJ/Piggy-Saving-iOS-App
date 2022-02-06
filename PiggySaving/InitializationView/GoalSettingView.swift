//
//  GoalSettingView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingView: View {
    @ObservedObject var configs: ConfigStore
    
    var body: some View {
        VStack {
            HStack {
                Text("Set your Goal")
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer(minLength: 35)
            }
            GoalSettingSetCurrencyView(configs: configs)
            if configs.configs.currency != Currency.undefined.rawValue {
                GoalSettingSetMinimalUnitView(configs: configs)
                .padding(.top, 50)
            }
            GoalSettingSetEndDateView(configs: configs)
            Divider()
            if configs.configs.minimalUnit != 0 && configs.configs.endDate != nil {
                GoalSettingResultView(configs: configs)
            }
            Spacer()
        }
        .frame(width: SCREEN_SIZE.width * 0.86)
    }
}

struct GoalSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore(currency: Currency.chineseYuan.rawValue)
        GoalSettingView(configs: configConst)
    }
}
