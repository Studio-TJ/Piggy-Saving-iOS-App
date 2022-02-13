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
                SettingTabView()
                    .environmentObject(configStore)
                    .environment(\.managedObjectContext, configStore.container.viewContext)
                
            } else {
                MainView(configs: configStore)
                    .environment(\.managedObjectContext, configStore.container.viewContext)
            }
        }
    }
}
