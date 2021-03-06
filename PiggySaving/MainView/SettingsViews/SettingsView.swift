//
//  SettingsView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    
    @EnvironmentObject var configs: ConfigStore
    @EnvironmentObject var states: States
    @EnvironmentObject var popupHandler: PopupHandler
    @State private var resetAppConfirmation: Bool = false
    @State private var toReset: Bool = false
    
    var body: some View {
        ZStack {
            NavigationView {
                List {
                    SettingsRunningModeView()
                    SettingsViewOperationView()
                    SettingsViewSystemView()
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
                            states.mainViewSelection = MainTabItem.SAVINTS_LIST
                            configs.resetConfig()
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .blur(radius: popupHandler.popuped ? 5 : 0)
            .disabled(popupHandler.popuped)

            if popupHandler.popuped {
                popupHandler.view.transition(.opacity)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ConfigStore())
            .environment(\.isPreview, true)
    }
}
