//
//  MainView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 27/01/2022.
//

import SwiftUI

struct MainSavingView: View {
    @ObservedObject var configs: ConfigStore = ConfigStore()
    var lastData = LastAmount()
    
    var body: some View {
        VStack {
            if (configs.usingExternalURL == false) {
                Text("Running Locally")
            } else {
                Text("Connected to server: " + configs.externalURL)
            }
        }
        .onAppear {
            ServerApi().getLast(externalURL: configs.externalURL) { lastData in
//                self.lastData = lastData
            }
            ServerApi().getSum(externalURL: configs.externalURL) { lastData in
//                self.lastData = lastData
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainSavingView()
    }
}
