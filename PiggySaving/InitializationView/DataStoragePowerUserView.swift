//
//  DataStoragePowerUserView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 09/02/2022.
//

import SwiftUI

struct DataStoragePowerUserView: View {
    @Binding var serverURL: String
    @State private var showURLHelper = false
    var body: some View {
        VStack {
            HStack {
                Text("Using Self-Hosted Server")
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer()
            }
            .padding(.leading, 10)
            Text("You are a power user, great! You can also self host a backend server of this app. With a self-hosted backend, your data will be stored on your own server instead of this device. You will be able to access the data from another device. No other party can have access of your data.")
                .padding(.trailing, 10)
                .padding(.leading, 10)
            // TODO: use internal webkit for showing the basic insturction
            Text("The instruction of setting up a backend server can be found here.")
                .padding(.top, 5)
                .padding(.trailing, 10)
                .padding(.leading, 10)
            HStack {
                Text("Enter server URL:")
                Button {
                    showURLHelper = true
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                }
                .alert("The server URL can be a domain or an IP address. Please also enter the correct http protocol as well as destination port if applicable. Please note: if your server is not reachable from public Internet, please make sure your device is within the same network of your server. ", isPresented: $showURLHelper) {
                    Button("OK", role: .cancel) {}
                }
            }
            TextField("https://", text: $serverURL)
                .padding(.top, 5)
                .frame(width: SCREEN_SIZE.width * 0.8)
                .disableAutocorrection(true)
                .keyboardType(.URL)
        }
        .padding(1)
    }
}

struct DataStoragePowerUserView_Previews: PreviewProvider {
    static var previews: some View {
        let serverURL = ""
        DataStoragePowerUserView(serverURL: .constant(serverURL))
    }
}
