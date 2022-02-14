//
//  CostListMonthView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 14/02/2022.
//

import SwiftUI

struct CostListMonthView: View {
    var costs: [Saving]
    @Binding var showList: [String: Bool]
    
    var key: String {
        return costs[0].dateMonthYear
    }
    
    var month: String {
        costs[0].dateLocalizedMonth
    }
    
    var sumOfMonth: Double {
        var sum: Double = 0
        costs.forEach { saving in
            sum += saving.amount
        }
        
        return sum
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(self.month)
                    .font(Fonts.BODY_CHINESE_NORMAL)
                    .foregroundColor(Color.accentColor)
                Spacer()
                HStack(spacing: 0) {
                    Text("-" + CURRENCY_SYMBOL + String(format: "%.2f", -self.sumOfMonth))
                        .font(Fonts.BODY_CHINESE_NORMAL)
                        .foregroundColor(Color("MainPink"))
                }
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
                ForEach(costs) { cost in
                    CostListItemView(cost: cost)
                    if cost != costs.last {
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

struct CostListMonthView_Previews: PreviewProvider {
    static var previews: some View {
        let savings = Saving.sampleData4
        VStack {
            CostListMonthView(costs: savings, showList: .constant([:]))
                .previewLayout(.sizeThatFits)
            Spacer()
        }
    }
}
