//
//  GoalSettingResultView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingResultView: View {
    @ObservedObject var configs: ConfigStore
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct GoalSettingResultView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore(currency: "CNY")
        GoalSettingResultView(configs: configConst)
    }
}
