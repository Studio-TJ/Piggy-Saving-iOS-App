//
//  CostRemoveConvirmationView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 15/02/2022.
//

import SwiftUI

struct CostAddView: View {
    @EnvironmentObject var popupHandler: PopupHandler
    
    @State private var date = Date()
    @State private var amount: Double = 0.0
    @State private var description: String = ""
//    @FocusState private var amountFocus: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            DatePicker(
                "Date",
                selection: $date,
                displayedComponents: .date)
                .frame(width: SCREEN_SIZE.width * 0.7)
                .padding(.top, 20)
                .padding(.leading, 20)
            HStack {
                Text("Amount")
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
//                    .focused($amountFocus)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                Text(CURRENCY_SYMBOL)
                    .font(Fonts.CAPTION)
                    .frame(alignment: .bottom)
                Button {
//                    amountFocus = false
                } label: {
                    Text("Done")
                        .frame(minWidth: 80, minHeight: 25)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color("AccentColor"))
                        }
                        .foregroundColor(Color("FrontColor"))
                }
                .padding(.trailing, 20)
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
            HStack {
                Button("Confirm") {
                    withAnimation(.linear(duration: 0.5)) {
                        popupHandler.popuped = false
                    }
                    popupHandler.view = AnyView(EmptyView())
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.green)
                        .frame(width: 120, height: 45)
                )
                .padding(.leading, 60)
                Spacer()
                Button("Cancel") {
                    withAnimation(.linear(duration: 0.5)) {
                        popupHandler.popuped = false
                    }
                    popupHandler.view = AnyView(EmptyView())
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                        .frame(width: 120, height: 45)
                )
                .padding(.trailing, 60)
            }
            .padding(.top, 20)
            Spacer()
        }
        .frame(width: SCREEN_SIZE.width * 0.9, height: SCREEN_SIZE.height * 0.3)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("BackgroundColor"))
                .frame(minWidth: SCREEN_SIZE.width * 0.9, minHeight: 250)
                .shadow(color: Color("AccentColor").opacity(0.2), radius: 16)
        )
    }
}

struct CostRemoveConvirmationView_Previews: PreviewProvider {
    static var previews: some View {
        CostAddView()
    }
}
