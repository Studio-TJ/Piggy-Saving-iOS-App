//
//  EnterServerURLView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import SwiftUI

struct EnterServerURLView: View {
    @ObservedObject var configs: ConfigStore
    @State var externalURL: String = ""
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            Text("Enter server URL:")
            TextField("https://", text: $externalURL)
                .frame(width: SCREEN_SIZE.width * 0.8)
                .disableAutocorrection(true)
                .keyboardType(.URL)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let newConfigs = self.configs.configs
                    newConfigs.isInitialized = true
                    newConfigs.usingExternalURL = true
                    newConfigs.externalURL = self.externalURL.lowercased()
                    newConfigs.ableToWithdraw = self.configs.configs.ableToWithdraw
                    self.configs.configs = newConfigs
                }
            }
        }
    }
}

struct EnterServerURLView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore()
        EnterServerURLView(configs: configConst)
    }
}
