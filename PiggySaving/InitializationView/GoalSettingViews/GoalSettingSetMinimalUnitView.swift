//
//  GoalSettingSetMinimalUnitView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingSetMinimalUnitView: View {
    @ObservedObject var configs: ConfigStore
    @State private var showMinimalUnitHelper = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Set minimal Unit")
                    .font(Fonts.CAPTION)
                Button {
                    showMinimalUnitHelper = true
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                }
                .alert("Set the minimal unit you want to save.", isPresented: $showMinimalUnitHelper) {
                    Button("OK", role: .cancel) {}
                }
                Spacer()
            }
            HStack(alignment: .bottom) {
                TextField("Minimal Unit", value: $configs.configs.minimalUnit, format: .number)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                Text(Currency(rawValue: configs.configs.currency)!.currencyUnit)
                    .font(Fonts.CAPTION)
                    .frame(alignment: .bottom)
                Spacer()
            }
        }
    }
}

struct GoalSettingSetMinimalUnitView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore(currency: Currency.chineseYuan.rawValue)
        GoalSettingSetMinimalUnitView(configs: configConst)
            .previewLayout(.sizeThatFits)
    }
}
