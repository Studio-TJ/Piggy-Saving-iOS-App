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
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if (configStore.isInitialized == false) {
                    ChooseSourceView(isInitialized: $configStore.isInitialized, usingExternalURL: $configStore.usingExternalURL, externalURL: $configStore.externalURL)
                } else {
                    MainSavingView(configs: configStore)
                }
            }
        }
    }
}
