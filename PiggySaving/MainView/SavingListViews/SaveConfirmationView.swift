//
//  SaveConfirmationView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 14/02/2022.
//

import SwiftUI

struct SaveConfirmationView: View {
    @Binding var toggle: Bool
    var body: some View {
        Button("Toggle") {
            toggle.toggle()
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.pink)
        )
    }
}

struct SaveConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        SaveConfirmationView(toggle: .constant(true))
    }
}
