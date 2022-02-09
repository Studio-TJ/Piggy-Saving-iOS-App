//
//  SavingListMonthView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 09/02/2022.
//

import SwiftUI

struct SavingListMonthView: View {
    var savings: [Saving]
    
    @State var showList = false
    @State var externalURL = ""
    
    var month: String {
        savings[0].dateLocalizedMonth
    }
    
    var sumOfMonth: Double {
        var sum: Double = 0
        savings.forEach { saving in
            sum += saving.amount
        }
        
        return sum
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(self.month)
                    .font(Fonts.BODY_CHINESE_NORMAL)
                    .foregroundColor(Color("MainPink"))
                Spacer()
                Text(CURRENCY_SYMBOL + String(format: "%.2f", self.sumOfMonth))
                    .font(Fonts.BODY_CHINESE_NORMAL)
                    .foregroundColor(Color("MainPink"))
                Button {
                    withAnimation {
                        showList.toggle()
                    }
                } label: {
                    Label("List", systemImage: "chevron.right")
                        .foregroundColor(Color("Grey"))
                        .labelStyle(.iconOnly)
                        .imageScale(.small)
                        .rotationEffect(.degrees(showList ? 90 : 0))
                        .padding()
                }
            }
            .padding(.leading, 10)
            
            if showList {
                ForEach(savings) { saving in
                    SavingListItemView(externalURL: $externalURL, itemUpdated: .constant(false), saving: saving)
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
    }
}

struct SavingListMonthView_Previews: PreviewProvider {
    static var previews: some View {
        let savings = Saving.sampleData1
        VStack {
            SavingListMonthView(savings: savings)
                .previewLayout(.sizeThatFits)
            Spacer()
        }
    }
}
