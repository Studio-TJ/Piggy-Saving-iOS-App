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
//    @FetchRequest(sortDescriptors: []) var configss: FetchedResults
    @Environment(\.managedObjectContext) var dcContext
    
    var body: some View {
        List {
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
