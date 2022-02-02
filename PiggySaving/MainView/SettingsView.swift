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
                    configs.resetConfig()
                    print(self.configs.configs.currency)
                },
                       label: {
                    Text("Reset App!")
                        .foregroundColor(Color.red)
                })
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
