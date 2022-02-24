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
        .frame(width: min(SCREEN_SIZE.width * 0.9, 400))
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackgroundColor"))
                .frame(minWidth: min(SCREEN_SIZE.width * 0.9, 400))
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
            localReRoll()
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
    
    private func localReRoll() {
        let numberOfDays = configs.configs.numberOfDays
        let today = Calendar.current.startOfDay(for: Date())
        let fetchRequest = SavingData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == 'saving'")
        let savings = try? context.fetch(fetchRequest)
        var todayIndex = 0
        var replacedSavingDate: Date = today
        let thisAmount = self.saving.amount
        if var savings = savings {
            savings.sort {
                $0.date! < $1.date!
            }
            savings.forEach { saving in
                if saving.date! <= today {
                    todayIndex += 1
                }
            }
            let replacedIndex = Int.random(in: todayIndex..<Int(numberOfDays))
            replacedSavingDate = savings[replacedIndex].date!
        }
        fetchRequest.predicate = NSPredicate(format: "date == %@ AND type == 'saving'", replacedSavingDate as CVarArg)
        var replacedSaving = try? context.fetch(fetchRequest).first
        fetchRequest.predicate = NSPredicate(format: "date == %@ AND type == 'saving'", self.saving.dateFormatted as CVarArg)
        let thisSaving = try? context.fetch(fetchRequest).first
        if let thisSaving = thisSaving {
            if let replacedSaving = replacedSaving {
                thisSaving.amount = replacedSaving.amount
            }
        }
        try? context.save()
        fetchRequest.predicate = NSPredicate(format: "date == %@ AND type == 'saving'", replacedSavingDate as CVarArg)
        replacedSaving = try? context.fetch(fetchRequest).first
        if let replacedSaving = replacedSaving {
            self.saving.amount = replacedSaving.amount
            replacedSaving.amount = thisAmount
        }
        try? context.save()
        states.savingDataChanged = true
    }
}

struct SavingConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        let saving = Saving(date: "2020-12-20", amount: 10.8, saved: 0)
        SavingConfirmationView(saving: saving)
    }
}
