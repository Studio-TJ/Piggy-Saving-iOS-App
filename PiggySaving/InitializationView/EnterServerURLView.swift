//
//  EnterServerURLView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct EnterServerURLView: View {
    @Binding var configs: Configs
    let saveAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Enter server URL:")
            TextField("https://", text: $configs.externalURL)
                .frame(width: UIScreen.screenWidth * 0.8)
                .disableAutocorrection(true)
                .keyboardType(.URL)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    self.configs.setIsInitialized(isInitialized: true)
                    self.configs.setUsingExternalURL(usingExternalURL: true)
                    self.configs.setExternalURL(externalURL:  self.configs.externalURL.lowercased())
                    saveAction()
                }
            }
        }
    }
}

struct EnterServerURLView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = Configs()
        EnterServerURLView(configs: .constant(configConst), saveAction: {})
    }
}
