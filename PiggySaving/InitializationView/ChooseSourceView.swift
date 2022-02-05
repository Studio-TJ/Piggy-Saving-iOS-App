//
//  ChooseSourceView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 26/01/2022.
//

import SwiftUI

struct ChooseSourceView: View {
    @ObservedObject var configs: ConfigStore
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Select Source")
                Button(action: {}) {
                    NavigationLink(destination: EnterServerURLView(configs: configs)) {
                        Text("Use with self-hosted server")
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
}

struct ChooseSourceView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore()
        ChooseSourceView(configs: configConst)
    }
}
