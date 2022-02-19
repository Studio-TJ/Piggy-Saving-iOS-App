//
//  SettingsViewLanguageView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 19/02/2022.
//

import SwiftUI

struct SettingsViewLanguageView: View {
    var language: String {
        let languageCode = Locale.preferredLanguages[0]
        let locale = NSLocale(localeIdentifier: languageCode)
        return locale.localizedString(forLocaleIdentifier: languageCode)
    }
    var body: some View {
        HStack {
            Text("Language")
            Spacer()
            Button(language) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            
        }
    }
}

struct SettingsViewLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewLanguageView()
    }
}
