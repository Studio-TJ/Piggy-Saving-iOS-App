//
//  ChooseSourceView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import SwiftUI

struct ChooseSourceView: View {
    @Binding var isInitialized: Bool
    @Binding var usingExternalURL: Bool
    @Binding var externalURL: String
    
    var body: some View {
        VStack {
            Text("Select Source")
            Button(action: {}) {
                NavigationLink(destination: EnterServerURLView(isInitialized: $isInitialized, usingExternalURL: $usingExternalURL, externalURL: $externalURL)) {
                    Text("Select")
                }
            }
            .font(.headline)
            .padding(.all)
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(45)
            
            
            Button(action: {}) {
                NavigationLink(destination: LocalUsageView()) {
                    Text("Use Locally")
                }
            }
            .font(.headline)
            .padding(.all)
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(45)
        }
    }
}

struct ChooseSourceView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseSourceView(isInitialized: .constant(false), usingExternalURL: .constant(false), externalURL: .constant(""))
    }
}
