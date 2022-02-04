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
    
    var body: some View {
        List {
            HStack {
                Text("Running Mode")
                Spacer()
                let mode = configs.configs.usingExternalURL ? "Self-Hosted" : "Local"
                Text(mode)
            }
            if configs.configs.usingExternalURL {
                VStack(alignment: .leading) {
                        Text("Server address:")
                        Text(configs.configs.externalURL!)
                }
            }
            Picker("Currency", selection: $configs.configs.currency) {
                Text("Chinese Yuan").tag(Currency.chineseYuan.id)
                Text("Euro").tag(Currency.euro.id)
                Text("US Dollar").tag(Currency.usDollar.id)
            }
            HStack {
                Toggle(isOn: $configs.configs.ableToWithdraw)
                {
                    Text("Withdraw")

                }
            }
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
        }
        .sheet(isPresented: $resetAppConfirmation) {
        } content: {
            WarningConfirmationView(description: "You are about to reset the App. This action will erase all data stored on this devices and it is not undoable.") {
                self.resetAppConfirmation = false
            } confirmAction: {
                self.resetAppConfirmation = false
                configs.resetConfig()
            }

        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
