//
//  SavingListMonthView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 09/02/2022.
//

import SwiftUI

struct SavingListMonthView: View {
    var savings: [Saving]
    @Binding var showList: [String: Bool]
    @Binding var itemUpdated: Bool
    let externalURL: String
    
    var key: String {
        return savings[0].dateMonthYear
    }
    
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
                Image(systemName: "chevron.right")
                    .padding()
                    .onTapGesture {
                        if showList[key] ?? true {
                            showList.updateValue(false, forKey: key)
                        } else {
                            showList.updateValue(true, forKey: key)
                        }
                    }
                    .rotationEffect(.degrees(showList[key] ?? true ? 90 : 0))
            }
            .padding(.leading, 10)
            
            if showList[key] ?? true {
                ForEach(savings) { saving in
                    SavingListItemView(externalURL: externalURL, itemUpdated: $itemUpdated, saving: saving)
                    if saving != savings.last {
                        Divider()
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
        .onAppear {
            if !showList.keys.contains(key) {
                showList[key] = false
            }
        }
    }
}

struct SavingListMonthView_Previews: PreviewProvider {
    static var previews: some View {
        let savings = Saving.sampleData1
        VStack {
            SavingListMonthView(savings: savings, showList: .constant([:]), itemUpdated: .constant(false), externalURL: "")
                .previewLayout(.sizeThatFits)
            Spacer()
        }
    }
}
