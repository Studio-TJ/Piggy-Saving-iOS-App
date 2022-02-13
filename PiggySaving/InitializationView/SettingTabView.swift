//
//  SettingTabView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct SettingTabView: View {
    @State var selected: InitializationTabItem = .WELCOME
 
    var body: some View {
        TabView(selection: $selected) {
            WelcomePage(selectedItem: $selected).tag(InitializationTabItem.WELCOME)
            GoalSettingView(selectedItem: $selected).tag(InitializationTabItem.GOAL_SETTINGS)
            DataStorageView(selectedItem: $selected).tag(InitializationTabItem.DATA_STORAGE)
            NotificationView(selectedItem: $selected).tag(InitializationTabItem.NOTIFICATION)
            DoneSettingView(selectedItem: $selected).tag(InitializationTabItem.DONE_SETTING)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

enum InitializationTabItem: Int, Codable {
    case WELCOME
    case GOAL_SETTINGS
    case DATA_STORAGE
    case NOTIFICATION
    case DONE_SETTING
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView()
    }
}
