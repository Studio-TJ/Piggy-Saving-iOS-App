//
//  SettingsViewFooterInfo.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 12/02/2022.
//

import SwiftUI

struct SettingsViewFooterInfoView: View {
    var body: some View {
        Section {} footer: {
            HStack {
                Spacer()
                Text(VERSION_STRING)
                Spacer()
            }
        }
    }
}

struct SettingsViewFooterInfo_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SettingsViewFooterInfoView()
        }
    }
}
