//
//  CostListItemView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 04/02/2022.
//

import SwiftUI

struct CostListItemView: View {
    let cost: Saving
    
    @State private var offset = CGSize.zero
    
    @EnvironmentObject var popupHandler: PopupHandler
    @EnvironmentObject var states: States
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Image(systemName: "square.and.pencil")
                    .padding(.trailing, 10)
                    .opacity(min(abs(offset.width) / Double(70), 1))
            }
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
                        if gesture.translation.width < -70 {
                            UINotificationFeedbackGenerator().notificationOccurred(.success)
                        }
                        print(offset.width)
                    }
                    .onEnded { gesture in
                        if gesture.translation.width < -65 {
                            popupHandler.view = AnyView(CostEditView(edit: true,
                                                                     sequence: cost.sequence,
                                                                     date: cost.dateFormatted,
                                                                     amount: -cost.amount,
                                                                     description: cost.description ?? "")
                                                            .environmentObject(popupHandler)
                                                            .environmentObject(states))
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
}

struct CostListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let costConst = Saving(date: "2020-02-10", amount: -10.8, description: "我这里有一个非常长的解释不知道为什么但是我就是要搞这么长测试一下再说8")
        CostListItemView(cost: costConst)
            .previewLayout(.sizeThatFits)

    }
}
