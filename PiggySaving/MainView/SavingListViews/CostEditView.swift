//
//  CostRemoveConvirmationView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 15/02/2022.
//

import SwiftUI

struct CostEditView: View {
    @EnvironmentObject var configs: ConfigStore
    @EnvironmentObject var popupHandler: PopupHandler
    @EnvironmentObject var states: States
    @State private var errorWrapper: ErrorWrapper?
    @Environment(\.managedObjectContext) var context
    
    var edit: Bool = false
    var sequence: Int = 0
    
    @State var date = Calendar.current.startOfDay(for: Date())
    @State var amount: Double = 0.0
    @State var description: String = ""
    @FocusState private var amountFocus: Bool
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self.date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: .date)
                .frame(width: SCREEN_SIZE.width * 0.7)
                .padding(.top, 20)
                .padding(.leading, 20)
                .padding(.trailing, 60)
            HStack {
                Text("Amount")
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
                    .focused($amountFocus)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                Text(CURRENCY_SYMBOL)
                    .font(Fonts.CAPTION)
                    .frame(alignment: .bottom)
            }
            .padding(.leading, 20)
            HStack {
                Text("Description")
                TextField("Description", text: $description)
                    .keyboardType(.default)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 120)
            }
            .padding(.leading, 20)
            HStack(alignment: .center) {
                Button("Confirm") {
                    withdraw(delete: false)
                    dismiss()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.green)
                        .frame(width: 80, height: 45)
                )
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                        .frame(width: 80, height: 45)
                )
                if edit {
                    Spacer()
                    Button("Delete") {
                        withdraw(delete: true)
                        dismiss()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.red)
                            .frame(width: 80, height: 45)
                    )
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .padding(.top, 20)
            .padding(.bottom, 30)
        }
        .frame(width: min(SCREEN_SIZE.width * 0.9, 400))
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackgroundColor"))
                .frame(minWidth: min(SCREEN_SIZE.width * 0.9, 400))
                .shadow(color: Color("AccentColor").opacity(0.2), radius: 16)
        )
        .onTapGesture {
            if amountFocus {
                amountFocus = false
            }
        }
    }
    
    private func dismiss() {
        withAnimation(.linear(duration: 0.5)) {
            popupHandler.popuped = false
        }
        popupHandler.view = AnyView(EmptyView())
    }
    
    private func withdraw(delete: Bool) {
        if configs.configs.usingExternalURL {
            Task {
                do {
                    try await ServerApi.withdraw(externalURL: configs.configs.externalURL ?? "", date: self.dateString, amount: self.amount, description: self.description, sequence: sequence, delete: delete)
                    states.savingDataChanged = true
                } catch {
                    self.errorWrapper = ErrorWrapper(error: error, guidance: NSLocalizedString("Cannot send withdraw request to server. Please check your network connection and try again later. If you are sure that your network connection is working properly, please contact the developer. You can safely dismiss this page for now.", comment: "Withdraw action to server error guidance."))
                }
            }
        } else {
            let fetchRequest = SavingData.fetchRequest()
            if edit {
                fetchRequest.predicate = NSPredicate(format: "date == %@ AND sequence == %@", date as CVarArg, NSNumber(value: sequence))
                
                let storedCost = try? context.fetch(fetchRequest).first
                if let storedCost = storedCost {
                    if delete {
                        context.delete(storedCost)
                    } else {
                        storedCost.amount = -amount
                        storedCost.comment = description
                    }
                }
            } else {
                fetchRequest.predicate = NSPredicate(format: "date == %@", date as CVarArg)
                let storedCosts = try? context.fetch(fetchRequest)
                var sequence = 1
                if let storedCosts = storedCosts {
                    sequence = storedCosts.count
                }
                let newCost = SavingData(context: context)
                newCost.date = date
                newCost.amount = -amount
                newCost.comment = description
                newCost.sequence = Int32(sequence)
                newCost.type = "cost"
            }
            try? context.save()
            states.savingDataChanged = true
        }
    }
}

struct CostRemoveConvirmationView_Previews: PreviewProvider {
    static var previews: some View {
        CostEditView()
    }
}
