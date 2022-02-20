//
//  SavingConfirmationView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 16/02/2022.
//

import SwiftUI

struct SavingConfirmationView: View {
    @EnvironmentObject var popupHandler: PopupHandler
    @EnvironmentObject var configs: ConfigStore
    @EnvironmentObject var states: States
    @Environment(\.managedObjectContext) var context
    
    @State private var errorWrapper: ErrorWrapper?
    @State var saving: Saving
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "x.square")
            }
            .padding(.trailing, 10)
            .padding(.top, 10)
            .onTapGesture {
                dismiss()
            }
            Text(saving.dateFormatted, style: .date)
            Text("Today to Save")
                .font(Fonts.TITLE_SEMIBOLD)
            Text(CURRENCY_SYMBOL + String(format: "%.2f", saving.amount))
                .font(Fonts.TITLE_SEMIBOLD)
            HStack {
                Button("Save Now"){
                    saveNow()
                    dismiss()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green)
                        .frame(width: 100, height: 60)
                )
                Spacer()
                Button("Roll Aagin") {
                    reRoll()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                        .frame(width: 100, height: 60)
                )
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
            .padding(.trailing, 50)
            .padding(.leading, 50)
        }
        .frame(width: SCREEN_SIZE.width * 0.9)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackgroundColor"))
                .frame(minWidth: SCREEN_SIZE.width * 0.9)
                .shadow(color: Color("AccentColor").opacity(0.2), radius: 16)
        )

    }
    
    private func dismiss() {
        withAnimation(.linear(duration: 0.5)) {
            popupHandler.popuped = false
        }
        popupHandler.view = AnyView(EmptyView())
    }
    
    private func reRoll() {
        if configs.configs.usingExternalURL {
            Task {
                do {
                    let newResult = try await ServerApi.roll(externalURL: configs.configs.externalURL ?? "", date: saving.date)
                    if let newResult = newResult {
                        saving.amount = newResult
                        states.savingDataChanged = true
                    }
                }
            }
        } else {
            print("Local reroll")
        }
    }
    
    private func saveNow() {
        if configs.configs.usingExternalURL {
            Task {
                do {
                    try await ServerApi.save(externalURL: configs.configs.externalURL ?? "", date: self.saving.date, isSaved: true)
                    states.savingDataChanged = true
                } catch {
                    self.errorWrapper = ErrorWrapper(error: error, guidance: NSLocalizedString("Cannot send save request to server. Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now.", comment: "Saving action to server error guidance."))
                }
            }
        } else {
            let fetchRequest = SavingData.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "date == %@ AND type == 'saving'", saving.dateFormatted as CVarArg)
            let storedSaving = try? context.fetch(fetchRequest).first
            if let storedSaving = storedSaving {
                storedSaving.saved = true
                try? context.save()
            }
            states.savingDataChanged = true
        }
    }
}

struct SavingConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        let saving = Saving(date: "2020-12-20", amount: 10.8, saved: 0)
        SavingConfirmationView(saving: saving)
    }
}
