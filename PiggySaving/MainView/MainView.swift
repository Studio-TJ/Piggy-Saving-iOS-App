//
//  MainView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 27/01/2022.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var configs: ConfigStore = ConfigStore()
    
    var body: some View {
        VStack {
            if (configs.usingExternalURL == false) {
                Text("Running Locally")
            } else {
                Text("Connected to server: " + configs.externalURL)
            }
        }
        .onAppear {
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
