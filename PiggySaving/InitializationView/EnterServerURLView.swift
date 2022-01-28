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
    @Binding var isInitialized: Bool
    @Binding var usingExternalURL: Bool
    @Binding var externalURL: String
    
    var body: some View {
        VStack {
            Text("Enter server URL:")
            TextField("https://", text: $externalURL)
                .frame(width: UIScreen.screenWidth * 0.8)
                .disableAutocorrection(true)
                .keyboardType(.URL)
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    self.isInitialized = true
                    self.usingExternalURL = true
                    self.externalURL = self.externalURL.lowercased()
                }
            }
        }
    }
}

struct EnterServerURLView_Previews: PreviewProvider {
    static var previews: some View {
        EnterServerURLView(isInitialized: .constant(false), usingExternalURL: .constant(false), externalURL: .constant(""))
    }
}
