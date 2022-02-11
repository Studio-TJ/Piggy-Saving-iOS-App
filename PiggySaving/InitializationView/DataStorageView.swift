//
//  DataStorageView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct DataStorageView: View {
    @ObservedObject var configs: Configs
    @State var serverURL = ""
    @State var showPowerUserGuide = false
    var body: some View {
        VStack {
            HStack {
                Text("Data storage")
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer()
            }
            .padding(20)
            Image(systemName: "internaldrive")
                .font(.system(size: 120))
            Text("By default, your data will be stored locally on this device. No other party will have access of your data.")
                .padding(20)
            Spacer()
            Button {
                print("Power user")
                showPowerUserGuide = true
            } label: {
                Text("Power user? Click here.")
                    .underline()
                    .foregroundColor(Color.gray)
            }
            .padding(.bottom, SCREEN_SIZE.height * 0.1)
            .sheet(isPresented: $showPowerUserGuide) {
                NavigationView {
                    DataStoragePowerUserView(serverURL: $serverURL)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    showPowerUserGuide = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Save") {
                                    showPowerUserGuide = false
                                    self.configs.externalURL = serverURL
                                    self.configs.usingExternalURL = true
                                }
                            }
                        }
                }
            }
        }
        
    }
}

struct DataStorageView_Previews: PreviewProvider {
    static var previews: some View {
        let configs = ConfigStore(placeholder: true)
        DataStorageView(configs: configs.configs)
    }
}
