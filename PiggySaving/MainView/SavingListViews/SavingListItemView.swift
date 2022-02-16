//
//  ListItemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 31/01/2022.
//

import SwiftUI

struct SavingListItemView: View {
    let externalURL: String
    
    @EnvironmentObject var configs: ConfigStore
    @EnvironmentObject var states: States
    @Environment(\.managedObjectContext) var context
    
    @State private var errorWrapper: ErrorWrapper?
    
    @State var saving: Saving
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(saving.dateLocalizedMonthDay)
                    .font(Fonts.CAPTION)
                    .foregroundColor(Color("Grey"))
                if saving.isSaved {
                    Text("+" + String(format: "%.2f", saving.amount))
                        .font(.system(size: 16).monospacedDigit())
                } else {
                    Text("Not Saved yet.")
                        .font(Fonts.BODY_CHINESE_NORMAL)
                        .foregroundColor(Color("MainPink"))
                }
            }
            Spacer()
            if saving.isSaved {
                Text("Saved")
                    .foregroundColor(Color("Grey"))
            } else {
                VStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color("MainPink"))
                        .frame(width: 100, height: 23)
                        .overlay(
                            Text("Save Now")
                                .foregroundColor(.white)
                        )
                        .onTapGesture {
//                            if configs.configs.usingExternalURL {
//                                Task {
//                                    do {
//                                        try await ServerApi.save(externalURL: self.externalURL, date: self.saving.date, isSaved: true)
//                                        states.savingDataChanged = true
//                                    } catch {
//                                        self.errorWrapper = ErrorWrapper(error: error, guidance: NSLocalizedString("Cannot send save request to server. Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now.", comment: "Saving action to server error guidance."))
//                                    }
//                                }
//                            } else {
//                                let fetchRequest = SavingData.fetchRequest()
//                         
//                                fetchRequest.predicate = NSPredicate(format: "date == %@", saving.dateFormatted as CVarArg)
//                                let storedSaving = try? context.fetch(fetchRequest).first
//                                if let storedSaving = storedSaving {
//                                    storedSaving.saved = true
//                                    try? context.save()
//                                }
//                                states.savingDataChanged = true
//                            }
                        }
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
        SavingListItemView(externalURL: "", saving: savingConst)
            .environmentObject(ConfigStore())
            .previewLayout(.sizeThatFits)
    }
}
