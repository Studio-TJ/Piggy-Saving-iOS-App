//
//  SettingsViewOperationsSetEndDateView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 12/02/2022.
//

import SwiftUI

struct SettingsViewOperationsSetEndDateView: View {
    let endDate: Date
    
    @State private var showEndDateHelper: Bool = false
    var body: some View {
        HStack {
            Text("End Date")
            Button {
                showEndDateHelper = true
            } label: {
                Image(systemName: "questionmark.circle.fill")
            }
            Spacer()
            .alert("Since end date setting has a significant impact on the random amount to save, it is not possible to modify at this moment. The modifying feature will be added in the future.", isPresented: $showEndDateHelper) {
                Button("OK", role: .cancel) {}
            }
            Spacer()
            Text(endDate, style: .date)
            
        }
    }
}

struct SettingsViewOperationsSetEndDateView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewOperationsSetEndDateView(endDate: Date())
    }
}
