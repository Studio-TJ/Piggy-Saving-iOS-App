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
            if (configStore.configs.isInitialized == false) {
                ChooseSourceView(configs: configStore)
            } else {
                MainView(configs: configStore)
            }
        }
        .onChange(of: configStore.configs.hasChanges) { configs in
            configStore.updateConfig()
        }
    }
}
