//
//  SettingsViewOperationWithdrawModeView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 12/02/2022.
//

import SwiftUI

struct SettingsViewOperationWithdrawModeView: View {
    @Binding var ableToWithdraw: Bool
    @State private var showWithdrawHelper: Bool = false
    var body: some View {
        HStack {
            Toggle(isOn: $ableToWithdraw)
            {
                HStack {
                    Text("Withdraw Mode")
                    Button {
                        showWithdrawHelper = true
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                    }
                    Spacer()
                    .alert("By default withdraw mode is disable, which means you should not withdraw your money until reaching the end date. However you can enable this mode and also record your withdraw.", isPresented: $showWithdrawHelper) {
                        Button("OK", role: .cancel) {}
                    }
                }
            }
        }
    }
}

struct SettingsViewOperationWithdrawModeView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewOperationWithdrawModeView(ableToWithdraw: .constant(true))
    }
}
