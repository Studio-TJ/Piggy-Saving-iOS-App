//
//  SettingsRunningModeView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 12/02/2022.
//

import SwiftUI

struct SettingsRunningModeView: View {
    let usingExternalURL: Bool
    let externalURL: String?
    var body: some View {
        Section(header: Text("Running Mode"), footer: Text("Note: Running mode cannot be modified at this moment.")) {
            HStack {
                Text("Running Mode")
                Spacer()
                let mode = usingExternalURL ? "Self-Hosted" : "Local"
                Text(mode)
            }
            if usingExternalURL {
                VStack(alignment: .leading) {
                    Text("Server address:")
                    Text(externalURL ?? "")
                }
            }
        }
    }
}

struct SettingsRunningModeView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SettingsRunningModeView(usingExternalURL: true, externalURL: "http://a.b")
        }
    }
}
