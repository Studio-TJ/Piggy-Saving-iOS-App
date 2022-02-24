//
//  SavingsListHeaderBarView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 24/02/2022.
//

import SwiftUI

struct SavingsListHeaderBarView: View {
    let leftRatio: Double
    let leftText: String
    let rightText: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color("BackgroundColor"))
                        .opacity(0.5)
                        .frame(width: geo.size.width * leftRatio)
                        .shadowA()
                    Rectangle()
                        .fill(Color("NotSoWhite"))
                        .shadowA()
                }
                HStack {
                    Text(leftText)
                        .heading15Reg()
                    Spacer()
                    Text(rightText)
                        .heading20Bold()
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
            }
        }
        .frame(height: 43)
    }
}

struct SavingsListHeaderBarView_Previews: PreviewProvider {
    static var previews: some View {
        let leftRatio = 0.61
        let leftText = "Current Balance"
        let rightText = CURRENCY_SYMBOL + " 775.97"
        SavingsListHeaderBarView(leftRatio: leftRatio,
                                 leftText: leftText,
                                rightText: rightText)
    }
}
