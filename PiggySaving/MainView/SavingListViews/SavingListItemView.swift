//
//  ListItemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 31/01/2022.
//

import SwiftUI

struct SavingListItemView: View {
    @EnvironmentObject var popupHandler: PopupHandler
    @EnvironmentObject var states: States
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
                Button("Save") {
                    popupHandler.view = AnyView(SavingConfirmationView(saving: saving)
                                                    .environmentObject(popupHandler)
                                                    .environmentObject(states))
                    withAnimation(.linear(duration: 0.2)) {
                        popupHandler.popuped = true
                    }
                }
                .frame(width: 69, height: 23)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("MainPink"))
                )
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
        SavingListItemView(saving: savingConst)
            .environmentObject(ConfigStore())
            .previewLayout(.sizeThatFits)
    }
}
