//
//  GoalSettingSetCurrencyView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingSetCurrencyView: View {
    @ObservedObject var configs: ConfigStore
    @State private var showCurrencyHelper = false
    
    var body: some View {
        HStack {
            Text("Choose Currency")
                .font(Fonts.BODY_CHINESE_NORMAL)
            Button {
                showCurrencyHelper = true
            } label: {
                Image(systemName: "questionmark.circle.fill")
            }
            .alert("Currency settings is used for display purpose only.", isPresented: $showCurrencyHelper) {
                Button("OK", role: .cancel) {}
            }
            Spacer()
            Picker("Currency", selection: $configs.configs.currency) {
                ForEach(CURRENCIES, id: \.self) {
                    Text(Locale.current.localizedString(forCurrencyCode: $0)!).tag($0 as String?)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct GoalSettingSetCurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore(currency: "CNY")
        GoalSettingSetCurrencyView(configs: configConst)
            .previewLayout(.sizeThatFits)
    }
}
