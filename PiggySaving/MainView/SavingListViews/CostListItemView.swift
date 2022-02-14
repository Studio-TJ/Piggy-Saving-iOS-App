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
                Text(cost.description ?? "")
                    .frame(maxWidth: SCREEN_SIZE.width * 0.6)
            }
            Spacer()
            Text("-" + CURRENCY_SYMBOL + String(format: "%.2f", -cost.amount))
                .foregroundColor(Color("Grey"))
        }
    }
}

struct CostListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let costConst = Saving(date: "2020-02-10", amount: -10.8, description: "我这里有一段非常长的文字用来测试取钱可能我很啰嗦就是要记这么多")
        CostListItemView(cost: costConst)
            .previewLayout(.sizeThatFits)

    }
}
