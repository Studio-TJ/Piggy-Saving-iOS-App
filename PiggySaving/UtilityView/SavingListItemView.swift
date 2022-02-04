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
    @State private var errorWrapper: ErrorWrapper?
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
                            do {
                                try await ServerApi.save(externalURL: self.externalURL, date: self.saving.date, isSaved: true)
                                itemUpdated = true
                            } catch {
                                self.errorWrapper = ErrorWrapper(error: error, guidance: "Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now.")
                            }
                        }
                    },
                           label: {
                        Text("Save Now!")
                    })
                }
            }
            .sheet(item: $errorWrapper, onDismiss: {
                self.errorWrapper = nil
            }) { wrapper in
                ErrorView(errorWrapper: wrapper)
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
