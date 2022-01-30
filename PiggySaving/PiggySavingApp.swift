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
                    ChooseSourceView(configs: $configStore.configs) {
                        Task {
                            do {
                                try await ConfigStore.save(configs: configStore.configs)
                            } catch {
                                errorWrapper = ErrorWrapper(error: error,
                                                            customErrorType: CustomErrorType.configSavingFailed,
                                                            guidance: "Saving configuration failed. The Initialization did not completed successuflly. Please start over.")
                            }
                        }
                    }
                } else {
                    MainView(configs: configStore)
                }
            }
            .task {
                do {
                    configStore.configs = try await ConfigStore.load()
                } catch  {
                    errorWrapper = ErrorWrapper(error: error,
                                                customErrorType: CustomErrorType.configLoadingFailed,
                                                guidance: "Config loading failed.")
                }
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
