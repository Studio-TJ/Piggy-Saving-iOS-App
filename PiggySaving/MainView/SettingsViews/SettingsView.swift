//
//  SettingsView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    
    @ObservedObject var configs: ConfigStore = ConfigStore()
    @State private var resetAppConfirmation: Bool = false
    @State private var toReset: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                SettingsRunningModeView(usingExternalURL: configs.configs.usingExternalURL, externalURL: configs.configs.externalURL)
                SettingsViewOperationView()
                HStack {
                    Spacer()
                    Button(action: {
                        resetAppConfirmation = true
                    },
                           label: {
                        Text("Reset App!")
                            .foregroundColor(Color.red)
                    })
                    Spacer()
                }
                SettingsViewFooterInfoView()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .padding(.top, 20)
            .onChange(of: configs.configs.ableToWithdraw) { value in
                configs.finishInitialConfiguration()
            }
            .sheet(isPresented: $resetAppConfirmation) {
            } content: {
                WarningConfirmationView(description: "You are about to reset the App. This action will erase all data stored on this devices and it is not undoable.") {
                    self.resetAppConfirmation = false
                } confirmAction: {
                    self.toReset = true
                    self.resetAppConfirmation = false
                }
                .onDisappear {
                    if toReset {
                        configs.resetConfig()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environment(\.isPreview, true)
    }
}
