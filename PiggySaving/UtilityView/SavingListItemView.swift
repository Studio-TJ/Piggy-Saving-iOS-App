//
//  ListItemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 31/01/2022.
//

import SwiftUI

struct SavingListItemView: View {
    @Binding var externalURL: String
    @Binding var itemUpdated: Bool
    let saving: Saving
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(saving.date)
                    .font(.headline)
                if !saving.isSaved {
                    Spacer()
                    Button(action: {
                        Task {
                            try await ServerApi.save(externalURL: self.externalURL, date: self.saving.date, isSaved: true)
                        }
                        itemUpdated = true
                    },
                           label: {
                        Text("Save Now!")
                    })
                }
            }
            HStack {
                Label(String(format: "%.2f", saving.amount), systemImage: "eurosign.circle")
                Spacer()
                let isSavedImage = saving.isSaved ? "checkmark.circle" : "xmark.circle"
                let isSavedText = saving.isSaved ? "Saved" : "Not saved"
                Label(isSavedText, systemImage: isSavedImage)
                    .labelStyle(.trailingIcon)
            }
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let savingConst = Saving()
        SavingListItemView(externalURL: .constant(""), itemUpdated: .constant(false), saving: savingConst)
            .previewLayout(.sizeThatFits)
    }
}
