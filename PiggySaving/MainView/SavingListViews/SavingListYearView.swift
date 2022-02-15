//
//  SavingListYearView.swift
//  PiggySaving
//
//  Created by Tianyu Liu on 09/02/2022.
//

import SwiftUI

struct SavingListYearView: View {
    var savings: [[Saving]]
    let externalURL: String
    let type: String
    @Binding var monthShowList: [String: Bool]
    
    var year: String {
        savings[0][0].dateLocalizedYear
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(year)
                    .font(Fonts.TITLE_SEMIBOLD)
                Spacer()
                Text(type == "Saving" ? "Saving Record" : "Withdraw Record")
                    .font(Fonts.BODY_CHINESE_NORMAL)
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            
            if type == "Saving" {
                ForEach(savings, id: \.self) { monthSavings in
                    SavingListMonthView(savings: monthSavings, showList: $monthShowList, externalURL: externalURL)
                    if monthSavings != savings.last {
                        Divider()
                            .padding(.top, 5)
                    }
                }
            } else {
                ForEach(savings, id: \.self) { monthCosts in
                    CostListMonthView(costs: monthCosts, showList: $monthShowList)
                    if monthCosts != savings.last {
                        Divider()
                            .padding(.top, 5)
                    }
                }
            }
        }
    }
}

struct SavingListYearView_Previews: PreviewProvider {
    static var previews: some View {
        let savings = [Saving.sampleData1, Saving.sampleData2]
        VStack {
            SavingListYearView(savings: savings, externalURL: "", type: "Saving", monthShowList: .constant([:]))
            Spacer()
        }
    }
}
