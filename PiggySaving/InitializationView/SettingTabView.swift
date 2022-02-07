//
//  SettingTabView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct SettingTabView: View {
    @ObservedObject var configs: ConfigStore
    
    var body: some View {
        TabView {
            WelcomePage()
            GoalSettingView(configs: configs)
            DataStorageView()
            NotificationView()
            DoneSettingView()
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore(currency: "CNY")
        SettingTabView(configs: configConst)
    }
}
