//
//  GoalSettingView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingView: View {
    @ObservedObject var configs: Configs
    
    var body: some View {
        VStack {
            HStack {
                Text("Set your Goal")
                    .font(Fonts.TITLE_SEMIBOLD)
                    .padding(.top, 50)
                Spacer(minLength: 35)
            }
            GoalSettingSetMinimalUnitView(configs: configs)
                .padding(.top, 50)
            GoalSettingSetEndDateView(configs: configs)
            Divider()
            GoalSettingResultView(configs: configs)
            Spacer()
        }
        .frame(width: SCREEN_SIZE.width * 0.86)
    }
}

struct GoalSettingView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore()
        GoalSettingView(configs: configConst.configs)
    }
}
