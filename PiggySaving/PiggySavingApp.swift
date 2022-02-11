//
//  PiggySavingApp.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import SwiftUI

@main
struct PiggySavingApp: App {
    @StateObject private var configStore = ConfigStore()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some Scene {
        WindowGroup {
            if (configStore.configs.isInitialized == false || configStore.configs.usingExternalURL == false) {
//                ChooseSourceView(configs: configStore)
                SettingTabView(configs: configStore)
            } else {
                MainView(configs: configStore)
            }
//            SettingTabView(configs: configStore)
        }
        .onChange(of: configStore.configs.isInitialized) { value in
            print(value)
        }
//        .onChange(of: configStore.configs.hasChanges) { configs in
//            print(configs)
//            configStore.updateConfig()
//        }
    }
}
