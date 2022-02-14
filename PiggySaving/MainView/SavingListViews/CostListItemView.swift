//
//  CostListItemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 04/02/2022.
//

import SwiftUI

struct CostListItemView: View {
    @State var cost: Saving
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(cost.dateLocalizedMonthDay)
                    .font(Fonts.CAPTION)
                    .foregroundColor(Color("Grey"))
                HStack {
                    Text(cost.description ?? "")
                    Spacer(minLength: 30)
                }
            }
            Spacer()
            Text("-" + CURRENCY_SYMBOL + String(format: "%.2f", -cost.amount))
                .foregroundColor(Color("Grey"))
        }
    }
}

struct CostListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let costConst = Saving(date: "2020-02-10", amount: -10.8, description: "我这里有一个非常长的解释不知道为什么但是我就是要搞这么长测试一下再说8")
        CostListItemView(cost: costConst)
            .previewLayout(.sizeThatFits)

    }
}
