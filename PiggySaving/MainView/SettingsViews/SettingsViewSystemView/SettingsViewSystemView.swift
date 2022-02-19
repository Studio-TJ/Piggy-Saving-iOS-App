//
//  SettingsViewSystemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 19/02/2022.
//

import SwiftUI

struct SettingsViewSystemView: View {
    var body: some View {
        Section(header: Text("System Related Settings")) {
            SettingsViewLanguageView()
        }
    }
}

struct SettingsViewSystemView_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SettingsViewSystemView()
        }
    }
}
