//
//  SettingsViewOperationSetMinimalUnitView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 12/02/2022.
//

import SwiftUI

struct SettingsViewOperationSetMinimalUnitView: View {
    let minimalUnit: Double
    
    @State private var showMinimalUnitHelper: Bool = false
    var body: some View {
        HStack {
            Text("Minimal Unit")
            Button {
                showMinimalUnitHelper = true
            } label: {
                Image(systemName: "questionmark.circle.fill")
            }
            Spacer()
            .alert("Since minimal unit setting has a significant impact on the random amount to save, it is not possible to modify at this moment. The modifying feature will be added in the future.", isPresented: $showMinimalUnitHelper) {
                Button("OK", role: .cancel) {}
            }
            Spacer()
            Text(CURRENCY_SYMBOL + String(format: "%.2f", minimalUnit))
            
        }
    }
}

struct SettingsViewOperationSetMinimalUnitView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewOperationSetMinimalUnitView(minimalUnit: 0.1)
    }
}
