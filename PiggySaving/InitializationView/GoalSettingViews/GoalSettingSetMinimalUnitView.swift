//
//  GoalSettingSetMinimalUnitView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 06/02/2022.
//

import SwiftUI

struct GoalSettingSetMinimalUnitView: View {
    @ObservedObject var configs: Configs
    @State private var showMinimalUnitHelper = false
    @FocusState private var enteringFocuse: Bool
    
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
                TextField("Minimal Unit", value: $configs.minimalUnit, format: .number)
                    .keyboardType(.decimalPad)
                    .focused($enteringFocuse)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                Text(CURRENCY_SYMBOL)
                    .font(Fonts.CAPTION)
                    .frame(alignment: .bottom)
                Button {
                    enteringFocuse = false
                } label: {
                    Text("Done")
                        .foregroundColor(Color.accentColor)
                        .frame(minWidth: 0, maxWidth: SCREEN_SIZE.width * 0.2, minHeight: 20)
                }

                Spacer()
            }
        }
    }
}

struct GoalSettingSetMinimalUnitView_Previews: PreviewProvider {
    static var previews: some View {
        let configConst = ConfigStore()
        GoalSettingSetMinimalUnitView(configs: configConst.configs)
            .previewLayout(.sizeThatFits)
    }
}
