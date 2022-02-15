//
//  CostListItemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 04/02/2022.
//

import SwiftUI

struct CostListItemView: View {
    @State var cost: Saving
    
    @State private var offset = CGSize.zero
    
    @EnvironmentObject var popupHandler: PopupHandler
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(cost.dateLocalizedMonthDay)
                    .font(Fonts.CAPTION)
                    .foregroundColor(Color("Grey"))
                HStack {
                    Text(cost.description ?? "")
                        .font(Fonts.BODY_CHINESE_NORMAL)
                    Spacer(minLength: 30)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Text("-" + CURRENCY_SYMBOL + String(format: "%.2f", -cost.amount))
                .font(.system(size: 16).monospacedDigit())
                .foregroundColor(Color("Grey"))
        }
        .offset(x: offset.width, y: 0)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.width < 0 {
                        offset = gesture.translation
                    }
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        popupHandler.view = AnyView(CostAddView().environmentObject(popupHandler))
                        withAnimation(.linear(duration: 1)) {
                            popupHandler.popuped = true
                        }
                    }
                    withAnimation(.spring()) {
                        offset = .zero
                    }
                }
        )
    }
}

struct CostListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let costConst = Saving(date: "2020-02-10", amount: -10.8, description: "我这里有一个非常长的解释不知道为什么但是我就是要搞这么长测试一下再说8")
        CostListItemView(cost: costConst)
            .previewLayout(.sizeThatFits)

    }
}
