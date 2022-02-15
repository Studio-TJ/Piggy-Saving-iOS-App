//
//  SavingListOverviewView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 09/02/2022.
//

import SwiftUI

struct SavingListOverviewView: View {
    let sumSaving: Double
    let totalSaving: Double
    let totalCost: Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 21)
                .fill(Color("MainPink"))
                .frame(width: SCREEN_SIZE.width * 0.92, height: SCREEN_SIZE.height * 0.26)
            VStack {
                HStack {
                    Text("Currently saved: " + CURRENCY_SYMBOL + String(format: "%.2f", self.sumSaving))
                        .font(Font.custom("SFProDisplay-Bold", size: 23))
                    Spacer()
                }
                HStack {
                    Text("Total amount till now: " + CURRENCY_SYMBOL + String(format: "%.2f", self.totalSaving))
                        .font(Font.custom("SFProDisplay-Bold", size: 23))
                    Spacer()
                }
                HStack {
                    Text("Total cost: " + CURRENCY_SYMBOL + String(format: "%.2f", self.totalCost))
                        .font(Font.custom("SFProDisplay-Bold", size: 23))
                    Spacer()
                }
            }
            .frame(width: SCREEN_SIZE.width * 0.92 - 10, height: SCREEN_SIZE.height * 0.26, alignment: .leading)
        }
    }
}

struct SavingListOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        let sumSaving: Double = 1000
        let totalSaving: Double = 3506
        let totalCost: Double = 250
        SavingListOverviewView(sumSaving: sumSaving, totalSaving: totalSaving, totalCost: totalCost)
    }
}
