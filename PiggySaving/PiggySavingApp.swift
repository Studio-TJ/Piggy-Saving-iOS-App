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
            NavigationView {
                if (configStore.configs.isInitialized == false) {
                    ChooseSourceView(configs: configStore)
                } else {
                    MainView(configs: configStore)
                }
            }
            .environment(\.managedObjectContext, configStore.container.viewContext)
            .onChange(of: configStore.configs.hasChanges) { configs in
                configStore.updateConfig()
            }
            .sheet(item: $errorWrapper, onDismiss: {
                switch errorWrapper?.customErrorType {
                case .configSavingFailed:
                    configStore.resetConfig()
                    break
                case .configLoadingFailed:
                    break
                case .none:
                    break
                }
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
        }
    }
}
