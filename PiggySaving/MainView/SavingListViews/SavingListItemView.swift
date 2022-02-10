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
        HStack {
            VStack(alignment: .leading) {
                Text(saving.dateLocalizedMonthDay)
                    .font(Fonts.CAPTION)
                    .foregroundColor(Color("Grey"))
                Text("+" + String(format: "%.2f", saving.amount))
            }
            Spacer()
            if saving.isSaved {
                Text("Saved")
                    .foregroundColor(Color("Grey"))
            } else {
                VStack(alignment: .trailing) {
                    // TODO: button will be modified to onTapGesture because of list behavior
                    Button(action: {
                        Task {
                            do {
                                try await ServerApi.save(externalURL: self.externalURL, date: self.saving.date, isSaved: true)
                                itemUpdated = true
                            } catch {
                                self.errorWrapper = ErrorWrapper(error: error, guidance: NSLocalizedString("Cannot send save request to server. Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now.", comment: "Saving action to server error guidance."))
                            }
                        }
                    },
                           label: {
                        Text("Save Now!")
                    })
                    Text("Not saved yet.")
                }
            }
        }
        .sheet(item: $errorWrapper, onDismiss: {
            self.errorWrapper = nil
        }) { wrapper in
            ErrorView(errorWrapper: [wrapper])
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let savingConst = Saving(saved: 0)
        SavingListItemView(externalURL: .constant(""), itemUpdated: .constant(false), saving: savingConst)
            .previewLayout(.sizeThatFits)
    }
}
