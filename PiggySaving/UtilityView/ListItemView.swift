//
//  ListItemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 31/01/2022.
//

import SwiftUI

struct ListItemView: View {
    let saving: Saving
    var body: some View {
        HStack {
            Label(saving.date, systemImage: "calendar.circle")
            Spacer()
            Label(String(format: "%.2f", saving.amount), systemImage: "eurosign.circle")
            Spacer()
            Label(String(saving.isSaved), systemImage: "eurosign.circle")
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let savingConst = Saving()
        ListItemView(saving: savingConst)
            .previewLayout(.sizeThatFits)
    }
}
