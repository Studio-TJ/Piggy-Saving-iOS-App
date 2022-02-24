//
//  SavingListHeaderView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 23/02/2022.
//

import SwiftUI

struct SavingListHeaderView: View {
    let currentBalance: Double
    let totalSavings: Double
    let totalExpenses: Double
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 5) {
                SavingsListHeaderBarView(leftRatio: 0.61, leftText: "Current Balance", rightText: CURRENCY_SYMBOL + " " + String(format: "%.2f", currentBalance))
                SavingsListHeaderBarView(leftRatio: 0, leftText: "Total Savings", rightText: CURRENCY_SYMBOL + " " + String(format: "%.2f", totalSavings))
                if totalExpenses != 0 {
                    SavingsListHeaderBarView(leftRatio: 0.5, leftText: "Total Expenses", rightText: CURRENCY_SYMBOL + " " + String(format: "%.2f", totalExpenses))
                }
            }
        }
        .padding(.top, 35)
        .padding(.leading, 15)
        .padding(.trailing, 15)
        .ignoresSafeArea(.all)
        .frame(width: SCREEN_SIZE.width, height: 236)
        .background(Color("MainPink"))
    }
}

struct SavingListHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let currentBalance = 775.97
        let totalSavings = 4047.10
        let totalExpenses = 3187.03
        SavingListHeaderView(currentBalance: currentBalance, totalSavings: totalSavings, totalExpenses: totalExpenses)
            .previewLayout(.sizeThatFits)
    }
}
