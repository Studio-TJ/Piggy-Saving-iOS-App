//
//  SettingsView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 28/01/2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var configs: ConfigStore = ConfigStore()
    
    var body: some View {
        List {
            HStack {
                Toggle(isOn: $configs.configs.ableToWithdraw)
                {
                    Text("Withdraw")
                }
                .onChange(of: configs.configs.ableToWithdraw) { value in
                    Task {
                        try await ConfigStore.save(configs: configs.configs)
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    configs.resetConfig()
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
